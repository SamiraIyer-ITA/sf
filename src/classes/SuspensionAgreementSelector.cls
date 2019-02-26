public class SuspensionAgreementSelector
	extends fflibext_SObjectSelector
	implements ISuspensionAgreementSelector
{
    public static ISuspensionAgreementSelector newInstance()
    {
        return (ISuspensionAgreementSelector) fflibext_Application.Selector.newInstance(Suspension_Agreement__c.SObjectType);
    }
    @TestVisible
    private Schema.sObjectType getSObjectType()
    {
        return Suspension_Agreement__c.SObjectType;
    }
    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Suspension_Agreement__c.ADCVD_Case__c,
            Suspension_Agreement__c.ADCVD_Case_Number_Text__c,
            Suspension_Agreement__c.ADCVD_Case_Type_Text__c,
            Suspension_Agreement__c.Additional_Notes__c,
            Suspension_Agreement__c.Anniversary_Month__c,
            Suspension_Agreement__c.Case_Concat_Text_Values__c,
            Suspension_Agreement__c.CBP_Case_Number_Text__c,
            Suspension_Agreement__c.Commodity_Text__c,
            Suspension_Agreement__c.Country_Text__c,
            Suspension_Agreement__c.CreatedById,
            Suspension_Agreement__c.CreatedDate,
            Suspension_Agreement__c.Effective_Date_of_Termination__c,
            Suspension_Agreement__c.Enforcement_Concerns__c,
            Suspension_Agreement__c.Investigation__c,
            Suspension_Agreement__c.LastModifiedById,
            Suspension_Agreement__c.LastModifiedDate,
            Suspension_Agreement__c.Locked__c,
            Suspension_Agreement__c.Lotus_Notes_History_Data__c,
            Suspension_Agreement__c.Name,
            Suspension_Agreement__c.Next_Sunset_Initiation_Date_UI__c,
            Suspension_Agreement__c.Next_Sunset_Initiation_Date__c,
            Suspension_Agreement__c.Office__c,
            Suspension_Agreement__c.Product_Text__c,
            Suspension_Agreement__c.Product_Short_Name_Text__c,
            Suspension_Agreement__c.Product_Short_Name_Text_Value__c,
            Suspension_Agreement__c.Product_Text_Value__c,
            Suspension_Agreement__c.Suspension_Date__c,
            Suspension_Agreement__c.Termination_Date__c,
            Suspension_Agreement__c.This_Investigation_has_a_Susp_Agreement__c
        };
    }
    public List<Suspension_Agreement__c> selectById(Set<Id> idSet)
    {
        return (List<Suspension_Agreement__c>) selectSObjectsById(idSet);
    }
    public List<Suspension_Agreement__c> selectAllToLimit()
    {
        return
            (List<Suspension_Agreement__c>)
            Database.query(
                newQueryFactory()
                .setLimit(Limits.getLimitQueryRows())
                .toSOQL());
    }
}