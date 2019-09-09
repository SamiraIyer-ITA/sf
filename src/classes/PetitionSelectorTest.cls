@isTest
public class PetitionSelectorTest {
	@IsTest
	static void testBehavior() {
		PetitionSelector.newInstance().selectById(new Set<Id>());
		PetitionSelector.newInstance().selectByWhereClause('Id != null');
		PetitionSelector.newInstance().selectAllToLimit();
		List<Petition__c> petList = PetitionSelector.allPetitions;
	}
}
