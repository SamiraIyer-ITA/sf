/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class Suspension_AgreementSelector implements ADCVD_Selector {
	public static Suspension_AgreementSelector instance = (Suspension_AgreementSelector)ADCVD_CaseSelector.selectorMap.get('Suspension_Agreement__c');
	public static Map<Id,Suspension_Agreement__c> idToUnlockedSuspAgrmtMap = new Map<Id,Suspension_Agreement__c>();
	public static Map<Id,Suspension_Agreement__c> idToAllSuspAgrmtMap = new Map<Id,Suspension_Agreement__c>();
	public Suspension_AgreementSelector() {}
	private Suspension_AgreementSelector(Set<Id> suspAgrmtIdSet) {
		if (idToUnlockedSuspAgrmtMap.isEmpty()) {
			
			List<Suspension_Agreement__c> tempList = new List<Suspension_Agreement__c>();
			String queryString = Utils.soqlBuilderAllFields('Suspension_Agreement__c', false);
			queryString += ' FROM Suspension_Agreement__c WHERE Id IN: suspAgrmtIdSet';
			tempList = database.query(queryString);
			for (Suspension_Agreement__c sa : tempList) {
				addSuspAgrmtToMap(sa);
			}
		}
	}
	public static Suspension_AgreementSelector getInstance () {
		if (instance == null) {
			System.debug('Suspension_AgreementSelector instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static Suspension_AgreementSelector getNewInstance() {
		Set<Id> suspAgrmtIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseSelector.caseIdToSuspAgrmtIdMap.keySet()) {
			suspAgrmtIdSet.addAll(ADCVD_CaseSelector.caseIdToSuspAgrmtIdMap.get(caseId));
		}
		instance = new Suspension_AgreementSelector(suspAgrmtIdSet);
		ADCVD_CaseSelector.selectorMap.put('Suspension_Agreement__c', instance);
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