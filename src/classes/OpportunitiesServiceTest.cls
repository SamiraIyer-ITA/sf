@IsTest
private class OpportunitiesServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(OpportunitiesService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(OpportunitiesService.service(new List<Opportunity>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithOpportunityList() {
		List<Opportunity> testOppList = new List<Opportunity>{
				new Opportunity(
					Id = fflib_IDGenerator.generate(Opportunity.SObjectType)
				)
		};
		System.assertNotEquals(OpportunitiesService.triggerService(testOppList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithOpportunityListAndMap() {
		List<Opportunity> testOppList = new List<Opportunity>{
			new Opportunity(
				Id = fflib_IDGenerator.generate(Opportunity.SObjectType)
			)
		};
		System.assertNotEquals(OpportunitiesService.triggerService(testOppList, new Map<Id, Opportunity>(testOppList)),
			null, 'Verify we call the trigger service');
	}
}