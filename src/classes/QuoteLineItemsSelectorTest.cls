@IsTest
private class QuoteLineItemsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<QuoteLineItem> result = QuoteLineItemsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByIdAndRecordTypeOppNotClosedQuoteIsSyncingPrimaryWithOrderItems() {
		List<QuoteLineItem> result = QuoteLineItemsSelector.newInstance()
			.selectByIdAndRecordTypeOppNotClosedQuoteIsSyncingPrimaryWithOrderItems(new Set<Id> {}, '');
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}