public class ADCVD_AdcvdOrderSelector
        extends fflibext_SObjectSelector
        implements ADCVD_IAdcvdOrderSelector
{
    public static ADCVD_IAdcvdOrderSelector newInstance()
    {
        return (ADCVD_IAdcvdOrderSelector) fflibext_Application.Selector.newInstance(ADCVD_Order__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType()
    {
        return ADCVD_Order__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            ADCVD_Order__c.ADCVD_Case__c,
            ADCVD_Order__c.ADCVD_Case_Number__c,
            ADCVD_Order__c.ADCVD_Case_Type__c,
            ADCVD_Order__c.ADCVD_Order_Name__c,
            ADCVD_Order__c.Anniversary_Month__c,
            ADCVD_Order__c.CBP_Case_Number__c,
            ADCVD_Order__c.Commodity__c,
            ADCVD_Order__c.Country__c,
            ADCVD_Order__c.Effective_Date_for_Most_Recent_SunsetFR__c,
            ADCVD_Order__c.Effective_Date_of_Revocation__c,
            ADCVD_Order__c.Investigation__c,
            ADCVD_Order__c.Link__c,
            ADCVD_Order__c.Locked__c,
            ADCVD_Order__c.Lotus_Notes_History_Data__c,
            ADCVD_Order__c.Next_Sunset_Initiation_Date__c,
            ADCVD_Order__c.Next_Sunset_Initiation_Date_UI__c,
            ADCVD_Order__c.Office__c,
            ADCVD_Order__c.Petition_Case_Type__c,
            ADCVD_Order__c.Petition_Filed__c,
            ADCVD_Order__c.Product__c,
            ADCVD_Order__c.Product_Short_Name__c,
            ADCVD_Order__c.Revocation_Reason__c,
            ADCVD_Order__c.Segment_Status__c,
            ADCVD_Order__c.Status__c,
            ADCVD_Order__c.Third_Country_Case_Number_s__c,
            ADCVD_Order__c.This_Investigation_has_an_Order__c
        };
    }

    public List<ADCVD_Order__c> selectById(Set<Id> idSet)
    {
        return (List<ADCVD_Order__c>) selectSObjectsById(idSet);
    }
}