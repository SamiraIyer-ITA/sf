/**
 * Opportunity fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IOpportunitiesSelector extends fflib_ISObjectSelector {

	List<Opportunity> selectById(Set<Id> idSet);
	List<Opportunity> selectByIdNoContractNoOrdersSowApproved(Set<Id> idSet);
}