public interface ADCVD_IOrderSelector
    extends fflib_ISObjectSelector
{
    List<ADCVD_Order__c> selectById(Set<Id> idSet);
    List<ADCVD_Order__c> selectAllToLimit();
}