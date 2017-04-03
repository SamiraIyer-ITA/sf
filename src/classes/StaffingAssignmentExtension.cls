public without sharing class StaffingAssignmentExtension {

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

    /**********************************
     * Variables for a parent record
     *********************************/
    //Sets field names to add to the standard controller, making them available to reference for null checks
    public List<String> parentFieldNames {get {
    	parentFieldNames = new List<String>();
    	parentFieldNames.add('Petition__c');
    	parentFieldNames.add('Investigation__c');
    	parentFieldNames.add('ADCVD_Order__c');
    	parentFieldNames.add('Segment__c');
    	parentFieldNames.add('Related_Organization__c');
    	return parentFieldNames;
    	} set;
    }
    //Get the parentId by checking the parent fields on the Staffing Assignment
    public Id parentId {get {
    	if(sa != null) {
	    	if (sa.Petition__c != null) {
				parentId = sa.Petition__c;
			} else if (sa.Investigation__c != null) {
				parentId = sa.Investigation__c;
			} else if (sa.ADCVD_Order__c != null) {
				parentId = sa.ADCVD_Order__c;
			} else if (sa.Segment__c != null) {
				parentId = sa.Segment__c;
			} else if (sa.Related_Organization__c != null) {
				parentId = sa.Related_Organization__c;
			} else {
				parentId = sa.Id;
			}
		}
		return parentId;
    	} set;
    }
    //Get the parentSObjectType name by checking the parent fields on the Staffing Assignment
    public String parentSObjectType {get {
    	if(sa != null) {
	    	if (sa.Petition__c != null) {
				parentSObjectType = 'Petition__c';
			} else if (sa.Investigation__c != null) {
				parentSObjectType = 'Investigation__c';
			} else if (sa.ADCVD_Order__c != null) {
				parentSObjectType = 'ADCVD_Order__c';
			} else if (sa.Segment__c != null) {
				parentSObjectType = 'Segment__c';
			} else if (sa.Related_Organization__c != null) {
				parentSObjectType = 'Related_Organization__c';
			} else {
				parentSObjectType = 'Staffing_Assignment__c';
			}
		}
		return parentSObjectType;
		} set;
	}
	//Maps to checkbox in UI when parent is ADCVD order. If checked, will trigger an overwrite of segment Staffing Assignments on save
	public Boolean overwriteSegments {get; set;}

    /***********************************
     * Variable for Staffing Assigment
     ***********************************/
    //Record created by constructor. Will hold a parentId in one of the lookup fields
    public Staffing_Assignment__c sa {get { 
        if(sa == null) {
            sa = querySA();
        }
        return sa;
    	} set;
    }

    /******************************************
     * Variables for User Select Option Lists
     *****************************************/
    //SelectOption list with all users that have a staffing role
     public List<SelectOption> allUserSelectOptions {get {
		if(allUserSelectOptions == null) {
			populateUserLists();
		}
		return allUserSelectOptions;
		} set;
	}
	//Map of Titles to SelectOption lists of users with a matching Staffing Role
	public Map<String, List<SelectOption>> userSelectOptions {get {
		if(userSelectOptions == null) {
			populateUserLists();
		}
		return userSelectOptions;
		} set;
	}
	//Map used to create SelectOption lists
	public Map<String, List<User>> userRoleMap {get {
		if(userRoleMap == null) {
			populateUserLists();
		}
		return userRoleMap;
		} set;
	}
	//Set of all Ids from users with Staffing Roles
	public Set<Id> userIdSet {get {
		if(userIdSet == null) {
			populateUserLists();
		}
		return userIdSet;
		} set;
	}
	//map of userId to class instance with recusal information
	public Map<Id,ADCVD_RecusalUtility> recUtil{get {
		if(recUtil == null) {
			populateRecusalMap(userIdSet);
		}
		return recUtil;
		} set;
	}

	public Map<Id,List<Recusal__c>> primaryRecusalMap {get; set;}
	public List<Recusal__c> recusalListForModal {get; set;}
	/**********************************************
	 * Variables for Staff Assignments and Wrapper
	 *********************************************/
	//List of staffing assignments returned for the parent
	public List<Staffing_Assignment__c> staffList {get {
		if(staffList == null) {
			staffList = new List<Staffing_Assignment__c>();
		}
		return staffList;
		} set;
	}
	//List of staffing assignment wrapper objects that will display in page
    public List<StaffingAssignmentWrapper> staffWrapperList {get {
        if(staffWrapperList == null) {
            staffWrapperList = new List<StaffingAssignmentWrapper>();
        }
        return staffWrapperList;
	    } set;
	}
	
//TODO: this needs to pull from current SA records
	@TestVisible 
	private static Set<String> userRolesSet = new Set<String>{'Accounting Director', 'Accounting PM', 'Assistant Secretary', 'Associate DAS', 
																'DAS', 'DAS Assistant', 'Office Director', 'Program Manager', 'Senior Legal', 
																'Senior Policy', 'Staff Legal', 'Staff Policy'};

	/*********************
	 * Constructor
	 *********************/
	
	public StaffingAssignmentExtension (ApexPages.StandardController stdController) {
		stdController.addFields(parentFieldNames);//add fields that will be referenced to avoid "field not retrieved by soql" error
        sa = (Staffing_Assignment__c)stdController.getRecord();
        init(sa);
	}
	//Primary method to initialize data on page load
	private void init(Staffing_Assignment__c sa){
		overwriteSegments = false;
		staffList = getstaffList(parentId, parentSObjectType);
		populateRecusalMap(userIdSet);
		staffWrapperList = addStaffWrapper(parentId, parentSObjectType, staffList, userIdSet);
		System.debug(staffWrapperList);
	}
	//method mapped to "Add Staff Assignment" button
	public PageReference addRow(){
		Staffing_Assignment__c sa = createNewStaffingAssignment(parentId);//create a Staffing Assignment record with the parent Id field populated
		StaffingAssignmentWrapper saw = new StaffingAssignmentWrapper(sa);//create a wrapper, adding that Staffing Assignment
		staffWrapperList.add(saw);
		return null;
	}

	//method mapped to "Review Recusals"
	public PageReference reviewRecusals(Id oneUserId) {
		recusalListForModal = new List<Recusal__c>();
		Set<Id> tempIdSet = new Set<Id>();
		for(staffingAssignmentWrapper saw: staffWrapperList) {
			if(saw.sa != null && saw.sa.User__c != null && saw.reviewRecusal != null && saw.reviewRecusal){
				tempIdSet.add(saw.sa.User__c);
			}
		}
		for(Id userId : tempIdSet) {
			if(primaryRecusalMap.get(userId) != null) {
				recusalListForModal.addAll(primaryRecusalMap.get(userId));
			}
		}
		return null;
	}

	//method mapped to "Save"
	public PageReference save() {
		List<Staffing_Assignment__c> staffListToUpsert = new List<Staffing_Assignment__c>();
		List<Staffing_Assignment__c> staffListToDelete = new List<Staffing_Assignment__c>();
		for(staffingAssignmentWrapper saw: staffWrapperList) {
			if(!String.isBlank(saw.sa.User__c)){
				staffListToUpsert.add(saw.sa);//If user field is populated, upsert
			} else if (String.isBlank(saw.sa.User__c) && !String.isBlank(saw.sa.Id)) {
				staffListToDelete.add(saw.sa);//If user field is not populated and record exists(has id), delete
			}
		}
		//propogate staffing assignment to child segments of the order
		if(overwriteSegments) {
			for(Segment__c s: [SELECT Id, (SELECT Id, User__c, Title__c FROM Staffing_Assignments__r) FROM Segment__c WHERE ADCVD_Order__c =: parentId]) {
				if(s.Staffing_Assignments__r != null) {
					//delete staffing assignments
					staffListToDelete.addAll(s.Staffing_Assignments__r);
				}
				//add new staffing assignments to segments
				for(staffingAssignmentWrapper saw: staffWrapperList) {
					if(!String.isBlank(saw.sa.User__c)){
						Staffing_Assignment__c newSa = new Staffing_Assignment__c();
						newSa.User__c = saw.sa.User__c;
						newSa.Title__c = saw.sa.Title__c;
						newSa.Segment__c = s.Id;
						staffListToUpsert.add(newSa);
					}
				}
			}
		}
		upsert staffListToUpsert;
		delete staffListToDelete;
		//if classic, use retURL
		if(isSalesforceClassic) {
			return new PageReference(getReturnUrl());
		} else {//else return null, allowing oncomplete JS to fire and redirect in LEX/SF1
			return null;
		}
		
	}

	public PageReference cancel() {
		if(isSalesforceClassic) {
			return new PageReference(getReturnUrl());
		} else {
			return null;
		}
	}

	private String getReturnUrl() {
		return ApexPages.currentPage().getParameters().get('retURL');
	}
	//if existing, return matching Staffing Assignment. Else return a new one
	private Staffing_Assignment__c querySA(){
		Staffing_Assignment__c returnSA = new Staffing_Assignment__c();
		if(parentId != null) {
            returnSA = [SELECT Id, ADCVD_Order__c, Investigation__c, Petition__c, 
				 				Related_Organization__c, Segment__c FROM Staffing_Assignment__c 
				 				WHERE Id =: parentId
				 				OR ADCVD_Order__c =:parentId
				 				OR Investigation__c =:parentId
				 				OR Petition__c =:parentId
				 				OR Related_Organization__c =:parentId
				 				OR Segment__c =:parentId  LIMIT 1];
        } else {
            returnSA = new Staffing_Assignment__c();
        }
        return returnSA;
    }
    //Returns list of all Staffing Assignments for the parent
	private List<Staffing_Assignment__c> getStaffList(Id parentId, String parentSObjectType) {
		if(staffList == null || staffList.isEmpty()) {
			//specify base query
			String soqlQuery = 'SELECT Id, User__c, Title__c, User__r.Staffing_Role__c FROM Staffing_Assignment__c WHERE ';
			//specify object specific clause and query object, add to wrapper
			soqlQuery += parentSObjectType + ' =: parentId LIMIT 1000 ';	
			System.debug(soqlQuery);
			staffList = database.query(soqlQuery);
		}
		return staffList;
	}
	//Initializes SelectOption lists
	private void populateUserLists(){
		userRoleMap = new Map<String, List<User>>();
		userSelectOptions = new Map<String, List<SelectOption>>();
		allUserSelectOptions = new List<SelectOption>();
		userIdSet = new Set<Id>();
		//add all users to lists that are mapped to Staffing Roles
		for(User u: [SELECT Id, Name, Staffing_Role__c FROM User WHERE Staffing_Role__c != null]) {
			userIdSet.add(u.Id);
			List<User> userList = new List<User>();
			//if the map already contains a list - use the list from the map
			if(userRoleMap.get(u.Staffing_Role__c) != null) {
				userList = userRoleMap.get(u.Staffing_Role__c);
			}
			userList.add(u);
			userRoleMap.put(u.Staffing_Role__c, userList);
		}
		for(String s: userRolesSet) {//Create Staffing Assignments for defaults
			List<User> userList = userRoleMap.get(s);//for each default Staffing Role, get the matching list of users
			List<SelectOption> userSelect = new List<SelectOption>();
			
			if(userList != null) {//for each user in this list (they all share same Staffing Role)
				for(User u: userList) {
					userSelect.add(new SelectOption(u.Id, u.Name));//create a SelectOption
				}
				allUserSelectOptions.addAll(userSelect);//add them to our list of all users
				if(userList.size() > 0) {
					userSelect.add(0,new SelectOption('', '--Select a User--'));//add the default if no user selected
				}
			} else {
				userSelect.add(new SelectOption('', '--Please update user records to have this AD CVD Title--'));//notify user if no users match this role
			}
			userSelectOptions.put(s, userSelect);//Staffing Role and list of users in map
		}
		allUserSelectOptions.add(0,new SelectOption('','--Select a User--'));//add the default the list of all users only once
	}

	//method used to create initial Staffing Assignments, includes setting titles from defauls
	public static Staffing_Assignment__c createNewStaffingAssignment(String parentId, String title) {
		Staffing_Assignment__c newSA = createNewStaffingAssignment(parentId);
		newSA.Title__c = title;
		return newSA;
	}
	//method used to create Staffing Assignments via the "add row" method
	public static Staffing_Assignment__c createNewStaffingAssignment(String parentIdAsString) {
		Staffing_Assignment__c newSA = new Staffing_Assignment__c();
		if(!String.isBlank(parentIdAsString)) {
			//Id exists only in this method
			Id parentId = (Id)parentIdAsString;
			//String exists only in this method
			String parentSObjectType = parentId.getSObjectType().getDescribe().getName();
			if(parentSObjectType == 'ADCVD_Order__c') {
				newSA.ADCVD_Order__c = parentId;
			} else if (parentSObjectType == 'Investigation__c') {
				newSA.Investigation__c = parentId;
			} else if (parentSObjectType == 'Petition__c') {
				newSA.Petition__c = parentId;
			} else if (parentSObjectType == 'Related_Organization__c') {
				newSA.Related_Organization__c = parentId;
			} else if (parentSObjectType == 'Segment__c') {
				newSA.Segment__c = parentId;
			}
		}
		return newSA;
	}

	//method to add a list of staffing assignments to the wrapper - prepopulates blank values
	public List<StaffingAssignmentWrapper> addStaffWrapper(Id parentId, String parentSObjectType, List<Staffing_Assignment__c> staffList, Set<Id> userIdSet) {
		//create a map to determine if the User Title is already specified
		List<StaffingAssignmentWrapper> returnList = new List<StaffingAssignmentWrapper>();
		Map<String, Boolean> userTitleExistsMap = new Map<String, Boolean>();
		ADCVD_RecusalUtility userInstance = new ADCVD_RecusalUtility();
		for(String s: userRolesSet) {//add all titles from default list to title map
			userTitleExistsMap.put(s, false);
		}
		//add existing user titles to the map, overwriting any defaults that have usersfor them
		for(Staffing_Assignment__c sa: staffList) {
			userTitleExistsMap.put(sa.Title__c, true);
		}
		//if the title does not exist, create a new blank row
		for(String s: userTitleExistsMap.keySet()) {
			if(userTitleExistsMap.get(s) == false) {
				Staffing_Assignment__c sa = createNewStaffingAssignment(parentId, s);
				staffList.add(sa);
			}
		}
		//for all the Staffing Assignments with and without users, create the wrappers
		StaffingAssignmentWrapper sawOuterInstance = new StaffingAssignmentWrapper(parentId, parentSObjectType, staffList, recUtil, userIdSet);
		returnList = sawOuterInstance.innerWrapperList.clone();
		primaryRecusalMap = sawOuterInstance.wrapperPrimaryRecusalMap;
		return returnList;
	}

	//populate Recusal Utility map
	private void populateRecusalMap(Set<Id> userIdSet) {
		recUtil = new Map<Id,ADCVD_RecusalUtility>();
		if (recUtil.isEmpty()) {
			ADCVD_RecusalUtility listInstance = ADCVD_RecusalUtility.getInstance(userIdSet, null);
			recUtil = listInstance.utilMap;
		}
	}

	//wrapper class for rendering the list(s) of staffing assignments
	public class StaffingAssignmentWrapper {
		//public contructor variable mappings set to private for clarification in page
		private Id parentId {get; set;}
		private String parentSObjectType {get; set;}
		private List<Staffing_Assignment__c> staffList {get; set;}
		private Map<Id,ADCVD_RecusalUtility> recUtil {get; set;}
		private Set<Id> userIdSet {get; set;}

		//variables for page and outer extension class access
		public Staffing_Assignment__c sa {get; set;}
		public Boolean overrideRole {get; set;}//data does not exist on Staffing Assignment record, only used to toggle SelectOption lists
		public Boolean reviewRecusal {get; set;}
		public Map<Id,String> recusalStatusMap {get; set;}
		public Map<Id,List<Recusal__c>> wrapperPrimaryRecusalMap {get; set;}
		public ADCVD_RecusalUtility userInstance {get; set;}
		//List of staffing assignment wrapper objects that will display in page
	    public List<StaffingAssignmentWrapper> innerWrapperList {get {
	        if(innerWrapperList == null) {
	            innerWrapperList = new List<StaffingAssignmentWrapper>();
	        }
	        return innerWrapperList;
		    } set;
		}
		//constructor used in initial creation called by outer class
		public StaffingAssignmentWrapper(Id parentId, String parentSObjectType, List<Staffing_Assignment__c> staffList, Map<Id,ADCVD_RecusalUtility> recUtil, Set<Id> userIdSet) {
			this.parentId = parentId;
			this.parentSObjectType = parentSObjectType;
			this.staffList = staffList;
			this.recUtil = recUtil;
			this.userIdSet = userIdSet;
			this.reviewRecusal = false;
			populateRecusalStatus(parentId, userIdSet, recUtil);
			//for all the Staffing Assignments with and without users, create the wrappers
			for(Staffing_Assignment__c sa : staffList) {
				if(sa != null && sa.User__c != null && recUtil != null) {
					userInstance = recUtil.get(sa.User__c);
				}
				StaffingAssignmentWrapper saw = new staffingAssignmentWrapper(parentId, parentSObjectType, sa, recusalStatusMap);
				innerWrapperList.add(saw);
			}
		}

		//constructor used in initial creation for each wrapper object
		private StaffingAssignmentWrapper(Id parentId, String parentSObjectType, Staffing_Assignment__c sa, Map<Id,String> recusalStatusMap) {
			//Staffing Assignment variables
			this.sa = sa;
			this.parentId = parentId;
			this.parentSObjectType = parentSObjectType;
			this.overrideRole = initialOverrideRole(this.sa);
			//Recusal variables
			this.recusalStatusMap = recusalStatusMap;
		}
		//constructor used in "add row" method
		private StaffingAssignmentWrapper(Staffing_Assignment__c sa) {
			this.sa = sa;
			this.overrideRole = initialOverrideRole(this.sa);
		}
		//sets the default override for each wrapper object
		private Boolean initialOverrideRole(Staffing_Assignment__c sa) {
			overrideRole =  sa.Title__c != null && sa.User__r.Staffing_Role__c != null && sa.Title__c != sa.User__r.Staffing_Role__c ? true : false;
			return overrideRole;
		}
		//Initializes SelectOption lists
		private void populateRecusalStatus(Id parentId, Set<Id> userIdSet, Map<Id,ADCVD_RecusalUtility> recUtil){
			recusalStatusMap = new Map<Id,String>();
			wrapperPrimaryRecusalMap = new Map<Id,List<Recusal__c>>();
			for (Id userId : userIdSet) {
				String recusalStatus = '';
				if (recUtil != null && recUtil.get(userId) != null) {
					userInstance = recUtil.get(userId);
				}
				if (userInstance.primaryRecusalList != null && !userInstance.primaryRecusalList.isEmpty()) {
					recusalStatus += 'This user has active recusals.' + '<br/>';
					wrapperPrimaryRecusalMap.put(userId, userInstance.primaryRecusalList);
				}
				if (userInstance.recusalsInRecordHierarchyMap != null && userInstance.recusalsInRecordHierarchyMap.get(parentId) != null 
					&& userInstance.recusalsInRecordHierarchyMap.get(parentId) == true) {//clarity that this is a map to a boolean
					System.debug(userInstance.recusalsInRecordHierarchyMap.get(parentId));
					recusalStatus += 'This user has been recused from some of this record\'s parents.' + '<br/>';
				}
				if (userInstance.recusedFromThisRecordMap != null && userInstance.recusedFromThisRecordMap.get(parentId) != null 
					&& userInstance.recusedFromThisRecordMap.get(parentId) == true) {//clarity that this is a map to a boolean
					recusalStatus += 'This user has been recused from this record.' + '<br/>';
				}
				if (recusalStatus == null || String.isBlank(recusalStatus)) {
					recusalStatus += 'This user does not have any active recusals.';
				}
				recusalStatusMap.put(userId, recusalStatus);
			}
		}
	}
}