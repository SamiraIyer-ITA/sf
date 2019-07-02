public without sharing class LitigationSelector extends fflibext_SObjectSelector implements ILitigationSelector {

    public static ILitigationSelector newInstance() {
        return (ILitigationSelector) fflibext_Application.Selector.newInstance(Litigation__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType() {
        return Litigation__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Litigation__c.ADCVD_Case_Number__c,
            Litigation__c.ADCVD_Case_Type__c,
            Litigation__c.Actual_Draft_Remand_Concurrence_to_DAS__c,
            Litigation__c.Actual_Draft_Remand_Issues_to_DAS__c,
            Litigation__c.Actual_Draft_Remand_released_to_party__c,
            Litigation__c.Actual_Final_Concurrence_to_DAS__c,
            Litigation__c.Actual_Final_Issues_to_DAS__c,
            Litigation__c.Actual_Final_Signature__c,
            Litigation__c.Actual_Initiation_Signature__c,
            Litigation__c.Actual_Prelim_Concurrence_to_DAS__c,
            Litigation__c.Actual_Prelim_Issues_to_DAS__c,
            Litigation__c.Actual_Preliminary_Signature__c,
            Litigation__c.Calculated_Amended_Final_Signature__c,
            Litigation__c.Calculated_Draft_Remand_release_to_party__c,
            Litigation__c.Calculated_Final_Signature__c,
            Litigation__c.Calculated_Initiation_Signature__c,
            Litigation__c.Calculated_Preliminary_Signature__c,
            Litigation__c.Country__c,
            Litigation__c.Court_of_Panel_s_Ruling__c,
            Litigation__c.Date_Remand_Issued_by_Court_or_Panel__c,
            Litigation__c.Draft_Remand_Concurrence_Due_to_DAS__c,
            Litigation__c.Draft_Remand_Issues_Due_to_DAS__c,
            Litigation__c.Expected_Final_Signature_Before_Ext__c,
            Litigation__c.External_Id__c,
            Litigation__c.Final_Concurrence_Due_to_DAS__c,
            Litigation__c.Final_Extension_of_days__c,
            Litigation__c.Final_Issues_Due_to_DAS__c,
            Litigation__c.Final_Team_Meeting_Deadline__c,
            Litigation__c.Initiation_Extension_of_days__c,
            Litigation__c.International_Litigation_Type__c,
            Litigation__c.Investigation__c,
            Litigation__c.Link__c,
            Litigation__c.Litigation_Name__c,
            Litigation__c.Litigation_Parent__c,
            Litigation__c.Lotus_Notes_History_Data__c,
            Litigation__c.Next_Announcement_Date__c,
            Litigation__c.Next_Due_to_DAS_Deadline__c,
            Litigation__c.Next_Major_Deadline__c,
            Litigation__c.Next_Office_Deadline__c,
            Litigation__c.Next_Office_PM_Deadline__c,
            Litigation__c.Period_Covered_End_Date__c,
            Litigation__c.Period_Covered_Start_Date__c,
            Litigation__c.Petition__c,
            Litigation__c.Prelim_Concurrence_Due_to_DAS__c,
            Litigation__c.Prelim_Extension_of_days__c,
            Litigation__c.Prelim_Issues_Due_to_DAS__c,
            Litigation__c.Prelim_Team_Meeting_Deadline__c,
            Litigation__c.Product_Description__c,
            Litigation__c.Product_Short_Name__c,
            Litigation__c.Product__c,
            Litigation__c.Request_Filed__c,
            Litigation__c.Requestor__c,
            Litigation__c.Segment__c,
            Litigation__c.Status__c,
            Litigation__c.USTR_Notification_to_Implement_Final_Res__c,
            Litigation__c.CBP_Case_Number__c,
            Litigation__c.Commodity__c,
            Litigation__c.Case_Concat_Text_Values__c,
            Litigation__c.Locked__c,
            Litigation__c.Schedule_Refresh__c,
            Litigation__c.Tolling_Update__c,
            Litigation__c.ADCVD_Case__c,
            Litigation__c.Office__c,
            Litigation__c.Product_Short_Name_Text_Value__c,
            Litigation__c.ADCVD_Case_Number_Text__c,
            Litigation__c.ADCVD_Case_Type_Text__c,
            Litigation__c.CBP_Case_Number_Text__c,
            Litigation__c.Commodity_Text__c,
            Litigation__c.Country_Text__c,
            Litigation__c.Product_Short_Name_Text__c,
            Litigation__c.Product_Text__c
        };
    }

    public List<Litigation__c> selectById(Set<Id> idSet) {
        return (List<Litigation__c>) selectSObjectsById(idSet);
    }
    public List<Litigation__c> selectAllToLimit() {
        return (List<Litigation__c>)Database.query(newQueryFactory().toSOQL());
    }
}