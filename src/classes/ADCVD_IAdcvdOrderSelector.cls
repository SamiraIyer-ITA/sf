public interface ADCVD_IAdcvdOrderSelector
    extends fflibext_ISObjectSelector
{
    List<ADCVD_Order__c> selectById(Set<Id> idSet);
}