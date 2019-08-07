/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: OrdersServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Order object or as a result of the
		Order object being updated. Which implementation is used is determined by custom metadata.
 */
public class OrdersServiceImpl implements IOrdersService{

	public static void updatePayments(List<Order> ordersList) {
		List<Id> allOrderIds = new List<Id>();
		for(Order myOrder : ordersList) {
			allOrderIds.add(myOrder.Id);
		}
		List<Payment__c> paymentsToUpdate = [SELECT Name,Id from Payment__c where Order__c IN: allOrderIds];
		update paymentsToUpdate;
	}

	public static void updateOrderContactAndOfficer(List<Order> ordersList) {
		List<Id> applicationIds = new List<Id>();

		Set<Id> applicationIdList = new Set<Id>();

		Map<Id, String> participantToContactEmail = new Map<Id, String>();
		Map<Id, String> participantToCorporateOfficer = new Map<Id,String>();

		for(Order myOrder : ordersList) {
			applicationIdList.add(myOrder.Participant__c);
		}

		//order by: if there are duplicate role records in application contact, use the newest one.
		for(Participant_Contact__c applicationContact : [SELECT Name, Id, Role__c, Participant__c, Participant_Contact__c.Email__c FROM Participant_Contact__c WHERE Participant__c IN: applicationIdList ORDER BY LastModifiedDate ASC]) {
			if(applicationContact.Role__c == 'Organization Corporate Officer') {
				participantToCorporateOfficer.put(applicationContact.Participant__c, applicationContact.Email__c);
			} else if(applicationContact.Role__c == 'Organization Contact') {
				participantToContactEmail.put(applicationContact.Participant__c, applicationContact.Email__c);
			}
		}

		for(Order myOrder : ordersList) {
			if(myOrder.Organization_Corporate_Officer__c !=  participantToCorporateOfficer.get(myOrder.Participant__c) ||
					myOrder.Organization_Contact__c != participantToContactEmail.get(myOrder.Participant__c)) {
				myOrder.Organization_Corporate_Officer__c = participantToCorporateOfficer.get(myOrder.Participant__c);
				myOrder.Organization_Contact__c = participantToContactEmail.get(myOrder.Participant__c);
			}
		}
	}
}