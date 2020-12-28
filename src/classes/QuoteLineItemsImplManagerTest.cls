@IsTest
private class QuoteLineItemsImplManagerTest {

	@IsTest
	static void test_passQuoteLineItemsListConstructor() {
		QuoteLineItemsImplManager manager = new QuoteLineItemsImplManager(new List<QuoteLineItem>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passQuoteLineItemsListAndMapConstructor() {
		QuoteLineItemsImplManager manager
			= new QuoteLineItemsImplManager(new List<QuoteLineItem>(), new Map<Id, SObject>(new List<QuoteLineItem>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}
}