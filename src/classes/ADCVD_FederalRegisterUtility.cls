public without sharing class ADCVD_FederalRegisterUtility {
	/*************************************************************
	This utility accepts a list of SObjects from a trigger handler.
    It has 3 constructors.  One is public and empty for setting 
    a class level variable in the trigger handler.  The second 
    is private and accepts a map of FR Types to a list of FRs.
    This one is used to set the variables for each FR and creates
    an instance of this class with just that FRs values.  The third
    calls the query of all parents from the Cascade utility and calls
    the second constructor to place the returned FRs into class
    instances.  It then returns a map of all parent Ids to an instance
    of this class with their child FR values populated to the public
    variables. For cascading updates on the same FR hierarchy, the map 
    of all parent Ids to class instances of a single FR means no new 
    query should be needed.
	 ************************************************************/
	//Object agnostic variables
   //holds the name of the original object type being updated, passed to CascadeUtility to query the correct FR parents //
	@TestVisible private static String parentObjectName = '';
    //used to hold the values from the CascadeUtility that have been type casted to FR and remapped with their Type as the middle
	@TestVisible private static Map<Id,Map<String,List<Federal_Register__c>>> parentIdToFRsMap = new Map<Id,Map<String,List<Federal_Register__c>>>();
    //used in class to hold a list of fields from multiple FRs of the same type from the same parent object...(Amended* types)
	@TestVisible private static List<Object> frFields = new List<Object>();
    //used in class to hold a single field from a single FR...(!Amended* types)
    @TestVisible private static Object frField = null;
    //used to hold the instances created by the single object constructor 
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frIdToInstanceMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    @TestVisible private static Set<Id> parentIdSet = new Set<Id>();
    //incoming list of parent objects from the original update
    public List<SObject> parentObjectList {get; set;}
    //the map that is used in trigger handlers to access an FR within an ADCVD_FederalRegisterUtility instance
    public Map<Id,ADCVD_FederalRegisterUtility> utilMap {get; private set;}

	//Singleton Implementation
	@TestVisible private static ADCVD_FederalRegisterUtility objectTypeInstance = null;
	@TestVisible private static ADCVD_FederalRegisterUtility objectInstance = null;

    //used many times to create instances of every child FR for each of its parents
    @TestVisible private static ADCVD_FederalRegisterUtility getInstance(SObject parentObject) {
        if(parentIdToFRsMap.get(parentObject.Id) != null) objectInstance = new ADCVD_FederalRegisterUtility(parentIdToFRsMap.get(parentObject.Id));
        return objectInstance;
    }
    //used once for the query via CascadeUtility and creating the parent Id to Instance map
	public static ADCVD_FederalRegisterUtility getInstance(List<SObject> parentObjectList) {
        parentObjectName = utils.getSObjectName(parentObjectList[0]);
        Boolean newIds = false;
        for(SObject so : parentObjectList) {
            if(so.Id != null && !parentIdSet.contains(so.Id)) {
                parentIdSet.add(so.Id);
                newIds = true;
            }
        }
        if(objectTypeInstance == null || newIds || parentObjectName == 'Federal_Register__c') objectTypeInstance = new ADCVD_FederalRegisterUtility(parentObjectList);
        return objectTypeInstance;
	}

	//FR Variables (holds an FR of a specific type for a specific parent SObject)
	public Federal_Register__c initiationFR {get; private set;}
	public Federal_Register__c continuationFR {get; private set;}
	public Federal_Register__c preliminaryFR {get; private set;}
	public List<Federal_Register__c> amendedPreliminaryFR {get; private set;}
	public Federal_Register__c finalFR {get; private set;}
	public List<Federal_Register__c> amendedfinalFR {get; private set;}
	public Federal_Register__c itcPreliminaryFR {get; private set;}
	public Federal_Register__c itcFinalFR {get; private set;}
	public Federal_Register__c orderFR {get; private set;}
	public Federal_Register__c postponementFR {get; private set;}
	public Federal_Register__c postLitigationFR {get; private set;}
	public Federal_Register__c adminReviewOpportunityNoticeFR {get; private set;}
	public Federal_Register__c rescissionFR {get; private set;}
	public Federal_Register__c correctionFR {get; private set;}
	public Federal_Register__c revocationFR {get; private set;}
	public Federal_Register__c initiationPrelimFR {get; private set;}
	public Federal_Register__c quarterlyScopeFR {get; private set;}
	public Federal_Register__c suspensionAgreementFR {get; private set;}
	
	//Published Date Variables
	public Date initiationPublishedDate {get; private set;}
	public Date continuationPublishedDate {get; private set;}
	public Date preliminaryPublishedDate {get; private set;}
	public List<Date> amendedPreliminaryPublishedDate {get; private set;}
	public Date finalPublishedDate {get; private set;}
	public List<Date> amendedfinalPublishedDate {get; private set;}
	public Date itcPreliminaryPublishedDate {get; private set;}
	public Date itcFinalPublishedDate {get; private set;}
	public Date orderPublishedDate {get; private set;}
	public Date postponementPublishedDate {get; private set;}
	public Date postLitigationPublishedDate {get; private set;}
	public Date adminReviewOpportunityNoticePublishedDate {get; private set;}
	public Date rescissionPublishedDate {get; private set;}
	public Date correctionPublishedDate {get; private set;}
	public Date revocationPublishedDate {get; private set;}
	public Date initiationPrelimPublishedDate {get; private set;}
	public Date quarterlyScopePublishedDate {get; private set;}
	public Date suspensionAgreementPublishedDate {get; private set;}



    //empy constructor in case a trigger handler needs to instantiate a class level variable
    public ADCVD_FederalRegisterUtility() {}
	
	/**
	 * called by the getInstance method to create one instantiation of the class for one FR
	 * @param  typeToFrMap the String (Type__c) to List of FRs for a specific parent SObject
	 * @return             sets the in utility variables
	 */
	@TestVisible private ADCVD_FederalRegisterUtility(Map<String,List<Federal_Register__c>> typeToFrMap) {

		//FR variables
		initiationFR 						= setInitiationFR(typeToFrMap);
		continuationFR 						= setContinuationFR(typeToFrMap);
		preliminaryFR 						= setPreliminaryFR(typeToFrMap);
		amendedPreliminaryFR 				= setAmendedPreliminaryFR(typeToFrMap);
		finalFR 							= setFinalFR(typeToFrMap);
		amendedfinalFR 						= setAmendedfinalFR(typeToFrMap);
		itcPreliminaryFR 					= setItcPreliminaryFR(typeToFrMap);
		itcFinalFR 							= setItcFinalFR(typeToFrMap);
		orderFR 							= setOrderFR(typeToFrMap);
		postponementFR 						= setPostponementFR(typeToFrMap);
		postLitigationFR 					= setPostLitigationFR(typeToFrMap);
		adminReviewOpportunityNoticeFR 		= setAdminReviewOpportunityNoticeFR(typeToFrMap);
		rescissionFR 						= setRescissionFR(typeToFrMap);
		correctionFR 						= setCorrectionFR(typeToFrMap);
		revocationFR 						= setRevocationFR(typeToFrMap);
		initiationPrelimFR 					= setInitiationPrelimFR(typeToFrMap);
		quarterlyScopeFR 					= setQuarterlyScopeFR(typeToFrMap);
		suspensionAgreementFR 				= setSuspensionAgreementFR(typeToFrMap);
		
		//Date variables
		initiationPublishedDate 					= setInitiationPublishedDate(typeToFrMap);
		continuationPublishedDate 					= setContinuationPublishedDate(typeToFrMap);
		preliminaryPublishedDate 					= setPreliminaryPublishedDate(typeToFrMap);
		amendedPreliminaryPublishedDate 			= setAmendedPreliminaryPublishedDate(typeToFrMap);
		finalPublishedDate 							= setFinalPublishedDate(typeToFrMap);
		amendedfinalPublishedDate 					= setAmendedfinalPublishedDate(typeToFrMap);
		itcPreliminaryPublishedDate 				= setItcPreliminaryPublishedDate(typeToFrMap);
		itcFinalPublishedDate 						= setItcFinalPublishedDate(typeToFrMap);
		orderPublishedDate 							= setOrderPublishedDate(typeToFrMap);
		postponementPublishedDate 					= setPostponementPublishedDate(typeToFrMap);
		postLitigationPublishedDate 				= setPostLitigationPublishedDate(typeToFrMap);
		adminReviewOpportunityNoticePublishedDate 	= setAdminReviewOpportunityNoticePublishedDate(typeToFrMap);
		rescissionPublishedDate 					= setRescissionPublishedDate(typeToFrMap);
		correctionPublishedDate 					= setCorrectionPublishedDate(typeToFrMap);
		revocationPublishedDate 					= setRevocationPublishedDate(typeToFrMap);
		initiationPrelimPublishedDate 				= setInitiationPrelimPublishedDate(typeToFrMap);
		quarterlyScopePublishedDate 				= setQuarterlyScopePublishedDate(typeToFrMap);
		suspensionAgreementPublishedDate 			= setSuspensionAgreementPublishedDate(typeToFrMap);
	}
    /**
     * Called in a trigger handler to create the utilMap that will map all parent ids to all their child registers
     * @param  parentObjectList List of parent SObjects being updated
     * @return                  sets the in utility map
     */
    @TestVisible private ADCVD_FederalRegisterUtility(List<SObject> parentObjectList) {
        Map<Id,List<SObject>> cuFrMap = new Map<Id,List<SObject>>();
        CascadeUtility cu = new CascadeUtility('Federal_Register__c');
        cuFrMap = cu.getParentIdToObjectsMap(parentObjectName, parentIdSet);
        if(cuFrMap.size() > 0) {
            parentIdToFRsMap = setFRsByTypeToMap(cuFrMap);
        }
        if(parentIdToFRsMap.size() > 0) {
            setFrIdToInstanceMap(cuFrMap);
            utilMap = setUtilMap();
        }
    }

    //used to create the class instances for each FR and place them in a static class level map
    @TestVisible private static void setFrIdToInstanceMap(Map<Id,List<SObject>> cuFrMap) {
        for (Id parentId : cuFrMap.keySet()) {
            List<SObject> soList = cuFrMap.get(parentId);
            for(SObject so : soList) {
                objectInstance = ADCVD_FederalRegisterUtility.getInstance(so);
                if(parentId != null && objectInstance != null) {
                    frIdToInstanceMap.put(parentId, objectInstance);
                }
            }
        }
    }
    //used to populate the values from the class map to one that can be used in the trigger handlers
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> setUtilMap() {
        Map<Id,ADCVD_FederalRegisterUtility>returnMap = new Map<Id,ADCVD_FederalRegisterUtility>();
        returnMap = frIdToInstanceMap;
        return returnMap;
    }

/*TODO...no longer needed	
    //accepts list of SObjects, returns map of parent SObject to list of child Federal_Register__c
	@TestVisible private static Map<Id,Map<String,List<Federal_Register__c>>> setParentIdToFRsMap(List<SObject> parentObjectList) {
		Map<Id,Map<String,List<Federal_Register__c>>> returnMap = new Map<Id,Map<String,List<Federal_Register__c>>>();
		returnMap = addFRsToMap(parentObjectList);
		return returnMap;
	}
*/	/*******************************************************************
	 * Date setter methods
	 *******************************************************************/

	 @TestVisible private static Date setInitiationPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Initiation', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setContinuationPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Continuation', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setPreliminaryPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Preliminary', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static List<Date> setAmendedPreliminaryPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Amended Preliminary', 'Published_Date__c');
        List<Date> tempDateList = new List<Date>();
        for(Object o : frFields) {
        	tempDateList.add((Date)o);
        }
        return tempDateList;
    }
    @TestVisible private static Date setFinalPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Final', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static List<Date> setAmendedfinalPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Amended Final', 'Published_Date__c');
        List<Date> tempDateList = new List<Date>();
        for(Object o : frFields) {
        	tempDateList.add((Date)o);
        }
        return tempDateList;
    }
    @TestVisible private static Date setItcPreliminaryPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'ITC Preliminary', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setItcFinalPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'ITC Final', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setOrderPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Order', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setPostponementPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Postponement', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setPostLitigationPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Post Litigation', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setAdminReviewOpportunityNoticePublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Admin Review Opportunity Notice', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setRescissionPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Rescission', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setCorrectionPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Correction', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setRevocationPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Revocation', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setInitiationPrelimPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Initiation/Prelim', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setQuarterlyScopePublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Quarterly Scope', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }
    @TestVisible private static Date setSuspensionAgreementPublishedDate(Map<String,List<Federal_Register__c>> typeToFrMap) {
        getFrFields(typeToFrMap, 'Suspension Agreement', 'Published_Date__c');
        Date tempDate = (Date)frField;
        return tempDate;
    }

    /************************************************
     * Feder_Register__c Setter Methods
     ************************************************/

     @TestVisible private static Federal_Register__c setInitiationFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Initiation');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setContinuationFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Continuation');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setPreliminaryFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Preliminary');
    	return tempFR;
    }
    @TestVisible private static List<Federal_Register__c> setAmendedPreliminaryFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	List<Federal_Register__c> tempFrList = setFrList(typeToFrMap, 'Amended Preliminary');
    	return tempFrList;
    }
    @TestVisible private static Federal_Register__c setFinalFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Final');
    	return tempFR;
    }
    @TestVisible private static List<Federal_Register__c> setAmendedfinalFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	List<Federal_Register__c> tempFrList = setFrList(typeToFrMap, 'Amended Final');
    	return tempFrList;
    }
    @TestVisible private static Federal_Register__c setItcPreliminaryFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'ITC Preliminary');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setItcFinalFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'ITC Final');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setOrderFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Order');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setPostponementFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Postponement');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setPostLitigationFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Post Litigation');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setAdminReviewOpportunityNoticeFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Admin Review Opportunity Notice');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setRescissionFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Rescission');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setCorrectionFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Correction');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setRevocationFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Revocation');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setInitiationPrelimFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Initiation/Prelim');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setQuarterlyScopeFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Quarterly Scope');
    	return tempFR;
    }
    @TestVisible private static Federal_Register__c setSuspensionAgreementFR(Map<String,List<Federal_Register__c>> typeToFrMap) {
    	Federal_Register__c tempFR = setFR(typeToFrMap, 'Suspension Agreement');
    	return tempFR;
    }
     
     /**********************************************************
      * Methods to set parentIdToFRsMap
      **********************************************************/    
/* TODO no longer needed
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
	@TestVisible private static Map<Id,Map<String,List<Federal_Register__c>>> addFRsToMap(List<SObject> parentObjectList) {
		Map<Id,Map<String,List<Federal_Register__c>>> returnMap = new Map<Id,Map<String,List<Federal_Register__c>>>();
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
			if (returnMap.get(tempId) != null && returnMap.get(tempId).get(fr.Type__c) != null) {//add new Fr to existing map
				Map<String,List<Federal_Register__c>> tempMap = returnMap.get(tempId);
				List<Federal_Register__c> tempList = tempMap.get(fr.Type__c);
				tempList.add(fr);
				tempMap.put(fr.Type__c, tempList);
				returnMap.put(tempId, tempMap);
			} else {//new type or new Id
				Map<String,List<Federal_Register__c>> tempMap = new Map<String,List<Federal_Register__c>>();
				List<Federal_Register__c> tempList = new List<Federal_Register__c>();
				tempList.add(fr);
				tempMap.put(fr.Type__c, tempList);
				returnMap.put(tempId, tempMap);
			}
		}
		return returnMap;
	}
*/
    //query all fields from Federal_Register__c where the Id dynamic lookup field stored in parentObjectName is in the Id set created from parentObjectList
    @TestVisible private static Map<Id,Map<String,List<Federal_Register__c>>> setFRsByTypeToMap(Map<Id,List<SObject>> soMap) {
        Map<Id,Map<String,List<Federal_Register__c>>> returnMap = new Map<Id,Map<String,List<Federal_Register__c>>>();
        for (Id parentId : soMap.keySet()) {
            for(SObject so : soMap.get(parentId)) {
                Federal_Register__c fr = (Federal_Register__c)so;
                if (returnMap.get(parentId) != null && returnMap.get(parentId).get(fr.Type__c) != null) {//add new Fr to existing map
                    Map<String,List<Federal_Register__c>> tempMap = returnMap.get(parentId);
                    List<Federal_Register__c> tempList = tempMap.get(fr.Type__c);
                    Boolean inList = false;
                    for(Federal_Register__c frInList : tempList) {
                        if(frInList.Id != null && frInList.Id == fr.Id) {
                            frInList = fr;
                            inList = true;
                        }
                    }
                    if(inList == false) {
                        tempList.add(fr);
                    }
                    tempMap.put(fr.Type__c, tempList);
                    returnMap.put(parentId, tempMap);
                } else {//new type or new Id
                    Map<String,List<Federal_Register__c>> tempMap = new Map<String,List<Federal_Register__c>>();
                    List<Federal_Register__c> tempList = new List<Federal_Register__c>();
                    tempList.add(fr);
                    tempMap.put(fr.Type__c, tempList);
                    returnMap.put(parentId, tempMap);
                }
            }
            
        }
        return returnMap;
    }

	/************************************************************************
	 *  Helper methods to get values from map
	 ************************************************************************/

	/**
     * [getFrFields sets class level Object and List<Object> variables from investigationIdToFRMap]
     * @param  i         [Investigation__c]
     * @param  fieldName [name of Federal_Register__c fields to be retrieved]
     * @param  frType    [Type__c from Federal_Register__c]
     * @return           [returns a list of Federal_Register__c fields as list of objects or null if it is not found]
     */
    public static void getFrFields(Map<String,List<Federal_Register__c>> typeToFrMap, String frType, String fieldName) {
        Integer frCount = frCount(typeToFrMap, frType);
        frField = null;
        frFields.clear();
        if (frCount == 1 && typeToFrMap != null && typeToFrMap.get(frType)[0].get(fieldName) != null) {//frCount and field level null check
            frField = typeToFrMap.get(frType)[0].get(fieldName);
        } else if (frCount > 1) {
            for (Federal_Register__c fr : typeToFrMap.get(frType)) {//get list of Federal Registers for the Object that are of frType
                if (fr.get(fieldName) != null) {//field level null check
                    frFields.add(fr.get(fieldName));
                }
            }
        }
    }
    //This returns the number of Federal_Register__c objects in a given list for cases where multiple have the same type.  This also performs all null checks except field level
    @TestVisible private static Integer frCount(Map<String,List<Federal_Register__c>> typeToFrMap, String frType) {
        Integer frCount = typeToFrMap != null && typeToFrMap.keySet().contains(frType) && 
                            typeToFrMap.get(frType) != null && typeToFrMap.get(frType).size() > 0 ? 
                            typeToFrMap.get(frType).size() : 0;
        return frCount;
    }
    //This returns a specific FR, cannot be used when multiple FRs are the same type and have the same parent Object
    @TestVisible private static Federal_Register__c setFR(Map<String,List<Federal_Register__c>> typeToFrMap, String frType) {
        Federal_Register__c fr = typeToFrMap != null && typeToFrMap.keySet().contains(frType) && 
                                    typeToFrMap.get(frType) != null  && typeToFrMap.get(frType).size() > 0 ? 
                                    typeToFrMap.get(frType)[0] : null;
        return fr;
    }
    //This returns a list of FRs
    @TestVisible private static List<Federal_Register__c> setFrList(Map<String,List<Federal_Register__c>> typeToFrMap, String frType) {
        List<Federal_Register__c> frList = typeToFrMap != null && typeToFrMap.keySet().contains(frType) && 
                                            typeToFrMap.get(frType) != null && typeToFrMap.get(frType).size() > 0 ? 
                                            typeToFrMap.get(frType) : null;
        return frList;
    }
}