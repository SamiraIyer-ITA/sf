public without sharing class ADCVD_RecusalUtility {
	/*************************************************************
//TODO: description
	 ************************************************************/
	//Object agnostic variables
   //holds the name of the original object type being updated
	@TestVisible private static String parentObjectName = '';
    //used to hold the instances created by the single object constructor 
    @TestVisible private static Map<Id,ADCVD_RecusalUtility> userIdToInstanceMap = new Map<Id,ADCVD_RecusalUtility>();
    //set of all parent Ids. This accumulates if a new parent Id is introduced through a cascading update that was missed on the initial query
    @TestVisible private static Set<Id> parentIdSet = new Set<Id>();
    //used for Singleton
    @TestVisible private static ADCVD_RecusalUtility objectTypeInstance = null;
    //Map of parentIds to hierarchyIdSet from cascade utility
    @TestVisible private static Map<Id,Set<Id>> parentIdToHierarchyIdSetMap = new Map<Id,Set<Id>>();
    //Map of Primary Recusals from userIdSet
    @TestVisible private static Map<Id,Recusal__c> classPrimaryRecusalMap = new Map<Id,Recusal__c>();


    //the map that is used in trigger handlers to access an FR within an ADCVD_RecusalUtility instance
    public Map<Id,ADCVD_RecusalUtility> utilMap {get; private set;}

    //Recusal Variables
    //Map of direct parent object to recusals for this user's instance
    public List<Recusal__c> primaryRecusalList = new List<Recusal__c>();
    //Map of direct parent object to a boolean set if this parent Object's hierarchy objects have recusals for this user's instance
    public Map<Id,Boolean> recusalsInRecordHierarchyMap = new Map<Id,Boolean>();
    //Map of direct parent object to a boolean set if this parent object has a linked recusal for this user's instance
    public Map<Id,Boolean> recusedFromThisRecordMap = new Map<Id,Boolean>();
    //Map of direct parent object to List of parent Object's hierarchy's linke recusals for this user's instance
    //public Map<Id,List<Recusal__c>> relatedRecusalMap = new Map<Id,List<Recusal__c>>();//not needed at this time
    
    

    //used once for the query via CascadeUtility and creating the parent Id to Instance map
	public static ADCVD_RecusalUtility getInstance(Set<Id> userIdSet, List<SObject> parentObjectList) {
		if(parentObjectList != null) {
			parentObjectName = utils.getSObjectName(parentObjectList[0]);
		}
        if(objectTypeInstance == null) objectTypeInstance = new ADCVD_RecusalUtility(userIdSet, parentObjectList);
        return objectTypeInstance;
	}
	
    @TestVisible private ADCVD_RecusalUtility(Set<Id> userIdSet, List<SObject> parentObjectList) {
        Map<Id,List<SObject>> cuRecMap = new Map<Id,List<SObject>>();
        CascadeUtility cu = new CascadeUtility('Recusal__c');
        cuRecMap = cu.getParentIdToObjectsMap(parentObjectName, userIdSet);
        parentIdToHierarchyIdSetMap = cu.getIdToHierarchyIdSetMap();
        setClassPrimaryRecusalMap(userIdSet, parentObjectList);
        if(cuRecMap.size() > 0) {
            setParentIdToInstanceMap(userIdSet, cuRecMap);
        }
        if(userIdToInstanceMap.size() > 0) {
            utilMap = setUtilMap();
        }
    }

    //empty constructor for tempInstance creation and in case a trigger handler needs to instantiate a class level variable
    public ADCVD_RecusalUtility() {}

    //used to populate the values from the class map to one that can be used in the trigger handlers
    @TestVisible private static Map<Id,ADCVD_RecusalUtility> setUtilMap() {
        Map<Id,ADCVD_RecusalUtility>returnMap = new Map<Id,ADCVD_RecusalUtility>();
        returnMap = userIdToInstanceMap;
        return returnMap;
    }

     /**********************************************************
      * Methods to set userIdToInstanceMap
      **********************************************************/    

    //query all fields from Federal_Register__c where the Id dynamic lookup field stored in parentObjectName is in the Id set created from saList
    @TestVisible private static void setParentIdToInstanceMap(Set<Id> userIdSet, Map<Id,List<SObject>> soMap) {
    	Map<Id,List<Recusal__c>> parentIdToRecusalListMap = (Map<Id,List<Recusal__c>>) soMap;
    	for (Id userId : userIdSet) {//instance per user
	        for (Id parentId : parentIdToRecusalListMap.keySet()) {//each instance maps are by parent object
	            for(Recusal__c r : parentIdToRecusalListMap.get(parentId)) {//each map has a list of recusals
	                ADCVD_RecusalUtility tempInstance = new ADCVD_RecusalUtility();
	                if (r.User_Id_from_primary__c != null && r.Primary_Recusal_Aligned_To__c != null) {//recusal is a related recusal and has a user
	                    tempInstance = userIdToInstanceMap.get(userId) != null ? userIdToInstanceMap.get(userId) : tempInstance;//get current instance if it exists
	                    tempInstance = setTempInstance(r, userId, parentId, parentIdToRecusalListMap, tempInstance);
	                }
	                userIdToInstanceMap.put(userId, tempInstance);
	            }
	            
	        }
	    }
    }

    @TestVisible private static ADCVD_RecusalUtility setTempInstance(Recusal__c r, Id userId, Id parentId, Map<Id,List<Recusal__c>> parentIdToRecusalListMap, ADCVD_RecusalUtility tempInstance) {
    	List<Recusal__c> tempList = new List<Recusal__c>();
    	Set<Id> tempSet = new Set<id>();

    	//Set boolean for recusalsInRecordHierarchyMap
    	tempSet = parentIdToHierarchyIdSetMap.get(parentId);
    	tempInstance.recusalsInRecordHierarchyMap.put(parentId, false);
    	if (tempSet != null && !tempSet.isEmpty()) {
    		for (Id tempId : tempSet) {
    			for(Recusal__c rec : parentIdToRecusalListMap.get(tempId)) {
    				if(rec != null && rec.User_Id_from_primary__c != null && rec.User_Id_from_primary__c == userId && validateRecusalParent(rec) == tempId) {
    					tempInstance.recusalsInRecordHierarchyMap.put(parentId, true);
    					break;
    				}
    			}
    		}
    	}
    	//Set boolean for recusedFromThisRecordMap
    	if (r.User_Id_from_primary__c == userId && validateRecusalParent(r) == parentId) {//this recusal is for this user and this recusal's parent is the current parentId
    		tempInstance.recusedFromThisRecordMap.put(parentId, true);
    	} else if (tempInstance.recusedFromThisRecordMap.get(parentId) != true) {//don't overwrite true, but don't allow nulls
    		tempInstance.recusedFromThisRecordMap.put(parentId, false);
    	}
    	//Set primaryRecusalMap to parentId to 
    	System.debug(classPrimaryRecusalMap.values());
    	for(Recusal__c primaryRecusal : classPrimaryRecusalMap.values()) {
    		if (primaryRecusal.User__c == userId) {
    			tempInstance.primaryRecusalList.add(primaryRecusal);
    		}
    	}
    	return tempInstance;
    }

    @TestVisible private static void setClassPrimaryRecusalMap(Set<Id> userIdSet, List<SObject> parentObjectList) {
    	if(userIdSet == null || userIdSet.isEmpty()) {
//TODO: if a parentObjectList is passed, need to get a userIdSet
    	}
    	if(classPrimaryRecusalMap == null || classPrimaryRecusalMap.size() < 1) {
    		Id recordTypeId = utils.getRecordTypeIdMap('Recusal__c').get('Primary');
	    	Date today = System.today();
	    	for(Recusal__c r : [SELECT Id, Actor__c, Actor_Start_Date__c, Actor_End_Date__c, Start_Date__c, End_Date__c, Reason_for_Recusal__c, 
									User__c FROM Recusal__c WHERE RecordTypeId =: recordTypeId 
	    		AND User__c IN: userIdSet AND Start_Date__c <=: today AND End_Date__c >=: today]) {
	    		classPrimaryRecusalMap.put(r.Id, r);
	    	}
    	}
    }

    @TestVisible private static Id validateRecusalParent(Recusal__c r) {
    	Id parentId;
    	if (r.Primary_Recusal_Aligned_To__c != null) {
			if (r.Petition__c != null) {
				parentId = r.Petition__c;
			} else if (r.Investigation__c != null) {
				parentId = r.Investigation__c;
			} else if (r.ADCVD_Order__c != null) {
				parentId = r.ADCVD_Order__c;
			} else if (r.Segment__c != null) {
				parentId = r.Segment__c;
			} else if (r.Litigation__c != null) {
				parentId = r.Litigation__c;
			} else if (r.Related_Organization__c != null) {
				parentId = r.Related_Organization__c;
			} else {
				parentId = r.Id;
			}
		}
		return parentId;
    }

/*    @TestVisible private static void validateParentObjectName(List<SObject> parentObjectList) {
		if(parentObjectName == 'Recusal__c') {
			rList = (Recusal__c) parentObjectList;
			for(Recusal__c r : rList) {

			}
		}
	}
*/
}