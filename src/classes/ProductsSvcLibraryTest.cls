@IsTest
private class ProductsSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new ProductsSvcLibrary());
	}
}