@isTest
public class InvestigationSelectorTest {
	@IsTest
	static void testBehavior() {
		InvestigationSelector.newInstance().selectById(new Set<Id>());
		InvestigationSelector.newInstance().selectByWhereClause('Id != null');
		InvestigationSelector.newInstance().selectByIdWithRelations(new Set<Id>());
		InvestigationSelector.newInstance().selectAllToLimit();
	}
}