public without sharing class Payment {

	public static final String LANGUAGE = 'en';

	@TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
	@TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
	@TestVisible private static final String PAY_GOV_URL = PaymentSettings__c.getAll().get('PAY_GOV_TCS_ONLINE_URL').value__c;

	public PaymentValueObject getAgencyTrackingId() {
		RecordLog.push('Payment.getAgencyTrackingId');
		Payment__c paymentObject = new Payment__c();
		RecordLog.message('Inserting Payment');
		try {
			insert paymentObject;
		} catch (Exception e) {
			RecordLog.message('Exception: ' + e.getMessage());
			RecordLog.emit('No Payment Id');
			throw e;
		}
		RecordLog.message('Payment inserted');
		//Since name is an Auto-Number field, must query the paymentObject to get the value
		paymentObject = [SELECT Name FROM payment__c WHERE Id = :paymentObject.Id LIMIT 1];
		PaymentValueObject pvo = new PaymentValueObject();
		pvo.agencyTrackingId = paymentObject.Name;
		pvo.paymentId = paymentObject.Id;
		RecordLog.message('Agency Tracking Id: ' + paymentObject.Name);
		RecordLog.emit(paymentObject.Id);
		return pvo;
	}

	public PaymentValueObject getAgencyTrackingId(Id orderId) {
		RecordLog.push('Payment.getAgencyTrackingId');
		RecordLog.message('Order Id: ' + orderId);
		Payment__c paymentObject = new Payment__c();
		paymentObject.Order__c = OrderId;
		RecordLog.message('Inserting Payment');
		try {
			insert paymentObject;
		} catch (Exception e) {
			RecordLog.message('Exception: ' + e.getMessage());
			RecordLog.emit('No Payment Id');
			throw e;
		}
		RecordLog.message('Payment inserted');
		//Since Name is an Auto-Number field, must query the paymentObject to get the value
		paymentObject = [SELECT Id, Name FROM Payment__c WHERE Id = :paymentObject.Id LIMIT 1];
		PaymentValueObject pvo = new PaymentValueObject();
		pvo.agencyTrackingId = paymentObject.Name;
		pvo.paymentId = paymentObject.Id;
		RecordLog.message('Agency Tracking Id: ' + paymentObject.Name);
		RecordLog.emit(paymentObject.Id);
		return pvo;
	}

	// Formats user info field values for sending to pay.gov
	private static String userElementFormat(String userElement, Integer charLimit) {
		if (userElement != null) {
			userElement = userElement.length() > charLimit ? userElement.substring(0, charLimit) : userElement;
		}
		return userElement;
	}

	//Step 1: Get a token FROM pay.gov for the transaction
	public String getToken(Id paymentId, String agency_tracking_id, String tcs_app_id, String transaction_type, String transaction_amount, String url_success, String url_cancel) {
		// GET USER INFO
		PaymentUserInfo pui = new PaymentUserInfo();
		return getToken(
			paymentId,
			agency_tracking_id,
			tcs_app_id,
			transaction_type,
			transaction_amount,
			url_success,
			url_cancel,
			pui.name,
			pui.street,
			null,
			pui.city,
			pui.stateCode,
			pui.postalCode,
			pui.countryCode,
			pui.email
		);
	}

	public String getToken(Id paymentId, String agency_tracking_id, String tcs_app_id, String transaction_type, String transaction_amount, String url_success, String url_cancel,
		String account_holder_name, String billing_address, String billing_address2, String billing_city, String billing_state, String billing_zip,
		String billing_country, String email_address) {

		RecordLog.push('Payment.getToken');
		RecordLog.message('TCS App Id: ' + tcs_app_id);

		PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest = new PayGovTCSOnline.StartOnlineCollectionRequest();

		//POPULATE REQUIRED ELEMENTS
		startOnlineCollectionRequest.tcs_app_id = tcs_app_id;
		startOnlineCollectionRequest.agency_tracking_id = agency_tracking_id;  //21 char LIMIT in general, but 11 char LIMIT for Vantiv.  SP + 9 digits
		startOnlineCollectionRequest.transaction_type = transaction_type;  //'Authorization' or 'Sale'
		startOnlineCollectionRequest.transaction_amount = transaction_amount;  //cannot be negative
		startOnlineCollectionRequest.language = Payment.LANGUAGE;
		startOnlineCollectionRequest.url_success = url_success;
		startOnlineCollectionRequest.url_cancel = url_cancel;
		//END REQUIRED ELEMENTS

		//POPULATE OPTIONAL ELEMENTS

		//80 char limit
		startOnlineCollectionRequest.account_holder_name = userElementFormat(account_holder_name, 80);
		//80 char limit
		startOnlineCollectionRequest.billing_address = userElementFormat(billing_address, 80);
		//80 char limit
		startOnlineCollectionRequest.billing_address2 = userElementFormat(billing_address2, 80);
		//40 char limit
		startOnlineCollectionRequest.billing_city = userElementFormat(billing_city, 40);
		//2 char limit
		startOnlineCollectionRequest.billing_state = userElementFormat(billing_state, 2);
		//20 char limit
		startOnlineCollectionRequest.billing_zip = userElementFormat(billing_zip, 20);
		//3 digit ISO code
		startOnlineCollectionRequest.billing_country = userElementFormat(billing_country, 3);
		//80 char limit
		//Email address is unnecessary at this time and a plus sign in an email address is invalid for pay.gov
		//startOnlineCollectionRequest.email_address = userElementFormat(email_address, 80);

		//END OPTIONAL ELEMENTS

		PayGovTCSOnline.CustomCollectionFields customFields = new PayGovTCSOnline.CustomCollectionFields();
		if (tcs_app_id.equals(PRIVACY_SHIELD_APP_ID)) {
			//Privacy Shield
			customFields.custom_field_1 = '55:0023:' + getCurrentFiscalYear() + ':SAFH232-000:35-05-0001-01-00-00-00:05-20-00-00:' + transaction_amount + '::::::::';  //Product #1 of this transaction.  transaction_amount must have 2 decimals, e.g. 100.00
		} else if (tcs_app_id.equals(EVENTS_SERVICES_APP_ID)) {
			//Events/Services - To be determined
			customFields.custom_field_1 = '::::::::::::::';
		} else {
			//Unknown application
			customFields.custom_field_1 = '::::::::::::::';
		}

		startOnlineCollectionRequest.custom_fields= customFields;

		RecordLog.message('Transaction Amount: ' + transaction_amount);
		RecordLog.message('Transaction Type: ' + transaction_type);
		RecordLog.message('Custom Field 1: ' + customFields.custom_field_1);

		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new  PayGovTCSOnline.TCSOnlineServicePort();
		PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollectionResponse;
		//RecordLog.emit() will be called in payGovOnline.startOnlineCollection
		try {
			startOnlineCollectionResponse = payGovOnline.startOnlineCollection(startOnlineCollectionRequest, paymentId);
		} catch (Exception e) {
			//An error occurred when contacting pay.gov
			throw e;
		}
		return startOnlineCollectionResponse.token;
	}

	//Step 2: Use the token in a Url redirect to pay.gov
	public PageReference redirectToPayGov(Id paymentId, String token, String tcs_app_id) {
		RecordLog.push('Payment.redirectToPayGov');
		RecordLog.message('TCS App Id: ' + tcs_app_id);
		String redirectUrl = Payment.PAY_GOV_URL + '?token=' + token + '&tcsAppID=' + tcs_app_id;
		RecordLog.message('Redirect URL: ' + redirectUrl);
		RecordLog.emit(paymentId);
		return new PageReference(redirectUrl);
	}

	//Step 3: Complete the transaction, receiving and saving the transaction details
	public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeTransaction(Id paymentId, String token, String tcs_app_id) {
		RecordLog.push('Payment.completeTransaction');
		RecordLog.message('TCS App Id: ' + tcs_app_id);
		PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest();
		completeOnlineCollectionWithDetailsRequest.tcs_app_id = tcs_app_id;
		completeOnlineCollectionWithDetailsRequest.token = token;
		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new PayGovTCSOnline.TCSOnlineServicePort();
		PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse;
		//RecordLog.emit() will be called in payGovOnline.completeOnlineCollectionWithDetails
		try {
			completeOnlineCollectionWithDetailsResponse = payGovOnline.completeOnlineCollectionWithDetails(completeOnlineCollectionWithDetailsRequest, paymentId);
		} catch (Exception e) {
			//The payment failed
			//Return null and handle this in the calling controller
			return null;
		}
		return completeOnlineCollectionWithDetailsResponse;
	}

	//Step 4: Save the transaction details
	public Payment__c saveTransactionDetails(Payment__c paymentObject, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse) {
		RecordLog.push('Payment.saveTransactionDetails');

		paymentObject.Pay_Gov_Tracking_Id__c = String.valueOf(completeOnlineCollectionWithDetailsResponse.paygov_tracking_id);
		paymentObject.Transaction_Amount__c = Decimal.valueof(completeOnlineCollectionWithDetailsResponse.transaction_amount);

		RecordLog.message('Pay.gov Tracking Id: ' + paymentObject.Pay_Gov_Tracking_Id__c);
		RecordLog.message('Transaction Amount: ' + paymentObject.Transaction_Amount__c);

		//The transaction datetime returned from pay.gov is correct for EST, but the timezone thinks it's GMT
		//So convert the datetime to GMT for it to be properly stored
		DateTime transDate = completeOnlineCollectionWithDetailsResponse.transaction_date;
		RecordLog.message('Original Transaction Date: ' + String.valueOf(transDate));
		RecordLog.message('Original Transaction Date as GMT: ' + String.valueOfGmt(transDate));
		DateTime transDateGMT = transDate.addSeconds(getTimeZoneOffset());
		paymentObject.Transaction_Date__c = transDateGMT;  //Datetimes need to be either GMT or have a timezone specified
		RecordLog.message('Adjusted Transaction Date: ' + String.valueOf(transDateGMT));

		String paymentDate = String.valueOf(completeOnlineCollectionWithDetailsResponse.payment_date);
		RecordLog.message('Payment Date: ' + paymentDate);
		paymentObject.Payment_Date__c = Date.valueOf(paymentDate);
		paymentObject.Transaction_Status__c = completeOnlineCollectionWithDetailsResponse.transaction_status;
		RecordLog.message('Transaction Status: ' + paymentObject.Transaction_Status__c);
		paymentObject.Payment_Type__c = completeOnlineCollectionWithDetailsResponse.payment_type;
		RecordLog.message('Payment Type: ' + paymentObject.Payment_Type__c);
		RecordLog.message('Updating the Payment');

		try {
			update paymentObject;
		} catch (Exception e) {
			RecordLog.message('Exception: ' + e.getMessage());
			throw e;
		} finally {
			RecordLog.emit(paymentObject.Id);
		}
		return paymentObject;
	}

	@TestVisible private static Integer getTimeZoneOffset() {
		Timezone tz = Timezone.getTimeZone('America/New_York');

		// Create a date after the 2007 shift of DST into November
		DateTime dtpost = system.now();
		system.debug(tz.getOffset(dtpost));  //-18000000 (= -5 hours = EST)

		Integer offsetSeconds = tz.getOffset(dtpost)/1000*-1;  //1000 is to convert milliseconds to seconds and -1 is to add seconds instead of subtract
		return offsetSeconds;
	}

	@TestVisible private static String getCurrentFiscalYear() {

		Date currentDate = Date.today();
		Integer year = currentDate.year();
		Integer month = currentDate.month();

		if (month > 9) {
			year++;
		}

		return String.valueOf(year);
	}

	public class PaymentValueObject {
		public String agencyTrackingId;
		public Id paymentId;
	}

	// User wrapper class for sending using info to pay.gov for autofill
	public class PaymentUserInfo {

		private String name;
		private String email;
		private String street;
		private String city;
		private String stateCode;
		private String postalCode;
		private String countryCode;

		public PaymentUserInfo() {
			User[] users = [
				SELECT  Name,
					Email,
					Street,
					City,
					StateCode,
					PostalCode,
					CountryCode
				FROM    User
				WHERE   Id = :UserInfo.getUserId()
			];
			if (!users.isEmpty()) {
				User paymentUser = users[0];
				name = Accents.removeDiacritics(paymentUser.Name);
				email = paymentUser.Email;
                street = paymentUser.Street != null ? Utils.convMultiLineTextToOne(paymentUser.Street) : null;
				city = paymentUser.City;
				stateCode = paymentUser.StateCode;
				postalCode = paymentUser.PostalCode != null ? String.valueOf(paymentUser.PostalCode) : null;
				if (paymentUser.CountryCode != null) {
					countryCode = Utils.getCountryCodeFromAlpha2(
						paymentUser.CountryCode, Utils.CountryCodeType.NUMERIC);
				}
			}
		}
	}

}
