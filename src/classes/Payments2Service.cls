/*
	Author: Jeff Weyhrauch
	Date: 5-18-2020
	Name: Payments2Service.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Payment2Utils object or as
		a result of the Payment2Utils object being updated. Which implementation is used is determined by custom
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

	/**
	 * Create a payment record.
	 *
	 * @param params All parameters from REST_BeginPaymentParams
	 *
	 * @return A Payment2__c object of the newly created payment.
	 */
	public static Payment2__c createPayment(REST_BeginPaymentParams params) {
		return service().createPayment(params);
	}

	/**
	 * Authorize an electronic payment.  This method includes a callout to the payment processor's site (Pay.gov).
	 *
	 * @param paymentAuthenticationDetails An instance of PaymentAuthenticationDetails that will be used by the payment processor as default values for the payment.
	 */
	@AuraEnabled(cacheable=false)
	public static String authorizePayment(PaymentAuthenticationDetails paymentAuthenticationDetails) {
		return service().authorizePayment(paymentAuthenticationDetails);
	}

	/**
	 * Package data to send to the payment processor
	 *
	 * @param payment Required.  A Payment2__c record.
	 * @param params Parameters of the REST_CreatePayment class.
	 *
	 * @return A JSON string of PaymentAuthenticationDetails
	 */
	public static String getPaymentProcessorData(Id paymentId, REST_BeginPaymentParams params) {
		return service().getPaymentProcessorData(paymentId, params);
	}

	/**
	 * Get transactions for the Transaction Management App used by NIST.
	 *
	 * @param accountType The account that a payment is attributed to.  'Services', 'Events', or 'Privacy Shield'.
	 * @param paymentMethod The way the payment was made.  'Credit Card' or 'ACH'.
	 * @param transactionType Whether the transaction was a 'Payment' or a 'Refund'.
	 * @param fromDateString The starting date from which to search for transactions.
	 * @param toDateString The ending date used in searching for transactions.
	 */
	@AuraEnabled(cacheable=false)
	public static List<Payment2__c> getTransactions(String accountType, String paymentMethod, String transactionType, String fromDateString, String toDateString, String downloaded) {
		return service().getTransactions(accountType, paymentMethod, transactionType, fromDateString, toDateString, downloaded);
	}

	/**
	 * Get an Order record, given an Order Id.  Filtering can return only paid orders or only non-paid orders.
	 *
	 * @param orderId An order Id.
	 * @param nonPaidOnly Whether only non-paid orders should be returned.  If true, do not make paidOnly true.
	 * @param paidOnly Whether only paid orders should be returned.  If true, do not make nonPaidOnly true.
	 */
	@AuraEnabled(cacheable=true)
	public static Order getOrderByPaidNonPaidOnly(String orderId, Boolean nonPaidOnly, Boolean paidOnly) {
		return service().getOrderByPaidNonPaidOnly(orderId, nonPaidOnly, paidOnly);
	}

	/**
	 * Get Order records, given a Contract Id.  Filtering can return only paid orders or only non-paid orders.
	 *
	 * @param contractId A Contract Id.
	 * @param nonPaidOnly Whether only non-paid orders should be returned.  If true, do not make paidOnly true.
	 * @param paidOnly Whether only paid orders should be returned.  If true, do not make nonPaidOnly true.
	 */
	@AuraEnabled(cacheable=true)
	public static List<Order> getOrdersByContractId(String contractId, Boolean onlyCreditCardPayments, Boolean nonPaidOnly, Boolean paidOnly) {
		return service().getOrdersByContractId(contractId, onlyCreditCardPayments, nonPaidOnly, paidOnly);
	}

	public class Payments2ServiceException extends Exception {}

}