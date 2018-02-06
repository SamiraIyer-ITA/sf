/**
 * 
 *    Created by Joshua Moody
 *    on Aug 6 2017
 *    MIL Corporation
 * 
 **/

public without sharing class PetitionSelector {

	/******************************************************************
	PetitionSelector IS CURRENTLY USED IN APP, BUT NEEDS REFACTORS TO QUERY
	ONLY THE PETITIONS IN CONTEXT. CODE TO KNOW WHICH ARE IN CONTEXT IS 
	NEEDED FOR THIS REFACTOR.
	* This class queries Petitions and stores them in class
	* for faster reference by classes using custom metadata.
	* This class provides methods to:
	* 1. Query all Petitions
	* 2. Map those records for the easiest consumption by classes
	******************************************************************/

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