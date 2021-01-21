/**
 * Implementation of IProducts interface that will be used as an fflib domain object.
 *
 * @author Andrew La Russa
 */
public class Products extends fflib_SObjectDomain implements IProducts   {

	public static IProducts newInstance(List<Product2> records)  {
		return (IProducts) fflibext_Application.Domain.newInstance(records);
	}

	public static IProducts newInstance(Set<Id> recordIds) {
		return (IProducts) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Products(List<Product2> sObjectList) {
		super(sObjectList);
	}

	public override void onBeforeInsert() {
		ProductsService.handleBeforeInsert(Records);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Products(sObjectList);
		}
	}
}