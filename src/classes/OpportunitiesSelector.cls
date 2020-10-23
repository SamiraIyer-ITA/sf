/**
 * Opportunity fflib Selector
 *
 * @author Andrew La Russa
 */
public class OpportunitiesSelector extends fflib_SObjectSelector implements IOpportunitiesSelector {

	public static IOpportunitiesSelector newInstance()  {
		return (IOpportunitiesSelector) fflibext_Application.Selector.newInstance(Opportunity.SObjectType);
	}

	public List<Opportunity> selectById(Set<Id> idSet) {
		return (List<Opportunity>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Opportunity.Id
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Opportunity.SObjectType;
	}
}