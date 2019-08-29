public interface ILitigationSelector extends fflibext_ISObjectSelector {
	List<Litigation__c> selectById(Set<Id> idSet);
	List<Litigation__c> selectByWhereClause(String wc);
	List<Litigation__c> selectAllToLimit();
}