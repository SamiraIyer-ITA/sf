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
	global static String doPost(String accountType, String paymentId, String token, String orderId) {

		String jsonReturnValue;  //Return value for calls made internally to this method

		try {
			jsonReturnValue =  confirmPayment(accountType, paymentId, token, orderId);
			setResponse(jsonReturnValue);  //Response is already serialized
			return jsonReturnValue;
		} catch (Exception e) {
			jsonReturnValue = '{"error": "' + e.getMessage() + '"}';
			setResponse(jsonReturnValue);
			return jsonReturnValue;
		}
	}

	private static void setResponse(String responseString) {
		if (RestContext.response != null) {
			RestContext.response.addHeader('Content-Type', 'application/json');
			RestContext.response.responseBody = Blob.valueOf(responseString);
		}
	}

	private static String confirmPayment(String accountType, String paymentId, String token, String orderId) {
		//Handle exceptions in the calling method
		IPayment payment = (IPayment) di_Injector.Org.getInstance('PaymentProcessor');
		String remoteAccountName = Payment2Utils.getRemoteAccountName(accountType);
		if (String.isBlank(remoteAccountName)) {
			throw new Payment2Utils.PaymentException('Unknown remote account name.');
		}
		return payment.confirmPayment(remoteAccountName, paymentId, token, accountType, orderId);
	}

}
