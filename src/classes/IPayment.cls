public interface IPayment {

	String authorizePayment(PaymentAuthenticationDetails authenticationDetails);
	String confirmPayment(String remoteAccountName, String paymentId, String token, String accountType, String orderId);

}