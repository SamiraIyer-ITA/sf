@IsTest
private class OpportunitiesSelectorTest {

	@IsTest
	static void testSelectById() {
		List<Opportunity> result = OpportunitiesSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}
}