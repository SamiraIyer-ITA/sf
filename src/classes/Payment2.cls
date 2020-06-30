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
	 * Create a payment record and get user details for the payment.  After calling this method, the user will be on the Pay.gov site.
	 * Do not combine startElectronicPayment() and authorizePayment().  They are broken up this way because authorizePayment() includes a callout and startElectronicPayment() include DML.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param contractId A Contract Id.
	 * @param orderIds An array of Order Ids.
	 * @param userId Either null or empty string if you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
	 * @param paymentPage The page on which the transaction is being processed.  Canceled payments get redirected back here.
	 * @param paymentConfirmationPage The page to which pay.gov returns to in Salesforce if the payment was authorized.
	 * @param objectApiName 'Contract' or 'Order', depending on whether the payment is being made on a 'Contract' or 'Order' page.
	 * @param recordId The Contract Id or Order Id of the page from which payment is attempted.
	 */
	@AuraEnabled(cacheable=false)
	public static String startElectronicPayment(String accountType, String contractId, String[] orderIds, String userId,
		String paymentPage, String paymentConfirmationPage, String objectApiName, String recordId) {
		try {
			//Get the User Id for the current user if none was passed in.
			if (String.isBlank(userId)) {
				userId = UserInfo.getUserId();
			}

			//Create a payment record
			String paymentStr = Payment2.createPayment(accountType, orderIds, null);
			//TODO: Properly set transactionAmount

			Payment2__c payment = (Payment2__c)JSON.deserialize(paymentStr,Payment2__c.class);

			//Gather data to send to the payment processor
			return getPaymentProcessorData(payment, orderIds, userId, paymentPage,
				paymentConfirmationPage, null, null, null, null, null, null);

		} catch(Exception e) {
			System.debug(e.getMessage() + '\n' + e.getStackTraceString());
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * Create a payment record.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param contractId A Contract Id.
	 * @param orderIds An array of Order Ids.
	 * @param userId Either null or empty string if you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
	 *
	 * @return A Payment2__c object of the newly created payment.
	 */
	public static String createPayment(String accountType, String[] orderIds, String transactionAmount) {
		if(String.isBlank(accountType) && (orderIds == null || orderIds.isEmpty()) ) {
			throw new IllegalArgumentException('OrderIds and AccountType cannot both be null.');
		}

		RecordLog.push('Payment.createPayment');
		RecordLog.message('Order Ids: ' + orderIds);

		Payment2__c payment = new Payment2__c();
		payment.Account_Type__c = accountType;
		RecordLog.message('Account Type: ' + accountType);
		payment.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		RecordLog.message('Record Type Id: ' + payment.RecordTypeId);

		if(orderIds != null && !orderIds.isEmpty()) {
			//Convert orderIds String array to set of Id
			Set<Id> orderIdSet = (Set<Id>) JSON.deserialize(JSON.serialize(orderIds), Set<Id>.class);
			List<Order> orderListWithDetails = OrdersSelector.newInstance().selectWithOrderItemDetails(orderIdSet);
			if(payment.Account_Type__c == null) {
				payment.Account_Type__c = orderListWithDetails[0].Type;
			}
			payment.Contract__c = orderListWithDetails[0].ContractId;
			RecordLog.message('Contract Id: ' + payment.Contract__c);

			//All Orders must be for the same Opportunity, so only look at the Opportunity values for the 1st Order
			payment.Organization_Name__c = orderListWithDetails[0].Opportunity.Account.Name;
			payment.Opportunity_Owner__c = orderListWithDetails[0].Opportunity.Owner.Name;
			payment.Opportunity_Created_Date__c = orderListWithDetails[0].Opportunity.CreatedDate;
			payment.Collection_Post_Name__c = orderListWithDetails[0].Opportunity.Collection_Post__r.Name;
			payment.Collection_Post_Org_Code__c = orderListWithDetails[0].Opportunity.Collection_Post__r.Org_Code__c;
			payment.Fulfillment_Post_Name__c = orderListWithDetails[0].Opportunity.Fulfillment_Post__r.Name;
			payment.Fulfillment_Post_Org_Code__c = orderListWithDetails[0].Opportunity.Fulfillment_Post__r.Org_Code__c;

			// Determine the Project Code value and Total Amount value
			Decimal totalAmount = 0.00;
			for(Integer i = 0; i < orderListWithDetails.size() ; i++ ) {
				if(orderListWithDetails.size() <= 12) {
					if (orderListWithDetails[i].OrderItems.size() != 0) {
						if (String.isNotBlank(orderListWithDetails[i].OrderItems[0].Accounting_code__c)) {
							if (i == 0) {
								payment.Project_Code__c = orderListWithDetails[i].OrderItems[0].Accounting_code__c.Left(4) + '231';
							} else{
								payment.Project_Code__c += ', ' + orderListWithDetails[i].OrderItems[0].Accounting_code__c.Left(4) + '231';
							}

						}
					}
					totalAmount += orderListWithDetails[i].TotalAmount;
				} else {
					system.debug('*** Exception: Payment Order limit exceeded. A Payment must be for 12 Orders or less.');
					RecordLog.message('Exception: Payment Order limit exceeded. A Payment must be for 12 Orders or less.');
					RecordLog.emit('No Payment Id');
					throw new PaymentLimitException('Exception: Payment Order limit exceeded. A Payment must be for 12 Orders or less.');
				}
			}
			payment.Transaction_Amount__c = totalAmount;

		} else if(transactionAmount != null){
			payment.Transaction_Amount__c = Decimal.valueOf(transactionAmount);
		}

		RecordLog.message('Transaction Amount: ' + payment.Transaction_Amount__c);
		RecordLog.message('Project Code: ' + payment.Project_Code__c);

		//checking for errors
		if(payment.Transaction_Amount__c == null) {
			//If Transaction_Amount__c is still null at this point it means there were no orders
			throw new IllegalArgumentException('OrderIds and TransactionAmount cannot both be null.');
		}

		RecordLog.message('Inserting Payment');
		payment = Payment2.createPaymentService(payment);

		RecordLog.message('Payment inserted');
		return JSON.serialize(payment);
	}

	/**
	 * Package data to send to the payment processor
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param payment The newly created payment record.
	 * @param orderIds An array of Order Ids.
	 * @param userId Either null or empty string if you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
	 * @param paymentPage The page on which the transaction is being processed.  Canceled payments get redirected back here.
	 * @param paymentConfirmationPage The page to which pay.gov returns to in Salesforce if the payment was authorized.
	 * @param objectApiName 'Contract' or 'Order', depending on whether the payment is being made on a 'Contract' or 'Order' page.
	 * @param recordId The Contract Id or Order Id of the page from which payment is attempted.
	 *
	 * @return A JSON string of PaymentAuthenticationDetails
	 */
	private static String getPaymentProcessorData(Payment2__c payment, String[] orderIds, String userId,
			String failurePage, String confirmationPage, String accountHolderName,
			String billingAddress, String billingCity, String billingStateCode, String billingZip, String billingCountryCode) {

		//Since Name is an Auto-Number field, must query the paymentObject to get the value
		List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id> {payment.Id});
		String paymentIdentifier = payments[0].Name;
		RecordLog.message('Payment Identifier: ' + paymentIdentifier);

		//Gather data to send to the payment processor
		List<User> users = UsersSelector.newInstance().selectById(new Set<Id> {userId});
		PaymentAuthenticationDetails details = new PaymentAuthenticationDetails();
		details.paymentId = payment.Id;
		details.paymentIdentifier = paymentIdentifier;
		details.transactionType = 'Sale';
		details.transactionAmount = String.valueOf(payment.Transaction_Amount__c);
		String baseUrl = getBaseUrl();
		//orderIds contains a starting and ending parentheses.  Remove them.
		String orderIdsString = '' + orderIds;  //Convert orderIds array to a string
		orderIdsString = orderIdsString.removeStart('(');
		orderIdsString = orderIdsString.removeEnd(')');
		details.successUrl = baseUrl + '/' + confirmationPage + '?paymentId=' + payment.Id + '&acctType='
			+ payment.Account_Type__c + '&orderIds=' + orderIdsString;
		RecordLog.message('Success Url = ' + details.successUrl);
		details.cancelUrl = baseUrl + '/' + failurePage + '?cancel=true';
		RecordLog.message('Cancel Url' + details.cancelUrl);

		if(accountHolderName == null) {
			details.accountHolderName = Accents.removeDiacritics(users[0].Name);
		} else {
			details.accountHolderName = accountHolderName;
		}
		RecordLog.message('Account Holder Name: ' + details.accountHolderName);

		if(billingAddress == null) {
			details.billingAddress = users[0].Contact.MailingStreet != null ? Utils.convMultiLineTextToOne(users[0].Contact.MailingStreet) : null;
		} else {
			details.billingAddress = billingAddress;
		}
		RecordLog.message('Billing Address: ' + details.billingAddress);

		if(billingCity == null) {
			details.billingCity = users[0].Contact.MailingCity;
		} else {
			details.billingCity = billingCity;
		}
		RecordLog.message('Billing City: ' + details.billingCity);

		if(billingStateCode == null) {
			details.billingStateCode = users[0].Contact.MailingStateCode;
		} else {
			details.billingStateCode = billingStateCode;
		}
		RecordLog.message('Billing State Code: ' + details.billingStateCode);

		if(billingZip == null) {
			details.billingZip = users[0].Contact.MailingPostalCode;
		} else {
			details.billingZip = billingZip;
		}
		RecordLog.message('Billing Zip Code: ' + details.billingZip);

		if(billingCountryCode == null) {
			details.billingCountryCode = Utils.getCountryCodeFromAlpha2(
					users[0].Contact.MailingCountryCode, Utils.CountryCodeType.NUMERIC);
		} else {
			details.billingCountryCode = billingCountryCode;
		}
		RecordLog.message('Billing Country Code: ' + details.billingCountryCode);

		//details.email = user.Contact.Email;  //Do not allow pluses if sending email to pay.gov
		details.accountType = payment.Account_Type__c;
		String remoteAccountName = getRemoteAccountName(payment.Account_Type__c);
		RecordLog.message('Remote Account Name: ' + remoteAccountName);
		details.remoteAccountName = remoteAccountName;
		RecordLog.emit(payment.Id);
		return JSON.serialize(details);
	}

	/**
	 * Authorize an electronic payment.  This method includes a callout to the payment processor's site (Pay.gov).
	 * Do not combine startElectronicPayment() and authorizePayment().  They are broken up this way because authorizePayment() includes a callout and startElectronicPayment() include DML.
	 *
	 * @param authenticationDetailsString A JSON string of data that will be used by the payment processor as default values for the payment.
	 */
	@AuraEnabled(cacheable=false)
	public static String authorizePayment(String authenticationDetailsString) {
		try {
			Payment2.PaymentAuthenticationDetails authenticationDetails = (Payment2.PaymentAuthenticationDetails)JSON.deserialize(authenticationDetailsString, PaymentAuthenticationDetails.class);
			IPayment payment = (IPayment) di_Injector.Org.getInstance('PaymentProcessor');
			return payment.authorizePayment(authenticationDetails);
		} catch(Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
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
	public static String confirmPayment(String accountType, String paymentId, String token, String[] orderIds) {
		try {
			IPayment payment = (IPayment) di_Injector.Org.getInstance('PaymentProcessor');
			String remoteAccountName = getRemoteAccountName(accountType);
			return payment.confirmPayment(remoteAccountName, paymentId, token, accountType, orderIds);
		} catch(Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
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
		//system.debug(tz.getOffset(dt));  //-18000000 (= -5 hours = EST)
		Integer offsetSeconds = tz.getOffset(dt)/1000*-1;  //1000 is to convert milliseconds to seconds and -1 is to add seconds instead of subtract
		return offsetSeconds;
	}

	/**
	 * Get the Salesforce Base URL.
	 */
	private static String getBaseUrl() {
		return URL.getSalesforceBaseURL().toExternalForm();
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
	public  static List<Payment2__c> populateOpportunityonPayment_2(List<Payment2__c> payments){
		return payments;
	}

	/**
	 * Uses the paymentId and PaymentsSelector2 to retrieve the payment record.
	 * User Story 9495
	 * @param paymentId - Id for a Payment2 record
	 */
	public static Payment2__c retrievePaymentRecord(String paymentId) {
		PaymentsSelector2 myPS2 = new PaymentsSelector2();
		List<Payment2__c> retrievedPayments = myPS2.selectById(new Set<Id>{paymentId});
		Payment2__c payment2Return = null;
		if(!retrievedPayments.isEmpty()) {
			payment2Return = retrievedPayments[0];
		}
		return payment2Return;
	}

	/**
	 * REST Service to email a Payment or Refund Receipt
	 * User Story 9495
	 * @param recipientEmail - A comma separated list of email addresses
	 * @param String paymentId - Id for a Payment2 record
	 */
	public static String emailReceiptService(String recipientEmail,String paymentId) {

		//Populate email template
		String htmlForEmail = '';

		//Send email here via rest service, get results
		emailReceipt restResults = new emailReceipt();

		return JSON.serialize(restResults);
	}

	/**
	 * REST Service to create a payment, call Pay.gov for a token, and return a redirect URL
	 * User Story 9490
	 * @param confirmationPage (required)
	 * @param failurePage (required)
	 * @param orderIds (nullable)
	 * @param userId (nullable)
	 * @param accountType (nullable)
	 * @param transactionAmount (nullable)
	 * @param projectCode (nullable)
	 * @param collectionPost (nullable)
	 * @param fulfillmentPost (nullable)
	 * @param accountHolderName (nullable)
	 * @param billingAddress (nullable)
	 * @param billingCity (nullable)
	 * @param billingStateCode (nullable)
	 * @param billingZip (nullable)
	 * @param billingCountryCode (nullable)
	 */
	public static String beginPaymentProcess(String confirmationPage, String failurePage, String[] orderIds, String userId, String accountType, String transactionAmount, String projectCode, String collectionPost, String fulfillmentPost, String accountHolderName, String billingAddress, String billingCity, String billingStateCode, String billingZip, String billingCountryCode) {
		if(String.isBlank(confirmationPage)) {
			throw new IllegalArgumentException('Confirmation Page is required.');
		}
		if(String.isBlank(failurePage)) {
			throw new IllegalArgumentException('Failure Page is required.');
		}

		// Call the REST Service in CRM-9489 to create a payment record
		String createdPayment2Str = Payment2.createPayment(accountType, orderIds, transactionAmount);
		Payment2__c createdPayment2 = (Payment2__c)JSON.deserialize(createdPayment2Str,Payment2__c.class);

		List<String> collectionFulfillmentStrings = new List<String> ();
		//Get billing info, update inputed fields, etc
		if(projectCode != null) {
			createdPayment2.Project_Code__c = projectCode;
		}
		if(collectionPost != null) {
			createdPayment2.Collection_Post_Name__c = collectionPost;
			collectionFulfillmentStrings.add(collectionPost);
		}
		if(fulfillmentPost != null) {
			createdPayment2.Fulfillment_Post_Name__c = fulfillmentPost;
			collectionFulfillmentStrings.add(fulfillmentPost);
		}
		List<Collection_Fulfillment__c> collectionFulfillment = [SELECT Name,Id,Cost_Center__c,Org_Code__c,Post__c FROM Collection_Fulfillment__c WHERE Post__c IN :collectionFulfillmentStrings];
		for(Collection_Fulfillment__c cf : collectionFulfillment) {
			if(cf.Post__c == collectionPost) {
				createdPayment2.Collection_Post_Name__c = cf.Name;
				createdPayment2.Collection_Post_Org_Code__c = cf.Org_Code__c;
				//createdPayment2.Collection_Post_Acronym__c = collectionFulfillment.Acronym__c;
				//TODO: Uncomment this line when Acronym__c field is implemented on Collection_Fulfillment__c Object
			}
			if(cf.Post__c == fulfillmentPost) {
				createdPayment2.Fulfillment_Post_Name__c = cf.Name;
				createdPayment2.Fulfillment_Post_Org_Code__c = cf.Org_Code__c;
				//createdPayment2.Fulfillment_Post_Acronym__c = collectionFulfillment.Acronym__c;
				//TODO: Uncomment this line when Acronym__c field is implemented on Collection_Fulfillment__c Object
			}
		}
		//REST service to update Payment2 with new details
		Payment2.updatePaymentService(createdPayment2);

		String authenticationDetailsString = Payment2.getPaymentProcessorData(createdPayment2,orderIds,userId,failurePage,confirmationPage,accountHolderName,billingAddress,billingCity,billingStateCode,billingZip,billingCountryCode);

		String drupalUrl = Payment2.authorizePayment(authenticationDetailsString);
		return drupalUrl;
	}

	/**
	 * Create Payment via REST Service for the Transaction Management App used by NIST.
	 * User Story 9489
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param orderIds List of Ids of related orders.
	 * @param transactionAmount The value of the transaction.
	 */
	public static Payment2__c createPaymentService(Payment2__c payment2Create) {
		//Create and insert using REST service
		Http h = new Http();
		Httprequest req = new Httprequest();
		req.setMethod('POST');
		req.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
		req.setHeader('Content-Type','application/json');
		Object payment2CreateObject = (Object)payment2Create;
		req.setBody(JSON.serialize(payment2CreateObject));
		req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/data/v48.0/sobjects/payment2__c');
		HttpResponse response = h.send(req);

		//Convert JSON format of the newly created Payment2 object
		Payment2__c convertedPayment2 = (Payment2__c)JSON.deserialize(response.getBody(),Payment2__c.class);
		return convertedPayment2;
	}

	/**
	 * Update Payment via REST Service for the Transaction Management App used by NIST.
	 *
	 * @param payment2Update The Payment2 object to update via REST service.
	 */
	public static void updatePaymentService(Payment2__c payment2Update) {
		//Update using REST service
		Http h = new Http();
		Httprequest req = new Httprequest();
		req.setMethod('PUT');
		req.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
		req.setHeader('Content-Type','application/json');
		Object payment2UpdateObject = (Object)payment2Update;
		req.setBody(JSON.serialize(payment2UpdateObject));
		req.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/data/v48.0/sobjects/payment2__c');
		HttpResponse response = h.send(req);
	}

	/**
	 * Create Payment via REST Service for the Transaction Management App used by NIST.
	 * User Story 9491
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentId The Id of a Payment2 record.
	 * @param token The token ret
	 * @param transactionAmount The value of the transaction.
	 */
	public static String confirmPaymentService(String accountType, String paymentId, String token, String[] orderIds) {
		return Payment2.confirmPayment(accountType,paymentId,token,orderIds);
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
	public class emailReceipt {
		Boolean receiptSent {get;set;}
		String errorMessage {get;set;}
	}
	public class PaymentLimitException extends Exception {}

}