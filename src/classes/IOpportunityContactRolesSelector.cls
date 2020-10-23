/**
 * Created by Mark Keckeis on 8/11/2020.
 */

public interface IOpportunityContactRolesSelector extends fflib_ISObjectSelector{
	List<OpportunityContactRole> selectById(Set<Id> idSet);
	List<OpportunityContactRole> selectByOpportunityId(Set<Id> idSet, boolean isPrimary);
}
