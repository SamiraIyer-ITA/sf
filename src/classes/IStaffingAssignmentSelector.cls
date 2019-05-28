public interface IStaffingAssignmentSelector
    extends fflibext_ISObjectSelector
{
    List<Staffing_Assignment__c> selectById(Set<Id> idSet);
    List<Staffing_Assignment__c> selectAllToLimit();
}