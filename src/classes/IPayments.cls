/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IPayments.cls
	Purpose: Payment__c interface that will be used as an FFLIB domain object.
 */
public interface IPayments extends fflib_ISObjectDomain {

	void updateRefunds(List<Payment__c> existingPayments);
	void updatePaymentContactAndOfficer(List<Payment__c> paymentsToUpdate);

}