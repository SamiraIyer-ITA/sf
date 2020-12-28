@IsTest
private class OpportunitiesSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new OpportunitiesSvcLibrary());
	}
}