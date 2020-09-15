public class PaymentsSelector2 extends fflib_SObjectSelector implements IPaymentsSelector2 {

	public static IPaymentsSelector2 newInstance(){
		return (IPaymentsSelector2) fflibext_Application.Selector.newInstance(Payment2__c.SObjectType);
	}

	public List<Payment2__c> selectById(Set<Id> idSet) {
		return (List<Payment2__c>) selectSObjectsById(idSet);
	}

	public List<Payment2__c> selectByTransactionDetails(String accountType, String paymentType, String recordTypeId,
		String transactionStatus, Datetime fromDatetime, Datetime toDatetime, Boolean nonTransmittedOnly) {
		String condition = 'Account_Type__c = :accountType ';
		condition += 'AND Payment_Type__c = :paymentType ';
		condition += 'AND RecordTypeId = :recordTypeId ';
		condition += 'AND Transaction_Status__c = :transactionStatus ';
		condition += 'AND Transaction_Date__c >= :fromDatetime ';
		condition += 'AND Transaction_Date__c <= :toDatetime ';
		if (nonTransmittedOnly) {
			condition += 'AND Transmitted__c = false';
		}
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
			Payment2__c.RecordTypeId,
			Payment2__c.Account_Holder_Name__c,
			Payment2__c.Account_Number__c,
			Payment2__c.Project_Code__c,
			Payment2__c.Organization_Name__c,
			Payment2__c.Opportunity_Owner__c,
			Payment2__c.Opportunity_Created_Date__c,
			Payment2__c.Collection_Post_Name__c,
			Payment2__c.Collection_Post_Org_Code__c,
			Payment2__c.Collection_Post_Acronym__c,
			Payment2__c.Fulfillment_Post_Name__c,
			Payment2__c.Fulfillment_Post_Org_Code__c,
			Payment2__c.Fulfillment_Post_Acronym__c,
			Payment2__c.Receipt_Ready__c,
			Payment2__c.Receipt_Sent_To__c,
			Payment2__c.Object_Class__c,
			Payment2__c.Task_Code__c,
			Payment2__c.Invoice_Date__c,
			Payment2__c.Invoice_Id__c,
			Payment2__c.Receipt_Allowed__c,
			Payment2__c.Payment_2__c,
			Payment2__c.Receipt_Email_Address__c
		};
	}

	public override String getOrderBy(){
		return 'Transaction_Date__c ASC';
	}

	private Schema.SObjectType getSObjectType() {
		return Payment2__c.SObjectType;
	}

}