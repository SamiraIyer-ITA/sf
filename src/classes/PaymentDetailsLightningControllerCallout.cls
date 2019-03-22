public class PaymentDetailsLightningControllerCallout {

	public static PaymentDetailsLightningController getPaymentDetails(Id paymentId) {

		PaymentDetailsLightningController paymentDetailsLightningController = PaymentDetailsLightningController.getPaymentDetails(paymentId);
		return paymentDetailsLightningController;
	}

}