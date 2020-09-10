/**
 * Created by eitanalfiya on 8/28/18.
 */
public interface IInvestigationSelector extends fflib_ISObjectSelector {
	List<Investigation__c> selectById(Set<Id> idSet);
	List<Investigation__c> selectByWhereClause(String wc);
	List<Investigation__c> selectByIdWithRelations(Set<Id> idSet);
	List<Investigation__c> selectAllToLimit();
}