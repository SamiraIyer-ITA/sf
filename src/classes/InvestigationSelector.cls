public class InvestigationSelector
		extends fflibext_SObjectSelector
		implements IInvestigationSelector {
	public static IInvestigationSelector newInstance() {
		return (IInvestigationSelector) fflibext_Application.Selector.newInstance(Investigation__c.SObjectType);
	}

	@TestVisible
	private Schema.sObjectType getSObjectType() {
		return Investigation__c.SObjectType;
	}

	private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
		return new List<Schema.SObjectField>{
				Investigation__c.Actual_Amend_Final_Concurrence_to_DAS__c,
				Investigation__c.Actual_Amend_Final_Issues_to_DAS__c,
				Investigation__c.Actual_Amend_Prelim_Concurrence_to_DAS__c,
				Investigation__c.Actual_Amend_Prelim_Issues_to_DAS__c,
				Investigation__c.Actual_Amended_Final_Signature__c,
				Investigation__c.Actual_Amended_Prelim_Determination_Sig__c,
				Investigation__c.Actual_Final_Concurrence_to_DAS__c,
				Investigation__c.Actual_Final_Issues_to_DAS__c,
				Investigation__c.Actual_Final_Signature__c,
				Investigation__c.Actual_Prelim_Concurrence_to_DAS__c,
				Investigation__c.Actual_Prelim_Issues_to_DAS__c,
				Investigation__c.Actual_Preliminary_Signature__c,
				Investigation__c.AD_Investigation_Aligned_To__c,
				Investigation__c.ADCVD_Case__c,
				Investigation__c.ADCVD_Case_Number_Text__c,
				Investigation__c.ADCVD_Case_Type_Text__c,
				Investigation__c.Amend_Final_Concurrence_Due_to_DAS__c,
				Investigation__c.Amend_Final_Issues_Due_to_DAS__c,
				Investigation__c.Amend_Prelim_Concurrence_Due_to_DAS__c,
				Investigation__c.Amend_Prelim_Issues_Due_to_DAS__c,
				Investigation__c.Amend_the_Preliminary_Determination__c,
				Investigation__c.Amended_Final_Announcement_Date__c,
				Investigation__c.Amended_Preliminary_Announcement_Date__c,
				Investigation__c.Announcement_Type__c,
				Investigation__c.Calc_Amended_Prelim_Determination_Sig__c,
				Investigation__c.Calculated_Amended_Final_Signature__c,
				Investigation__c.Calculated_Final_Signature__c,
				Investigation__c.Calculated_ITC_Final_FR_Published__c,
				Investigation__c.Calculated_ITC_Prelim_Determination__c,
				Investigation__c.Calculated_Order_FR_Signature__c,
				Investigation__c.Calculated_Postponement_of_PrelimDeterFR__c,
				Investigation__c.Calculated_Prelim_Extension_Request_File__c,
				Investigation__c.Calculated_Preliminary_Signature__c,
				Investigation__c.Case_Concat_Text_Values__c,
				Investigation__c.CBP_Case_Number_Text__c,
				Investigation__c.Commodity_Text__c,
				Investigation__c.Countervailed_Programs__c,
				Investigation__c.Country_Text__c,
				Investigation__c.Country_in_which_factors_were_valued__c,
				Investigation__c.CreatedById,
				Investigation__c.CreatedDate,
				Investigation__c.Days_Remaining__c,
				Investigation__c.Est_ITC_Notification_to_DOC_of_Final_Det__c,
				Investigation__c.Estimated_Order_FR_Published__c,
				Investigation__c.External_Id__c,
				Investigation__c.Final_Announcement_Date__c,
				Investigation__c.Final_Concurrence_Due_to_DAS__c,
				Investigation__c.Final_Extension_of_days__c,
				Investigation__c.Final_Extension_Remaining__c,
				Investigation__c.Final_Issues_Due_to_DAS__c,
				Investigation__c.Final_Team_Meeting_Deadline__c,
				Investigation__c.Have_Custom_Instruction_been_sent__c,
				Investigation__c.Injunction__c,
				Investigation__c.Input_Date_of_Post_Prelim_Determ_Sig__c,
				Investigation__c.Investigation_Name__c,
				Investigation__c.Investigation_Outcome__c,
				Investigation__c.ITC_Finding__c,
				Investigation__c.ITC_Notification_to_DOC_of_Final_Determ__c,
				Investigation__c.LastModifiedById,
				Investigation__c.LastModifiedDate,
				Investigation__c.Link__c,
				Investigation__c.Litigation_YesNo__c,
				Investigation__c.Litigation_Hold_Expiration_Date__c,
				Investigation__c.Litigation_Resolved__c,
				Investigation__c.Litigation_Status__c,
				Investigation__c.Locked__c,
				Investigation__c.Lotus_Notes_History_Data__c,
				Investigation__c.Lotus_Notes_Litigation_ID__c,
				Investigation__c.Ministerial_Error_for_final__c,
				Investigation__c.Ministerial_Error_for_Prelim__c,
				Investigation__c.Name,
				Investigation__c.Next_Announcement_Date__c,
				Investigation__c.Next_Due_to_DAS_Deadline__c,
				Investigation__c.Next_Major_Deadline__c,
				Investigation__c.Next_Office_Deadline__c,
				Investigation__c.Number_of_Additional_Companies_Investiga__c,
				Investigation__c.Number_of_Companies_Requested__c,
				Investigation__c.Number_of_Mandatory_Companies__c,
				Investigation__c.Office__c,
				Investigation__c.Period_Covered_End_Date__c,
				Investigation__c.Period_Covered_Start_Date__c,
				Investigation__c.Petition__c,
				Investigation__c.Petition_Initiation_Signature__c,
				Investigation__c.Petition_Withdrawn__c,
				Investigation__c.Prelim_Concurrence_Due_to_DAS__c,
				Investigation__c.Prelim_Extension_of_days__c,
				Investigation__c.Prelim_Issues_Due_to_DAS__c,
				Investigation__c.Prelim_Team_Meeting_Deadline__c,
				Investigation__c.Preliminary_Announcement_Date__c,
				Investigation__c.Preliminary_Extension_Remaining__c,
				Investigation__c.Product_Text__c,
				Investigation__c.Product_Short_Name_Text__c,
				Investigation__c.Product_Short_Name_Text_Value__c,
				Investigation__c.Range_of_Rates_Final__c,
				Investigation__c.Range_of_Rates_Final_Amended__c,
				Investigation__c.Range_of_Rates_Prelim__c,
				Investigation__c.Range_of_Rates_Prelim_Amended__c,
				Investigation__c.RecordTypeId,
				Investigation__c.Schedule_Refresh__c,
				Investigation__c.Segment__c,
				Investigation__c.Signature_of_Prelim_Postponement_FR__c,
				Investigation__c.Status__c,
				Investigation__c.Termination_of_Suspension_Gap_Period_Beg__c,
				Investigation__c.This_Petition_Has_An_Investigation__c,
				Investigation__c.Tolling_Update__c,
				Investigation__c.Upstream_Subsidy_Allegation__c,
				Investigation__c.Will_you_Amend_the_Final__c,
				Investigation__c.Will_you_Issue_a_Post_Preliminary_Determ__c
		};
	}

	public List<Investigation__c> selectById(Set<Id> idSet) {
		return (List<Investigation__c>) selectSObjectsById(idSet);
	}

	public List<Investigation__c> selectByIdWithRelations(Set<Id> idSet)
	{
		fflib_QueryFactory qf = newQueryFactory();
		qf.subselectQuery(Investigation__c.SObjectType, true)
				.selectField(Investigation__c.Id)
				.selectField(Investigation__c.ADCVD_Case__c)
				.selectField(Investigation__c.AD_Investigation_Aligned_To__c)
				.selectField(Investigation__c.Petition__c);
		qf.setCondition(Investigation__c.AD_Investigation_Aligned_To__c + ' in :idSet');
		return Database.query(qf.toSOQL());
	}

	public List<Investigation__c> selectByWhereClause(String wc) {
		return (List<Investigation__c>) selectSObjectsWhere(wc);
	}

	public List<Investigation__c> selectAllToLimit() {
		return
				(List<Investigation__c>)
						Database.query(
								newQueryFactory()
										.setLimit(Limits.getLimitQueryRows())
										.toSOQL());
	}

	// ========== Legacy Functionality ===================================

	public static List<Investigation__c> allInvestigations {
		get {
			if (allInvestigations == null) {
				allInvestigations = InvestigationSelector.newInstance().selectAllToLimit();
			}
			return allInvestigations;
		}

		set;
	}
}