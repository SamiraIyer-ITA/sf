public without sharing class PetitionSelector {

	public static List<Petition__c> allPetitions {
		get {
			if (allPetitions == null) {
				String query = Utils.soqlBuilderAllFields('Petition__c', true);
				allPetitions = database.query(query);
			}
			return allPetitions;
		} set;
	}
}