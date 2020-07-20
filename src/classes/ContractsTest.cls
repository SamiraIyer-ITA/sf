@IsTest
private class ContractsTest {

	static Id contractId = fflib_IDGenerator.generate(Contract.SObjectType);

	@IsTest
	static void testNewInstanceOfContractsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Contract> contractList  = new List<Contract>{ new Contract() };
		IContracts iContracts = (IContracts) Contracts.newInstance(contractList);
		System.assertNotEquals(iContracts, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfContractsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> contractIds = new Set<Id>{ contractId };
		IContracts iContracts = (IContracts) Contracts.newInstance(contractIds);
		System.assertNotEquals(iContracts, null, 'Interface returned as null and should not have');
	}
}