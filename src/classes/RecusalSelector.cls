public class RecusalSelector
    extends fflibext_SObjectSelector
    implements IRecusalSelector
{
    public static IRecusalSelector newInstance()
    {
        return (IRecusalSelector) fflibext_Application.Selector.newInstance(Recusal__c.SObjectType);
    }
    @TestVisible
    private Schema.sObjectType getSObjectType()
    {
        return Recusal__c.SObjectType;
    }
    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField>
        {
            Recusal__c.ADCVD_Case__c,
            Recusal__c.ADCVD_Order__c,
            Recusal__c.Actor_End_Date__c,
            Recusal__c.Actor_Start_Date__c,
            Recusal__c.Actor__c,
            Recusal__c.End_Date__c,
            Recusal__c.Investigation__c,
            Recusal__c.Litigation__c,
            Recusal__c.Locked__c,
            Recusal__c.Petition__c,
            Recusal__c.Primary_Recusal_Aligned_To__c,
            Recusal__c.Reason_for_Recusal__c,
            Recusal__c.Related_Organization__c,
            Recusal__c.Segment__c,
            Recusal__c.Start_Date__c,
            Recusal__c.User__c
        };
    }
    public List<Recusal__c> selectById(Set<Id> idSet)
    {
        return (List<Recusal__c>) selectSObjectsById(idSet);
    }

    public List<Recusal__c> selectByRecordTypeIdAndUserAndDate(Set<Id> recordTypeIdSet, Set<Id> userIdSet, Date targetDate)
    {
        // WHERE RecordTypeId = :recordTypeId AND User__c IN :userIdSet AND Start_Date__c <= :today AND End_Date__c >= :today
        return
            (List<Recusal__c>)
            Database.query(
                newQueryFactory()
                    .selectField('ADCVD_Case__r.Name')
                .setCondition(Recusal__c.RecordTypeId + ' in :recordTypeIdSet AND ' +
                    Recusal__c.User__c + ' in :userIdSet AND ' +
                    Recusal__c.Start_Date__c + ' <= :targetDate AND ' + Recusal__c.End_Date__c + ' >= :targetDate')
                .toSOQL());
    }

    public List<Recusal__c> selectByUserAndDate(Set<Id> userIdSet, Date targetDate)
    {
        return
            (List<Recusal__c>)
            Database.query(
                newQueryFactory()
                .selectField('ADCVD_Case__r.Name')
                .selectField('Related_Organization__r.Account__c')
                .setCondition(Recusal__c.User__c + ' in :userIdSet AND ' +
                    Recusal__c.Start_Date__c + ' <= :targetDate AND ' + Recusal__c.End_Date__c + ' >= :targetDate')
                .toSOQL());
    }
}