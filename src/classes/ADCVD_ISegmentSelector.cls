public interface ADCVD_ISegmentSelector
    extends fflibext_ISObjectSelector
{
    List<Segment__c> selectById(Set<Id> idSet);
    List<Segment__c> selectByAdcvdOrder(Set<Id> idSet);
}