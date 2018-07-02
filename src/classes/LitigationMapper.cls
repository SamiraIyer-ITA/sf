/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class LitigationMapper implements ADCVD_IMapper {
	public static LitigationMapper instance = (LitigationMapper)ADCVD_CaseMapper.mapperMap.get('Litigation__c');
	public static Map<Id,Litigation__c> idToUnlockedLitigationMap = new Map<Id,Litigation__c>();
	public static Map<Id,Litigation__c> idToAllLitigationMap = new Map<Id,Litigation__c>();
	public LitigationMapper() {}
	private LitigationMapper(Set<Id> litigationIdSet) {
		if (idToUnlockedLitigationMap.isEmpty()) {
			
			List<Litigation__c> tempList = new List<Litigation__c>();
			String queryString = Utils.soqlBuilderAllFields('Litigation__c', false);
			queryString += ' FROM Litigation__c WHERE Id IN: litigationIdSet';
			tempList = database.query(queryString);
			for (Litigation__c l : tempList) {
				addLitigationToMap(l);
			}
		}
	}
	public static LitigationMapper getInstance () {
		if (instance == null) {
			System.debug('LitigationMapper instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static LitigationMapper getNewInstance() {
		Set<Id> litigationIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToLitigationIdMap.keySet()) {
			litigationIdSet.addAll(ADCVD_CaseMapper.caseIdToLitigationIdMap.get(caseId));
		}
		instance = new LitigationMapper(litigationIdSet);
		ADCVD_CaseMapper.mapperMap.put('Litigation__c', instance);
		return instance;
	}
	public Map<Id, Litigation__c> getMap() {
		return idToUnlockedLitigationMap;
	}
	public Map<Id,Litigation__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllLitigationMap;
		} else {
			return idToUnlockedLitigationMap;
		}
	}

	public void addLitigationToMap(Litigation__c l) {
		if (!l.Locked__c) {
			idToUnlockedLitigationMap.put(l.Id, l);
		}
		idToAllLitigationMap.put(l.Id, l);
	}
}