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
        cuRecMap = cu.getParentIdToObjectsMap(parentObjectName, userIdSet);//get the big map of parentIds to Recusals list, scope is users with Staffing roles
        parentIdToHierarchyIdSetMap = cu.getIdToHierarchyIdSetMap();//bring the map in class
        setClassPrimaryRecusalMap(userIdSet, parentObjectList);//set the in class primary recusal map
		setParentsInScope(parentObjectList);//get Ids from the parentObjectList
        if(cuRecMap.size() > 0) {
            setParentIdToInstanceMap(userIdSet, cuRecMap);//create an instance per user with the 3 public maps
        }
        if(userIdToInstanceMap.size() > 0) {
            utilMap = setUtilMap();//copy class static map to public non-static one
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

    /**
     * iterates through users with Staffing Roles, creates an instance for each.
     * Then iterates through the parent Ids received from calling method (parentObjectList).
     * Lastly, it uses those parent Ids to get its list of recusals to process
     * @param  userIdSet users with Staffing Roles
     * @param  soMap     parent Ids mapped to Lists of Recusals
     * @return           [description]
     */
    @TestVisible private static void setParentIdToInstanceMap(Set<Id> userIdSet, Map<Id,List<SObject>> soMap) {
    	Map<Id,List<Recusal__c>> parentIdToRecusalListMap = (Map<Id,List<Recusal__c>>) soMap;
    	parentIdSet.addAll(parentIdToRecusalListMap.keySet());
    	for (Id userId : userIdSet) {//instance per user
    		ADCVD_RecusalUtility tempInstance = new ADCVD_RecusalUtility();
	        for (Id parentId : parentIdSet) {//in each instance, maps are created by parent object Id
                if(parentId != null && parentIdToRecusalListMap.get(parentId) != null) {
                    for(Recusal__c r : parentIdToRecusalListMap.get(parentId)) {//each map has a list of recusals in which multiple users recused themselves from a single record
                        if (r.User__c != null && r.Primary_Recusal_Aligned_To__c != null) {//recusal is a related recusal and has a user (probably don't need this anymore)
                            tempInstance = userIdToInstanceMap.get(userId) != null ? userIdToInstanceMap.get(userId) : tempInstance;//get current instance if it exists
                            tempInstance = setTempInstance(r, userId, parentId, parentIdToRecusalListMap, tempInstance);
                        }
                        userIdToInstanceMap.put(userId, tempInstance);
                    }
                }
	        }
	    }
    }

    /**
     * Sets the three temp instance maps.  Because this is called within nested loops, all three pieces of logic have checks to avoid unnecessary
     * resource spends.  The first determines if the current parent Id (from parentObjectList) has records in it's hierarchy that have
     * recusals.  If that changes to true at any point, it is skips for remaining iterations.  The second determines if this user has recused 
     * themselves from the current record.  Skipped on iterations where Recusal user is not current userId or parentId is not the direct parent.
     * Also skips remaining iterations if it ever evaluates to true.  The third creates a List of primary recusals for the user.  It also skips
     * remaining iterations once it is set.
     * @param  r                        Recusal__c
     * @param  userId                   User for this instance
     * @param  parentId                 An Id from the parentObjectList
     * @param  parentIdToRecusalListMap Big map of Lists of Recusals mapped to all hierarchy Ids
     * @param  tempInstance             This user's instance
     * @return                          [description]
     */
    @TestVisible private static ADCVD_RecusalUtility setTempInstance(Recusal__c r, Id userId, Id parentId, Map<Id,List<Recusal__c>> parentIdToRecusalListMap, ADCVD_RecusalUtility tempInstance) {
    	List<Recusal__c> tempList = new List<Recusal__c>();
    	Set<Id> tempSet = new Set<id>();

    	//Set boolean for recusalsInRecordHierarchyMap
    	tempSet = parentIdToHierarchyIdSetMap.get(parentId);
    	if(tempInstance.recusalsInRecordHierarchyMap.get(parentId) != true) {//don't overwrite if already true
    		tempInstance.recusalsInRecordHierarchyMap.put(parentId, false);//set to false, eliminating null or overwriting false
	    	if (tempSet != null && !tempSet.isEmpty()) {//if this parent record has parents, continue
	    		for (Id tempId : tempSet) {//hierarchy Id above the current record
	    			for(Recusal__c rec : parentIdToRecusalListMap.get(tempId)) {//find the recusal (grandchild) mapped to hierarchyId
	    				if(rec != null && rec.User__c != null && rec.User__c == userId 
	    				&& validateRecusalParent(rec) == tempId) {//make sure the recusal belongs to this user and that it's direct parent is in context
	    					tempInstance.recusalsInRecordHierarchyMap.put(parentId, true);//current parent record has at least one parent record that has a recusal for this user
	    					break;//don't overwrite once it's set to true
	    				}
	    			}
	    		}
	    	}
    	}
    	//Set boolean for recusedFromThisRecordMap
    	if (tempInstance.recusedFromThisRecordMap.get(parentId) != true) {//don't overwrite true, but don't allow nulls
    		tempInstance.recusedFromThisRecordMap.put(parentId, false);
	    	if (r.User__c == userId && validateRecusalParent(r) == parentId) {//this recusal is for this user and this recusal's parent is the current parentId
	    		tempInstance.recusedFromThisRecordMap.put(parentId, true);
	    	}
    	}
    	//Set primaryRecusalMap to parentId to 
    	if(tempInstance.primaryRecusalList == null || tempInstance.primaryRecusalList.size() < 1) {
	    	for(Recusal__c primaryRecusal : classPrimaryRecusalMap.values()) {
	    		if (primaryRecusal.User__c == userId) {
	    			tempInstance.primaryRecusalList.add(primaryRecusal);
	    		}
	    	}
	    }
    	return tempInstance;
    }

    @TestVisible private static void setClassPrimaryRecusalMap(Set<Id> userIdSet, List<SObject> parentObjectList) {
    	if(userIdSet == null || userIdSet.isEmpty()) {
    		for(User u : [SELECT Id FROM User WHERE Staffing_Role__c != null]) {
    			userIdSet.add(u.Id);
    		}
    	}
    	if(classPrimaryRecusalMap == null || classPrimaryRecusalMap.size() < 1) {
    		Id recordTypeId = utils.getRecordTypeIdMap('Recusal__c').get('Primary');
	    	Date today = System.today();
	    	for(Recusal__c r : [SELECT Id, Name, Actor__c, Actor_Start_Date__c, Actor_End_Date__c, Start_Date__c, End_Date__c, Reason_for_Recusal__c, 
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

    @TestVisible private static void setParentsInScope(List<SObject> parentObjectList) {
    	if(parentObjectList != null) {
    		for(SObject so : parentObjectList) {
				parentIdSet.add(so.Id);
			}
    	}
	}
}