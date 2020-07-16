@IsTest
private class UsersSelectorTest {

	@testSetup static void testSetup() {
		User adminUser = TestUtils.createAdminUser(true, 'admin@trade.gov', 1);
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Test User', account.Id, true);
		User communityUser = TestUtils.createCommunityUser('commuser@trade.gov', contact.Id);
	}

	@IsTest
	static void selectById_Positive() {
		List<User> users = [SELECT Id FROM User WHERE Email = 'commuser@trade.gov'];
		Set<Id> userIds = new Set<Id>();
		for (User user: users) {
			userIds.add(user.Id);
		}
		List<User> result = UsersSelector.newInstance().selectById(userIds);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List not empty');
	}

}