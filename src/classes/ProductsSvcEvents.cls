/**
 * Products Service Events implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class ProductsSvcEvents extends SObjectsTriggerService implements IProductsSvcEvents {

	public override void onBeforeInsert(List<SObject> records) {
		setProductCodes((List<Product2>) records);
	}

	public void setProductCodes(List<Product2> products) {
		((IProductCodeGenerator)
			di_Injector.Org.getInstance(EventProductCodeGenerator.class))
				.setProductCodes(products);
	}
}