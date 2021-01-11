@IsTest
private class QuotesSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new QuotesSvcLibrary());
	}
}