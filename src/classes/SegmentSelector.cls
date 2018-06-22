/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class SegmentSelector implements ADCVD_Selector {
	public static SegmentSelector instance = (SegmentSelector)ADCVD_CaseSelector.selectorMap.get('Segment__c');
	public static Map<Id,Segment__c> idToUnlockedSegmentMap = new Map<Id,Segment__c>();
	public static Map<Id,Segment__c> idToAllSegmentMap = new Map<Id,Segment__c>();
	public SegmentSelector() {}
	private SegmentSelector(Set<Id> segmentIdSet) {
		if (idToUnlockedSegmentMap.isEmpty()) {
			
			List<Segment__c> tempList = new List<Segment__c>();
			String queryString = Utils.soqlBuilderAllFields('Segment__c', false);
			queryString += ' FROM Segment__c WHERE Id IN: segmentIdSet';
			tempList = database.query(queryString);
			for (Segment__c s : tempList) {
				addSegmentToMap(s);
			}
		}
	}
	public static SegmentSelector getInstance () {
		if (instance == null) {
			System.debug('SegmentSelector instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static SegmentSelector getNewInstance() {
		Set<Id> segmentIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseSelector.caseIdToSegmentIdMap.keySet()) {
			segmentIdSet.addAll(ADCVD_CaseSelector.caseIdToSegmentIdMap.get(caseId));
		}
		instance = new SegmentSelector(segmentIdSet);
		ADCVD_CaseSelector.selectorMap.put('Segment__c', instance);
		return instance;
	}
	public Map<Id, Segment__c> getMap() {
		return idToUnlockedSegmentMap;
	}
	public Map<Id,Segment__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllSegmentMap;
		} else {
			return idToUnlockedSegmentMap;
		}
	}

	public void addSegmentToMap(Segment__c s) {
		if (!s.Locked__c) {
			idToUnlockedSegmentMap.put(s.Id, s);
		}
		idToAllSegmentMap.put(s.Id, s);
	}
}