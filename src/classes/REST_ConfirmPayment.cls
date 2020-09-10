/**
 * Confirm Payment REST Service.
 * User Story CRM-9491.
 */

@RestResource(urlMapping='/ConfirmPayment/*')
global without sharing class REST_ConfirmPayment {

	/**
	 * Process Post calls to this service.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentId The Id of the Payment record associated with the payment.
	 * @param token The token from the payment processor (Pay.gov).
	 * @param orderId The Id of the Order being paid for.
	 */
	@HttpPost
	global static void doPost(String accountType, String paymentId, String token, String orderId) {

		try {
			String confirmPaymentResponse =  Payment2.confirmPayment(accountType, paymentId, token, orderId);
			setResponse(confirmPaymentResponse);  //Response is already serialized
			return;
		} catch (Exception e) {
			setResponse('{"Error":{"name": "' + e.getMessage() + '"}}');
			return;
		}
	}

	private static void setResponse(String responseString) {
		RestContext.response.addHeader('Content-Type', 'application/json');
		String returnValue = responseString;
		RestContext.response.responseBody = Blob.valueOf(returnValue);
	}

}