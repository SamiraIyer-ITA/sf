public without sharing class SyncUtility {
	/*******************************************************************
	This utility class uses custom metadata to sync objects.  To setup 
	a new object to sync, create a custom metadata object with the same 
	fields as in Sync_Investigation__mdt. Every record added must have values 
	for source object, source field, destination field, and sync field.
	In this class, add a private static instance of both source and
	target objects, a set of strings contains all source objects on
	the custom metadata object, and a get method for your custom 
	metadata object. Most methods use the targetObjectName to specify
	object specific variables. Add else if statements to those methods
	and a set<YourSourceObject> Map and Id methods, similar to
	setPetitionMap.
	 *******************************************************************/

	//Object agnostic variables
	private static String targetObjectName = '';
	private static Set<String> sourceObjectNames = new Set<String>();
	private static Map<String,Map<String,String>> syncFieldMap = new Map<String,Map<String,String>>();
	private static Map<Id,SObject> sourceObjectsMap = new Map<Id,SObject>();
	private static Map<Id,String> sourceObjectsTypeMap = new Map<Id,String>();
	private static Map<Id,SObject> sourceIdToTargetObjectMap = new Map<Id,SObject>();

	//Object specific variables
	//Sync Petition to Investigation
	private static List<Investigation__c> investigationList = new List<Investigation__c>();
	private static Set<String> allInvestigationSources = new Set<String>{'Petition__c', 'Investigation__c'};
	private static List<Sync_Investigation__mdt> investigationCMT {
		get {
			if(investigationCMT == null) {
				investigationCMT = ([SELECT Source_Object__c, Source_Field__c, Destination_Field__c, Sync_Field__c
										FROM Sync_Investigation__mdt WHERE Source_Object__c IN: sourceObjectNames]);
			}
		return investigationCMT;
		}
	}

	//accepts object and String or null. If String is null, all sources is default
	public static void syncObject(List<SObject> targetObjectList, String sourceObjectName) {
		if (sourceObjectName != null) {
			sourceObjectNames.add(sourceObjectName);
		}
		syncObject(targetObjectList, sourceObjectNames, false);
	}
	//accepts object List and set of object names or boolean true to use all sources
	public static void syncObject(List<SObject> targetObjectList , Set<String> sourceObjects, Boolean allSources) {
		targetObjectName = utils.getSObjectName(targetObjectList[0]);//targetObjectName specifies which parts of the methods to run
		setSourceObjectNames(sourceObjects, allSources);//sets the names of the source objects to retrieve from
		initialize(targetObjectList);//Set targetObject values to class level object of targetObjectName's type
		setSyncFieldMap();//set the field api's for the sync from CMT
		setsourceObjectsMap();//set the source object values and add the target objects to target object map
		setTargetObjectValues();//set the values in the target object fields to the source object values
	}

	//method to set source Objects to query, handles nulls from syncObject params
	@TestVisible private static void setSourceObjectNames(Set<String> sourceObjects, Boolean allSources) {
		if(targetObjectName == 'Investigation__c') {
			if(sourceObjectNames == null || sourceObjectNames.size() < 1 || allSources) {
				sourceObjectNames.addAll(allInvestigationSources);
			} else {
				sourceObjectNames.addAll(sourceObjects);
			}
		}
	}
	//type cast the targetObjectList to a targetObject type so specific fields can be referenced
	@TestVisible private static void initialize(List<SObject> targetObjectList) {
		if(targetObjectName == 'Investigation__c') {
			investigationList = (List<Investigation__c>) targetObjectList;
		}
	}
	//query the CMT for the source object fields and set them to a map inside a object name map
	@TestVisible private static void setSyncFieldMap() {
		if(targetObjectName == 'Investigation__c') {
			addInvestigationFieldsToSyncFieldMap();
		}
	}
	//query the source objects for the values to sync
	@TestVisible private static void setsourceObjectsMap() {
		if(targetObjectName == 'Investigation__c') {
			for (String name : sourceObjectNames) {
				if(name != null && name.containsIgnoreCase('Petition__c')) {
					addPetitionsToSourceObjectsMap();
				}
				if(name != null && name.containsIgnoreCase('Investigation__c')) {
					addADInvestigationsToSourceObjectsMap();
				}
			}
		}
	}
	//sync the source values to the target object
	@TestVisible private static void setTargetObjectValues() {
		for (SObject sourceObject : sourceObjectsMap.values()) {//iterate through the objects queried
			Map<String,String> targetApiToSourceApiMap = syncFieldMap.get(sourceObjectsTypeMap.get(sourceObject.Id));//set the field api's from CMT to the source object type
			for (String targetObjectField : targetApiToSourceApiMap.keySet()) {//iterate through the target object field api's
				String sourceObjectField = targetApiToSourceApiMap.get(targetObjectField);//set the source field api that matches the target
				Object sourceValue = sourceObject.get(sourceObjectField);//instantiate an instance of the value from the source object using the source field api
				sourceIdToTargetObjectMap.get(sourceObject.Id).put(targetObjectField, sourceValue);//put the source value to the target object's target field
			}
		}
	}

	//Sync to Investigation methods to query needed source objects
	@TestVisible private static void addInvestigationFieldsToSyncFieldMap() {
		Map<String,String> petitionFieldMap = new Map<String,String>();
		Map<String,String> investigationFieldMap = new Map<String,String>();
		for (Sync_Investigation__mdt si : investigationCMT) {
			if (si.Sync_Field__c && sourceObjectNames.contains(si.Source_Object__c) && si.Source_Object__c == 'Petition__c') {//fields must be marked for sync and part of syncObjects params
				petitionFieldMap.put(si.Destination_Field__c, si.Source_Field__c);
			} else if (si.Sync_Field__c && sourceObjectNames.contains(si.Source_Object__c) && si.Source_Object__c == 'Investigation__c') {
				investigationFieldMap.put(si.Destination_Field__c, si.Source_Field__c);
			}
		}
		if (petitionFieldMap.size() > 0) {
			syncFieldMap.put('Petition__c', petitionFieldMap);//put that map of destination and source apis in the sync map, identified by the object type
		}
		if (investigationFieldMap.size() > 0) {
			syncFieldMap.put('Investigation__c', investigationFieldMap);
		}
	}
	@TestVisible private static Map<Id,Investigation__c> setPetitionIdToInvestigationMap() {
		Map<Id,Investigation__c> returnMap = new Map<Id,Investigation__c>();
		for (Investigation__c i : investigationList) {
			if (i.Petition__c != null) {
				returnMap.put(i.Petition__c, i);//create a set of petition Ids to query from the targetObjectList that was initialized
				sourceIdToTargetObjectMap.put(i.Petition__c, i);//add objects to the map that will be updated
			}
		}
		return returnMap;
	}

	@TestVisible private static void addPetitionsToSourceObjectsMap() {
		Set<Id> petitionIdSet = setPetitionIdToInvestigationMap().keySet();//create set for dynamic SOQL
		List<Petition__c> petitionList = new List<Petition__c>();
		String objectQuery = 'SELECT Id, ';
		for(Sync_Investigation__mdt si : investigationCMT) {
			if(si.Source_Object__c == 'Petition__c'){
				objectQuery += si.Source_Field__c + ', ';//Add CMT source fields to query
			}
		}
		objectQuery = objectQuery.removeEnd(', ');
		objectQuery += ' FROM Petition__c WHERE Id IN: petitionIdSet';//limit by the Ids gathered from the current set
		petitionList = Database.Query(objectQuery);
		System.debug('###@@ '+petitionList);
		for(Petition__c pet : petitionList) {
			sourceObjectsMap.put(pet.Id, pet);//set map of Id and values
			sourceObjectsTypeMap.put(pet.Id, 'Petition__c');//set map of Id and object type name
		}
	}
	@TestVisible private static Map<Id,Investigation__c> setAdIdToCvdInvestigationMap() {
		Map<Id,Investigation__c> returnMap = new Map<Id,Investigation__c>();
		for(Investigation__c i : investigationList) {
			if(i.AD_Investigation_Aligned_To__c != null) {
				returnMap.put(i.AD_Investigation_Aligned_To__c, i);//create a set of AD investigations to query from targetObjectList that was initialized
				sourceIdToTargetObjectMap.put(i.AD_Investigation_Aligned_To__c, i);//add objects to the map that will be updated
			}
		}
		return returnMap;
	}
	@TestVisible private static void addADInvestigationsToSourceObjectsMap() {
		Set<Id> adInvestigationIdSet = setAdIdToCvdInvestigationMap().keyset();
		System.debug('***&& '+adInvestigationIdSet);
		List<Investigation__c> adInvestigationList = new List<Investigation__c>();
		String objectQuery = 'SELECT Id, ';
		for(Sync_Investigation__mdt si : investigationCMT) {
			if(si.Source_Object__c == 'Investigation__c'){
				objectQuery += si.Source_Field__c + ', ';//Add CMT source fields to query
			}
		}
		objectQuery = objectQuery.removeEnd(', ');
		objectQuery += ' FROM Investigation__c WHERE Id IN: adInvestigationIdSet';//limit by Ids gathered from the current set
		adInvestigationList = Database.Query(objectQuery);
		System.debug('###@@ '+adInvestigationList);
		for(Investigation__c inv : adInvestigationList) {
			sourceObjectsMap.put(inv.Id, inv);//set map of Id and values
			sourceObjectsTypeMap.put(inv.Id, 'Investigation__c');//set map of Id and object type name
		}
	}	
}