public class ADCVD_FederalRegisterSelector
    extends fflibext_SObjectSelector
    implements ADCVD_IFederalRegisterSelector
{
    public static ADCVD_IFederalRegisterSelector newInstance()
    {
        return (ADCVD_IFederalRegisterSelector) fflibext_Application.Selector.newInstance(Federal_Register__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType()
    {
        return Federal_Register__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Federal_Register__c.ADCVD_Order__c,
            Federal_Register__c.Cite_Number__c,
            Federal_Register__c.Do_Delete__c,
            Federal_Register__c.External_Id__c,
            Federal_Register__c.FR_URL__c,
            Federal_Register__c.IDM_URL__c,
            Federal_Register__c.Investigation__c,
            Federal_Register__c.Litigation__c,
            Federal_Register__c.Petition__c,
            Federal_Register__c.Published_Date__c,
            Federal_Register__c.Segment__c,
            Federal_Register__c.Suspension_Agreement__c,
            Federal_Register__c.Type__c,
            Federal_Register__c.Locked__c
        };
    }

    public List<Federal_Register__c> selectAll()
    {
        return Database.query(newQueryFactory().toSOQL());
    }

    public List<Federal_Register__c> selectById(Set<Id> idSet)
    {
        return (List<Federal_Register__c>) selectSObjectsById(idSet);
    }
}