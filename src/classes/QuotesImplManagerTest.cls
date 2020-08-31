@IsTest
private class QuotesImplManagerTest {

	@IsTest
	static void test_passQuotesListConstructor() {
		QuotesImplManager manager = new QuotesImplManager(new List<Quote>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passQuotesListAndMapConstructor() {
		QuotesImplManager manager
			= new QuotesImplManager(new List<Quote>(), new Map<Id, SObject>(new List<Quote>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}
}