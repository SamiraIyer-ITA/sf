@IsTest
private class AppFactoryServicesMetadataSelectorTest {

	@IsTest
	static void testSelectById() {
		List<ApplicationFactory_Service__mdt> result
			= AppFactoryServicesMetadataSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByServiceImplementationSObjectDeveloperName() {
		AppFactoryServicesMetadataSelector.ImplementationWrapper result
		 = AppFactoryServicesMetadataSelector.newInstance()
			.selectByServiceImplementationSObjectDeveloperName(null);
		System.assert(result.appServices.isEmpty(), 'Selector returned empty list');
		System.assertEquals(null, result.implementationField, 'Implementation field should be null for no result');
	}
}