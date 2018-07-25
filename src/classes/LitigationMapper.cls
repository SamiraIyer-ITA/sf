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
	
    @TestVisible 
    private LitigationMapper(Set<Id> litigationIdSet) 
    {
		if (idToUnlockedLitigationMap.isEmpty()) {         
            List<Litigation__c> litigationList = LitigationSelector.newInstance().selectById(litigationIdSet);            
			for (Litigation__c l : litigationList) {
				addLitigationToMap(l);
			}                
		}
	}
    
	public static LitigationMapper getInstance () {
		System.debug('LitigationMapper instance: ' + instance);
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

	public void addLitigationToMap(Litigation__c l) {
		if (!l.Locked__c) {
			idToUnlockedLitigationMap.put(l.Id, l);
		}
		idToAllLitigationMap.put(l.Id, l);
	}
}