public interface IStaffingAssignmentSelector
		extends fflibext_ISObjectSelector {
	List<Staffing_Assignment__c> selectById(Set<Id> idSet);
	List<Staffing_Assignment__c> selectByWhereClause(String wc);
	List<Staffing_Assignment__c> selectAllToLimit();
	List<Staffing_Assignment__c> selectByParentId(String parentId, Set<String> setFieldsSet, String condition);
}