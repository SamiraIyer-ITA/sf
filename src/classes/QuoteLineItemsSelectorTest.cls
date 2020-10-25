@IsTest
private class QuoteLineItemsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<QuoteLineItem> result = QuoteLineItemsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems() {
		List<QuoteLineItem> result = QuoteLineItemsSelector.newInstance()
			.selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByIdWithProductFields() {
		List<QuoteLineItem> result = QuoteLineItemsSelector.newInstance()
			.selectByIdWithProductFields(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}