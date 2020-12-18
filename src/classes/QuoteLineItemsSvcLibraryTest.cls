@IsTest
private class QuoteLineItemsSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new QuoteLineItemsSvcLibrary());
	}
}