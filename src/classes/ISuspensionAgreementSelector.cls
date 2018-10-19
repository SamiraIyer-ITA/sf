public interface ISuspensionAgreementSelector
    extends fflib_ISObjectSelector
{
    List<Suspension_Agreement__c> selectById(Set<Id> idSet);
    List<Suspension_Agreement__c> selectAllToLimit();
}