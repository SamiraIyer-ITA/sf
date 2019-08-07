/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: PaymentsService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Payment object or as
		a result of the Payment object being updated. Which implementation is used is determined by custom
		metadata. See PaymentsServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class PaymentsService {

	private static IPaymentsService service(){
		return (IPaymentsService) fflibext_Application.Service.newInstance(IPaymentsService.class);
	}

	public static void updateRefunds(List<Payment__c> paymentsList){
		service().updateRefunds(paymentsList);
	}

	public static void updatePaymentContactAndOfficer(List<Payment__c> paymentsToUpdate) {
		service().updatePaymentContactAndOfficer(paymentsToUpdate);
	}

	public class PaymentsServiceException extends Exception {}

}