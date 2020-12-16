@IsTest
private class QuotesTest {

	static Id quoteId = fflib_IDGenerator.generate(Quote.SObjectType);

	@IsTest
	static void testNewInstanceOfQuotesDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Quote> quoteList  = new List<Quote>{ new Quote() };
		IQuotes iQuotes = (IQuotes) Quotes.newInstance(quoteList);
		System.assertNotEquals(iQuotes, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfQuotesDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> quoteIds = new Set<Id>{ quoteId };
		IQuotes iQuotes = (IQuotes) Quotes.newInstance(quoteIds);
		System.assertNotEquals(iQuotes, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testOrdersTrigger_InsertOrderRecord_TriggerIsCovered() {
		try { insert new Quote(); } catch (Exception e) {}
	}
}
