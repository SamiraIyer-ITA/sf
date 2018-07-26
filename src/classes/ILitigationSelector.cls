public interface ILitigationSelector
    extends fflibext_ISObjectSelector
{
    List<Litigation__c> selectById(Set<Id> idSet);
}