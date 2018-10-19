public interface IPetitionSelector
    extends fflib_ISObjectSelector
{
    List<Petition__c> selectById(Set<Id> idSet);
    List<Petition__c> selectAllToLimit();
}