public without sharing class PetitionSelector {

	public static List<Petition__c> petitionsInContext = new List<Petition__c>();

	public static List<Petition__c> allPetitions {
		get {
			if (allPetitions == null) {
				String query = Utils.soqlBuilderAllFields('Petition__c', true);
				allPetitions = database.query(query);
			}
			return allPetitions;
		} set;
	}

	public static List<Petition__c> getPetitionsInContext(Set<Id> petitionIdSet, Set<String> fields, Boolean newQuery) {
		if (newQuery) {
			petitionsInContext = (List<Petition__c>) Utils.getSObjectsInContext('Petition__c', petitionIdSet, fields);
		}
		return petitionsInContext;
	}
}