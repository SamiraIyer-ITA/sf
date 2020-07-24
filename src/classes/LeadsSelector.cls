/**
 * Lead fflib Selector
 *
 * @author Andrew La Russa
 */
public class LeadsSelector extends fflib_SObjectSelector implements ILeadsSelector {

	public static ILeadsSelector newInstance()  {
		return (ILeadsSelector) fflibext_Application.Selector.newInstance(Lead.SObjectType);
	}

	public List<Lead> selectById(Set<Id> idSet) {
		return (List<Lead>) selectSObjectsById(idSet);
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Lead.Id
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Lead.SObjectType;
	}
}