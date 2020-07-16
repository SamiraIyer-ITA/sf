public interface IPaymentsSelector2 extends fflib_ISObjectSelector{

	List<Payment2__c> selectById(Set<Id> idSet);

	List<Payment2__c> selectByTransactionDetails(String accountType, String paymentType, String recordTypeName, String transactionStatus, Datetime fromDatetime, Datetime toDatetime);
}