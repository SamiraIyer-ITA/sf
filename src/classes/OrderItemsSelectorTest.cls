@IsTest
private class OrderItemsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<OrderItem> result = OrderItemsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
    
    @IsTest
	static void testSelectRelatedRecords() {
		List<OrderItem> result = OrderItemsSelector.newInstance().selectRelatedRecords(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}
