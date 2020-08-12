@IsTest
private class LeadsImplManagerTest {

	@IsTest
	static void test_passLeadsListConstructor() {
		LeadsImplManager manager = new LeadsImplManager(new List<Lead>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passLeadsListAndMapConstructor() {
		LeadsImplManager manager
			= new LeadsImplManager(new List<Lead>(), new Map<Id, SObject>(new List<Lead>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}
}