public class PaymentsSelector2 extends fflib_SObjectSelector implements IPaymentsSelector2 {

	public static IPaymentsSelector2 newInstance(){
		return (IPaymentsSelector2) fflibext_Application.Selector.newInstance(Payment2__c.SObjectType);
	}

	public List<Payment2__c> selectById(Set<Id> idSet) {
		return (List<Payment2__c>) selectSObjectsById(idSet);
	}

	public List<Payment2__c> selectByTransactionDetails(String accountType, String paymentType, String recordTypeId,
		String transactionStatus, Datetime fromDatetime, Datetime toDatetime) {
		String condition = 'Account_Type__c = :accountType ';
		condition += 'AND Payment_Type__c = :paymentType ';
		condition += 'AND RecordTypeId = :recordTypeId ';
		condition += 'AND Transaction_Status__c = :transactionStatus ';
		condition += 'AND Transaction_Date__c >= :fromDatetime ';
		condition += 'AND Transaction_Date__c <= :toDatetime ';
		condition += 'AND Transmitted__c = false';
		return (List<Payment2__c>) Database.query(newQueryFactory()
			.setCondition(condition).toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		//add more fields as appropriate
		return new List<Schema.SObjectField>{
			Payment2__c.Id,
			Payment2__c.Name,
			Payment2__c.Remote_Tracking_Id__c,
			Payment2__c.Account_Type__c,
			Payment2__c.Payment_Processor__c,
			Payment2__c.Transaction_Amount__c,
			Payment2__c.Payment_Type__c,
			Payment2__c.Transaction_Date__c,
			Payment2__c.Transaction_Status__c,
			Payment2__c.RecordTypeId
		};
	}

	public override String getOrderBy(){
		return 'Transaction_Date__c ASC';
	}

	private Schema.SObjectType getSObjectType() {
		return Payment2__c.SObjectType;
	}

}