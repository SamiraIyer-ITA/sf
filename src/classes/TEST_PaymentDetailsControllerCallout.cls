public class TEST_PaymentDetailsControllerCallout {
    
    public static PaymentDetailsController getDetails(PaymentDetailsController paymentDetailsController) {
        
        try {
            System.debug('Calling paymentDetailsController.getDetails()');
        	paymentDetailsController.getDetails();
            System.debug('Done calling paymentDetailsController.getDetails()');
            return paymentDetailsController;
        } catch (Exception e) {
        }
        return null;
    }

}