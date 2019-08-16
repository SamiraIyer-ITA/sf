public without sharing class PetitionSelector extends fflibext_SObjectSelector implements IPetitionSelector {

	public static IPetitionSelector newInstance() {
		return (IPetitionSelector) fflibext_Application.Selector.newInstance(Petition__c.SObjectType);
	}
	@TestVisible
	private Schema.sObjectType getSObjectType() {
		return Petition__c.SObjectType;
	}

	private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
		return new List<Schema.SObjectField>{
				Petition__c.Actual_Initiation_Concurrence_to_DAS__c,
				Petition__c.Actual_Initiation_Issues_to_DAS__c,
				Petition__c.Actual_Initiation_Signature__c,
				Petition__c.ADCVD_Case__c,
				Petition__c.ADCVD_Case_Number_Text__c,
				Petition__c.ADCVD_Case_Type_Text__c,
				Petition__c.Calculated_Initiation_Signature__c,
				Petition__c.Case_Concat_Text_Values__c,
				Petition__c.Case_Number__c,
				Petition__c.Case_Type__c,
				Petition__c.CBP_Case_Number_Text__c,
				Petition__c.Commodity_Text__c,
				Petition__c.Country_Text__c,
				Petition__c.Country_Text__c,
				Petition__c.CreatedById,
				Petition__c.CreatedDate,
				Petition__c.External_Id__c,
				Petition__c.Initiation_Announcement_Date__c,
				Petition__c.Initiation_Concurrence_Due_to_DAS__c,
				Petition__c.Initiation_Extension_of_days__c,
				Petition__c.Initiation_Extension_Remaining__c,
				Petition__c.Initiation_Issues_Due_to_DAS__c,
				Petition__c.LastModifiedById,
				Petition__c.LastModifiedDate,
				Petition__c.Link__c,
				Petition__c.Litigation_YesNo__c,
				Petition__c.Litigation_Resolved__c,
				Petition__c.Litigation_Status__c,
				Petition__c.Locked__c,
				Petition__c.Lotus_Notes_History_Data__c,
				Petition__c.Lotus_Notes_Litigation_ID__c,
				Petition__c.Name,
				Petition__c.Next_Announcement_Date__c,
				Petition__c.Next_Due_to_DAS_Deadline__c,
				Petition__c.Next_Major_Deadline__c,
				Petition__c.Next_Office_Deadline__c,
				Petition__c.Office__c,
				Petition__c.OwnerId,
				Petition__c.Percent_of_Domestic_Industry__c,
				Petition__c.Period_for_Trade_Data__c,
				Petition__c.Petition_Filed__c,
				Petition__c.Petition_Name__c,
				Petition__c.Petition_Outcome__c,
				Petition__c.Product_Text__c,
				Petition__c.Product_Short_Name_Text__c,
				Petition__c.Product_Short_Name_Text_Value__c,
				Petition__c.RecordTypeId,
				Petition__c.Schedule_Refresh__c,
				Petition__c.Status__c,
				Petition__c.Tolling_Update__c,
				Petition__c.Total_Imports_Domestic_Consumption__c
		};
	}
	public List<Petition__c> selectById(Set<Id> idSet) {
		return (List<Petition__c>) selectSObjectsById(idSet);
	}

	public List<Petition__c> selectByWhereClause(String wc) {
		return (List<Petition__c>) selectSObjectsWhere(wc);
	}

	public List<Petition__c> selectAllToLimit() {
		return (List<Petition__c>)Database.query(newQueryFactory().setLimit(Limits.getLimitQueryRows()).toSOQL());
	}

	// ========= Legacy Functionality =============================

	private static List<Petition__c> petitionsInContext = new List<Petition__c>();

	public static List<Petition__c> allPetitions {
		get {
			if (allPetitions == null) {
				allPetitions = (List<Petition__c>) PetitionSelector.newInstance().selectAllToLimit();
			}
			return allPetitions;
		}
		set;
	}

	public static List<Petition__c> getPetitionsInContext(Set<Id> petitionIdSet, Set<String> fields, Boolean newQuery) {
		if (newQuery) {
			petitionsInContext = (List<Petition__c>) PetitionSelector.newInstance().selectById(petitionIdSet);
		}
		return petitionsInContext;
	}
}