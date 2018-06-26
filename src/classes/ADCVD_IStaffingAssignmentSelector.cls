public interface ADCVD_IStaffingAssignmentSelector
    extends fflibext_ISObjectSelector
{
    List<Staffing_Assignment__c> selectAll();
    List<Staffing_Assignment__c> selectById(Set<Id> idSet);
    List<Staffing_Assignment__c> selectByParentId(Set<Id> idSet);
}