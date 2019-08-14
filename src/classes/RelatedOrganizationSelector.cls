public class RelatedOrganizationSelector
		extends fflibext_SObjectSelector
		implements IRelatedOrganizationSelector {
	public static IRelatedOrganizationSelector newInstance() {
		return (IRelatedOrganizationSelector) fflibext_Application.Selector.newInstance(Related_Organization__c.SObjectType);
	}
	@TestVisible
	private Schema.sObjectType getSObjectType() {
		return Related_Organization__c.SObjectType;
	}
	private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
		return new List<Schema.SObjectField>{
				Related_Organization__c.ADCVD_Case_Number__c,
				Related_Organization__c.ADCVD_Case_Type__c,
				Related_Organization__c.ADCVD_Order__c,
				Related_Organization__c.Account__c,
				Related_Organization__c.CBP_Case_Number__c,
				Related_Organization__c.Country__c,
				Related_Organization__c.Custom_Instruction__c,
				Related_Organization__c.Exporter__c,
				Related_Organization__c.Investigation__c,
				Related_Organization__c.Link__c,
				Related_Organization__c.Litigation__c,
				Related_Organization__c.Parent_Id__c,
				Related_Organization__c.Petition__c,
				Related_Organization__c.Producer__c,
				Related_Organization__c.Product_Short_Name__c,
				Related_Organization__c.Product__c,
				Related_Organization__c.Related_Organization_Name__c,
				Related_Organization__c.Segment__c,
				Related_Organization__c.Status__c,
				Related_Organization__c.Type__c,
				Related_Organization__c.Locked__c,
				Related_Organization__c.Case_Concat_Text_Values__c,
				Related_Organization__c.Product_Short_Name_Text_Value__c,
				Related_Organization__c.ADCVD_Case__c,
				Related_Organization__c.ADCVD_Case_Number_Text__c,
				Related_Organization__c.ADCVD_Case_Type_Text__c,
				Related_Organization__c.CBP_Case_Number_Text__c,
				Related_Organization__c.Case_Concat_Text__c,
				Related_Organization__c.Commodity_Text__c,
				Related_Organization__c.Country_Text__c,
				Related_Organization__c.IO_Parent__c,
				Related_Organization__c.Product_Short_Name_Text__c,
				Related_Organization__c.Product_Text__c,
				Related_Organization__c.Legal_Representation__c,
				Related_Organization__c.ADCVD_Entity_Alias__c,
				Related_Organization__c.ADCVD_Entity_Name__c,
				Related_Organization__c.Lead_Attorney__c
		};
	}
	public List<Related_Organization__c> selectById(Set<Id> idSet) {
		return (List<Related_Organization__c>) selectSObjectsById(idSet);
	}
	public List<Related_Organization__c> selectAllToLimit() {
		return
				(List<Related_Organization__c>)
						Database.query(
								newQueryFactory()
										.setLimit(Limits.getLimitQueryRows())
										.toSOQL());
	}
}