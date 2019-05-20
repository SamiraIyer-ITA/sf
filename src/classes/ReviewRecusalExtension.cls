/**
 * 
 *    Created by Joshua Moody
 *    on Apr 4 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class ReviewRecusalExtension {
 	/***********************************************************
    * This class is the controller/extension for a page that displays
    * information about a user's recusals.
    * This class provides methods to:
    * 1. Dynamically display in the correct UX (can be updated to 
    * using the lightningStylesheets tag, which is currently in beta)
    * 2. Get the record that is related to the recusal
    * 3. Display in a list all the primary and related recusals for 
    * a user
    ***********************************************************/

    
	/*********************************
 	* Variables to manage UI
 	********************************/
	public Boolean isSalesforce1 {get {
        isSalesforce1 =uiUtils.isSalesforce1();
        return isSalesforce1;
        } set;
    }

    public Boolean isLightningExperience {get {
        isLightningExperience =uiUtils.isLightningExperience();
        return isLightningExperience;
        } set;
    }

    public Boolean isSalesforceClassic {get {
        isSalesforceClassic =uiUtils.isSalesforceClassic();
        return isSalesforceClassic;
        } set;
    }

	 public String recusalLink {
		 get {
			 recusalLink = '';
			 recusalLink = AppConfig__c.getValues('Recusal Link').Link__c;
			 return recusalLink;
	 	} set;
	 }

    /**********************************
     * Variables for a parent record
     *********************************/
    //Sets field names to add to the standard controller, making them available to reference for null checks
    public List<String> parentFieldNames {get {
    	parentFieldNames = new List<String>();
    	parentFieldNames.add('Primary_Recusal_Aligned_To__c');
    	parentFieldNames.add('User__c');
    	parentFieldNames.add('Petition__c');
    	parentFieldNames.add('Investigation__c');
    	parentFieldNames.add('ADCVD_Order__c');
    	parentFieldNames.add('Segment__c');
    	parentFieldNames.add('Litigation__c');
    	parentFieldNames.add('Related_Organization__c');
    	return parentFieldNames;
    	} set;
    }
    //Get the parentId by checking the parent fields on the Recusal
    public Id parentId {get {
    	if(rec != null && rec.Primary_Recusal_Aligned_To__c != null && rec.RecordTypeId == utils.getRecordTypeIdMap('Recusal__c').get('Related')) {
	    	/*if (rec.Petition__c != null) {
				parentId = rec.Petition__c;
			} else if (rec.Investigation__c != null) {
				parentId = rec.Investigation__c;
			} else if (rec.ADCVD_Order__c != null) {
				parentId = rec.ADCVD_Order__c;
			} else if (rec.Segment__c != null) {
				parentId = rec.Segment__c;
			} else if (rec.Litigation__c != null) {
				parentId = rec.Litigation__c;
			} else if (rec.Related_Organization__c != null) {
				parentId = rec.Related_Organization__c;
			} else {
				parentId = rec.Id;
			}*/
		}
		return parentId;
    	} set;
    }

    /***********************************
     * Variable for Recusal
     ***********************************/
    //Record created by constructor. Will hold a parentId in one of the lookup fields
    public Recusal__c rec {get { 
        if(rec == null) {
            rec = new Recusal__c();
        }
        return rec;
    	} set;
    }

    public Boolean noRecusals{get; set;}
    /******************************************
     * Variables for Users
     *****************************************/
    /*public User user {get {
 		if(user == null) {
 			user = new User();
 			for(User u : [SELECT Id, Name From User Where Id =: userId]) {
 				user = u;
 			}
 		}
 		return user;
 		} set;
 	}*/
	public Id userId {get; set;}
	//Set of all Ids from users with Staffing Roles
	public Set<Id> userIdSet {get {
		if(userIdSet == null) {
			userIdSet = new Set<Id>();
			if(userId != null) {
				userIdSet.add(userId);
				return userIdSet;
			} else {
				for(User u : [SELECT Id FROM User WHERE Staffing_Role__c != null]) {
					userIdSet.add(u.Id);
				}
			}
		}
		return userIdSet;
		} set;
	}
	
	/**********************************************
	 * Variables for Recusal List
	 *********************************************/
	//map of userId to class instance with recusal information
	public Map<Id,ADCVD_RecusalUtility> recUtil{get {
		if(recUtil == null) {
			ADCVD_RecusalUtility listInstance = ADCVD_RecusalUtility.getInstance(userIdSet, null);
			recUtil = listInstance.utilMap;
		} 
		return recUtil;
		} set;
	}
	//List of primary recusals returned for the user
	public List<Recusal__c> primaryRecusalList {get {
		if(primaryRecusalList == null) {
			if(recUtil != null && recUtil.get(userId) != null && recUtil.get(userId).primaryRecusalList != null) {
				primaryRecusalList = recUtil.get(userId).primaryRecusalList;
			} else {
				primaryRecusalList = new List<Recusal__c>();
			}
		}
		return primaryRecusalList;
		} set;
	}

	/*********************
	 * Constructor
	 *********************/
	
	public ReviewRecusalExtension (ApexPages.StandardController stdController) {
		if (!Test.isRunningTest()) {stdController.addFields(parentFieldNames);}//add fields that will be referenced to avoid "field not retrieved by soql" error
        rec = (Recusal__c)stdController.getRecord();
        if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('userId') != null) {
            userId = ApexPages.currentPage().getParameters().get('userId');
            parentId = ApexPages.currentPage().getParameters().get('parentId');
        }
        if (userId != null) {
        	init(userId);
        } else {
        	init(rec);
        }
	}
	//Primary method to initialize data on page load
	private void init(Id userId){
		noRecusals = setNoRecusals(primaryRecusalList);
	}
	private void init(Recusal__c rec) {

	}

	private Boolean setNoRecusals(List<Recusal__c> primaryRecusalList) {
		Boolean returnBool = false;
		if(primaryRecusalList == null || primaryRecusalList.isEmpty()) {
			returnBool = true;
		}
		return returnBool;
	}

	public PageReference cancel() {
		if(parentId != null) {
			if(isSalesforceClassic) {
				return new PageReference('/' + parentId);
			} else {
				return null;
			}
		}
		return null;
	}
}