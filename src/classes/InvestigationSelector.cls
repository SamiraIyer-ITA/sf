public without sharing class InvestigationSelector implements ADCVD_Selector{

	public static InvestigationSelector instance = (InvestigationSelector)ADCVD_CaseSelector.selectorMap.get('Investigation__c');
	public static Map<Id,Investigation__c> idToUnlockedInvestigationMap = new Map<Id,Investigation__c>();
	public static Map<Id,Investigation__c> idToAllInvestigationMap = new Map<Id,Investigation__c>();
	public InvestigationSelector() {}
	private InvestigationSelector(Set<Id> investigationIdSet) {
		if (idToUnlockedInvestigationMap.isEmpty()) {
			
			List<Investigation__c> tempList = new List<Investigation__c>();
			String queryString = Utils.soqlBuilderAllFields('Investigation__c', false);
			queryString += ' FROM Investigation__c WHERE Id IN: investigationIdSet';
			tempList = database.query(queryString);
			for (Investigation__c i : tempList) {
				addInvToMap(i);
			}
		}
	}
	public static InvestigationSelector getInstance () {
		if (instance == null) {
			System.debug('InvestigationSelector instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static InvestigationSelector getNewInstance() {
		Set<Id> investigationIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseSelector.caseIdToInvestigationIdMap.keySet()) {
			investigationIdSet.addAll(ADCVD_CaseSelector.caseIdToInvestigationIdMap.get(caseId));
		}
		instance = new InvestigationSelector(investigationIdSet);
		ADCVD_CaseSelector.selectorMap.put('Investigation__c', instance);
		return instance;
	}
	public Map<Id, Investigation__c> getMap() {
		return idToUnlockedInvestigationMap;
	}
	public Map<Id,Investigation__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllInvestigationMap;
		} else {
			return idToUnlockedInvestigationMap;
		}
	}

	public void addInvToMap(Investigation__c i) {
		if (!i.Locked__c) {
			idToUnlockedInvestigationMap.put(i.Id, i);
		}
		idToAllInvestigationMap.put(i.Id, i);
	}

	public static List<Investigation__c> allInvestigations {
		get {
			if (allInvestigations == null) {
				String query = Utils.soqlBuilderAllFields('Investigation__c', true);
				allInvestigations = database.query(query);
			}
			return allInvestigations;
		} set;
	}

}