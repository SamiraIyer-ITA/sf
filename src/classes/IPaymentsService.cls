/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IPaymentsService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Payment object or as a result of the Payment object being updated.
 */
public interface IPaymentsService {

	void updateRefunds(List<Payment__c> paymentsList);
	void updatePaymentContactAndOfficer(List<Payment__c> paymentsToUpdate);

}