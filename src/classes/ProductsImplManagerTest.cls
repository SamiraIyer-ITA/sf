@IsTest
private class ProductsImplManagerTest {

	@IsTest
	static void test_passProductsListConstructor() {
		ProductsImplManager manager = new ProductsImplManager(new List<Product2>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passProductsListAndMapConstructor() {
		ProductsImplManager manager
			= new ProductsImplManager(new List<Product2>(), new Map<Id, SObject>(new List<Product2>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}
}