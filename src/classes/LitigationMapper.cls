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
	public static Map<Id,Map<Id, Litigation__c>> parentIdToLitMap = new Map<Id,Map<Id, Litigation__c>>();

	public LitigationMapper() {}

	@TestVisible
	private LitigationMapper(Set<Id> litigationIdSet) {
		if (idToUnlockedLitigationMap.isEmpty()) {
			for (Litigation__c l : LitigationSelector.newInstance().selectById(litigationIdSet)) {
				addLitigationToMap(l);
			}
		}
	}

	public static LitigationMapper getInstance() {
		if (instance == null) {
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
	//method to return the parentIdtoLitMap
	public Map<Id, Map<Id,Litigation__c>> getParentToLitMap() {
		return parentIdToLitMap;
	}

	public void addLitigationToMap(Litigation__c l) {
		if (!l.Locked__c) {
			idToUnlockedLitigationMap.put(l.Id, l);
		}
		idToAllLitigationMap.put(l.Id, l);
		setParentIdToLitMap(l);
	}

	//method to update the parentIdToLitMap
	private void setParentIdToLitMap(Litigation__c lit) {
		//Create a temporary map
		Map<Id, Litigation__c> tempMap;
		//Populate the maps with each Federal Register returned
		Id parentId = (Id)lit.get(lit.Litigation_Parent__c);
		tempMap = parentIdToLitMap.containsKey(parentId) ?
			parentIdToLitMap.get(parentId) : new Map<Id, Litigation__c>();
		tempMap.put(lit.Id, lit);
		parentIdToLitMap.put(parentId, tempMap);
	}

}