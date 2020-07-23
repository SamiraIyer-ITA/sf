/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: Payments2Service.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Payment2 object or as
		a result of the Payment2 object being updated. Which implementation is used is determined by custom
		metadata. See Payments2ServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class Payments2Service {

	private static IPayments2Service service(){
		return (IPayments2Service) fflibext_Application.Service.newInstance(IPayments2Service.class);
	}

	public static void updateSystemSearchStringList(List<Payment2__c> payments2List){
		service().updateSystemSearchStringList(payments2List);
	}

	public static void sendEmailReceipt(Map<Id,Payment2__c> existingRecords, List<Payment2__c> newRecords){
		service().sendEmailReceipt(existingRecords, newRecords);
	}

	/**
	 * Create a payment record and get the redirect URL to call Pay.gov.
	 *
	 * @param orderId The Id of an order for which a Pay.gov payment will be made.
	 *
	 * @return A JSON string with an error or redirectURL for redirection to Pay.gov.
	 */
	@AuraEnabled(cacheable=false)
	public static String beginPayment(Id orderId) {
		return service().beginPayment(orderId);
	}

	/**
	 * Confirm with the payment processor that the authorized payment should be charged.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentId The Payment Id.
	 * @param token The token previously returned from Pay.gov when the transaction was authorized.
	 * @param orderId The Id of the order being paid for.
	 *
	 * @return
	 */
	@AuraEnabled(cacheable=false)
	public static String confirmPayment(String accountType, String paymentId, String token, String orderId) {
		return service().confirmPayment(accountType, paymentId, token, orderId);
	}

	public class Payments2ServiceException extends Exception {}

}