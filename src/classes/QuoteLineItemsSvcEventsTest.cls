@IsTest
private class QuoteLineItemsSvcEventsTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new QuoteLineItemsSvcEvents());
	}
}