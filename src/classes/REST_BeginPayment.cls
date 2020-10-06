/**
	 * Begin Payment Rest Service.
	 * Called from an application external to Salesforce.
	 * Creates a Payment, calls Pay.gov for a token, and returns a redirect URL.
	 * User Story 9490
	 */

@RestResource(urlMapping='/BeginPayment/*')
global without sharing class REST_BeginPayment {

	/**
	 * Process Post calls to this service.
	 *
	 * @param params Parameters of the REST_CreatePayment class.
	 *
	 * For params, details are:
	 * confirmationPage Required.  The page to which pay.gov returns to in Salesforce if the payment was authorized.
	 * failurePage Required.  Canceled or failed payments get redirected back here.
	 * orderId Optional.  An Id for an Order.  Either orderId are all are required: accountType, transactionAmount, projectCode, collectionPost, fulfillmentPost.
	 * accountType Required if orderId is null.  The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * transactionAmount Required if orderId is null.  The payment amount.
	 * projectCode Required if orderId is null.  The Project Code to which to attribute a payment.  eg '1GKY231'.
	 * organizationName Required if orderId is null.  The name of the company to which to attribute the payment.
	 * accountHolderName Optional.  Defaults the Name field at pay.gov.
	 * billingAddress Optional.  Defaults the Address field at pay.gov.
	 * billingCity Optional.  Defaults the City field at pay.gov.
	 * billingStateCode Optional.  Defaults the State field at pay.gov.
	 * billingZip Optional.  Defaults the Zip Code field at pay.gov.
	 * billingCountryCode Optional.  Defaults the Country field at pay.gov.
	 * taskCode: String.  Used to populate the new Task Code field.
	 * objectClass: String.  Used to populate the new Object Class field.
	 * organizationCode: String.  Used to populate the Fulfillment Post Org Code if it has a value.
	 * originatingOffice: String.  Used to populate the Fulfillment Post Acronym field.
	 * receiptEmailAddresses: String.  Comma-separated list of email addresses to which the receipt is sent.
	 * receiptAllowed: Boolean.  Whether a receipt should be sent by Salesforce.
	 * invoiceDate: String.  Optional.  A string value that an external Salesforce payment may want displayed on the receipt.
	 * invoiceId: String.  Optional.  A string value that an external Salesforce payment may want displayed on the receipt.
	 * internalCaller Whether the caller of the service is internal (from within Salesforce) or not.
	 *
	 * @return A JSON string containing an error or a redirectUrl (for redirection to Pay.gov).
	 */
	@HttpPost
	global static void doPost(REST_BeginPaymentParams params) {
		beginPayment(params);
	}

	/**
	 * For internal Salesforce callers.  See doPost() for parameter details.
	 *
	 * @param params Parameters of the REST_CreatePayment class.
	 *
	 * @return A JSON string containing an error or a redirectUrl (for redirection to Pay.gov).
	 */
	public static String beginPayment(REST_BeginPaymentParams params) {
		String jsonReturnValue;  //Return value for calls made internally to this method

		params = setDefaultValues(params);

		RequiredFields requiredFields = checkRequiredFields(params);
		if (requiredFields != null && requiredFields.hasRequiredFields == false) {
			jsonReturnValue = requiredFields.serializedError;
		} else {
		//Call the CreatePayment Rest Service.
		//Calling it as a REST Service allows DML (creating a Payment record) before the callout to get a Pay.gov token.
			try {
				String paymentDetails = createPaymentCallout(params);

				PaymentAuthenticationDetails paymentAuthenticationDetails = Payment2Utils.deserializePaymentDetails(paymentDetails);

				//Check if an error was returned
				if (paymentAuthenticationDetails.error != null) {
					jsonReturnValue = '{"error": "' + paymentAuthenticationDetails.error + '"}';
				} else {
					//Get the redirectUrl.  This includes SOAP callout to Pay.gov.
					if (Test.IsRunningTest()) {
						jsonReturnValue = '{"redirectUrl": "myReturnUrl"}';
					} else {
						String redirectUrl = Payments2Service.authorizePayment(paymentAuthenticationDetails);
						jsonReturnValue = '{"redirectUrl": "' + redirectUrl + '"}';
					}
				}

			} catch (Exception e) {
				jsonReturnValue = '{"error": "' + e.getMessage() + '"}';
			}
		}

		setResponse(jsonReturnValue);
		return jsonReturnValue;

	}

	/**
	 * Set default values that couldn't be set in the REST_BeginPaymentParams class because they always populate as null.
	 *
	 * @param params Parameters of the REST_CreatePayment class.
	 *
	 * @return REST_BeginPaymentParams
	 */
	private static REST_BeginPaymentParams setDefaultValues(REST_BeginPaymentParams params) {
		if (params.receiptAllowed == null) {
			params.receiptAllowed = true;
		}

		if (params.internalCaller == null) {
			params.internalCaller = false;
		}

		if (params.taskCode == null) {
			params.taskCode = '000';
		}

		if (params.objectClass == null) {
			params.objectClass = '05-20-00-00';
		}

		return params;
	}

	/**
	 * Utility method to set the REST response body.
	 * @param responseString The string to set as the response.
	 */
	private static void setResponse(String responseString) {
		if (RestContext.response != null) {
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.responseBody = Blob.valueOf(responseString);
		}
	}

	/**
	 * Callout to Salesforce to create a payment record and to prepare data for the payment processor (Pay.gov)
	 * Same parameters as the doPost() method.
	 */
	private static String createPaymentCallout(REST_BeginPaymentParams params) {

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		String sessionId;
		//If we came from an AuraEnabled method or through a REST service without a logged in user,
		// UserInfo.getSessionId() won't work.  So get it in an alternative way.
		sessionId = Utils.getSessionId();
		request.setHeader('Authorization','Bearer ' + sessionId);
		request.setHeader('Content-Type','application/json');
		Map<String, REST_BeginPaymentParams> jsonBody = new Map<String, REST_BeginPaymentParams>();
		jsonBody.put('params', params);
		request.setBody(JSON.serialize(jsonBody));
		request.setEndpoint(System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/CreatePayment');
		HttpResponse response = http.send(request);
		return response.getBody();
	}

	private class RequiredFields {
		Boolean hasRequiredFields = true;
		String serializedError;
	}

	private static RequiredFields checkRequiredFields(REST_BeginPaymentParams params) {

		//Create a list of fields that are required
		Map<String, Object> requiredFieldMap = new Map<String, Object>();  //Map of field name and field value
		requiredFieldMap.put('confirmationPage', params.confirmationPage);
		requiredFieldMap.put('failurePage', params.failurePage);

		//Check that each required field is populated
		RequiredFields requiredFields = checkIndividuallyRequiredFields(requiredFieldMap);
		if (requiredFields != null) {
			//A required field is missing
			return requiredFields;
		}

		//Check for missing data passed in
		if (String.isBlank(params.orderId) &&
			(String.isBlank(params.accountType) ||
				String.isBlank(params.transactionAmount) ||
				String.isBlank(params.projectCode) ||
				String.isBlank(params.organizationName) ||
				String.isBlank(params.taskCode) ||
				String.isBlank(params.objectClass) ||
				String.isBlank(params.organizationCode) ||
				String.isBlank(params.originatingOffice)
			)) {
			//Required fields are missing
			requiredFields = new RequiredFields();
			requiredFields.hasRequiredFields = false;
			requiredFields.serializedError = '{"error": "Either orderId or these fields are required: accountType, transactionAmount, projectCode, organizationName, taskCode, objectClass, originatingOffice."}';
			return requiredFields;
		}

		if (String.isNotBlank(params.orderId)) {
			List<Order> orderList = OrdersSelector.newInstance().selectById(new Set<Id>{params.orderId});
			if (orderList.size() > 0) {
				Order order = orderList[0];
				if (order.Order_Paid__c == true) {
					requiredFields = new RequiredFields();
					requiredFields.hasRequiredFields = false;
					requiredFields.serializedError = '{"error": "This order has already been paid for."}';
					return requiredFields;
				}
			} else {
				requiredFields = new RequiredFields();
				requiredFields.hasRequiredFields = false;
				requiredFields.serializedError = '{"error": "Invalid Order Id."}';
				return requiredFields;
			}
		}

		return requiredFields;
	}

	/**
 * Check that each required field is populated
 * @param requiredFieldList An Object list of fields that are required.
 *
 * @return RequiredFields.
 */
	private static RequiredFields checkIndividuallyRequiredFields(Map<String, Object> requiredFieldMap) {
		for (String fieldName : requiredFieldMap.keySet()) {
			Object fieldValue = requiredFieldMap.get(fieldName);
			if (fieldValue == null || String.isBlank(fieldValue.toString())) {
				RequiredFields requiredFields = new RequiredFields();
				requiredFields.hasRequiredFields = false;
				requiredFields.serializedError = '{"error": "Required field is missing: ' + fieldName + '."}';
				return requiredFields;
			}
		}

		return null;
	}

}
