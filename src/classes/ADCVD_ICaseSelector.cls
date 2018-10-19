public interface ADCVD_ICaseSelector
    extends fflibext_ISObjectSelector
{
    List<ADCVD_Case__c> selectById(Set<Id> idSet);
    List<ADCVD_Case__c> selectByIdWithRelations(Set<Id> idSet);
}