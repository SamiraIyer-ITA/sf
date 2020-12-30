@IsTest
private class ContractsServiceTest {

	@IsTest
	static void test_baseService() {
		System.assertNotEquals(ContractsService.service(), null, 'Verify we call the base service');
	}

	@IsTest
	static void test_implService() {
		System.assertNotEquals(ContractsService.service(new List<Contract>()), null,
			'Verify we call the impl service');
	}

	@IsTest
	static void test_passTriggerServiceWithContractList() {
		List<Contract> testContractList = new List<Contract>{
				new Contract(
					Id = fflib_IDGenerator.generate(Contract.SObjectType)
				)
		};
		System.assertNotEquals(ContractsService.triggerService(testContractList), null,
			'Verify we call the trigger service');
	}

	@IsTest
	static void test_passTriggerServiceWithContractListAndMap() {
		List<Contract> testContractList = new List<Contract>{
			new Contract(
				Id = fflib_IDGenerator.generate(Contract.SObjectType)
			)
		};
		System.assertNotEquals(ContractsService.triggerService(testContractList, new Map<Id, Contract>(testContractList)),
			null, 'Verify we call the trigger service');
	}
}