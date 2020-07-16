@IsTest
private class ContractsSelectorTest {

	@IsTest
	static void ContractsSelector_PassEmptySetOfIds_ReturnsEmptyListOfContracts(){
		List<Contract> result = ContractsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}