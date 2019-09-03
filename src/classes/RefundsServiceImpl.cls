/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: RefundsServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Refund object or as a result of the
		Refund object being updated. Which implementation is used is determined by custom metadata.
 */
public class RefundsServiceImpl implements IRefundsService{
	public static void updateRefundContactAndOfficer(List<Refund__c> refundsToUpdate) {
		List<Id> paymentIds = new List<Id>();
		for(Refund__c myRefund : refundsToUpdate) {
			paymentIds.add(myRefund.Payment__c);
		}

		List<Payment__c> paymentList = [SELECT Id,Organization_Contact__c,Organization_Corporate_Officer__c FROM Payment__c WHERE Id IN: paymentIds];
		for(Refund__c myRefund : refundsToUpdate) {
			for(Payment__c myPayment : paymentList) {
				if(myRefund.Payment__c == myPayment.Id) {
					myRefund.Organization_Corporate_Officer__c = myPayment.Organization_Corporate_Officer__c;
					myRefund.Organization_Contact__c = myPayment.Organization_Contact__c;
				}
			}
		}
	}
}