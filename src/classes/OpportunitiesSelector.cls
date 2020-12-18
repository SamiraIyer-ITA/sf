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

	public List<Opportunity> selectByIdNoContractNoOrdersSowApproved(Set<Id> idSet) {
		String condition = 'ContractId = NULL '
							+ 'AND SOW_Approved__c = TRUE '
							+ 'AND Id NOT IN (SELECT OpportunityId FROM Order WHERE OpportunityId IN :idSet) '
							+ 'AND Id IN :idSet';
		return (List<Opportunity>)
			Database.query(
				newQueryFactory()
					.setCondition(condition)
					.toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Opportunity.Id,
			Opportunity.Name,
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
			Opportunity.SOW_Approved__c,
			Opportunity.Type,
			Opportunity.Assigned_User__c,
			Opportunity.Assigned_Date__c,
			Opportunity.Conference_Call_Scheduling_In_Progress__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Opportunity.SObjectType;
	}
}