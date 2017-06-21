public without sharing class SyncUtility {
	/*******************************************************************
	* This utility class uses custom metadata to sync objects.  To setup 
	* a new object to sync, create a custom metadata object with the same 
	* fields as in Sync_Utility__mdt. Every record added must have values 
	* for source object, source field, destination field, and sync field.
	* In this class, methods are either completely object agnostic and 
	* perform logic on SObjects, or they qualify their operations based
	* on the targetObjectName, or they type cast to the object type needed
	* (i.e. when specific custom fields need to be referenced).  To add to
	* a new source object to an existing target object, update the methods
	* within the targetObjectName qualifications and any Object specific
	* methods (listed after general methods).  To add a new target object,
	* add a new CMT object as described above, then add a set of all 
	* potential sources for that object and add an else if clause to all 
	* the methods with comments to do so. Lastly, add target object specific
	* dynamic method using dynamic soql at the bottom.
	********************************************************************/

	//Object agnostic variables
	@TestVisible private static String targetObjectName = '';
	@TestVisible private static Set<String> sourceObjectNames = new Set<String>();
	@TestVisible private static Map<String,Map<String,String>> syncFieldMap = new Map<String,Map<String,String>>();
	@TestVisible private static Map<String,String> sourceFieldQueries = new Map<String,String>();
	@TestVisible private static Map<Id,SObject> sourceObjectsMap = new Map<Id,SObject>();
	@TestVisible private static Map<Id,String> sourceObjectsTypeMap = new Map<Id,String>();
	@TestVisible private static Map<Id,List<SObject>> sourceIdToTargetObjectMap = new Map<Id,List<SObject>>();
	@TestVisible private static List<SObject> soList = new List<SObject>();
	@TestVisible private static List<Sync_Utility__mdt> syncUtilityCMT {
		get {
			if(syncUtilityCMT == null) {
				syncUtilityCMT = ([SELECT Source_Object__c, Source_Field__c, Destination_Field__c, Sync_This_Field__c, Synced_for_Final__c 
										FROM Sync_Utility__mdt WHERE Destination_Object__c =: targetObjectName AND Source_Object__c IN: sourceObjectNames]);
			}
		return syncUtilityCMT;
		}
	}

	//Object specific variables
	//Sync to Investigation
	@TestVisible private static List<Investigation__c> investigationList = new List<Investigation__c>();
	@TestVisible private static List<Petition__c> petitionList = new List<Petition__c>();
	@TestVisible private static Set<String> allInvestigationSources = new Set<String>{'Petition__c', 'Investigation__c'};
	//Sync to Recusal
	@TestVisible private static List<Recusal__c> recusalList = new List<Recusal__c>();
	@TestVisible private static Set<String> allRecusalSources = new Set<String>{'Recusal__c'};
	//Sync to New Shipper Review
	@TestVisible private static List<Segment__c> segmentList = new List<Segment__c>();
	@TestVisible private static Set<String> allSegmentSources = new Set<String>{'Segment__c'};
	@TestVisible private static Set<String> finalSyncLevelFieldSet = new Set<String>();
	
	
	/*******************************************************************
	 * syncObject is the public method class.  It is overloaded so a 
	 * single source object name can be passed as a string or a set of 
	 * source object names can be passed in a set. Additionally, there 
	 * is a boolean to set explicitly include all sources available for 
	 * an object.  If the source object name is passed as a null, the 
	 * result will be all source objects being synced.
	 * @param targetObjectList The list from the trigger calling this syncObject
	 * @param sourceObjectName The source objects to sync
	 *******************************************************************/

	//accepts object and String or null. If String is null, all sources is default
	public void syncObject(List<SObject> targetObjectList, String sourceObjectName) {
		Set<String> tempObjectNameSet = new Set<String>();
		if (sourceObjectName != null) {
			tempObjectNameSet.add(sourceObjectName);
		}
		syncObject(targetObjectList, tempObjectNameSet, false);
	}
	//accepts object List and set of object names or boolean true to use all sources
	public static void syncObject(List<SObject> targetObjectList , Set<String> sourceObjects, Boolean allSources) {
		initialize(targetObjectList);//Set targetObject values to class level object of targetObjectName's type
		setSourceObjectNames(sourceObjects, allSources);//sets the names of the source objects to retrieve from
		setSyncFieldMap();//set the field api's for the sync from CMT
		setSourceObjectsMap();//set the source object values and add the target objects to target object map
		setTargetObjectValues();//set the values in the target object fields to the source object values
	}

	/****************************************************************************
	* General Methods - Either object agnostic or switch based on targeObjectName
	***************************************************************************/

	//type cast the targetObjectList to a targetObject type so specific fields can be referenced
	@TestVisible private static void initialize(List<SObject> targetObjectList) {
		targetObjectName = utils.getSObjectName(targetObjectList[0]);//targetObjectName specifies which parts of the methods to run
		soList.clear();//clear the list if still populated from a cascading update
		soList.addAll(targetObjectList);//add current targetList to it
		typeCastSObjectList(targetObjectName);//type cast to the correct object so specific fields can be accessed
	}

	//type cast a general List<SObject> to a specific object type so custom fields can be accessed
	@TestVisible private static void typeCastSObjectList(String typeToCastTo) {
		if(targetObjectName == 'Investigation__c') {
			if(typeToCastTo == 'Investigation__c') {
				investigationList.clear();//clear the list if it still populated from a cascading update or if it still has a target list & this is a CVD alignment operation
				investigationList.addAll((List<Investigation__c>) soList);//typecast and add whatever is in soList
			} else if (typeToCastTo == 'Petition__c') {
				petitionList = (List<Petition__c>) soList;
			}
		} else if (targetObjectName == 'Recusal__c') {
			if(typeToCastTo == 'Recusal__c') {
				recusalList.clear();
				recusalList.addAll((List<Recusal__c>) soList);
			}
		} else if (targetObjectName == 'Segment__c') {
			if(typeToCastTo == 'Segment__c') {
				segmentList.clear();
				segmentList.addAll((List<Segment__c>) soList);
			}
		} //add else if to type cast to different sources from other target objects.  You will need a class level list to hold any object types not already listed.
		//However, you can re-use in this method any class level lists that are already created
	}

	//sets source Objects to query, handles nulls from syncObject params
	@TestVisible private static void setSourceObjectNames(Set<String> sourceObjects, Boolean allSources) {
		if(targetObjectName == 'Investigation__c') {
			if(sourceObjects == null || sourceObjects.size() < 1 || allSources) {
				sourceObjectNames.addAll(allInvestigationSources);
			} else {
				sourceObjectNames.addAll(sourceObjects);
			}
		} else if(targetObjectName == 'Recusal__c') {
			if(sourceObjects == null || sourceObjects.size() < 1 || allSources) {
				sourceObjectNames.addAll(allRecusalSources);
			} else {
				sourceObjectNames.addAll(sourceObjects);
			}
		} else if(targetObjectName == 'Segment__c') {
			if(sourceObjects == null || sourceObjects.size() < 1 || allSources) {
				sourceObjectNames.addAll(allSegmentSources);
			} else {
				sourceObjectNames.addAll(sourceObjects);
			}
		} //add else if to evaluate a different target objects potential sources
	}

	//query the CMT for the source object fields and set them to a map inside a object name map
	@TestVisible private static void setSyncFieldMap() {
		for(String sourceObjectName : sourceObjectNames) {
			addFieldsToSyncFieldMap(sourceObjectName);
		}
	}

	//query the source objects for the values to sync
	@TestVisible private static void setSourceObjectsMap() {
		Map<String,Set<Id>> targetObjectIdSetMap = setTargetObjectIdSet();//create a set for each source object
		Map<String,String> sourceQueryFieldNames = setQueryFields();//get fields to query for each source object
		for(String sourceObjectName : sourceObjectNames) {//one query per source Object
			Set<Id> tempIdSet = new Set<Id>();
			tempIdSet.addAll(targetObjectIdSetMap.get(sourceObjectName));//get just the Id set for this source object
			String soQuery = 'SELECT ';
			soQuery += sourceQueryFieldNames.get(sourceObjectName);//add query fields based on this source object
			soQuery = soQuery.removeEnd(', ');
			soQuery += ' FROM ' + sourceObjectName + ' WHERE Id IN: tempIdSet';//limit by the Ids gathered from the current set
			soList = (List<SObject>)Database.Query(soQuery);
			addSourceListToSourceObjectsMap(sourceObjectName);//add soList to sourceObjectMap
		}
	}

	//sync the source values to the target object
	@TestVisible private static void setTargetObjectValues() {
		for (SObject sourceObject : sourceObjectsMap.values()) {//iterate through the source objects that were queried
			Map<String,String> targetApiToSourceApiMap = syncFieldMap.get(sourceObjectsTypeMap.get(sourceObject.Id));//set the field api's from CMT to the source object type
			if(sourceIdToTargetObjectMap.get(sourceObject.Id) != null && sourceIdToTargetObjectMap.get(sourceObject.Id).size() > 0) {
				for(SObject target : sourceIdToTargetObjectMap.get(sourceObject.Id)) {//most are lists of one, but this is a list for loop in case multiple objects update from same source
					Segment__c s = targetObjectName == 'Segment__c' ? (Segment__c) target : null;
					for (String targetObjectField : targetApiToSourceApiMap.keySet()) {//iterate through the target object field api's
						if (s == null 
							|| (s != null && s.New_Shipper_Sync_Level__c == 'Final' && finalSyncLevelFieldSet.contains(targetObjectField))
							|| (s != null && s.New_Shipper_Sync_Level__c == 'Preliminary')) {
							String sourceObjectField = targetApiToSourceApiMap.get(targetObjectField);//set the source field api that matches the target
							Object sourceValue = sourceObject.get(sourceObjectField);//instantiate an instance of the value from the source object using the source field api
							target.put(targetObjectField, sourceValue);//put the source value to the target object's target field
						}
					}
				}
			}	
		}
	}

	//get Id set from targetObjectList for query
	@TestVisible private static Map<String,Set<Id>> setTargetObjectIdSet() {
		Map<String,Set<Id>> returnMap = new Map<String,Set<Id>>();
		if(targetObjectName == 'Investigation__c') {
			investigationTargetObjectIdSet(returnMap);//get Investigation target Object Id Sets and add the lookup (source) Ids and target Investigations to sourceIdToTargetObjectMap
		} else if (targetObjectName == 'Recusal__c') {
			recusalTargetObjectIdSet(returnMap);
		} else if (targetObjectName == 'Segment__c') {
			segmentTargetObjectIdSet(returnMap);
		} //add else if for a different target object
		return returnMap;
	}

	//get a string of comma delimited fields to query for each source Object
	@TestVisible private static Map<String,String> setQueryFields() {
		Map<String,String> returnMap = new Map<String,String>();
		for(String sourceObjectName : sourceObjectNames) {
			String tempString = '';
			for(Sync_Utility__mdt su : syncUtilityCMT) {
				if(su.Source_Object__c == sourceObjectName){
					tempString += su.Source_Field__c + ', ';//Add CMT source fields to query
				}
			}
			returnMap.put(sourceObjectName, tempString);//map the source object name to the field query string
		}
		return returnMap;
	}

	@TestVisible private static void addFieldsToSyncFieldMap(String sourceObjectName) {
		Set<String> tempFieldSet = new Set<String>();
		Map<String,String> tempFieldMap = new Map<String,String>();
		String tempString = '';
		for (Sync_Utility__mdt su : syncUtilityCMT) {
			if(su.Sync_This_Field__c && su.Source_Object__c == sourceObjectName) {
				tempFieldMap.put(su.Destination_Field__c, su.Source_Field__c);
				tempString += su.Source_Field__c + ', ';
				if(targetObjectName == 'Segment__c' && su.Synced_for_Final__c) {
					tempFieldSet.add(su.Destination_Field__c);
				}
			}
		}
		if(tempFieldMap.size() > 0) {
			syncFieldMap.put(sourceObjectName, tempFieldMap);
			sourceFieldQueries.put(sourceObjectName, tempString);
			finalSyncLevelFieldSet.addAll(tempFieldSet);
		}
	}

	//adds the list of SObjects from the query in setSourceObjectsMap to the map
	@TestVisible private static void addSourceListToSourceObjectsMap(String sourceObjectName) {
		typeCastSObjectList(sourceObjectName);//type cast to the current source
		if(targetObjectName == 'Investigation__c') {
			if(sourceObjectName == 'Investigation__c') {
				for(Investigation__c i : investigationList) {//this is no longer the targetObjectList. In typeCastSObjectList, the queried AD investigations replaced targetObjectList
					sourceObjectsMap.put(i.Id, i);
					sourceObjectsTypeMap.put(i.Id, 'Investigation__c');//set map of Id and object type name, this is used to grab the correct fields from syncFieldMap
				}
			} else if (sourceObjectName == 'Petition__c') {
				for(Petition__c p : petitionList) {
					sourceObjectsMap.put(p.Id, p);
					sourceObjectsTypeMap.put(p.Id, 'Petition__c');//set map of Id and object type name
				}
			}
		} else if(targetObjectName == 'Recusal__c' && sourceObjectName == 'Recusal__c') {
			for(Recusal__c rec : recusalList) {//this is no longer the targetObjectList. In typeCastSObjectList, the queried Recusals replaced targetObjectList
				sourceObjectsMap.put(rec.Id, rec);
				sourceObjectsTypeMap.put(rec.Id, 'Recusal__c');//set map of Id and object type name, this is used to grab the correct fields from syncFieldMap
			}
		} else if(targetObjectName == 'Segment__c' && sourceObjectName == 'Segment__c') {
			for(Segment__c seg : segmentList) {
				sourceObjectsMap.put(seg.Id, seg);
				sourceObjectsTypeMap.put(seg.Id, 'Segment__c');
			}
		} //add else if for a differenct target object
	}

	/**************************************************************************
	*Methods specific to syncing Investigations
	* 1. To query the field APIs from CMT
	* 2. To iterate through the Investigations to update (targets) and 
	* add the correct lookup fields to the Id sets that will be used
	* in the query in setSourceObjectsMap.  Also maps the lookup
	* field (source) Ids to their target Investigations.
	***************************************************************************/

	@TestVisible private static void investigationTargetObjectIdSet(Map<String,Set<Id>> returnMap) {
		Set<Id> petitionIdSet = new Set<Id>();
		Set<Id> adInvestigationIdSet = new Set<Id>();
		for(Investigation__c i : investigationList) {//this is still the targetObjectList that has been typeCast to Investigation
			if(i.Petition__c != null) {
				if(sourceIdToTargetObjectMap.get(i.Petition__c) != null) {
					sourceIdToTargetObjectMap.get(i.Petition__c).add(i);//add target objects to the map that will be updated
				} else {
					List<SObject> tempList = new List<SObject>();
					tempList.add(i);
					sourceIdToTargetObjectMap.put(i.Petition__c, tempList);
				}
				petitionIdSet.add(i.Petition__c);
			}
			if(i.AD_Investigation_Aligned_To__c != null) {//use if because the same Investigation could get updated by
				if(sourceIdToTargetObjectMap.get(i.AD_Investigation_Aligned_To__c) != null) {
					sourceIdToTargetObjectMap.get(i.AD_Investigation_Aligned_To__c).add(i);//add target objects to the map that will be updated
				} else {
					List<SObject> tempList = new List<SObject>();
					tempList.add(i);
					sourceIdToTargetObjectMap.put(i.AD_Investigation_Aligned_To__c, tempList);
				}
				adInvestigationIdSet.add(i.AD_Investigation_Aligned_To__c);
			}
		}
		returnMap.put('Petition__c', petitionIdSet);
		returnMap.put('Investigation__c', adInvestigationIdSet);
	}

	/**************************************************************************
	*Methods specific to syncing Recusals
	* 1. To query the field APIs from CMT
	* 2. To iterate through the Recusals to update (targets) and 
	* add the correct lookup fields to the Id sets that will be used
	* in the query in setSourceObjectsMap.  Also maps the lookup
	* field (source) Ids to their target Recusals.
	***************************************************************************/

	@TestVisible private static void recusalTargetObjectIdSet(Map<String,Set<Id>> returnMap) {
		Set<Id> primaryRecusalIdSet = new Set<Id>();
		for(Recusal__c rec : recusalList) {//this is still the targetObjectList that has been typeCast to Recusal
			if(rec.Primary_Recusal_Aligned_To__c != null) {
				if(sourceIdToTargetObjectMap.get(rec.Primary_Recusal_Aligned_To__c) != null) {
					sourceIdToTargetObjectMap.get(rec.Primary_Recusal_Aligned_To__c).add(rec);//add target objects to the map that will be updated
				} else {
					List<SObject> tempList = new List<SObject>();
					tempList.add(rec);
					sourceIdToTargetObjectMap.put(rec.Primary_Recusal_Aligned_To__c, tempList);
				}
				primaryRecusalIdSet.add(rec.Primary_Recusal_Aligned_To__c);
			}
		}
		returnMap.put('Recusal__c', primaryRecusalIdSet);
	}


	/**************************************************************************
	*Methods specific to syncing New Shipper Reviews
	* 1. To query the field APIs from CMT
	* 2. To iterate through the New Shipper Reviews to update (targets) and 
	* add the correct lookup fields to the Id sets that will be used
	* in the query in setSourceObjectsMap.  Also maps the Admin Review lookup
	* field (source) Ids to their target New Shipper Reviews.
	***************************************************************************/
	@TestVisible private static void segmentTargetObjectIdSet(Map<String,Set<Id>> returnMap) {
		Set<Id> adminReviewIdSet = new Set<Id>();
		for (Segment__c s : segmentList) {
			if (s.Administrative_Review_Aligned_To__c != null) {
				if (sourceIdToTargetObjectMap.get(s.Administrative_Review_Aligned_To__c) != null) {
					sourceIdToTargetObjectMap.get(s.Administrative_Review_Aligned_To__c).add(s);
				} else {
					List<SObject> tempList = new List<SObject>();
					tempList.add(s);
					sourceIdToTargetObjectMap.put(s.Administrative_Review_Aligned_To__c, tempList);
				}
				adminReviewIdSet.add(s.Administrative_Review_Aligned_To__c);
			}
		}
		returnMap.put('Segment__c', adminReviewIdSet);
	}
}