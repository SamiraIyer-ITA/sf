@IsTest
private class QuoteLineItemsServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(QuoteLineItemsService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(QuoteLineItemsService.service(new List<QuoteLineItem>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithQuoteLineItemList() {
		List<QuoteLineItem> testQuoteLineItemList = new List<QuoteLineItem>{
				new QuoteLineItem(
					Id = fflib_IDGenerator.generate(QuoteLineItem.SObjectType)
				)
		};
		System.assertNotEquals(QuoteLineItemsService.triggerService(testQuoteLineItemList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithQuoteLineItemListAndMap() {
		List<QuoteLineItem> testQuoteLineItemList = new List<QuoteLineItem>{
			new QuoteLineItem(
				Id = fflib_IDGenerator.generate(QuoteLineItem.SObjectType)
			)
		};
		System.assertNotEquals(QuoteLineItemsService.triggerService(testQuoteLineItemList, new Map<Id, QuoteLineItem>(testQuoteLineItemList)),
			null, 'Verify we call the trigger service');
	}
}