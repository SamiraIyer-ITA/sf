/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class SegmentMapper implements ADCVD_IMapper {
	public static SegmentMapper instance = (SegmentMapper)ADCVD_CaseMapper.mapperMap.get('Segment__c');
	public static Map<Id,Segment__c> idToUnlockedSegmentMap = new Map<Id,Segment__c>();
	public static Map<Id,Segment__c> idToAllSegmentMap = new Map<Id,Segment__c>();
	public SegmentMapper() {}
	private SegmentMapper(Set<Id> segmentIdSet) {
		if (idToUnlockedSegmentMap.isEmpty()) {
			for (Segment__c s : SegmentSelector.newInstance().selectById(segmentIdSet)) {
				addSegmentToMap(s);
			}
		}
	}
	public static SegmentMapper getInstance () {
		if (instance == null) {
			return getNewInstance();
		}
		return instance;
	}
	public static SegmentMapper getNewInstance() {
		Set<Id> segmentIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToSegmentIdMap.keySet()) {
			segmentIdSet.addAll(ADCVD_CaseMapper.caseIdToSegmentIdMap.get(caseId));
		}
		instance = new SegmentMapper(segmentIdSet);
		ADCVD_CaseMapper.mapperMap.put('Segment__c', instance);
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