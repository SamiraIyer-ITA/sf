@IsTest
public class LitigationSelectorTest {
	@IsTest
	static void testBehavior() {
		LitigationSelector.newInstance().selectById(new Set<Id>());
		LitigationSelector.newInstance().selectByWhereClause('Id != null');
		LitigationSelector.newInstance().selectAllToLimit();
	}
}
