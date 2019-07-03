public interface IRecusalSelector
    extends fflib_ISObjectSelector
{
    List<Recusal__c> selectById(Set<Id> idSet);
    List<Recusal__c> selectByRecordTypeIdAndUserAndDate(Set<Id> recordTypeIdSet, Set<Id> userIdSet, Date targetDate);
    List<Recusal__c> selectByUserAndDate(Set<Id> userIdSet, Date targetDate);
}