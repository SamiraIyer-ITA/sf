public without sharing class SuspensionAgreementTriggerHandler {

	private static Map<String,Constant__mdt> saCalcOffsets = saCalcOffsets();

	//FINAL ADCVD Order Offsets
	private static FINAL Integer SUNSET_INIT_YEARS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Years').Number_Value__c);//Next_Sunset_Initiation_Date__c
	private static FINAL Integer SUNSET_INIT_MONTHS				    = ((Integer)saCalcOffsets.get('Susp_Agr_Sunset_Initiation_Months').Number_Value__c);//Next_Sunset_Initiation_Date__c
    private static FINAL Integer EFFECTIVE_DATE_TERM_MONTHS         = ((Integer)saCalcOffsets.get('Susp_Agr_Effective_Termination_Months').Number_Value__c);//Effective_Date_of_Termination__c
    private static FINAL Integer EFFECTIVE_DATE_TERM_YEARS          = ((Integer)saCalcOffsets.get('Susp_Agr_Effective_Termination_Years').Number_Value__c);//Effective_Date_of_Termination__c


    public static boolean preventRecursion = false;
    public static void mainEntry(List<Suspension_Agreement__c> newList, List<Suspension_Agreement__c> oldList, Map<Id, Suspension_Agreement__c> newMap, 
        Map<Id, Suspension_Agreement__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
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
    }

    /*****************************
     * Class Level Variables
    *****************************/
    
	@TestVisible private static Map<Id,Investigation__c> investigationsInScopeMap = new Map<Id,Investigation__c>();
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();

    
    /******************************************
    * Methods called directly by mainEntry()
    ******************************************/
	  
    @TestVisible private static void initialize(List<Suspension_Agreement__c> newList, Map<Id,Suspension_Agreement__c> newMap) {
        if(newMap != null) {
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Segments with an Id
            frUtilMap = listInstance.utilMap;
        }
        investigationsInScopeMap = findInvestigationsInScopeMap(newList); //find the parent Investigation 
    }

	//set ADCVD Case value from Investigations     
    @TestVisible private static void setCaseValues(List<Suspension_Agreement__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Suspension_Agreement__c sa : newList) {
            sa = (Suspension_Agreement__c) pvs.setCaseValuesFromParent(investigationsInScopeMap.get(sa.Investigation__c), sa);
            //System.debug('# setCaseValues SuspAgrmnt Record = ' + sa);
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
     
    //returns a map of the Investigation__c objects in the form: key = Id, value = Investigation object
    //This pulls the investigation fields needed via the Investigation lookup field and adds them to the map
    @TestVisible private static Map<Id,Investigation__c> findInvestigationsInScopeMap(List<Suspension_Agreement__c> newList) {
        Map<Id,Investigation__c> returnMap = new Map<Id,Investigation__c>();
        Set<Id> investigationIdSet = findIdsInScope(newList);
        for (Investigation__c i : [SELECT Id, ADCVD_Case_Type__c, ADCVD_Case__c 
                                    FROM Investigation__c WHERE Id IN: investigationIdSet]) {
            returnMap.put(i.Id, i);
        }
        return returnMap;
    }
      
    //used to set Offset Variables
	@TestVisible private static Map<String,Constant__mdt> saCalcOffsets() {
		if(saCalcOffsets == null || saCalcOffsets.size() < 1) {
			Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
			List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
													ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
											FROM Constant__mdt 
											WHERE Suspension_Agreement_Calculation_Offset__c =: true];
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
            suspensionAgreementPublishedDate = frUtilMap.get(sa.Id) != null ? frUtilMap.get(sa.Id).suspensionAgreementPublishedDate : null;
        }
        if (suspensionAgreementPublishedDate != null) {
            sa.Anniversary_Month__c = utils.getMonthFromDate(suspensionAgreementPublishedDate);
        } else {
            sa.Anniversary_Month__c = null;
        }
    }

    //Next_Sunset_Initiation_Date__c
    @TestVisible private static void setNextSunsetInitiationDate(Suspension_Agreement__c sa) {
    	Date nextSSR = null;
    	if (sa.Id != null && frUtilMap != null) {
    		nextSSR = frUtilMap.get(sa.Id) != null ? frUtilMap.get(sa.Id).suspensionAgreementPublishedDate : null;//set to suspensionAgreementPublishedDate if populated
    		nextSSR = (frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).continuationPublishedDate != null) ? frUtilMap.get(sa.Id).continuationPublishedDate : nextSSR;//overwrite to continuationPublishedDate if populated
    		nextSSR = (frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).terminationPublishedDate != null) ? null : nextSSR;//overwrite to null if revocationPublishedDate is populated
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
        if (sa.Id != null && frUtilMap != null && frUtilMap.get(sa.Id) != null && frUtilMap.get(sa.Id).terminationPublishedDate != null) {
            if (frUtilMap.get(sa.Id).suspensionAgreementPublishedDate != null) {
                maxDate = frUtilMap.get(sa.Id).suspensionAgreementPublishedDate;
                maxDateName = 'Suspension Agreement Federal Register Published Date: ' + maxDate.format();
            }
            if (frUtilMap.get(sa.Id).continuationPublishedDate != null) {
                maxDate = frUtilMap.get(sa.Id).continuationPublishedDate;
                maxDateName = 'most recent Continuation Federal Register Published Date: ' + maxDate.format();
            }
            maxDate = maxDate != null ? maxDate.addYears(EFFECTIVE_DATE_TERM_YEARS).addMonths(EFFECTIVE_DATE_TERM_MONTHS) : null;
        }
        if (maxDate != null && sa != null && sa.Effective_Date_of_Termination__c != null && maxDate < sa.Effective_Date_of_Termination__c) {
            sa.Effective_Date_of_Termination__c.addError('The Effective Date of Termination cannot be more than 5 years from the ' + maxDateName);
        }
    }
}