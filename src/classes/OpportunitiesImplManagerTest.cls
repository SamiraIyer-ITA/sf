@IsTest
private class OpportunitiesImplManagerTest {

	@IsTest
	static void test_passOpportunitiesListConstructor() {
		OpportunitiesImplManager manager = new OpportunitiesImplManager(new List<Opportunity>());
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_passOpportunitiesListAndMapConstructor() {
		OpportunitiesImplManager manager
			= new OpportunitiesImplManager(new List<Opportunity>(), new Map<Id, SObject>(new List<Opportunity>()));
		System.assert(manager.getRecordsByInterfaceType().isEmpty(), 'Should have no results');
	}

	@IsTest
	static void test_serviceServices() {
		System.assert(OpportunitiesImplManager.servicesService() instanceof OpportunitiesSvcServices);
	}
}