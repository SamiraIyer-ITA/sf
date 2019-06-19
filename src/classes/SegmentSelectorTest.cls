@IsTest
private class SegmentSelectorTest {
	@IsTest
	static void testBehavior() {
		SegmentSelector.newInstance().selectById(new Set<Id>());
		SegmentSelector.newInstance().selectByWhereClause('test');
		SegmentSelector.newInstance().selectAllToLimit();
	}
}