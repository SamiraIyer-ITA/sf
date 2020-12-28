/**
 * Implementation of IContracts interface that will be used as an fflib domain object.
 *
 * @author Daniel Haro
 */
public class Contracts extends fflib_SObjectDomain implements IContracts {

	public static IContracts newInstance(List<Contract> records)  {
		return (IContracts) fflibext_Application.Domain.newInstance(records);
	}

	public static IContracts newInstance(Set<Id> recordIds) {
		return (IContracts) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Contracts(List<Contract> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Contracts(sObjectList);
		}
	}
}