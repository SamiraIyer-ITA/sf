/**
 * Create Payment REST Service.  Only called from Salesforce.
 * User Story CRM-9489
 */

@RestResource(urlMapping='/CreatePayment/*')
global without sharing class REST_CreatePayment {

	/**
	 * Process Post calls to this service.
	 *
	 * @param params Parameters of the REST_CreatePayment class.
	 *
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
	 */
	@HttpPost
	global static void doPost(REST_BeginPaymentParams params) {

		Payment2__c payment;
		try {
			payment = Payments2Service.createPayment(params);

			//Package the payment data in a useful way for the payment processor (Pay.gov)
			/*payment.Id is passed into the next method instead of payment because the object must be queried again
			 to get the payment.Name field.  Since payment.Name is an Auto-Number field, the record must be queried
			 again to get its value.
			 */
			String paymentDetails = Payments2Service.getPaymentProcessorData(payment.Id, params);
			setResponse(paymentDetails);  //paymentDetails is already serialized
			return;
		} catch (Exception e) {
			setResponse('{"error": "' + e.getMessage() + '"}');
			return;
		}
	}

	private static void setResponse(String responseString) {
		RestContext.response.addHeader('Content-Type', 'application/json');
		RestContext.response.responseBody = Blob.valueOf(responseString);
	}

}