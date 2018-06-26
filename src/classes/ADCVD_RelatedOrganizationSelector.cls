public class ADCVD_RelatedOrganizationSelector
    extends fflibext_SObjectSelector
    implements ADCVD_IRelatedOrganizationSelector
{
    public static ADCVD_IRelatedOrganizationSelector newInstance()
    {
        return (ADCVD_IRelatedOrganizationSelector) fflibext_Application.Selector.newInstance(Related_Organization__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType()
    {
        return Related_Organization__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Related_Organization__c.ADCVD_Case_Number__c,
            Related_Organization__c.ADCVD_Case_Type__c,
            Related_Organization__c.ADCVD_Order__c,
            Related_Organization__c.Account__c,
            Related_Organization__c.CBP_Case_Number__c,
            Related_Organization__c.Country__c,
            Related_Organization__c.Custom_Instruction__c,
            Related_Organization__c.Exporter__c,
            Related_Organization__c.Investigation__c,
            Related_Organization__c.Legal_Representation__c,
            Related_Organization__c.Link__c,
            Related_Organization__c.Litigation__c,
            Related_Organization__c.Locked__c,
            Related_Organization__c.Parent_Id__c,
            Related_Organization__c.Petition__c,
            Related_Organization__c.Producer__c,
            Related_Organization__c.Product_Short_Name__c,
            Related_Organization__c.Product__c,
            Related_Organization__c.Related_Organization_Name__c,
            Related_Organization__c.Segment__c,
            Related_Organization__c.Status__c,
            Related_Organization__c.Type__c
        };
    }

    public List<Related_Organization__c> selectAll()
    {
        return Database.query(newQueryFactory().toSOQL());
    }

    public List<Related_Organization__c> selectById(Set<Id> idSet)
    {
        return (List<Related_Organization__c>) selectSObjectsById(idSet);
    }

    public List<Related_Organization__c> selectBySObjectId(Set<Id> idSet)
    {
        if (idSet == null || idSet.isEmpty())
        {
            return new List<Related_Organization__c>();
        }

        SObjectType sobjType = new List<Id>(idSet).get(0).getSObjectType();
        SObjectField sobjField = Related_Organization__c.SObjectType.getDescribe().fields.getMap().get(sobjType.getDescribe().getName());

        return
            Database.query(
                newQueryFactory()
                    .setCondition(sobjField + ' in :idSet')
                    .toSOQL());
    }
}