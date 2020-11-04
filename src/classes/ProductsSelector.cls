/**
 * Product2 fflib Selector
 *
 * @author Andrew La Russa
 */
public class ProductsSelector extends fflib_SObjectSelector implements IProductsSelector {

	public static IProductsSelector newInstance()  {
		return (IProductsSelector) fflibext_Application.Selector.newInstance(Product2.SObjectType);
	}

	public List<Product2> selectById(Set<Id> idSet) {
		return (List<Product2>) selectSObjectsById(idSet);
	}

	public AggregateResultProxy[] selectMaxProductCodesByFamily(Set<String> filters) {
		AggregateResultProxy[] groupedResultProxies = new List<AggregateResultProxy>();
		for (AggregateResult groupedResult : [
			SELECT 	Family,
					MAX(Accounting_Code__c) maxSmartCode
			FROM 	Product2
			WHERE 	Accounting_Code__c LIKE :filters
			GROUP 	BY Family
		]) {
			groupedResultProxies.add(new AggregateResultProxy().withAggregateResult(groupedResult));
		}
		return groupedResultProxies;
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Product2.Description,
			Product2.Id,
			Product2.IsActive,
			Product2.Name,
			Product2.ProductCode,
			Product2.Family,
			Product2.Event_Type_Smart_Code__c,
            		Product2.Accounting_Code__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Product2.SObjectType;
	}

}
