public class StaffingAssignmentSelector
		extends fflibext_SObjectSelector
		implements IStaffingAssignmentSelector {

	public static IStaffingAssignmentSelector newInstance() {
		return (IStaffingAssignmentSelector) fflibext_Application.Selector.newInstance(Staffing_Assignment__c.SObjectType);
	}
	@TestVisible
	private Schema.sObjectType getSObjectType() {
		return Staffing_Assignment__c.SObjectType;
	}

	private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
		return new List<Schema.SObjectField>{
				Staffing_Assignment__c.ADCVD_Case_Number_Text__c,
				Staffing_Assignment__c.ADCVD_Case_Number__c,
				Staffing_Assignment__c.ADCVD_Case_Type_Text__c,
				Staffing_Assignment__c.ADCVD_Case_Type__c,
				Staffing_Assignment__c.ADCVD_Case__c,
				Staffing_Assignment__c.ADCVD_Order__c,
				Staffing_Assignment__c.CBP_Case_Number_Text__c,
				Staffing_Assignment__c.CBP_Case_Number__c,
				Staffing_Assignment__c.Case_Concat_Text_Values__c,
				Staffing_Assignment__c.Commodity_Text__c,
				Staffing_Assignment__c.Country_Text__c,
				Staffing_Assignment__c.Country__c,
				Staffing_Assignment__c.CreatedById,
				Staffing_Assignment__c.CreatedDate,
				Staffing_Assignment__c.Id,
				Staffing_Assignment__c.Investigation__c,
				Staffing_Assignment__c.Locked__c,
				Staffing_Assignment__c.Name,
				Staffing_Assignment__c.OwnerId,
				Staffing_Assignment__c.Parent_Name__c,
				Staffing_Assignment__c.Parent__c,
				Staffing_Assignment__c.Petition__c,
				Staffing_Assignment__c.Product_Short_Name_Text_Value__c,
				Staffing_Assignment__c.Product_Short_Name_Text__c,
				Staffing_Assignment__c.Product_Short_Name__c,
				Staffing_Assignment__c.Product_Text__c,
				Staffing_Assignment__c.Product__c,
				Staffing_Assignment__c.Related_Org_Parent_Id__c,
				Staffing_Assignment__c.Related_Org_Parent_Name__c,
				Staffing_Assignment__c.Related_Organization_Parent__c,
				Staffing_Assignment__c.Related_Organization__c,
				Staffing_Assignment__c.Segment__c,
				Staffing_Assignment__c.Staff_Parent__c,
				Staffing_Assignment__c.Title__c,
				Staffing_Assignment__c.User__c
		};
	}
	public List<Staffing_Assignment__c> selectById(Set<Id> idSet) {
		return (List<Staffing_Assignment__c>) selectSObjectsById(idSet);
	}

	public List<Staffing_Assignment__c> selectByWhereClause(String wc) {
		return (List<Staffing_Assignment__c>) selectSObjectsWhere(wc);
	}
	public List<Staffing_Assignment__c> selectAllToLimit() {
		return (List<Staffing_Assignment__c>)
				Database.query(newQueryFactory().setLimit(Limits.getLimitQueryRows()).toSOQL());
	}

	public List<Staffing_Assignment__c> selectByParentId(String Id, Set<String> selectFieldsSet, String condition) {

		fflib_QueryFactory staffingAssignmentQueryFactory = newQueryFactory();
		staffingAssignmentQueryFactory.selectFields(selectFieldsSet);

		return (List<Staffing_Assignment__c>) Database.query(staffingAssignmentQueryFactory.setCondition(condition).toSOQL());
	}
}