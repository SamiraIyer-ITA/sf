@IsTest
private class ProductsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<Product2> result = ProductsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectMaxProductCodesByFamily() {
		Product2 product = new Product2(
			Name = 'Test Product',
			Family = 'Certified Trade Mission',
			ProductCode = '0N01'
		);
		insert product;
		Set<String> filters = new Set<String>{ '%0N__' };
		Map<String, Object> valuesByAlias
			= ProductsSelector.newInstance().selectMaxProductCodesByFamily(filters)[0].getValuesByAlias();
		System.assertEquals('Certified Trade Mission',  valuesByAlias.get('Family'));
		System.assertEquals('0N01',  valuesByAlias.get('maxSmartCode'));
	}
}