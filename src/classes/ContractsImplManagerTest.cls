@IsTest
private class ContractsImplManagerTest {

	@IsTest
	static void test_passContractsListConstructor() {
		ContractsImplManager manager = new ContractsImplManager(new List<Contract>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passContractsListAndMapConstructor() {
		ContractsImplManager manager
			= new ContractsImplManager(new List<Contract>(), new Map<Id, SObject>(new List<Contract>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}
}