public without sharing class ADCVD_FederalRegisterUtility {
	/*************************************************************
	This utility accepts a list of SObjects from a trigger handler.
    It has 2 constructors.  One is public and empty for setting 
    a class level variable in the trigger handler. The second
    calls the query of all parents from the Cascade utility and calls
    the first constructor to place the returned FRs into class
    instances.  It then returns a map of all parent Ids to an instance
    of this class with their child FR values populated to the public
    variables. For cascading updates on the same FR hierarchy, the map 
    of all parent Ids to class instances of a single FR means no new 
    query should be needed.
	 ************************************************************/
	//Object agnostic variables
   //holds the name of the original object type being updated, passed to CascadeUtility to query the correct FR parents //
	@TestVisible private static String parentObjectName = '';
    //used to hold the instances created by the single object constructor 
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> parentIdToInstanceMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    //set of all parent Ids. This accumulates if a new parent Id is introduced through a cascading update that was missed on the initial query
    @TestVisible private static Set<Id> parentIdSet = new Set<Id>();
    //used for Singleton
    @TestVisible private static ADCVD_FederalRegisterUtility objectTypeInstance = null;
    //the map that is used in trigger handlers to access an FR within an ADCVD_FederalRegisterUtility instance
    public Map<Id,ADCVD_FederalRegisterUtility> utilMap {get; private set;}

    //FR Variables (holds an FR of a specific type for a specific parent SObject)
    public Federal_Register__c initiationFR {get; private set;}
    public Federal_Register__c continuationFR {get; private set;}
    public Federal_Register__c preliminaryFR {get; private set;}
    public Federal_Register__c amendedPreliminaryFR {get; private set;}
    public Federal_Register__c finalFR {get; private set;}
    public Federal_Register__c amendedFinalFR {get; private set;}
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
    public Date amendedPreliminaryPublishedDate {get; private set;}
    public Date finalPublishedDate {get; private set;}
    public Date amendedFinalPublishedDate {get; private set;}
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
            setParentIdToInstanceMap(cuFrMap);
        }
        if(parentIdToInstanceMap.size() > 0) {
            //setFrIdToInstanceMap(cuFrMap);
            utilMap = setUtilMap();
        }
    }

    //empty constructor for tempInstance creation and in case a trigger handler needs to instantiate a class level variable
    public ADCVD_FederalRegisterUtility() {}
    

    //used to populate the values from the class map to one that can be used in the trigger handlers
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> setUtilMap() {
        Map<Id,ADCVD_FederalRegisterUtility>returnMap = new Map<Id,ADCVD_FederalRegisterUtility>();
        returnMap = parentIdToInstanceMap;
        return returnMap;
    }

     /**********************************************************
      * Methods to set parentIdToInstanceMap
      **********************************************************/    

    //query all fields from Federal_Register__c where the Id dynamic lookup field stored in parentObjectName is in the Id set created from parentObjectList
    @TestVisible private static void setParentIdToInstanceMap(Map<Id,List<SObject>> soMap) {
        for (Id parentId : soMap.keySet()) {
            for(SObject so : soMap.get(parentId)) {
                Federal_Register__c fr = (Federal_Register__c)so;
                ADCVD_FederalRegisterUtility tempInstance = new ADCVD_FederalRegisterUtility();
                if (fr.Type__c != null && !fr.Do_Delete__c) {
                    tempInstance = parentIdToInstanceMap.get(parentId) != null ? parentIdToInstanceMap.get(parentId) : tempInstance;
                    tempInstance = setTempInstance(fr, tempInstance);
                }
                parentIdToInstanceMap.put(parentId, tempInstance);
            }
            
        }
    }

    @TestVisible private static ADCVD_FederalRegisterUtility setTempInstance(Federal_Register__c fr, ADCVD_FederalRegisterUtility tempInstance) {
        if(fr.Type__c == 'Initiation') {
            tempInstance.initiationFR = fr;
            tempInstance.initiationPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Continuation') {
            tempInstance.continuationFR = fr;
            tempInstance.continuationPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Preliminary') {
            tempInstance.preliminaryFR = fr;
            tempInstance.preliminaryPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Amended Preliminary') {
            tempInstance.amendedPreliminaryFR = fr;
            tempInstance.amendedPreliminaryPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Final') {
            tempInstance.finalFR = fr;
            tempInstance.finalPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Amended Final') {
            tempInstance.amendedFinalFR = fr;
            tempInstance.amendedFinalPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'ITC Preliminary') {
            tempInstance.itcPreliminaryFR = fr;
            tempInstance.itcPreliminaryPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'ITC Final') {
            tempInstance.itcFinalFR = fr;
            tempInstance.itcFinalPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Order') {
            tempInstance.orderFR = fr;
            tempInstance.orderPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Postponement') {
            tempInstance.postponementFR = fr;
            tempInstance.postponementPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Post Litigation') {
            tempInstance.postLitigationFR = fr;
            tempInstance.postLitigationPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Admin Review Opportunity Notice') {
            tempInstance.adminReviewOpportunityNoticeFR = fr;
            tempInstance.adminReviewOpportunityNoticePublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Rescission') {
            tempInstance.rescissionFR = fr;
            tempInstance.rescissionPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Correction') {
            tempInstance.correctionFR = fr;
            tempInstance.correctionPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Revocation') {
            tempInstance.revocationFR = fr;
            tempInstance.revocationPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Initiation/Prelim') {
            tempInstance.initiationPrelimFR = fr;
            tempInstance.initiationPrelimPublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Quarterly Scope') {
            tempInstance.quarterlyScopeFR = fr;
            tempInstance.quarterlyScopePublishedDate = fr.Published_Date__c;
        } else if (fr.Type__c == 'Suspension Agreement') {
            tempInstance.suspensionAgreementFR = fr;
            tempInstance.suspensionAgreementPublishedDate = fr.Published_Date__c;
        }
        return tempInstance;
    }
}