/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: IPayments2Service.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Payment2 object or as a result of the Payment2 object being updated.
 */
public interface IPayments2Service {

	void updateSystemSearchStringList(List<Payment2__c> payments2List);
	void sendEmailReceipt(Map<Id,Payment2__c> existingRecords, List<Payment2__c> newRecords);
	String beginPayment(Id orderId);
	String confirmPayment(String accountType, String paymentId, String token, String orderId);

}
