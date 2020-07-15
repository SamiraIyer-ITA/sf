@IsTest
private class LeadsServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(LeadsService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(LeadsService.service(new List<Lead>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithLeadList() {
		List<Lead> testLeadList = new List<Lead>{
				new Lead(
					Id = fflib_IDGenerator.generate(Lead.SObjectType)
				)
		};
		System.assertNotEquals(LeadsService.triggerService(testLeadList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithLeadListAndMap() {
		List<Lead> testLeadList = new List<Lead>{
			new Lead(
				Id = fflib_IDGenerator.generate(Lead.SObjectType)
			)
		};
		System.assertNotEquals(LeadsService.triggerService(testLeadList, new Map<Id, Lead>(testLeadList)),
			null, 'Verify we call the trigger service');
	}
}