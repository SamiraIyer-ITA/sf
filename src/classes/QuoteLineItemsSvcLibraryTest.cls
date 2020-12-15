/**
 * Created by andre on 12/15/2020.
 */

@IsTest
private class QuoteLineItemsSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new QuoteLineItemsSvcLibrary());
	}
}