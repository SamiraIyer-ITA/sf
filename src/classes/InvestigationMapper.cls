public without sharing class InvestigationMapper implements ADCVD_IMapper{

	public static InvestigationMapper instance = (InvestigationMapper)ADCVD_CaseMapper.mapperMap.get('Investigation__c');
	public static Map<Id,Investigation__c> idToUnlockedInvestigationMap = new Map<Id,Investigation__c>();
	public static Map<Id,Investigation__c> idToAllInvestigationMap = new Map<Id,Investigation__c>();
	public InvestigationMapper() {}
	private InvestigationMapper(Set<Id> investigationIdSet) {
		if (idToUnlockedInvestigationMap.isEmpty()) {
			for (Investigation__c i : InvestigationSelector.newInstance().selectById(investigationIdSet)) {
				addInvToMap(i);
			}
		}
	}
	public static InvestigationMapper getInstance () {
		if (instance == null) {
			return getNewInstance();
		}
		return instance;
	}
	public static InvestigationMapper getNewInstance() {
		Set<Id> investigationIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToInvestigationIdMap.keySet()) {
			investigationIdSet.addAll(ADCVD_CaseMapper.caseIdToInvestigationIdMap.get(caseId));
		}
		instance = new InvestigationMapper(investigationIdSet);
		ADCVD_CaseMapper.mapperMap.put('Investigation__c', instance);
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
				allInvestigations = InvestigationSelector.newInstance().selectAllToLimit();
			}
			return allInvestigations;
		} set;
	}

}