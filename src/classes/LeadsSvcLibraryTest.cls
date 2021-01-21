@IsTest
private class LeadsSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new LeadsSvcLibrary());
	}
}