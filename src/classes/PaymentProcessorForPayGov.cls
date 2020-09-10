public with sharing class PaymentProcessorForPayGov implements IPayment {

	public static final String METADATA_SETTINGS_NAME = 'PayGov';

	public String authorizePayment(PaymentAuthenticationDetails authenticationDetails) {
		RecordLog.push('Payment.authorizePayment');
		RecordLog.message('Remote Account Name: ' + authenticationDetails.remoteAccountName);

		PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest = new PayGovTCSOnline.StartOnlineCollectionRequest();

		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);

		//POPULATE REQUIRED ELEMENTS
		startOnlineCollectionRequest.tcs_app_id = authenticationDetails.remoteAccountName;
		startOnlineCollectionRequest.agency_tracking_id = authenticationDetails.paymentIdentifier;  //21 char LIMIT in general, but 11 char LIMIT for Vantiv.  SP + 9 digits in production
		startOnlineCollectionRequest.transaction_type = authenticationDetails.transactionType;  //'Authorization' or 'Sale'
		startOnlineCollectionRequest.transaction_amount = authenticationDetails.transactionAmount;  //cannot be negative
		startOnlineCollectionRequest.language = (String) paymentSettingsMap.get('Language_Code__c');
		startOnlineCollectionRequest.url_success = authenticationDetails.successUrl;
		startOnlineCollectionRequest.url_cancel = authenticationDetails.cancelUrl;
		//END REQUIRED ELEMENTS

		//POPULATE OPTIONAL ELEMENTS

		//80 char limit
		startOnlineCollectionRequest.account_holder_name = Payment2Utils.userElementFormat(authenticationDetails.accountHolderName, 80);
		//80 char limit
		startOnlineCollectionRequest.billing_address = Payment2Utils.userElementFormat(authenticationDetails.billingAddress, 80);
		//80 char limit
		startOnlineCollectionRequest.billing_address2 = Payment2Utils.userElementFormat(authenticationDetails.billingAddress2, 80);
		//40 char limit
		startOnlineCollectionRequest.billing_city = Payment2Utils.userElementFormat(authenticationDetails.billingCity, 40);
		//2 char limit
		startOnlineCollectionRequest.billing_state = Payment2Utils.userElementFormat(authenticationDetails.billingStateCode, 2);
		//20 char limit
		startOnlineCollectionRequest.billing_zip = Payment2Utils.userElementFormat(authenticationDetails.billingZip, 20);
		//3 digit ISO code
		startOnlineCollectionRequest.billing_country = Payment2Utils.userElementFormat(authenticationDetails.billingCountryCode, 3);
		//80 char limit
		startOnlineCollectionRequest.email_address = Payment2Utils.userElementFormat(authenticationDetails.email, 80);

		//END OPTIONAL ELEMENTS

		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id> {authenticationDetails.paymentId});
		//

		PayGovTCSOnline.CustomCollectionFields customFields = new PayGovTCSOnline.CustomCollectionFields();
		if (authenticationDetails.accountType.equals('Privacy Shield')) {
			//Privacy Shield
			customFields.custom_field_1 = '55:0023:' + Payment2Utils.getCurrentFiscalYear() + ':SAFH232-000:35-05-0001-01-00-00-00:05-20-00-00:' + authenticationDetails.transactionAmount + '::::::::';  //Product #1 of this transaction.  transaction_amount must have 2 decimals, e.g. 100.00
		} else {
			//Only Privacy Shield uses custom fields, but the first one must be filled in for NIST's system.

			if (String.isBlank(payments[0].Project_Code__c)) {
				throw new Payment2Utils.PaymentException('Project Code is missing.');
			}
			List<String> projectCodesForPayment = payments[0].Project_Code__c.split(',');
			for (String projectCodeForPayment : projectCodesForPayment) {
				// MGK increment custom_field_X so that each value in the list is a custom field
				// MGK use int = 1 loop
				customFields.custom_field_1 = '55:0023:' + Payment2Utils.getCurrentFiscalYear() + ':' + projectCodeForPayment + '-000:' + payments[0].Fulfillment_Post_Org_Code__c + ':05-20-00-00:' + authenticationDetails.transactionAmount + '::::::::';  //Product #1 of this transaction.  transaction_amount must have 2 decimals, e.g. 100.00
			}
		}

		startOnlineCollectionRequest.custom_fields= customFields;

		RecordLog.message('Transaction Amount: ' + authenticationDetails.transactionAmount);
		RecordLog.message('Transaction Type: ' + authenticationDetails.transactionType);
		RecordLog.message('Custom Field 1: ' + customFields.custom_field_1);

		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new PayGovTCSOnline.TCSOnlineServicePort();
		PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollectionResponse;
		//RecordLog.emit() will be called in payGovOnline.startOnlineCollection
		try {
			if (Test.isRunningTest()) {
				startOnlineCollectionResponse = new PayGovTCSOnline.StartOnlineCollectionResponse();
				startOnlineCollectionResponse.token = 'token';
			} else {
				startOnlineCollectionResponse = payGovOnline.startOnlineCollection(startOnlineCollectionRequest, authenticationDetails.paymentId);
			}
			RecordLog.push('Redirect to Pay.gov');
			RecordLog.message('Token: ' + startOnlineCollectionResponse.token);
			RecordLog.message('Remote Account Name: ' + authenticationDetails.remoteAccountName);
			String redirectURL = (String) paymentSettingsMap.get('Redirect_URL__c');
			String paymentRedirectURL = redirectURL + '?token=' + startOnlineCollectionResponse.token + '&tcsAppID=' + authenticationDetails.remoteAccountName;
			RecordLog.message('Redirect URL: ' + paymentRedirectURL);
			RecordLog.emit(authenticationDetails.paymentId);
			return paymentRedirectURL;
		} catch (Exception e) {
			//An error occurred when contacting pay.gov
			throw e;
		}
	}

	public String confirmPayment(String remoteAccountName, String paymentId, String token, String acctType, String orderId) {
		RecordLog.push('Payment.confirmPayment');
		RecordLog.message('Payment Id: ' + paymentId);
		RecordLog.message('OrderId:' + orderId);
		RecordLog.message('Account Type:' + acctType);
		RecordLog.message('Remote Account Name:' + remoteAccountName);
		PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest();
		completeOnlineCollectionWithDetailsRequest.tcs_app_id = remoteAccountName;
		completeOnlineCollectionWithDetailsRequest.token = token;
		PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new PayGovTCSOnline.TCSOnlineServicePort();
		PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse;
		//RecordLog.emit() will be called in payGovOnline.completeOnlineCollectionWithDetails
		Boolean error = false;
		String errorMessage = null;
		String accountHolderName = null;
		String accountNumber = null;
		try {
			if (Test.isRunningTest()) {
				completeOnlineCollectionWithDetailsResponse = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse();
				completeOnlineCollectionWithDetailsResponse.paygov_tracking_id = '3XL4M20';
				completeOnlineCollectionWithDetailsResponse.transaction_amount = '2500.00';
				completeOnlineCollectionWithDetailsResponse.transaction_type = 'Sale';
				completeOnlineCollectionWithDetailsResponse.payment_type = 'PLASTIC_CARD';
				completeOnlineCollectionWithDetailsResponse.transaction_status = 'Success';
				completeOnlineCollectionWithDetailsResponse.transaction_date = date.today();
				completeOnlineCollectionWithDetailsResponse.payment_date = date.today();
			} else {
				completeOnlineCollectionWithDetailsResponse = payGovOnline.completeOnlineCollectionWithDetails(completeOnlineCollectionWithDetailsRequest, paymentId);
			}
		} catch (Exception e) {
			//The payment failed
			RecordLog.push('Payment.completeTransaction Exception');
			RecordLog.message(e.getMessage());
			RecordLog.emit(paymentId);
			errorMessage = 'Unable to complete payment.  ';
			error = true;
		}

		RecordLog.push('Save Payment Details');

		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id> {paymentId});
		List<Order> orders;
		if (error) {
			payments[0].Transaction_Status__c = 'Failed';
			RecordLog.message('Transaction Status: Failed');
		} else {
			payments[0].Remote_Tracking_Id__c = String.valueOf(completeOnlineCollectionWithDetailsResponse.paygov_tracking_id);
			payments[0].Transaction_Amount__c = Decimal.valueof(completeOnlineCollectionWithDetailsResponse.transaction_amount);

			RecordLog.message('Pay.gov Tracking Id: ' + payments[0].Remote_Tracking_Id__c);
			RecordLog.message('Transaction Amount: ' + payments[0].Transaction_Amount__c);
			RecordLog.message('Transaction Type: ' + completeOnlineCollectionWithDetailsResponse.transaction_type);

			//The transaction datetime returned from pay.gov is correct for EST, but the timezone thinks it's GMT
			//So convert the datetime to GMT for it to be properly stored
			DateTime transDate = completeOnlineCollectionWithDetailsResponse.transaction_date;
			RecordLog.message('Original Transaction Date: ' + String.valueOf(transDate));
			RecordLog.message('Original Transaction Date as GMT: ' + String.valueOfGmt(transDate));
			DateTime transDateGMT = transDate.addSeconds(Payment2Utils.getTimeZoneOffset());
			payments[0].Transaction_Date__c = transDateGMT;  //Datetimes need to be either GMT or have a timezone specified
			RecordLog.message('Adjusted Transaction Date: ' + String.valueOf(transDateGMT));

			String paymentDate = String.valueOf(completeOnlineCollectionWithDetailsResponse.payment_date);
			RecordLog.message('Payment Date: ' + paymentDate);
			payments[0].Payment_Date__c = Date.valueOf(paymentDate);
			payments[0].Transaction_Status__c = completeOnlineCollectionWithDetailsResponse.transaction_status;
			RecordLog.message('Transaction Status: ' + payments[0].Transaction_Status__c);
			payments[0].Payment_Type__c = completeOnlineCollectionWithDetailsResponse.payment_type;
			payments[0].Receipt_Ready__c = true;
			RecordLog.message('Receipt Ready: ' + payments[0].Receipt_Ready__c);

			if(String.isNotBlank(orderId)) {
				//Also update each Order to add the lookup for this payment
				orders = OrdersSelector.newInstance().selectById(new Set<Id>{orderId});
				for (Order order : orders) {
					order.Payment2__c = paymentId;
					order.Order_Paid__c = true;
				}
			}
		}

		RecordLog.message('Updating the Payment');

		try {
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
			uow.registerDirty(payments);
			if(String.isNotBlank(orderId)) {
				uow.registerDirty(orders);
			}
			uow.commitWork();
		} catch (Exception e) {
			RecordLog.message('Exception: ' + e.getMessage());
			error = true;
			errorMessage += 'Unable to update payment and/or order record.';
		} finally {
			RecordLog.emit(paymentId);

			//Future callout to Pay.gov again to get and update the Account Holder Name and Masked Account Number
			PaymentProcessorForPayGov.futureGetPaymentDetails(paymentId);
		}

		if (error) {
			AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
			auraHandledException.setMessage(errorMessage);
			throw auraHandledException;
		}

		PaymentProcessorForPayGov.confirmationMessage confirm = new PaymentProcessorForPayGov.confirmationMessage();
		confirm.paymentConfirmed = !error;
		confirm.errorMessage = errorMessage;

		return JSON.serialize(confirm);
	}

	/**
	* Populate the Account Holder Name and Account Number using a pay.gov future callout
	*
	* @param paymentId
	*/
	@future(callout=true)
	public static void futureGetPaymentDetails(Id paymentId) {
		try {
			String paymentDetails = PaymentDetailsLightningController2.getPaymentDetails(paymentId);
			PaymentDetailsForPayGov.ReturnValue returnValue = (PaymentDetailsForPayGov.ReturnValue) JSON.deserialize(paymentDetails, PaymentDetailsForPayGov.ReturnValue.class);
			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id> {paymentId});
			payments[0].Account_Holder_Name__c = returnValue.accountHolderName;
			payments[0].Account_Number__c = returnValue.accountNumber;
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType});
			uow.registerDirty(payments);
			uow.commitWork();
		} catch (Exception e) {
			RecordLog.push('futureGetPaymentDetails Exception');
			RecordLog.message(e.getMessage());
			RecordLog.emit(paymentId);
		}
	}

	public class confirmationMessage {
		public Boolean paymentConfirmed {get;set;}
		public String errorMessage {get;set;}
	}

}
