public interface IRecusalSelector
    extends fflib_ISObjectSelector
{
    List<Recusal__c> selectById(Set<Id> idSet);
    List<Recusal__c> selectByUserAndNoCase(Set<Id> userIdSet);
}