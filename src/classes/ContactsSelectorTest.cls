@IsTest
private class ContactsSelectorTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Test User', account.Id, true);
	}

	@IsTest
	static void selectById_Positive() {
		List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = 'Test User'];
		Set<Id> contactIds = new Set<Id>();
		for (Contact contact: contacts) {
			contactIds.add(contact.Id);
		}
		List<Contact> result = ContactsSelector.newInstance().selectById(contactIds);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List not empty');
	}

}