@isTest
public class PetitionSelectorTest {
	@IsTest
	static void testBehavior() {
		PetitionSelector.newInstance().selectById(new Set<Id>());
		PetitionSelector.newInstance().selectByWhereClause('test');
		PetitionSelector.newInstance().selectAllToLimit();
		List<Petition__c> petList = PetitionSelector.allPetitions;
	}
}