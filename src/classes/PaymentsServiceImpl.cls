/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: PaymentsServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Payment object or as a result of the
		Payment object being updated. Which implementation is used is determined by custom metadata.
 */
public class PaymentsServiceImpl implements IPaymentsService{
	public static void updateRefunds(List<Payment__c> existingPayments) {
		List<Id> paymentIds = new List<Id>();
		for(Payment__c myPayment : existingPayments) {
			paymentIds.add(myPayment.Id);
		}

		List<Refund__c> refundsToUpdate = [select Name,Id from Refund__c where Payment__c IN: paymentIds];
		update refundsToUpdate;
	}

	public static void updatePaymentContactAndOfficer(List<Payment__c> paymentsToUpdate) {
		List<Id> orderIds = new List<Id>();
		Set<Id> applicationIdList = new Set<Id>();
		for(Payment__c myPayment : paymentsToUpdate) {
			orderIds.add(myPayment.Order__c);
		}

		//order by: if there are duplicate role records in application contact, use the newest one.
		for(Order myOrder : [SELECT Name,Id,Participant__c,Organization_Contact__c,Organization_Corporate_Officer__c from Order WHERE ID IN: orderIds]) {
			for(Payment__c myPayment : paymentsToUpdate) {
				if(myPayment.Order__c == myOrder.Id) {
					myPayment.Organization_Corporate_Officer__c = myOrder.Organization_Corporate_Officer__c;
					myPayment.Organization_Contact__c = myOrder.Organization_Contact__c;
				}
			}
		}
	}
}