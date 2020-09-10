public interface IPayment {

	String authorizePayment(Payment2.PaymentAuthenticationDetails authenticationDetails);
	String confirmPayment(String remoteAccountName, String paymentId, String token, String accountType, String orderId);

}
