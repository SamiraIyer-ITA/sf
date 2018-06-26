public interface ADCVD_IInvestigationSelector
    extends fflibext_ISObjectSelector
{
    List<Investigation__c> selectById(Set<Id> idSet);
}