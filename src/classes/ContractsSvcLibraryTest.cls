@IsTest
private class ContractsSvcLibraryTest {

	@IsTest
	static void testNewInstance_EmptyConstructor() {
		System.assertNotEquals(null, new ContractsSvcLibrary());
	}
}