/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: IPayments2.cls
	Purpose: Payment2 interface that will be used as an FFLIB domain object.
 */
public interface IPayments2 extends fflib_ISObjectDomain {

	void updateSystemSearchString(List<Payment2__c> payments2List);
	void sendEmailReceipt(Map<Id,Payment2__c> existingRecords, List<Payment2__c> newRecords);
}
