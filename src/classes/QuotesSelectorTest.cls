@IsTest
private class QuotesSelectorTest {

	@IsTest
	static void testSelectById() {
		List<Quote> result = QuotesSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectBySyncedQuotesAndOpportunitiesWithPrimaryLineItem() {
		List<Quote> result = QuotesSelector.newInstance()
			.selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByQuoteLineItemsIsSyncingOppNotClosedIsPrimary() {
		List<Quote> result = QuotesSelector.newInstance()
			.selectByQuoteLineItemsIsSyncingOppNotClosedIsPrimary(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}