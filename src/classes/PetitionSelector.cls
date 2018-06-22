public without sharing class PetitionSelector implements ADCVD_Selector {

	public static PetitionSelector instance = (PetitionSelector)ADCVD_CaseSelector.selectorMap.get('Petition__c');
	public static Map<Id,Petition__c> idToUnlockedPetitionMap = new Map<Id,Petition__c>();
	public static Map<Id,Petition__c> idToAllPetitionMap = new Map<Id,Petition__c>();
	public PetitionSelector() {}
	private PetitionSelector(Set<Id> petitionIdSet) {
		if(idToUnlockedPetitionMap.isEmpty()) {
			List<Petition__c> tempList = new List<Petition__c>();
			String queryString = Utils.soqlBuilderAllFields('Petition__c', false);
			queryString += ' FROM Petition__c WHERE Id IN: petitionIdSet';
			tempList = database.query(queryString);
			for (Petition__c p : tempList) {
				addPetToMap(p);
			}
		}
	}
	public static PetitionSelector getInstance () {
		System.debug('PetitionSelector instance: ' + instance);
		if (instance == null) {
			 return getNewInstance();
		}
		return instance;
	}
	public static PetitionSelector getNewInstance() {
		Set<Id> petitionIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseSelector.caseIdToPetitionIdMap.keySet()) {
			petitionIdSet.addAll(ADCVD_CaseSelector.caseIdToPetitionIdMap.get(caseId));
		}
		instance = new PetitionSelector(petitionIdSet);
		ADCVD_CaseSelector.selectorMap.put('Petition__c', instance);
		return instance;
	}
	public Map<Id,Petition__c> getMap() {
		return idToUnlockedPetitionMap;
	}
	public Map<Id,Petition__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllPetitionMap;
		} else {
			return idToUnlockedPetitionMap;
		}
	}

	public void addPetToMap(Petition__c p) {
		if (!p.Locked__c) {
			idToUnlockedPetitionMap.put(p.Id, p);
		}
		idToAllPetitionMap.put(p.id, p);
	}




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