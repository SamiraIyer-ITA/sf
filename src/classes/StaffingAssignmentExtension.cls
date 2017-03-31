public without sharing class StaffingAssignmentExtension {

	/*********************************
 	* Variables to manage UI
 	********************************/
 	public Boolean redirectInLEX {get; set;}
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
    public Id parentId {get {
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
		return parentId;
    	} set;
    }

    public String parentObjectType {get {
    	if(sa != null) {
	    	if (sa.Petition__c != null) {
				parentObjectType = 'Petition__c';
			} else if (sa.Investigation__c != null) {
				parentObjectType = 'Investigation__c';
			} else if (sa.ADCVD_Order__c != null) {
				parentObjectType = 'ADCVD_Order__c';
			} else if (sa.Segment__c != null) {
				parentObjectType = 'Segment__c';
			} else if (sa.Related_Organization__c != null) {
				parentObjectType = 'Related_Organization__c';
			} else {
				parentObjectType = 'Staffing_Assignment__c';
			}
		}
		return parentObjectType;
		} set;
	}

    /***********************************
     * Variables for Staffing Assigment
     ***********************************/
    public Id idFromPage {get; set;}
    public Staffing_Assignment__c sa {get { 
        if(sa == null) {
            querySA(idFromPage);
        }
        return sa;
    	} set;
    }

    /******************************************
     * Variables for User Select Option Lists
     *****************************************/
     public List<SelectOption> allUserSelectOptions {get {
		if(allUserSelectOptions == null) {
			populateUserLists();
		}
		return allUserSelectOptions;
		} set;
	}
	public Map<String, List<SelectOption>> userSelectOptions {get {
		if(userSelectOptions == null) {
			populateUserLists();
		}
		return userSelectOptions;
		} set;
	}

	public Map<String, List<User>> userRoleMap {get {
		if(userRoleMap == null) {
			populateUserLists();
		}
		return userRoleMap;
		} set;
	}
	
	/**********************************************
	 * Variables for Staff Assignments and Wrapper
	 *********************************************/
	public List<Staffing_Assignment__c> staffList {get {
		if(staffList == null) {
			staffList = new List<Staffing_Assignment__c>();
		}
		return staffList;
		} set;
	}
    public List<StaffingAssignmentWrapper> staffWrapperList {get {
        if(staffWrapperList == null) {
            staffWrapperList = new List<StaffingAssignmentWrapper>();
        }
        return staffWrapperList;
	    } set;
	}
	
	public Boolean overwriteSegments {get; set;}
	public String navigatedBysObjectType {get; set;}
//TODO: this needs to pull from current SA records
	@TestVisible 
	private static Set<String> userRolesSet = new Set<String>{'Accounting Director', 'Accounting PM', 'Assistant Secretary', 'Associate DAS', 
																'DAS', 'DAS Assistant', 'Office Director', 'Program Manager', 'Senior Legal', 
																'Senior Policy', 'Staff Legal', 'Staff Policy'};

	/*********************
	 * Constructors
	 *********************/

	 public StaffingAssignmentExtension () {
		System.debug('extension constructor 1');
		if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('Id') != null) {
            idFromPage = ApexPages.currentPage().getParameters().get('Id');
        }
        init(sa);
	}
	
	public StaffingAssignmentExtension (ApexPages.StandardController stdController) {
		stdController.addFields(parentFieldNames);
		System.debug('extension constructor 2');
        sa = (Staffing_Assignment__c)stdController.getRecord();
        init(sa);
	}

	private void init(Staffing_Assignment__c sa){
		overwriteSegments = false;
		staffList = getstaffList(parentId, parentObjectType);
		staffWrapperList = addStaffWrapper(parentId, parentObjectType, staffList);
		if(!isSalesforceClassic) {
			staffWrapperList = sortStaffWrapperListForLEX(staffWrapperList);
		}
		System.debug(staffWrapperList);
	}

	public PageReference addRow(){
		Staffing_Assignment__c sa = createNewStaffingAssignment(parentId);
		StaffingAssignmentWrapper saw = new StaffingAssignmentWrapper(sa);
		staffWrapperList.add(saw);
		return null;
	}

	public PageReference save() {
		List<Staffing_Assignment__c> staffListToUpsert = new List<Staffing_Assignment__c>();
		List<Staffing_Assignment__c> staffListToDelete = new List<Staffing_Assignment__c>();
		Boolean isOrder = false;
		for(staffingAssignmentWrapper saw: staffWrapperList) {
			if(!String.isBlank(saw.sa.User__c)){
				staffListToUpsert.add(saw.sa);
			} else if (String.isBlank(saw.sa.User__c) && !String.isBlank(saw.sa.Id)) {
				staffListToDelete.add(saw.sa);
			}
			if(saw != null && saw.parentSObjectType == 'ADCVD_Order__c') {
				parentId = saw.parentId;
				isOrder = true;
			}
		}
		//propogate staffing assignment to child segments of the order
		if(overwriteSegments && isOrder) {
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
		system.debug(getReturnUrl());
		if(isSalesforceClassic) {
			return new PageReference(getReturnUrl());
		} else {
			redirectInLEX = true;
			return null;
		}
		
	}

	public PageReference cancel() {
		if(isSalesforceClassic) {
			return new PageReference(getReturnUrl());
		} else {
			redirectInLEX = true;
			return null;
		}
	}

	private String getReturnUrl() {
		return ApexPages.currentPage().getParameters().get('retURL');
	}

	private Staffing_Assignment__c querySA(Id idFromPage){
		Staffing_Assignment__c querySA = new Staffing_Assignment__c();
		if(idFromPage != null) {
            querySA = [SELECT Id, ADCVD_Order__c, Investigation__c, Petition__c, 
				 				Related_Organization__c, Segment__c FROM Staffing_Assignment__c 
				 				WHERE Id =: idFromPage
				 				OR ADCVD_Order__c =:idFromPage
				 				OR Investigation__c =:idFromPage
				 				OR Petition__c =:idFromPage
				 				OR Related_Organization__c =:idFromPage
				 				OR Segment__c =:idFromPage  LIMIT 1];
        } else {
            querySA = new Staffing_Assignment__c();
        }
        return querySA;
    }

	private List<Staffing_Assignment__c> getStaffList(Id parentId, String parentObjectType) {
		if(staffList == null || staffList.isEmpty()) {
			//specify base query
			String soqlQuery = 'SELECT Id, User__c, Title__c, User__r.Staffing_Role_Filter_Field__c , User__r.Staffing_Role__c FROM Staffing_Assignment__c WHERE ';
			//specify object specific clause and query object, add to wrapper
			soqlQuery += parentObjectType + ' =: parentId LIMIT 1000 ';	
			System.debug(soqlQuery);
			staffList = database.query(soqlQuery);
		}
		return staffList;
	}

	private void populateUserLists(){
		userRoleMap = new Map<String, List<User>>();
		userSelectOptions = new Map<String, List<SelectOption>>();
		allUserSelectOptions = new List<SelectOption>();
		for(User u: [SELECT Id, Name, Staffing_Role__c FROM User WHERE Staffing_Role__c != null]) {
			List<User> userList = new List<User>();
			//if the map already contains a list - use the list from the map
			if(userRoleMap.get(u.Staffing_Role__c) != null) {
				userList = userRoleMap.get(u.Staffing_Role__c);
			}
			userList.add(u);
			userRoleMap.put(u.Staffing_Role__c, userList);
		}
		for(String s: userRolesSet) {
			List<User> userList = userRoleMap.get(s);
			List<SelectOption> userSelect = new List<SelectOption>();
			
			if(userList != null) {
				for(User u: userList) {
					userSelect.add(new SelectOption(u.Id, u.Name));
				}
				allUserSelectOptions.addAll(userSelect);
				if(userList.size() > 0) {
					userSelect.add(0,new SelectOption('', '--Select a User--'));	
				}
			} else {
				userSelect.add(new SelectOption('', '--Please update user records to have this AD CVD Title--'));	
			}
			userSelectOptions.put(s, userSelect);
		}
		allUserSelectOptions.add(0,new SelectOption('','--Select a User--'));
	}

	private List<StaffingAssignmentWrapper> sortStaffWrapperListForLEX (List<StaffingAssignmentWrapper> apexRepeatOrderedList) {
    	List<StaffingAssignmentWrapper> htmlOrderedList = new List<StaffingAssignmentWrapper>();
    	List<StaffingAssignmentWrapper> tempList1 = new List<StaffingAssignmentWrapper>();
    	List<StaffingAssignmentWrapper> tempList2 = new List<StaffingAssignmentWrapper>();
    	Boolean oddNumber = false;
    	Boolean switchList = true;
    	StaffingAssignmentWrapper oddObject;
    	Integer totalCount = apexRepeatOrderedList.size();
    	Decimal halfCount = Decimal.valueOf(Math.floor(totalCount / 2));
    	Integer compareTotal = (Integer)halfCount * 2;
    	if(compareTotal != totalCount){
    		oddObject = apexRepeatOrderedList.get(totalCount-1);
    		apexRepeatOrderedList.remove(totalCount-1);
    		oddNumber = true;
    	}
    	for(StaffingAssignmentWrapper o : apexRepeatOrderedList) {
    		if(switchList) {
    			tempList1.add(o);
    			switchList = false;
    		} else {
    			tempList2.add(o);
    			switchList = true;
    		}
    	}
    	if(oddNumber) {
    		tempList1.add(oddObject);
    	}
    	htmlOrderedList.addAll(tempList1);
    	htmlOrderedList.addAll(tempList2);
    	return htmlOrderedList;
    }

	//wrapper class for rendering the list(s) of staffing assignments
	public class StaffingAssignmentWrapper {
		public Staffing_Assignment__c Sa {get; set;}
		public String parentSObjectType {get; set;}
		public String parentId {get; set;}
		public Boolean overrideRole {get; set;}
		public StaffingAssignmentWrapper(Id parentId, String parentSObjectType, Staffing_Assignment__c sa) {
			this.sa = sa;
			this.parentId = parentId;
			this.parentSObjectType = parentSObjectType;
			this.overrideRole = initialOverrideRole(this.sa);
		}
		public StaffingAssignmentWrapper(Staffing_Assignment__c sa) {
			this.sa = sa;
			this.overrideRole = initialOverrideRole(this.sa);
		}
		private Boolean initialOverrideRole(Staffing_Assignment__c sa) {
			overrideRole =  sa.Title__c != null && sa.User__r.Staffing_Role__c != null && sa.Title__c != sa.User__r.Staffing_Role__c ? true : false;
			return overrideRole;
		}
	}

	public static Staffing_Assignment__c createNewStaffingAssignment(String parentId, String title) {
		Staffing_Assignment__c newSA = createNewStaffingAssignment(parentId);
		newSA.Title__c = title;
		return newSA;
	}

	public static Staffing_Assignment__c createNewStaffingAssignment(String parentIdAsString) {
		Staffing_Assignment__c newSA = new Staffing_Assignment__c();
		if(!String.isBlank(parentIdAsString)) {
			Id parentId = (Id)parentIdAsString;
			String parentObjectType = parentId.getSObjectType().getDescribe().getName();
			if(parentObjectType == 'ADCVD_Order__c') {
				newSA.ADCVD_Order__c = parentId;
			} else if (parentObjectType == 'Investigation__c') {
				newSA.Investigation__c = parentId;
			} else if (parentObjectType == 'Petition__c') {
				newSA.Petition__c = parentId;
			} else if (parentObjectType == 'Related_Organization__c') {
				newSA.Related_Organization__c = parentId;
			} else if (parentObjectType == 'Segment__c') {
				newSA.Segment__c = parentId;
			}
		}
		return newSA;
	}

	//method to add a list of staffing assignments to the wrapper - prepopulates blank values
	public List<StaffingAssignmentWrapper> addStaffWrapper(Id parentId, String parentSObjectType, List<Staffing_Assignment__c> staffList) {
		//create a map to determine if the User Title is already specified
		List<StaffingAssignmentWrapper> returnList = new List<StaffingAssignmentWrapper>();
		Map<String, Boolean> userTitleExistsMap = new Map<String, Boolean>();
		System.debug(staffList);
		for(String s: userRolesSet) {
			userTitleExistsMap.put(s, false);
		}
		//add existing user titles to the map
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
		for(Staffing_Assignment__c sa : staffList) {
			StaffingAssignmentWrapper saw = new staffingAssignmentWrapper(parentId, parentSObjectType, sa);
			returnList.add(saw);
		}
		return returnList;
	}
}