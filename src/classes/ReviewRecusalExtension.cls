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

	 public String recusalLink {
		 get {
			 recusalLink = '';
			 recusalLink = AppConfig__c.getValues('Recusal Link').Link__c;
			 return recusalLink;
		} set;
	 }

	public Id caseId {get; set;}
	public Recusal__c rec {get {
		if(rec == null) {
			rec = new Recusal__c();
		}
		return rec;
		} set;
	}

	public Boolean noRecusals{get; set;}
	public Id userId {get; set;}
	@TestVisible private ADCVD_CaseMapper caseMapper {
		get {
			if (caseMapper == null) {
				caseMapper = new ADCVD_CaseMapper();
			}
			return caseMapper;
		} set;
	}
	@TestVisible private RecusalMapper recMapper {
		get {
			if (recMapper == null) {
				recMapper = (RecusalMapper) caseMapper.getMapper('Recusal__c');
			}
			return recMapper;
		} set;
	}
	//List of primary recusals returned for the user
	public List<Recusal__c> recusalList {
		get {
			if (recusalList == null) {
				recusalList = new List<Recusal__c>();
			}
			return recusalList;
		} set;
	}

	/*********************
	 * Constructor
	 *********************/

	public ReviewRecusalExtension (ApexPages.StandardController stdController) {
		if (ApexPages.currentPage().getParameters() != null && ApexPages.currentPage().getParameters().get('userId') != null) {
			userId = ApexPages.currentPage().getParameters().get('userId');
			caseId = ApexPages.currentPage().getParameters().get('caseId');
		}
		if (userId != null) {
			init();
		}
	}
	//Primary method to initialize data on page load
	@TestVisible private void init(){
		caseMapper = caseMapper.getInstance(new Set<Id> {caseId});
		recMapper = recMapper.getInstance(new Set<Id> {userId});
		recusalList = new List<Recusal__c>();
		List<Recusal__c> recusalWithCases = new List<Recusal__c>();
		List<Recusal__c> recusalWithoutCases = new List<Recusal__c>();

		for (Recusal__c r : recMapper.getMapByUserIds().get(userId)) {
			if (r.ADCVD_Case__c != null) {
				recusalWithCases.add(r);
			} else {
				recusalWithoutCases.add(r);
			}
		}
		recusalList.addAll(recusalWithCases);
		recusalList.addAll(recusalWithoutCases);

		System.debug('***recusalList: ' + recusalList);
		noRecusals = setNoRecusals(recusalList);
	}

	private Boolean setNoRecusals(List<Recusal__c> recusalList) {
		Boolean returnBool = false;
		if(recusalList == null || recusalList.isEmpty()) {
			returnBool = true;
		}
		return returnBool;
	}

	public PageReference cancel() {
		return null;
	}
}
