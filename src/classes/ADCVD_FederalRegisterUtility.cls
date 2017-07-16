public without sharing class ADCVD_FederalRegisterUtility {
	/*************************************************************
	This utility accepts a list of SObjects from a trigger handler.
    It has 2 constructors.  One is public and empty for setting 
    a class level variable in the trigger handler. The second
    calls the query of all parents from the Cascade utility and calls
    the first constructor to place the returned Federal Registers into class
    instances.  It then returns a map of all parent Ids to an instance
    of this class with their child Federal Register values populated to the public
    variables. For cascading updates on the same Federal Register hierarchy, the map 
    of all parent Ids to class instances of a single Federal Register means no new 
    query should be needed.
	 ************************************************************/
	//Object agnostic variables
   //holds the name of the original object type being updated, passed to CascadeUtility to query the correct Federal Register parents //
	@TestVisible private static String parentObjectName = '';
    //used to hold the instances created by the single object constructor 
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> parentIdToInstanceMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    //set of all parent Ids. This accumulates if a new parent Id is introduced through a cascading update that was missed on the initial query
    @TestVisible private static Set<Id> parentIdSet = new Set<Id>();
    //used for Singleton
    @TestVisible private static ADCVD_FederalRegisterUtility objectTypeInstance = null;
    //the map that is used in trigger handlers to access an Federal Register within an ADCVD_FederalRegisterUtility instance
    public Map<Id,ADCVD_FederalRegisterUtility> utilMap {get; private set;}
    public Map<String,Date> varMap {get {
        if (varMap == null) {
            varMap = new Map<String,Date>();
        }
        return varMap;
    }set;
    }

    //Federal Register Variables (holds an Federal Register of a specific type for a specific parent SObject)
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
    public Federal_Register__c terminationFR {get; private set;}
    
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
    public Date terminationPublishedDate {get; private set;}

    //used once for the query via CascadeUtility and creating the parent Id to Instance map
	public static ADCVD_FederalRegisterUtility getInstance(List<SObject> parentObjectList) {
		Boolean newIds = false;
		if(parentObjectList.size() > 0) {
			parentObjectName = utils.getSObjectName(parentObjectList[0]);
        		for(SObject so : parentObjectList) {
		    		if(so.Id != null && !parentIdSet.contains(so.Id)) {
					parentIdSet.add(so.Id);
					newIds = true;
		    		}
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
        Map<Id,ADCVD_FederalRegisterUtility> returnMap = new Map<Id,ADCVD_FederalRegisterUtility>();
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

    /**
     * Sets the Federal Register and published Date values from all Federal Registers for a given parent.  Ternaries are used on Federal Registers used in calculations to ensure the oldest
     * Federal Register is used, except in the case of Continuation where the newest is used
     * @param  fr           A Federal Register
     * @param  tempInstance An instance of this class that has Federal Registers that exist mapped to a variable based on their type
     * @return              The same instance is returned but with an additional Federal Register and Federal Register publishedDate variable mapped
     */
    @TestVisible private static ADCVD_FederalRegisterUtility setTempInstance(Federal_Register__c fr, ADCVD_FederalRegisterUtility tempInstance) {
        if(fr.Type__c == 'Initiation') {
            tempInstance.initiationFR = (tempInstance.initiationFR != null && fr.CreatedDate > tempInstance.initiationFR.CreatedDate) ? 
                                            tempInstance.initiationFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.initiationPublishedDate = (tempInstance.initiationPublishedDate != null && fr.CreatedDate > tempInstance.initiationFR.CreatedDate) ? 
                                            tempInstance.initiationPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Initiation', tempInstance.initiationPublishedDate);
        } else if (fr.Type__c == 'Continuation') {
            tempInstance.continuationFR = (tempInstance.continuationFR != null && fr.CreatedDate < tempInstance.continuationFR.CreatedDate) ? 
                                            tempInstance.continuationFR : fr;//set variable to new value if currently null or new Federal Register is newer than current variable
            tempInstance.continuationPublishedDate = (tempInstance.continuationPublishedDate != null && fr.CreatedDate < tempInstance.continuationFR.CreatedDate) ? 
                                            tempInstance.continuationPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Continuation', tempInstance.continuationPublishedDate);
        } else if (fr.Type__c == 'Preliminary') {
            tempInstance.preliminaryFR = (tempInstance.preliminaryFR != null && fr.CreatedDate > tempInstance.preliminaryFR.CreatedDate) ? 
                                            tempInstance.preliminaryFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.preliminaryPublishedDate = (tempInstance.preliminaryPublishedDate != null && fr.CreatedDate > tempInstance.preliminaryFR.CreatedDate) ? 
                                            tempInstance.preliminaryPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Preliminary', tempInstance.preliminaryPublishedDate);
        } else if (fr.Type__c == 'Amended Preliminary') {
            tempInstance.amendedPreliminaryFR = fr;
            tempInstance.amendedPreliminaryPublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Amended Preliminary', tempInstance.amendedPreliminaryPublishedDate);
        } else if (fr.Type__c == 'Final') {
            tempInstance.finalFR = (tempInstance.finalFR != null && fr.CreatedDate > tempInstance.finalFR.CreatedDate) ? 
                                            tempInstance.finalFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.finalPublishedDate = (tempInstance.finalPublishedDate != null && fr.CreatedDate > tempInstance.finalFR.CreatedDate) ? 
                                            tempInstance.finalPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Final', tempInstance.finalPublishedDate);
        } else if (fr.Type__c == 'Amended Final') {
            tempInstance.amendedFinalFR = fr;
            tempInstance.amendedFinalPublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Amended Final', tempInstance.amendedFinalPublishedDate);
        } else if (fr.Type__c == 'ITC Preliminary') {
            tempInstance.itcPreliminaryFR = (tempInstance.itcPreliminaryFR != null && fr.CreatedDate > tempInstance.itcPreliminaryFR.CreatedDate) ? 
                                            tempInstance.itcPreliminaryFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.itcPreliminaryPublishedDate = (tempInstance.itcPreliminaryPublishedDate != null && fr.CreatedDate > tempInstance.itcPreliminaryFR.CreatedDate) ? 
                                            tempInstance.itcPreliminaryPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('ITC Preliminary', tempInstance.itcPreliminaryPublishedDate);
        } else if (fr.Type__c == 'ITC Final') {
            tempInstance.itcFinalFR = (tempInstance.itcFinalFR != null && fr.CreatedDate > tempInstance.itcFinalFR.CreatedDate) ? 
                                            tempInstance.itcFinalFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.itcFinalPublishedDate = (tempInstance.itcFinalPublishedDate != null && fr.CreatedDate > tempInstance.itcFinalFR.CreatedDate) ? 
                                            tempInstance.itcFinalPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('ITC Final', tempInstance.itcFinalPublishedDate);
        } else if (fr.Type__c == 'Order') {
            tempInstance.orderFR = (tempInstance.orderFR != null && fr.CreatedDate > tempInstance.orderFR.CreatedDate) ? 
                                            tempInstance.orderFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.orderPublishedDate = (tempInstance.orderPublishedDate != null && fr.CreatedDate > tempInstance.orderFR.CreatedDate) ? 
                                            tempInstance.orderPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Order', tempInstance.orderPublishedDate);
        } else if (fr.Type__c == 'Postponement') {
            tempInstance.postponementFR = (tempInstance.postponementFR != null && fr.CreatedDate > tempInstance.postponementFR.CreatedDate) ? 
                                            tempInstance.postponementFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.postponementPublishedDate = (tempInstance.postponementPublishedDate != null && fr.CreatedDate > tempInstance.postponementFR.CreatedDate) ? 
                                            tempInstance.postponementPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Postponement', tempInstance.postponementPublishedDate);
        } else if (fr.Type__c == 'Post Litigation') {
            tempInstance.postLitigationFR = fr;
            tempInstance.postLitigationPublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Post Litigation', tempInstance.postLitigationPublishedDate);
        } else if (fr.Type__c == 'Admin Review Opportunity Notice') {
            tempInstance.adminReviewOpportunityNoticeFR = fr;
            tempInstance.adminReviewOpportunityNoticePublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Admin Review Opportunity Notice', tempInstance.adminReviewOpportunityNoticePublishedDate);
        } else if (fr.Type__c == 'Rescission') {
            tempInstance.rescissionFR = (tempInstance.rescissionFR != null && fr.CreatedDate > tempInstance.rescissionFR.CreatedDate) ? 
                                            tempInstance.rescissionFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.rescissionPublishedDate = (tempInstance.rescissionPublishedDate != null && fr.CreatedDate > tempInstance.rescissionFR.CreatedDate) ? 
                                            tempInstance.rescissionPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Rescission', tempInstance.rescissionPublishedDate);
        } else if (fr.Type__c == 'Correction') {
            tempInstance.correctionFR = fr;
            tempInstance.correctionPublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Correction', tempInstance.correctionPublishedDate);
        } else if (fr.Type__c == 'Revocation') {
            tempInstance.revocationFR = (tempInstance.revocationFR != null && fr.CreatedDate > tempInstance.revocationFR.CreatedDate) ? 
                                            tempInstance.revocationFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.revocationPublishedDate = (tempInstance.revocationPublishedDate != null && fr.CreatedDate > tempInstance.revocationFR.CreatedDate) ? 
                                            tempInstance.revocationPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Revocation', tempInstance.revocationPublishedDate);
        } else if (fr.Type__c == 'Initiation/Prelim') {
            tempInstance.initiationPrelimFR = fr;
            tempInstance.initiationPrelimPublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Initiation/Prelim', tempInstance.initiationPrelimPublishedDate);
        } else if (fr.Type__c == 'Quarterly Scope') {
            tempInstance.quarterlyScopeFR = fr;
            tempInstance.quarterlyScopePublishedDate = fr.Published_Date__c;
            tempInstance.varMap.put('Quarterly Scope', tempInstance.quarterlyScopePublishedDate);
        } else if (fr.Type__c == 'Suspension Agreement') {
            tempInstance.suspensionAgreementFR = (tempInstance.suspensionAgreementFR != null && fr.CreatedDate > tempInstance.suspensionAgreementFR.CreatedDate) ? 
                                            tempInstance.suspensionAgreementFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.suspensionAgreementPublishedDate = (tempInstance.suspensionAgreementPublishedDate != null && fr.CreatedDate > tempInstance.suspensionAgreementFR.CreatedDate) ? 
                                            tempInstance.suspensionAgreementPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Suspension Agreement', tempInstance.suspensionAgreementPublishedDate);
        } else if (fr.Type__c == 'Termination') {
            tempInstance.terminationFR = (tempInstance.terminationFR != null && fr.CreatedDate > tempInstance.terminationFR.CreatedDate) ? 
                                            tempInstance.terminationFR : fr;//set variable to new value if currently null or new Federal Register is older than current variable
            tempInstance.terminationPublishedDate = (tempInstance.terminationPublishedDate != null && fr.CreatedDate > tempInstance.terminationFR.CreatedDate) ? 
                                            tempInstance.terminationPublishedDate : fr.Published_Date__c;
            tempInstance.varMap.put('Termination', tempInstance.terminationPublishedDate);
        }
        return tempInstance;
    }
}