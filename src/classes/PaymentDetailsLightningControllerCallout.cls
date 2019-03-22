public class PaymentDetailsLightningControllerCallout {

	public static PaymentDetailsLightningController getPaymentDetails(Id paymentId) {

		try {
			System.debug('Calling paymentDetailsLightningController.getPaymentDetails(paymentId)');
			PaymentDetailsLightningController paymentDetailsLightningController = PaymentDetailsLightningController.getPaymentDetails(paymentId);
			System.debug('Done calling paymentDetailsLightningController.getPaymentDetails(paymentId)');
			return paymentDetailsLightningController;
		} catch (Exception e) {
		}
		return null;
	}

}