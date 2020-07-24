/**
 * Implementation of ILeads interface that will be used as an fflib domain object.
 *
 * @author Andrew La Russa
 */
public class Leads extends fflib_SObjectDomain implements ILeads {

	public static ILeads newInstance(List<Lead> records)  {
		return (ILeads) fflibext_Application.Domain.newInstance(records);
	}

	public static ILeads newInstance(Set<Id> recordIds) {
		return (ILeads) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Leads(List<Lead> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Leads(sObjectList);
		}
	}
}