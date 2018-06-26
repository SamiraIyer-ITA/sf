public class ADCVD_StaffingAssignmentSelector
    extends fflibext_SObjectSelector
    implements ADCVD_IStaffingAssignmentSelector
{
    public static ADCVD_IStaffingAssignmentSelector newInstance()
    {
        return (ADCVD_IStaffingAssignmentSelector) fflibext_Application.Selector.newInstance(Staffing_Assignment__c.SObjectType);
    }

    private Schema.sObjectType getSObjectType()
    {
        return Staffing_Assignment__c.SObjectType;
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Staffing_Assignment__c.ADCVD_Case__c,
            Staffing_Assignment__c.ADCVD_Case_Number__c,
            Staffing_Assignment__c.ADCVD_Case_Type__c,
            Staffing_Assignment__c.ADCVD_Order__c,
            Staffing_Assignment__c.CBP_Case_Number__c,
            Staffing_Assignment__c.Country__c,
            Staffing_Assignment__c.Investigation__c,
            Staffing_Assignment__c.Locked__c,
            Staffing_Assignment__c.Parent_Name__c,
            Staffing_Assignment__c.Parent__c,
            Staffing_Assignment__c.Petition__c,
            Staffing_Assignment__c.Product__c,
            Staffing_Assignment__c.Related_Org_Parent_Id__c,
            Staffing_Assignment__c.Related_Org_Parent_Name__c,
            Staffing_Assignment__c.Related_Organization_Parent__c,
            Staffing_Assignment__c.Related_Organization__c,
            Staffing_Assignment__c.Segment__c,
            Staffing_Assignment__c.Title__c,
            Staffing_Assignment__c.User__c
        };
    }

    public List<Staffing_Assignment__c> selectAll()
    {
        return Database.query(newQueryFactory().toSOQL());
    }

    public List<Staffing_Assignment__c> selectById(Set<Id> idSet)
    {
        return (List<Staffing_Assignment__c>) selectSObjectsById(idSet);
    }

    public List<Staffing_Assignment__c> selectByParentId(Set<Id> idSet)
    {
        if (idSet == null || idSet.isEmpty())
        {
            return new List<Staffing_Assignment__c>();
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