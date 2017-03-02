public without sharing class ADCVD_FederalRegisterUtility {
	/*************************************************************
	This utility provides object agnostic methods to query the
	Federal Register Object for use in other object triggers.
	 ************************************************************/

 	//Object agnostic variables
	@TestVisible private static String parentObjectName = '';
	@TestVisible private static Map<Id,Map<String,List<Federal_Register__c>>> parentIdToFRsMap = new Map<Id,Map<String,List<Federal_Register__c>>>();

	//accepts list of SObjects, returns map of parent SObject to list of child Federal_Register__c
	public static Map<Id,Map<String,List<Federal_Register__c>>> getParentIdToFRsMap(List<SObject> parentObjectList) {
		initialize(parentObjectList);
		System.debug(parentObjectName);
		if (parentIdToFRsMap.size() < 1) {
			addFRsToMap(parentObjectList);
		}
		return parentIdToFRsMap;
	}
	//set parentObjectName
	@TestVisible private static void initialize(List<SObject> parentObjectList) {
		if(String.isBlank(parentObjectName)) {
			parentObjectName = utils.getSObjectName(parentObjectList[0]);//parentObjectName specifies fields to query and the lookup field to use for Investigation__c and Segment__c
		} else if(parentObjectName != utils.getSObjectName(parentObjectList[0])) {//switched to a new object
			parentIdToFRsMap.clear();
			parentObjectName = utils.getSObjectName(parentObjectList[0]);
		} else {//same object, but a new cascading update
			parentIdToFRsMap.clear();
		}
	}
	//get Id set from parentObjectList for query
	@TestVisible private static Set<Id> setParentObjectIdSet(List<SObject> parentObjectList) {
		Set<Id> returnSet = new Set<Id>();
		for(SObject o : parentObjectList) {
			returnSet.add(o.Id);
		}
		return returnSet;
	}
	@TestVisible private static String setLookupFieldName() {
		String returnString = '';
		if(parentObjectName == 'Investigation__c' || parentObjectName == 'Segment__c') {
			returnString = parentObjectName;
		}//add else if lookup field API is not the same as Object name
		return returnString;
	}
	//query all fields from Federal_Register__c where the Id dynamic lookup field stored in parentObjectName is in the Id set created from parentObjectList
	@TestVisible private static void addFRsToMap(List<SObject> parentObjectList) {
		Set<Id> parentObjectIdSet = setParentObjectIdSet(parentObjectList);//create set for dynamic SOQL
		String lookupFieldName = setLookupFieldName();
		List<Federal_Register__c> frList = new List<Federal_Register__c>();
		String frQuery = 'SELECT ';
		for(String fieldName : utils.getFieldMap('Federal_Register__c').keySet()) {
			frQuery += fieldName + ', ';//Add all Federal_Register__c fields to query
		}
		frQuery = frQuery.removeEnd(', ');
		frQuery += ' FROM Federal_Register__c WHERE ' + lookupFieldName + ' IN: parentObjectIdSet';//limit by the Ids gathered from the current set
		System.debug('*** frQuery: ' + frQuery);
		frList = Database.Query(frQuery);
		System.debug('*** frList: ' + frList);
		for (Federal_Register__c fr : frList) {
			Id tempId = (Id)fr.get(lookupFieldName);
			if (parentIdToFRsMap.get(tempId) != null && parentIdToFRsMap.get(tempId).get(fr.Type__c) != null) {//add new Fr to existing map
				Map<String,List<Federal_Register__c>> tempMap = parentIdToFRsMap.get(tempId);
				List<Federal_Register__c> tempList = tempMap.get(fr.Type__c);
				tempList.add(fr);
				tempMap.put(fr.Type__c, tempList);
				parentIdToFRsMap.put(tempId, tempMap);
			} else {//new type or new Id
				Map<String,List<Federal_Register__c>> tempMap = new Map<String,List<Federal_Register__c>>();
				List<Federal_Register__c> tempList = new List<Federal_Register__c>();
				tempList.add(fr);
				tempMap.put(fr.Type__c, tempList);
				parentIdToFRsMap.put(tempId, tempMap);
			}
		}
	}
}