/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class Suspension_AgreementMapper implements ADCVD_IMapper {
	public static Suspension_AgreementMapper instance = (Suspension_AgreementMapper)ADCVD_CaseMapper.mapperMap.get('Suspension_Agreement__c');
	public static Map<Id,Suspension_Agreement__c> idToUnlockedSuspAgrmtMap = new Map<Id,Suspension_Agreement__c>();
	public static Map<Id,Suspension_Agreement__c> idToAllSuspAgrmtMap = new Map<Id,Suspension_Agreement__c>();
	public Suspension_AgreementMapper() {}
	private Suspension_AgreementMapper(Set<Id> suspAgrmtIdSet) {
		if (idToUnlockedSuspAgrmtMap.isEmpty()) {
			for (Suspension_Agreement__c sa : SuspensionAgreementSelector.newInstance().selectById(suspAgrmtIdSet)) {
				addSuspAgrmtToMap(sa);
			}
		}
	}
	public static Suspension_AgreementMapper getInstance () {
		if (instance == null) {
			System.debug('Suspension_AgreementMapper instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static Suspension_AgreementMapper getNewInstance() {
		Set<Id> suspAgrmtIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToSuspAgrmtIdMap.keySet()) {
			suspAgrmtIdSet.addAll(ADCVD_CaseMapper.caseIdToSuspAgrmtIdMap.get(caseId));
		}
		instance = new Suspension_AgreementMapper(suspAgrmtIdSet);
		ADCVD_CaseMapper.mapperMap.put('Suspension_Agreement__c', instance);
		return instance;
	}
	public Map<Id, Suspension_Agreement__c> getMap() {
		return idToUnlockedSuspAgrmtMap;
	}
	public Map<Id,Suspension_Agreement__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllSuspAgrmtMap;
		} else {
			return idToUnlockedSuspAgrmtMap;
		}
	}

	public void addSuspAgrmtToMap(Suspension_Agreement__c sa) {
		if (!sa.Locked__c) {
			idToUnlockedSuspAgrmtMap.put(sa.Id, sa);
		}
		idToAllSuspAgrmtMap.put(sa.Id, sa);
	}
}