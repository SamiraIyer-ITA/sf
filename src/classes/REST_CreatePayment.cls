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

		Payment2__c payment;
		try {
			payment = Payment2.createPayment(params);

			//Package the payment data in a useful way for the payment processor (Pay.gov)
			/*payment.Id is passed into the next method instead of payment because the object must be queried again
			 to get the payment.Name field.  Since payment.Name is an Auto-Number field, the record must be queried
			 again to get its value.
			 */
			String paymentDetails = Payment2.getPaymentProcessorData(payment.Id, params);
			setResponse(paymentDetails);  //paymentDetails is already serialized
			return;
		} catch (Exception e) {
			setResponse('{"error": "' + e.getMessage() + '"}');
			return;
		}
	}

	private static void setResponse(String responseString) {
		RestContext.response.addHeader('Content-Type', 'application/json');
		String returnValue = responseString;
		RestContext.response.responseBody = Blob.valueOf(returnValue);
	}

}