public interface ADCVD_IPetitionSelector
    extends fflibext_ISObjectSelector
{
    List<Petition__c> selectById(Set<Id> idSet);
}