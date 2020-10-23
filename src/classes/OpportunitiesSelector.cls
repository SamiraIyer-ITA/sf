/**
 * Opportunity fflib Selector
 *
 * @author Andrew La Russa
 */
public class OpportunitiesSelector extends fflib_SObjectSelector implements IOpportunitiesSelector {

	public static IOpportunitiesSelector newInstance()  {
		return (IOpportunitiesSelector) fflibext_Application.Selector.newInstance(Opportunity.SObjectType);
	}

	public List<Opportunity> selectById(Set<Id> idSet) {
		return (List<Opportunity>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Opportunity.Id,
			Opportunity.AccountId,
			Opportunity.Amount,
			Opportunity.CloseDate,
			Opportunity.ContractId,
			Opportunity.RecordTypeId,
			Opportunity.Record_Type_Developer_Name__c,
			Opportunity.Requested_Service_End_Date__c,
			Opportunity.Requested_Service_Start_Date__c,
			Opportunity.Pricebook2Id,
			Opportunity.StageName,
			Opportunity.SyncedQuoteId,
			Opportunity.Type
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Opportunity.SObjectType;
	}
}