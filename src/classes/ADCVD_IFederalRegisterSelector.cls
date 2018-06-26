public interface ADCVD_IFederalRegisterSelector
    extends fflibext_ISObjectSelector
{
    List<Federal_Register__c> selectAll();
    List<Federal_Register__c> selectById(Set<Id> idSet);
}