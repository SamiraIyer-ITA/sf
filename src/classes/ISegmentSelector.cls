public interface ISegmentSelector
    extends fflib_ISObjectSelector
{
    List<Segment__c> selectById(Set<Id> idSet);
    List<Segment__c> selectAllToLimit();
}