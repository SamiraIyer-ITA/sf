@IsTest
private class QuotesServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(QuotesService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(QuotesService.service(new List<Quote>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithQuoteList() {
		List<Quote> testQuoteList = new List<Quote>{
				new Quote(
					Id = fflib_IDGenerator.generate(Quote.SObjectType)
				)
		};
		System.assertNotEquals(QuotesService.triggerService(testQuoteList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithQuoteListAndMap() {
		List<Quote> testQuoteList = new List<Quote>{
			new Quote(
				Id = fflib_IDGenerator.generate(Quote.SObjectType)
			)
		};
		System.assertNotEquals(QuotesService.triggerService(testQuoteList, new Map<Id, Quote>(testQuoteList)),
			null, 'Verify we call the trigger service');
	}
}