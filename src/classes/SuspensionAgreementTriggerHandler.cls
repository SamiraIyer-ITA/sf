/**
 * 
 *    Created by Joshua Moody
 *    on May 16 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class SuspensionAgreementTriggerHandler {
     /***********************************************************
   * This class handles all trigger contexts for the Suspension_Agreement__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Retrieve constant values saved in custom metadata
   * 5. Performs custom validations not possible with validation rules
   ***********************************************************/

	private static Map<String,Constant__mdt> saCalcOffsets = saCalcOffsets();

	//FINAL ADCVD Order Offsets
    private static FINAL Integer SUNSET_INIT_YEARS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Years').Number_Value__c);//Next_Sunset_Initiation_Date__c
    private static FINAL Integer SUNSET_INIT_MONTHS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Months').Number_Value__c);//Next_Sunset_Initiation_Date__c
    private static FINAL Integer EFFECTIVE_DATE_TERM_MONTHS         = ((Integer)saCalcOffsets.get('Susp_Agr_Effective_Termination_Months').Number_Value__c);//Effective_Date_of_Termination__c
    private static FINAL Integer EFFECTIVE_DATE_TERM_YEARS          = ((Integer)saCalcOffsets.get('Susp_Agr_Effective_Termination_Years').Number_Value__c);//Effective_Date_of_Termination__c


    public static boolean preventRecursion = false;
    public static void mainEntry(List<Suspension_Agreement__c> newList, List<Suspension_Agreement__c> oldList, Map<Id, Suspension_Agreement__c> newMap,
            Map<Id, Suspension_Agreement__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList,newMap);
            setCaseValues(newList); 
            calculateDates(newList);
            runCustomValidations(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList,newMap);
            calculateDates(newList);
            runCustomValidations(newList);
        }
        
        if (isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            new StaffingAssignmentService().createStaffFromSObjectParent(newList, 'Suspension_Agreement__c');
            
        }
    }

    /*****************************
     * Class Level Variables
    *****************************/
    
    @TestVisible private static Map<Id,Investigation__c> investigationsInScopeMap = new Map<Id,Investigation__c>();
    @TestVisible private static Map<Id, FederalRegisterMapper.MappedFRs> frUtilMap = new Map<Id, FederalRegisterMapper.MappedFRs>();
    @TestVisible private static FederalRegisterMapper frMapper;
    @TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
	@TestVisible private static Suspension_AgreementMapper saMapper;
    
    /******************************************
    * Methods called directly by mainEntry()
    ******************************************/
	  
    @TestVisible private static void initialize(List<Suspension_Agreement__c> newList, Map<Id,Suspension_Agreement__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        for (Suspension_Agreement__c sa : newList) {
            caseIdSet.add(sa.ADCVD_Case__c);
        }
        caseMapper = caseMapper.getInstance(caseIdSet);
        InvestigationMapper is = (InvestigationMapper) caseMapper.getMapper('Investigation__c').getInstance();
        investigationsInScopeMap = (Map<Id,Investigation__c>) caseMapper.getMapper('Investigation__c').getInstance().getMap(true);
        if(newMap != null) {
            addNewSuspAgrmtToMappers(newMap);
            frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
            frUtilMap = frMapper.getMappedFRs(newMap.keySet(), caseMapper);
        }
        caseMapper = caseMapper.getInstance(caseIdSet);
        investigationsInScopeMap = (Map<Id,Investigation__c>) caseMapper.getMapper('Investigation__c').getInstance().getMap(true);// findPetitionsInScopeMap(newList); //find the parent Investigation
    }
    
    @TestVisible private static Set<Id> getCaseIdSet(List<Suspension_Agreement__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> invIdSet = new Set<Id>();
        for (Suspension_Agreement__c sa : newList) {
            invIdSet.add(sa.Investigation__c);
        }
        for (Investigation__c i : [SELECT ADCVD_Case__c FROM Investigation__c WHERE Id IN: invIdSet]) {
            caseIdSet.add(i.ADCVD_Case__c);
        }
        return caseIdSet;
    }

	//set ADCVD Case value from Investigations     
    @TestVisible private static void setCaseValues(List<Suspension_Agreement__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Suspension_Agreement__c sa : newList) {
            sa = (Suspension_Agreement__c) pvs.setCaseValuesFromParent(investigationsInScopeMap.get(sa.Investigation__c), sa);
        }
    }
    
    @TestVisible private static void addNewSuspAgrmtToMappers(Map<Id,Suspension_Agreement__c> newMap) {
        Map<Id,List<Suspension_Agreement__c>> caseToSuspAgrmtMap = new Map<Id,List<Suspension_Agreement__c>>();
        saMapper = (Suspension_AgreementMapper) caseMapper.getMapper('Suspension_Agreement__c').getInstance();
        for (Suspension_Agreement__c sa : newMap.values()) {
            saMapper.addSuspAgrmtToMap(sa);
            List<Suspension_Agreement__c> tempList = caseToSuspAgrmtMap.get(sa.ADCVD_Case__c) != null ?
                                                   caseToSuspAgrmtMap.get(sa.ADCVD_Case__c) : new List<Suspension_Agreement__c>();
            tempList.add(sa);
            caseToSuspAgrmtMap.put(sa.ADCVD_Case__c, tempList);
        }
        for (Id caseId : caseToSuspAgrmtMap.keySet()) {
            caseMapper.setCaseIdToSuspAgrmtMap(caseId, caseToSuspAgrmtMap.get(caseId));
        }
    }

     
    @TestVisible private static void calculateDates(List<Suspension_Agreement__c> newList) {
		for (Suspension_Agreement__c sa : newList) {
            setAnniversaryMonth(sa);
			setNextSunsetInitiationDate(sa);
		}
	}

    @TestVisible private static void runCustomValidations(List<Suspension_Agreement__c> newList) {
        for (Suspension_Agreement__c sa : newList) {
            validateEffectiveDateOfTermination(sa);
        }
    }

    /***********************************
    * Helper Methods
    ***********************************/
    
    //returns a set of Investigation Ids in scope of the Suspension Agreement in trigger
    @TestVisible private static Set<Id> findIdsInScope(List<Suspension_Agreement__c> newList) {
        Set<Id> investigationIdSet = new Set<Id>();
        for (Suspension_Agreement__c sa : newList) {
            investigationIdSet.add(sa.Investigation__c);
        }
        return investigationIdSet;
    }
      
    //used to set Offset Variables
	@TestVisible private static Map<String,Constant__mdt> saCalcOffsets() {
		if(saCalcOffsets == null || saCalcOffsets.size() < 1) {
			Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
			List<Constant__mdt> tempList = new ADCVD_ConstantMetadataSelector().selectBySuspensionAgreementCalculationOffset(true);
			for(Constant__mdt sc : tempList) {
				returnMap.put(sc.QualifiedAPIName, sc);
			}
			return returnMap;
		} else {
			return saCalcOffsets;
		}
	}


    /*********************************
    * Date Calculations
    *********************************/

    //Set Anniversary_Month__c
    @TestVisible private static void setAnniversaryMonth(Suspension_Agreement__c sa) {
        Date suspensionAgreementPublishedDate = null;
        if (sa.Id != null && frUtilMap != null) {
            suspensionAgreementPublishedDate = frUtilMap.get(sa.Id) != null ? frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Suspension Agreement') : null;
        }
        if (suspensionAgreementPublishedDate != null) {
            sa.Anniversary_Month__c = Utils.getMonthFromDate(suspensionAgreementPublishedDate);
        } else {
            sa.Anniversary_Month__c = null;
        }
    }

    //Next_Sunset_Initiation_Date__c
    @TestVisible private static void setNextSunsetInitiationDate(Suspension_Agreement__c sa) {
    	Date nextSSR = null;
    	if (sa.Id != null && frUtilMap.containsKey(sa.Id)) {
            nextSSR = frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Suspension Agreement'); //set to suspensionAgreementPublishedDate if populated
            Federal_Register__c continuationFR = frUtilMap.get(sa.Id).frsByType.get('Continuation');
            Federal_Register__c suspensionAgreementFR = frUtilMap.get(sa.Id).frsByType.get('Suspension Agreement');
            nextSSR = (continuationFR != null && suspensionAgreementFR !=null
                && continuationFR.Published_Date__c > suspensionAgreementFR.Published_Date__c)
                ? frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Continuation') : nextSSR;//overwrite to continuationPublishedDate if populated
            nextSSR = (frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Termination') != null) ? null : nextSSR;//overwrite to null if revocationPublishedDate is populated
        }
    	if (nextSSR != null) {
    		sa.Next_Sunset_Initiation_Date__c = nextSSR.toStartOfMonth().addYears(SUNSET_INIT_YEARS).addMonths(SUNSET_INIT_MONTHS);
    	} else {
            sa.Next_Sunset_Initiation_Date__c = null;
        }
    }


    /**************************
    * Custom Validations
    **************************/

    //Effective_Date_of_Termination__c
    @TestVisible private static void validateEffectiveDateOfTermination(Suspension_Agreement__c sa) {
        String maxDateName = '';
        Date maxDate = null;
        if (sa.Id != null && frUtilMap != null && frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Termination')  != null) {
            if (frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Suspension Agreement') != null) {
                maxDate = frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Suspension Agreement');
                maxDateName = 'Suspension Agreement Federal Register Published Date: ' + maxDate.format();
            }
            if (frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Continuation') != null) {
                maxDate = frUtilMap.get(sa.Id).typeToPublishedDateMap.get('Continuation');
                maxDateName = 'most recent Continuation Federal Register Published Date: ' + maxDate.format();
            }
            maxDate = maxDate != null ? maxDate.addYears(EFFECTIVE_DATE_TERM_YEARS).addMonths(EFFECTIVE_DATE_TERM_MONTHS) : null;
        }
        if (maxDate != null && sa != null && sa.Effective_Date_of_Termination__c != null && maxDate < sa.Effective_Date_of_Termination__c) {
            sa.Effective_Date_of_Termination__c.addError('The Effective Date of Termination cannot be more than 5 years from the ' + maxDateName);
        }
    }
}