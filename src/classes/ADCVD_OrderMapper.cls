/**
 * 
 *    Created by Joshua Moody
 *    on 6/22/2018
 *    MIL Corporation
 * 
 **/
public without sharing class ADCVD_OrderMapper implements ADCVD_IMapper{

	public static ADCVD_OrderMapper instance = (ADCVD_OrderMapper)ADCVD_CaseMapper.mapperMap.get('ADCVD_Order__c');
	public static Map<Id,ADCVD_Order__c> idToUnlockedOrderMap = new Map<Id,ADCVD_Order__c>();
	public static Map<Id,ADCVD_Order__c> idToAllOrderMap = new Map<Id,ADCVD_Order__c>();
	public ADCVD_OrderMapper() {}
	private ADCVD_OrderMapper(Set<Id> orderIdSet) {
		if (idToUnlockedOrderMap.isEmpty()) {
			
			List<ADCVD_Order__c> tempList = new List<ADCVD_Order__c>();
			String queryString = Utils.soqlBuilderAllFields('ADCVD_Order__c', false);
			queryString += ' FROM ADCVD_Order__c WHERE Id IN: orderIdSet';
			tempList = database.query(queryString);
			for (ADCVD_Order__c ao : tempList) {
				addOrderToMap(ao);
			}
		}
	}
	public static ADCVD_OrderMapper getInstance () {
		if (instance == null) {
			System.debug('ADCVD_OrderMapper instance: ' + instance);
			return getNewInstance();
		}
		return instance;
	}
	public static ADCVD_OrderMapper getNewInstance() {
		Set<Id> orderIdSet = new Set<Id>();
		for (Id caseId : ADCVD_CaseMapper.caseIdToOrderIdMap.keySet()) {
			orderIdSet.addAll(ADCVD_CaseMapper.caseIdToOrderIdMap.get(caseId));
		}
		instance = new ADCVD_OrderMapper(orderIdSet);
		ADCVD_CaseMapper.mapperMap.put('ADCVD_Order__c', instance);
		return instance;
	}
	public Map<Id, ADCVD_Order__c> getMap() {
		return idToUnlockedOrderMap;
	}
	public Map<Id,ADCVD_Order__c> getMap(Boolean includeLocked) {
		if (includeLocked) {
			return idToAllOrderMap;
		} else {
			return idToUnlockedOrderMap;
		}
	}

	public void addOrderToMap(ADCVD_Order__c ao) {
		if (!ao.Locked__c) {
			idToUnlockedOrderMap.put(ao.Id, ao);
		}
		idToAllOrderMap.put(ao.Id, ao);
	}
}