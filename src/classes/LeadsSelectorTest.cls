@IsTest
private class LeadsSelectorTest {

	@IsTest
	static void testSelectById() {
		List<Lead> result = LeadsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}