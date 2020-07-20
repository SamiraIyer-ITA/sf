public with sharing class Payment2 {

	/**
	 * Get transactions for the Transaction Management App used by NIST.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentMethod The way the payment was made.  'Credit Card' or 'ACH'.
	 * @param transactionType Whether the transaction was a 'Payment' or a 'Refund'.
	 * @param fromDateString The starting date from which to search for transactions.
	 * @param toDateString The ending date used in searching for transactions.
	 */
	@AuraEnabled(cacheable=false)
	public static List<Payment2__c> getTransactions(String accountType, String paymentMethod, String transactionType, String fromDateString, String toDateString, String downloaded) {
		try {
			String transactionStatus;
			String recordTypeId;
			String paymentType;
			Boolean nonTransmittedOnly = true;

			//From Datetime
			Date fromDate = Date.parse(fromDateString);
			Datetime fromDatetime = Datetime.newInstance(fromDate.year(), fromDate.month(), fromDate.day(),0,0,0);

			//To Datetime
			Date toDate = Date.parse(toDateString);
			Datetime toDatetime =  Datetime.newInstance(toDate.year(), toDate.month(), toDate.day(),23,59,59);

			Map<String, Id> rtMap = Utils.getRecordTypeIdMap('Payment2__c');

			if (transactionType == 'Payments') {
				recordTypeId = rtMap.get('Credit_Card_or_ACH_Payment');
				if (paymentMethod == 'Credit Card') {
					paymentType = 'PLASTIC_CARD';
					transactionStatus = 'Success';
				} else if (paymentMethod == 'ACH') {
					paymentType = 'ACH';
					transactionStatus = 'Received';
				}
			} else if (transactionType == 'Refunds') {
				recordTypeId = rtMap.get('Credit_Card_Refund');
				transactionStatus = 'Success';
				paymentType = 'Credit Card Refund';
			}

			if (downloaded == 'All') {
				nonTransmittedOnly = false;
			}

			return PaymentsSelector2.newInstance().selectByTransactionDetails(accountType, paymentType, recordTypeId, transactionStatus, fromDatetime, toDatetime, nonTransmittedOnly);
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * Get an Order record, given an Order Id.  Filtering can return only paid orders or only non-paid orders.
	 *
	 * @param orderId An order Id.
	 * @param nonPaidOnly Whether only non-paid orders should be returned.  If true, do not make paidOnly true.
	 * @param paidOnly Whether only paid orders should be returned.  If true, do not make nonPaidOnly true.
	 */
	@AuraEnabled(cacheable=true)
	public static Order getOrderByPaidNonPaidOnly(String orderId, Boolean nonPaidOnly, Boolean paidOnly) {
		try {
			Set<Id> orderIds = new Set<Id>{orderId};//
			List<Order> orders = OrdersSelector.newInstance().selectByPaidNonPaidOnly(orderIds, nonPaidOnly, paidOnly);
			if (orders.size() > 0) {
				return orders[0];
			}
			return null;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * Get Order records, given a Contract Id.  Filtering can return only paid orders or only non-paid orders.
	 *
	 * @param contractId A Contract Id.
	 * @param nonPaidOnly Whether only non-paid orders should be returned.  If true, do not make paidOnly true.
	 * @param paidOnly Whether only paid orders should be returned.  If true, do not make nonPaidOnly true.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Order> getOrdersByContractId(String contractId, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly) {
		try {
			Set<Id> contractIds = new Set<Id>{contractId};
			List<Order> orders = OrdersSelector.newInstance().selectByContractId(contractIds, onlyCreditCardPayments, nonPaidOnly, paidOnly);
			return orders;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * Create a payment record.
	 *
	 * @param accountType Required if orderId is null.  The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param orderId An Id for an Order.  Either orderId or all other parameters are required.
	 * @param projectCode Required if orderId is null.  The Project Code to which to attribute a payment.  eg '1GKY231'.
	 * @param collectionPost Required if orderId is null.  The name of the collection office to which to attribute a payment.
	 * @param fulfillmentPost Required if orderId is null.  The name of the fulfillment office to which to attribute a payment.
	 * @param transactionAmount Required if orderId is null.  The payment amount.
	 * @param organizationName Required if orderId is null.  The name of the company to which to attribute the payment.
	 * @return A Payment2__c object of the newly created payment.
	 */
	public static Payment2__c createPayment(REST_BeginPaymentParams params) {

		//Check for missing data
		if (String.isBlank(params.orderId) &&
			(String.isBlank(params.accountType) ||
				String.isBlank(params.transactionAmount) ||
				String.isBlank(params.projectCode) ||
				String.isBlank(params.taskCode) ||
				String.isBlank(params.objectClass) ||
				String.isBlank(params.organizationCode) ||
				String.isBlank(params.originatingOffice ) ||
				String.isBlank(params.organizationName))) {
			throw new IllegalArgumentException('Either orderId or these values are required: accountType, transactionAmount, projectCode, collectionPost,  fulfillmentPost, organizationName');
		}

		RecordLog.push('Payment.createPayment');
		RecordLog.message('Order Id: ' + params.orderId);

		//Begin to create the payment record
		Payment2__c payment = new Payment2__c();

		//payment.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		if (String.isNotBlank(params.orderId)) {
			payment.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		} else {
			payment.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('External_Credit_Card_or_ACH_Payment');
		}

		RecordLog.message('Record Type Id: ' + payment.RecordTypeId);

		if (String.isNotBlank(params.projectCode)) {
			payment.Project_Code__c = params.projectCode;
		}

		if (String.isNotBlank(params.accountType)) {
			payment.Account_Type__c = params.accountType;
		}

		if (String.isNotBlank(params.transactionAmount)) {
			payment.Transaction_Amount__c = Decimal.valueOf(params.transactionAmount);
		}

		if (String.isNotBlank(params.organizationName)) {
			payment.Organization_Name__c = params.organizationName;
		}

		if (String.isNotBlank(params.taskCode )) {
			payment.Task_Code__c = params.taskCode ;
		}

		if (String.isNotBlank(params.objectClass)) {
			payment.Object_Class__c  = params.objectClass ;
		}

		if (String.isNotBlank(params.invoiceDate)) {
			payment.Invoice_Date__c = params.invoiceDate ;
		}

		if (String.isNotBlank(params.invoiceId )) {
			payment.Invoice_Id__c  = params.invoiceId ;
		}

		if (String.isNotBlank(params.organizationCode )) {
			payment.Organization_Name__c = params.organizationCode ;
		}

		if (String.isNotBlank(params.orderId)) {
			payment = populatePaymentDetailsFromOrder(params, payment);
		}

		RecordLog.message('Account Type: ' + 		payment.Account_Type__c);
		RecordLog.message('Organization Name: ' + 	payment.Organization_Name__c);
		RecordLog.message('Project Code: ' + 		payment.Project_Code__c);
		RecordLog.message('Transaction Amount: ' + 	payment.Transaction_Amount__c);
		RecordLog.message('Organization Name: ' + 	payment.Organization_Name__c);
		RecordLog.message('Task Code: ' + 			payment.Task_Code__c);
		RecordLog.message('Object Class: ' + 		payment.Object_Class__c);
		RecordLog.message('Invoice Date: ' + 		payment.Invoice_Date__c);
		RecordLog.message('Invoice Id: ' + 			payment.Invoice_Id__c);

		RecordLog.message('Inserting Payment');
		try {
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType});
			uow.registerNew(payment);
			uow.commitWork();
		} catch (Exception e) {
			RecordLog.message('Exception: ' + e.getMessage());
			RecordLog.emit('No Payment Id');
			throw e;
		}

		RecordLog.message('Payment inserted');
		return payment;
	}

	private static Payment2__c populatePaymentDetailsFromOrder(REST_BeginPaymentParams params, Payment2__c payment) {
		List<Order> orderListWithDetails = OrdersSelector.newInstance().selectWithOrderItemDetails(new Set<Id>{params.orderId}, true);

		payment.Organization_Name__c = orderListWithDetails[0].Opportunity.Account.Name;
		RecordLog.message('Opportunity Owner: ' + payment.Opportunity_Owner__c);
		payment.Opportunity_Owner__c = orderListWithDetails[0].Opportunity.Owner.Name;
		payment.Opportunity_Created_Date__c = orderListWithDetails[0].Opportunity.CreatedDate;
		RecordLog.message('Opportunity Created Date: ' + payment.Opportunity_Created_Date__c);
		payment.Collection_Post_Name__c = orderListWithDetails[0].Opportunity.Collection_Post__r.Name;
		RecordLog.message('Collection Post Name: ' + payment.Collection_Post_Name__c);
		payment.Collection_Post_Org_Code__c = orderListWithDetails[0].Opportunity.Collection_Post__r.Org_Code__c;
		RecordLog.message('Collection Post Org Code: ' + payment.Collection_Post_Org_Code__c);
		payment.Fulfillment_Post_Name__c = orderListWithDetails[0].Opportunity.Fulfillment_Post__r.Name;
		RecordLog.message('Fulfillment Post Name: ' + payment.Fulfillment_Post_Name__c);
		payment.Fulfillment_Post_Org_Code__c = orderListWithDetails[0].Opportunity.Fulfillment_Post__r.Org_Code__c;
		RecordLog.message('Fulfillment Post Org Code: ' + payment.Fulfillment_Post_Org_Code__c);

		payment.Contract__c = orderListWithDetails[0].ContractId;
		RecordLog.message('Contract Id: ' + payment.Contract__c);

		payment.Account_Type__c = orderListWithDetails[0].Type;

		if (orderListWithDetails[0].OrderItems != null
			&& orderListWithDetails[0].OrderItems.size() > 0
			&& String.isNotBlank(orderListWithDetails[0].OrderItems[0].Accounting_Code__c)) {
			payment.Project_Code__c = orderListWithDetails[0].OrderItems[0].Accounting_Code__c.Left(4) + '231';
		} else {
			throw new Payment2.PaymentException('Project Code is missing.');
		}

		payment.Transaction_Amount__c = orderListWithDetails[0].TotalAmount;

		return payment;
	}

	/**
	 * Package data to send to the payment processor
	 *
	 * @param payment Required.  A Payment2__c record.
	 * @param params Parameters of the REST_CreatePayment class.
	 *
	 * For params, details are:
	 * orderId Optional.  An Id for an Order.
	 * userId Optional. If you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
	 * failurePage Required.  Canceled or failed payments get redirected back here.
	 * confirmationPage Required.  The page to which pay.gov returns to in Salesforce if the payment was authorized.
	 * accountHolderName Optional.  Defaults the Name field at pay.gov.
	 * billingAddress Optional.  Defaults the Address field at pay.gov.
	 * billingCity Optional.  Defaults the City field at pay.gov.
	 * billingStateCode Optional.  Defaults the State field at pay.gov.
	 * billingZip Optional.  Defaults the Zip Code field at pay.gov.
	 * billingCountryCode Optional.  Defaults the Country field at pay.gov.
	 *
	 * @return A JSON string of PaymentAuthenticationDetails
	 */
	public static String getPaymentProcessorData(Id paymentId, REST_BeginPaymentParams params) {

		//Check for required fields
		if (paymentId == null || String.isBlank(params.confirmationPage) || String.isBlank(params.failurePage)) {
			throw new IllegalArgumentException('paymentId, params.confirmationPage, and params.failurePage are required parameters.');
		}

		//Since Name is an Auto-Number field, must query the paymentObject to get the value
		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id>{paymentId});
		Payment2__c payment = payments[0];

		String paymentIdentifier = payment.Name;
		RecordLog.message('Payment Identifier: ' + paymentIdentifier);

		//Gather data to send to the payment processor
		List<User> users;
		if (String.isNotBlank(params.userId)) {
			users = UsersSelector.newInstance().selectById(new Set<Id> {params.userId});
		}
		PaymentAuthenticationDetails details = new PaymentAuthenticationDetails();
		details.paymentId = payment.Id;
		details.paymentIdentifier = paymentIdentifier;
		details.transactionType = 'Sale';
		details.transactionAmount = String.valueOf(payment.Transaction_Amount__c);

		details.successUrl = params.confirmationPage + '?paymentId=' + payment.Id + '&acctType='
			+ payment.Account_Type__c;
		if (String.isNotBlank(params.orderId)) {
			details.successUrl += '&orderId=' + params.orderId;
		}
		RecordLog.message('Success Url: ' + details.successUrl);

		details.cancelUrl = params.failurePage + '?cancel=true';
		RecordLog.message('Cancel Url: ' + details.cancelUrl);

		if (String.isNotBlank(params.accountHolderName)) {
			details.accountHolderName = params.accountHolderName;
		} else {
			if (users != null && users.size() > 0) {
				details.accountHolderName = Accents.removeDiacritics(users[0].Name);
			}
		}
		RecordLog.message('Account Holder Name: ' + details.accountHolderName);

		if (String.isNotBlank(params.billingAddress)) {
			details.billingAddress = params.billingAddress;
		} else {
			if (users != null && users.size() > 0) {
				details.billingAddress = users[0].Contact.MailingStreet != null ? Utils.convMultiLineTextToOne(users[0].Contact.MailingStreet) : null;
			}
		}
		RecordLog.message('Billing Address: ' + details.billingAddress);

		if (String.isNotBlank(params.billingCity)) {
			details.billingCity = params.billingCity;
		} else {
			if (users != null && users.size() > 0) {
				details.billingCity = users[0].Contact.MailingCity;
			}
		}
		RecordLog.message('Billing City: ' + details.billingCity);

		if (String.isNotBlank(params.billingStateCode)) {
			details.billingStateCode = params.billingStateCode;
		} else {
			if (users != null && users.size() > 0) {
				details.billingStateCode = users[0].Contact.MailingStateCode;
			}
		}
		RecordLog.message('Billing State Code: ' + details.billingStateCode);

		if (String.isNotBlank(params.billingZip)) {
			details.billingZip = params.billingZip;
		} else {
			if (users != null && users.size() > 0) {
				details.billingZip = users[0].Contact.MailingPostalCode;
			}
		}
		RecordLog.message('Billing Zip Code: ' + details.billingZip);

		if (String.isNotBlank(params.billingCountryCode)) {
			details.billingCountryCode = params.billingCountryCode;
		} else {
			if (users != null && users.size() > 0) {
				details.billingCountryCode = Utils.getCountryCodeFromAlpha2(
					users[0].Contact.MailingCountryCode, Utils.CountryCodeType.NUMERIC);
			}
		}
		RecordLog.message('Billing Country Code: ' + details.billingCountryCode);

		//details.email = users[0].Contact.Email;  //Do not populate now.  Currently unused at Pay.gov.
		//If do populate email, do not allow plus sign in email address or Pay.gov will error.
		details.accountType = payment.Account_Type__c;
		String remoteAccountName = getRemoteAccountName(payment.Account_Type__c);
		RecordLog.message('Remote Account Name: ' + remoteAccountName);
		details.remoteAccountName = remoteAccountName;
		RecordLog.emit(payment.Id);
		return JSON.serialize(details);
	}

	/**
	 * Authorize an electronic payment.  This method includes a callout to the payment processor's site (Pay.gov).
	 *
	 * @param authenticationDetailsString A JSON string of data that will be used by the payment processor as default values for the payment.
	 */
	@AuraEnabled(cacheable=false)
	public static String authorizePayment(String authenticationDetailsString) {
		//Handle exceptions in the calling method
		Payment2.PaymentAuthenticationDetails authenticationDetails = (Payment2.PaymentAuthenticationDetails)JSON.deserialize(authenticationDetailsString, PaymentAuthenticationDetails.class);
		IPayment payment = (IPayment) di_Injector.Org.getInstance('PaymentProcessor');
		return payment.authorizePayment(authenticationDetails);
	}

	/**
	 * Confirm with the payment processor that the authorized payment should be charged.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentId The Payment Id.
	 * @param token The token previously returned from Pay.gov when the transaction was authorized.
	 * @param orderIds An array of Order Ids, which are the orders being paid for.
	 */
	@AuraEnabled(cacheable=false)
	public static String confirmPayment(String accountType, String paymentId, String token, String orderId) {
		//Handle exceptions in the calling method
		IPayment payment = (IPayment) di_Injector.Org.getInstance('PaymentProcessor');
		String remoteAccountName = getRemoteAccountName(accountType);
		if (String.isBlank(remoteAccountName)) {
			throw new PaymentException('Unknown remote account name.');
		}
		return payment.confirmPayment(remoteAccountName, paymentId, token, accountType, orderId);
	}

	/**
	 * Format User Info field values for sending to pay.gov
	 *
	 * @param userElement A value that will be passed to pay.gov.
	 * @param charLimit The character limit allowed by pay.gov.
	 */
	// Formats user info field values for sending to pay.gov
	public static String userElementFormat(String userElement, Integer charLimit) {
		if (userElement != null) {
			userElement = userElement.length() > charLimit ? userElement.substring(0, charLimit) : userElement;
		}
		return userElement;
	}

	/**
	 * Get the current fiscal year
	 */
	public static String getCurrentFiscalYear() {
		Date currentDate = Date.today();  //Check for GMT
		Integer year = currentDate.year();
		Integer month = currentDate.month();
		if (month > 9) {
			year++;
		}
		return String.valueOf(year);
	}

	/**
	 * Get the time zone offset, which allows GMT dates to be converted to Washington DC time.
	 */
	public static Integer getTimeZoneOffset() {
		Timezone tz = Timezone.getTimeZone('America/New_York');
		// Create a date after the 2007 shift of DST into November
		DateTime dt = system.now();
		//tz.getOffset(dt)  == -18000000 (== -5 hours, which is EST)
		Integer offsetSeconds = tz.getOffset(dt)/1000*-1;  //1000 is to convert milliseconds to seconds and -1 is to add seconds instead of subtract
		return offsetSeconds;
	}

	/**
	 * Get the Remote Account Name from metadata.  This is the 'Application' name used by Pay.gov.
	 */
	public static String getRemoteAccountName(String accountType) {
		//Replace spaces with underscores (e.g. Privacy Shield = Privacy_Shield)
		String accountMetaDataName = accountType.replace(' ', '_') + '_Remote_Account__c';
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings('PayGov');
		return (String) paymentSettingsMap.get(accountMetaDataName);
	}

	public class PaymentAuthenticationDetails {
		public Id paymentId;
		public String paymentIdentifier;
		public String remoteAccountName;
		public String transactionType;
		public String transactionAmount;
		public String successUrl;
		public String cancelUrl;
		public String accountHolderName;
		public String billingAddress;
		public String billingAddress2;
		public String billingCity;
		public String billingStateCode;
		public String billingZip;
		public String billingCountryCode;
		public String email;
		public String accountType;
	}

	public class PaymentException extends Exception {}

}