public interface IRelatedOrganizationSelector
		extends fflib_ISObjectSelector {
	List<Related_Organization__c> selectById(Set<Id> idSet);
	List<Related_Organization__c> selectAllToLimit();
}