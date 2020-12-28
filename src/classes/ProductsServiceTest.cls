@IsTest
private class ProductsServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(ProductsService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(ProductsService.service(new List<Product2>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithProduct2List() {
		List<Product2> testProductList = new List<Product2>{
				new Product2(
					Id = fflib_IDGenerator.generate(Product2.SObjectType)
				)
		};
		System.assertNotEquals(ProductsService.triggerService(testProductList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithProduct2ListAndMap() {
		List<Product2> testProductList = new List<Product2>{
			new Product2(
				Id = fflib_IDGenerator.generate(Product2.SObjectType)
			)
		};
		System.assertNotEquals(ProductsService.triggerService(testProductList, new Map<Id, Product2>(testProductList)),
			null, 'Verify we call the trigger service');
	}
}