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
	 * userId Optional. If you want the current user's information to be the default values at pay.gov.  Pass in a user id if you want someone else's information to be the default values.
	 * accountType Required if orderId is null.  The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * transactionAmount Required if orderId is null.  The payment amount.
	 * projectCode Required if orderId is null.  The Project Code to which to attribute a payment.  eg '1GKY231'.
	 * collectionPost Required if orderId is null.  The name of the collection office to which to attribute a payment.
	 * fulfillmentPost Required if orderId is null.  The name of the fulfillment office to which to attribute a payment.
	 * organizationName Required if orderId is null.  The name of the company to which to attribute the payment.
	 * accountHolderName Optional.  Defaults the Name field at pay.gov.
	 * billingAddress Optional.  Defaults the Address field at pay.gov.
	 * billingCity Optional.  Defaults the City field at pay.gov.
	 * billingStateCode Optional.  Defaults the State field at pay.gov.
	 * billingZip Optional.  Defaults the Zip Code field at pay.gov.
	 * billingCountryCode Optional.  Defaults the Country field at pay.gov.
	 */
	@HttpPost
	global static void doPost(REST_BeginPaymentParams params) {

		RequiredFields requiredFields = checkRequiredFields(params);
		if (! requiredFields.hasRequiredFields) {
			setResponse(requiredFields.serializedError);
			return;
		}

		//Call the CreatePayment Rest Service.
		//Calling it as a REST Service allows DML (creating a Payment record) before the callout to get a Pay.gov token.
		String paymentDetails;
		try {
			paymentDetails = createPaymentCallout(params);
		} catch (Exception e) {
			setResponse(e.getMessage());
			return;
		}

		//Get the redirectUrl.  This includes SOAP callout to Pay.gov.
		String redirectUrl = Payment2.authorizePayment(paymentDetails);
		setResponse('{"redirectUrl": "' + redirectUrl + '"}');
		return;
	}

	/**
	 * Utility method to set the REST response body.
	 * @param responseString The string to set as the response.
	 */
	private static void setResponse(String responseString) {
		RestContext.response.addHeader('Content-Type', 'application/json');
		String returnValue = responseString;
		RestContext.response.responseBody = Blob.valueOf(returnValue);
	}

	/**
	 * Callout to Salesforce to create a payment record and to prepare data for the payment processor (Pay.gov)
	 * Same parameters as the doPost() method.
	 */
	private static String createPaymentCallout(REST_BeginPaymentParams params) {

		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setHeader('Authorization','Bearer ' + UserInfo.getSessionId());
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
		RequiredFields requiredFields = new RequiredFields();

		//Check for required fields
		if (String.isBlank(params.confirmationPage) || String.isBlank(params.failurePage)) {
			//Throw error.  confirmationPage and failurePage are required.
			requiredFields.hasRequiredFields = false;
			requiredFields.serializedError = '{"error": "Required field is missing: confirmationPage or failurePage"}';
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
			requiredFields.hasRequiredFields = false;
			requiredFields.serializedError = '{"error": "Either orderId or these fields are required: accountType, transactionAmount, projectCode, organizationName,taskCode, objectClass, objectClass,originatingOffice"}';
			return requiredFields;
		}

		if(params.receiptAllowed && String.isBlank(params.receiptEmailAddresses)){
			//Required email is missing
			requiredFields.hasRequiredFields = false;
			requiredFields.serializedError = '{"error": "receiptAllowed is true yet receiptEmailAddresses is blank"}';
			return requiredFields;
		}

		return requiredFields;
	}

}