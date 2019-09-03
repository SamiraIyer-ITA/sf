@IsTest
private class AccountSelectorTest {

	@IsTest
	static void AccountSelector_PassEmptySetOfIds_ReturnsEmptyListOfAccounts(){
		List<Account> result = AccountSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

}