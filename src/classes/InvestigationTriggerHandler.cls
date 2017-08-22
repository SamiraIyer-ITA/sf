public without sharing class InvestigationTriggerHandler {
	
    @TestVisible private static Set<String> outcomesThatTermInvestigations = new Set<String>();
    @TestVisible private static Set<String> activeLitigationStatuses = new Set<String>();
    private static Map<String,Constant__mdt> investigationApiToConstants = setInvestigationApiToConstants();

	//FINAL Investigation Record Type Developer Names
	private static FINAL String ADRECORD = 'AD';//investigationApiToConstants.get('AD_Calc_Final_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String CVDRECORD = 'CVD';//investigationApiToConstants.get('CVD_Calc_Final_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String INVESTIGATION = 'Investigation__c';//investigationApiToConstants.get('AD_Calc_Final_Sig').ADCVD_Objects__r.Object_API_Name__c;
/*
	//FINAL AD Record Type Offsets
    private static FINAL Integer AD_CALC_AMEND_PRELIM_SIGN = ((Integer)investigationApiToConstants.get('AD_Calc_Amend_Prelim_Det_Sig').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer AD_CALC_PRELIM_SIGN = ((Integer)investigationApiToConstants.get('AD_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c
    private static FINAL Integer AD_CALC_FINAL_SIGN = ((Integer)investigationApiToConstants.get('AD_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer AD_CALC_ITC_PRELIM_DET = ((Integer)investigationApiToConstants.get('AD_Calc_ITC_Prelim_Det').Number_Value__c);//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer AD_CALC_PRELIM_EXT_REQ_FILE = ((Integer)investigationApiToConstants.get('AD_Calc_Prelim_Ext_Request_File').Number_Value__c);//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer AD_CALC_POSTPONE_PRELIM_DET_FR = ((Integer)investigationApiToConstants.get('AD_Calc_Postpone_Prelim_Det_FR').Number_Value__c);//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer AD_PRELIM_TEAM_MEETING_DEADLINE = ((Integer)investigationApiToConstants.get('AD_Prelim_Team_Meeting_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer AD_TERM_SUSP_GAP_PERIOD_BEG_W_EXT = ((Integer)investigationApiToConstants.get('AD_Term_Susp_Gap_Period_Beg_w_FinExt').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c with Final Extension of days
    private static FINAL Integer AD_TERM_SUSP_GAP_PERIOD_BEG_W_O_EXT = ((Integer)investigationApiToConstants.get('AD_Term_Susp_Gap_Period_Beg_w_o_FinExt').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c without Final Extension of days
    private static FINAL Integer AD_FINAL_TEAM_MEETING_DEADLINE = ((Integer)investigationApiToConstants.get('AD_Final_Team_Meeting_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer AD_CALC_AMENDED_FINAL_SIGNATURE = ((Integer)investigationApiToConstants.get('AD_Calc_Amend_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c
    private static FINAL Integer AD_EST_ITC_NOTIF_DOC_FINAL_DET = ((Integer)investigationApiToConstants.get('AD_Est_ITC_Note_of_DOC_to_Final_Det').Number_Value__c);//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer AD_CALC_ORDER_FR_SIGNATURE = ((Integer)investigationApiToConstants.get('AD_Calc_Order_FR_Sig').Number_Value__c);//Calculated_Order_FR_Signature__c
    private static FINAL Integer AD_CALC_ITC_FINAL_FR_PUBLISHED = ((Integer)investigationApiToConstants.get('AD_Calc_ITC_Final_FR_Published').Number_Value__c);//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer AD_EST_ORDER_FR_PUBLISHED = ((Integer)investigationApiToConstants.get('AD_Est_Order_FR_Published').Number_Value__c);//Estimated_Order_FR_Published__c

    //FINAL CVD Record Type Offsets
    private static FINAL Integer CVD_CALC_AMEND_PRELIM_SIGN = ((Integer)investigationApiToConstants.get('CVD_Calc_Amend_Prelim_Det_Sig').Number_Value__c);//Calc_Amended_Prelim_Determination_Sig__c
    private static FINAL Integer CVD_CALC_PRELIM_SIGN = ((Integer)investigationApiToConstants.get('CVD_Calc_Prelim_Sig').Number_Value__c);//Calculated_Preliminary_Signature __c
    private static FINAL Integer CVD_CALC_FINAL_SIGN = ((Integer)investigationApiToConstants.get('CVD_Calc_Final_Sig').Number_Value__c);//Calculated_Final_Signature__c
    private static FINAL Integer CVD_CALC_ITC_PRELIM_DET = ((Integer)investigationApiToConstants.get('CVD_Calc_ITC_Prelim_Det').Number_Value__c);//Calculated_ITC_Prelim_Determination__c
    private static FINAL Integer CVD_CALC_PRELIM_EXT_REQ_FILE = ((Integer)investigationApiToConstants.get('CVD_Calc_Prelim_Ext_Request_File').Number_Value__c);//Calculated_Prelim_Extension_Request_File__c
    private static FINAL Integer CVD_CALC_POSTPONE_PRELIM_DET_FR = ((Integer)investigationApiToConstants.get('CVD_Calc_Postpone_Prelim_Det_FR').Number_Value__c);//Calculated_Postponement_of_PrelimDeterFR__c
    private static FINAL Integer CVD_PRELIM_TEAM_MEETING_DEADLINE = ((Integer)investigationApiToConstants.get('CVD_Prelim_Team_Meeting_Deadline').Number_Value__c);//Prelim_Team_Meeting_Deadline__c
    private static FINAL Integer CVD_TERM_SUSP_GAP_PERIOD_BEG = ((Integer)investigationApiToConstants.get('CVD_Term_Susp_Gap_Period_Beg').Number_Value__c);//Termination_of_Suspension_Gap_Period_Beg__c
    private static FINAL Integer CVD_FINAL_TEAM_MEETING_DEADLINE = ((Integer)investigationApiToConstants.get('CVD_Final_Team_Meeting_Deadline').Number_Value__c);//Final_Team_Meeting_Deadline__c
    private static FINAL Integer CVD_CALC_AMENDED_FINAL_SIGNATURE = ((Integer)investigationApiToConstants.get('CVD_Calc_Amend_Final_Sig').Number_Value__c);//Calculated_Amended_Final_Signature__c
    private static FINAL Integer CVD_EST_ITC_NOTIF_DOC_FINAL_DET = ((Integer)investigationApiToConstants.get('CVD_Est_ITC_Note_to_DOC_of_Final_Det').Number_Value__c);//Est_ITC_Notification_to_DOC_of_Final_Det__c
    private static FINAL Integer CVD_CALC_ORDER_FR_SIGNATURE = ((Integer)investigationApiToConstants.get('CVD_Calc_Order_FR_Sig').Number_Value__c);//Calculated_Order_FR_Signature__c
    private static FINAL Integer CVD_CALC_ITC_FINAL_FR_PUBLISHED = ((Integer)investigationApiToConstants.get('CVD_Calc_ITC_Final_FR_Published').Number_Value__c);//Calculated_ITC_Final_FR_Published__c
    private static FINAL Integer CVD_EST_ORDER_FR_PUBLISHED = ((Integer)investigationApiToConstants.get('CVD_Est_Order_FR_Published').Number_Value__c);//Estimated_Order_FR_Published__c

    //FINAL Status Offsets
    private static FINAL Integer NAFTA_COUNTRY_HOLD = ((Integer)investigationApiToConstants.get('Inv_Hold_Status_NAFTA').Number_Value__c);//Litigation_Hold_Expiration_Date__c
    private static FINAL Integer NON_NAFTA_COUNTRY_HOLD = ((Integer)investigationApiToConstants.get('Inv_Hold_Status_Non_NAFTA').Number_Value__c);//Litigation_Hold_Expiration_Date__c
*/    
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Investigation__c> newList, List<Investigation__c> oldList, Map<Id, Investigation__c> newMap, 
        Map<Id, Investigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            initialize(newList, newMap);
            setRecordType(newList);
            syncToInvestigation(newList);
        	calculateInvestigationDates(newList);
            calculateInvestigationStatuses(newList);
            runValidations(newList);
        }
        if (isBefore && isUpdate) {
            initialize(newList, newMap);
            syncToInvestigation(newList);
            calculateInvestigationDates(newList);
            calculateInvestigationStatuses(newList);
            runValidations(newList);
        }
        if (isAfter && isUpdate) {
            initialize(newList, newMap);
            recalculateCVDinvestigations(newMap);
//            recalculateIssues(newMap, oldMap);
        }
        if (isAfter && isInsert) {
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(newList);
        }
    }
    
    /****************************************
    * Class Level Variables
    ****************************************/

    @TestVisible private static Map<Id,Petition__c> petitionsInScopeMap = new Map<Id,Petition__c>();
    @TestVisible private static Set<Id> unfinishedPetitions = new Set<Id>();
    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    @TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    @TestVisible private static Map<Id,List<Litigation__c>> investigationIdToLitigationMap = new Map<Id,List<Litigation__c>>();
    @TestVisible private static Map<Id,String> investigationIdToLitigationStatusMap = new Map<Id,String>();


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Investigation__c> newList, Map<Id,Investigation__c> newMap) {
        petitionsInScopeMap = findPetitionsInScopeMap(newList);
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(newList[0]);
        if (newMap != null) {
            ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(newMap.values());//pass newMap to only get Investigations with an Id
            frUtilMap = listInstance.utilMap;
            setInvestigationIdToLitigationMap(newMap.keySet());
            setInvestigationIdToLitigationStatusMap();

        }
    }
    private static void setRecordType(List<Investigation__c> newList) {
        for (Investigation__c i: newList) {
            if (petitionsInScopeMap.get(i.Petition__c) != null) {
                String petitionType = petitionsInScopeMap.get(i.Petition__c).Case_Type__c;    
                if (petitionType.contains('CVD')) {
                    i.RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, 'CVD');
                } else if (petitionType.contains('AD')) {
                    i.RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, 'AD');
                }
            }
        }
    }
    //Syncs petition fields to investigation fields and AD to CVD if aligned
    @TestVisible private static void syncToInvestigation(List<Investigation__c> newList) {
            SyncUtility.syncObject(newList, null, true);
    }
    //Primary calculation method for Trigger Handler
    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList) {
        Boolean completePetition = false;
        List<Investigation__c> adInvList = new List<Investigation__c>();
        List<Investigation__c> cvdInvList = new List<Investigation__c>();
    	for (Investigation__c i : newList) {
            completePetition = findCompletePetition(i);
            if (completePetition) {
                if (recordTypeNameMap.get(i.RecordTypeId) == ADRECORD) {
                    adInvList.add(i);
                } else if (recordTypeNameMap.get(i.RecordTypeId) == CVDRECORD) {
                    cvdInvList.add(i);
                }
            }
        }
        DateCalculationService adDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance(ADRECORD);
        adDcs.getCalculatedDates(adInvList, 'Investigation__c', ADRECORD);
        DateCalculationService cvdDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance(CVDRECORD);
        cvdDcs.getCalculatedDates(cvdInvList, 'Investigation__c', CVDRECORD);
    }

    /**
     * Primary method to call all status calculations.
     * @param  newList List of Investigations in scope
     * @return         void
     */
    @TestVisible private static void calculateInvestigationStatuses(List<Investigation__c> newList) {
        setLitigationStatus(newList);
        setStatus(newList);
    }

    @TestVisible private static void runValidations(List<Investigation__c> newList) {
        for (Investigation__c i : newList) {
            validateITCNegativePrelim(i);
            validateITCNegativeFinal(i);
            validateOrder(i);
        }
    }

    //returns a list of CVD Investigations to update if the aligned AD Investigation is updated
    @TestVisible private static void recalculateCVDinvestigations(Map<Id,Investigation__c> newMap) {
        List<Investigation__c> cvdInvestigations = [SELECT Id FROM Investigation__c WHERE AD_Investigation_Aligned_To__c IN: newMap.keySet()];
        update cvdInvestigations;
    }

    /***********************************
    * Helper Methods
    ***********************************/

    //returns a set of Petition Ids in scope of the Investigations in trigger
    @TestVisible private static Set<Id> findIdsInScope(List<Investigation__c> newList) {
    	Set<Id> petitionIdSet = new Set<Id>();
    	for (Investigation__c i : newList) {
    		petitionIdSet.add(i.Petition__c);
    	}
    	return petitionIdSet;
    }
    //returns a map of the Petition__c objects in the form: key = Id, value = Investigation object
    //This pulls the petition fields needed via the Petition lookup field and adds them to the map
    @TestVisible private static Map<Id,Petition__c> findPetitionsInScopeMap(List<Investigation__c> newList) {
    	Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
    	Set<Id> petitionIdSet = findIdsInScope(newList);
    	for (Petition__c p : [SELECT Id, Petition_Filed__c, Initiation_Extension_of_days__c, Actual_Initiation_Signature__c, 
    									Calculated_Initiation_Signature__c, Case_Type__c
    								FROM Petition__c WHERE Id IN: petitionIdSet]) {
    		returnMap.put(p.Id, p);
            if (p.Actual_Initiation_Signature__c == null && p.Calculated_Initiation_Signature__c == null) {
                unfinishedPetitions.add(p.Id);
            }
    	}
    	return returnMap;
    }
    //returns a map of <String,Integer> in the form: key = CMT Api name, CMT number value
    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> setInvestigationApiToConstants() {
        if (investigationApiToConstants == null || investigationApiToConstants.size() < 1) {
            Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
            for (Constant__mdt ic : [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, String_Value__c, 
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c, 
                                                    Litigation_Calculation_Offset__c  
                                            FROM Constant__mdt 
                                            WHERE Investigation_Calculation_Offset__c =: true]) {
                if (ic.Used_with_Field_Named__c == 'Investigation_Outcome__c') {
                    outcomesThatTermInvestigations.add(ic.String_Value__c);
                }
                if (ic.Used_with_Field_Named__c == 'Status__c' && ic.Litigation_Calculation_Offset__c && ic.String_Value__c != null) {
                    activeLitigationStatuses.add(ic.String_Value__c);
                }
                returnMap.put(ic.QualifiedAPIName, ic);
            }
            return returnMap;
        } else {
            return investigationApiToConstants;
        }
    }

    /**
     * Sets map of Investigation Ids in scope to all of their Litigations.
     * @param  petitionIdSet [description]
     * @return            [description]
     */
    @TestVisible private static void setInvestigationIdToLitigationMap(Set<Id> investigationIdSet) {
        for (Litigation__c l : [SELECT Id, Investigation__c, Status__c FROM Litigation__c WHERE Investigation__c IN: investigationIdSet]) {
            List<Litigation__c> tempList = new List<Litigation__c>();
            if (investigationIdToLitigationMap.get(l.Investigation__c) != null) {
                tempList = investigationIdToLitigationMap.get(l.Investigation__c);
            }
            tempList.add(l);
            investigationIdToLitigationMap.put(l.Investigation__c, tempList);
        }
    }

    @TestVisible private static void setInvestigationIdToLitigationStatusMap() {
        if (investigationIdToLitigationMap != null && !investigationIdToLitigationMap.isEmpty()) {
            for (Id invId : investigationIdToLitigationMap.keySet()) {
                for (Litigation__c l : investigationIdToLitigationMap.get(invId)) {
                    if (investigationIdToLitigationStatusMap.get(invId) == null || !activeLitigationStatuses.contains(investigationIdToLitigationStatusMap.get(invId))) {
                        investigationIdToLitigationStatusMap.put(invId, l.Status__c);
                    }
                }
            }
        }
    }
    

    /**************************************
    * Date Calculations
    ***************************************/

    //checks that the petition has the values to proceed...this avoids NPEs on Petitions without dates to start calculations
    //This could need to be updated for self-initiated Investigations if self-initiation is not added at the Petition
    @TestVisible private static Boolean findCompletePetition(Investigation__c i) {
        Boolean returnBoolean = false;
        Petition__c p = petitionsInScopeMap.get(i.Petition__c);
        if (!unfinishedPetitions.contains(p.Id)) {
            returnBoolean = true;
        }
        return returnBoolean;
    }

    /*****************************
    * Validations
    *****************************/

    @TestVisible private static void validateITCNegativePrelim(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'ITC Negative Prelim') {return;}
        Date itcPrelim = null;
        if(i.Id != null && frUtilMap != null) {
            itcPrelim = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).itcPreliminaryPublishedDate : null;
        }
        if (itcPrelim == null) {
            i.addError('You must enter a ITC Preliminary Federal Register to set Investigation Outcome to "ITC Negative Prelim".');
        }
    }

    @TestVisible private static void validateITCNegativeFinal(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'ITC Negative Final') {return;}
        Date itcFinal = null;
        if(i.Id != null && frUtilMap != null) {
            itcFinal = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).itcFinalPublishedDate : null;
        }
        if (itcFinal == null) {
            i.addError('You must enter a ITC Final Federal Register to set Investigation Outcome to "ITC Negative Final".');
        }
    }

    @TestVisible private static void validateOrder(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'Order') {return;}
        Date orderFR = null;
        if(i.Id != null && frUtilMap != null) {
            orderFR = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).orderPublishedDate : null;
        }
        if (orderFR == null) {
            i.addError('You must create an ADCVD Order for this Investigation and add an Order Federal Register to it to set Investigation Outcome to "Order".');
        }
    }

    /*****************************
    * Status Calculations
    *****************************/

    @TestVisible private static void setLitigationStatus(List<Investigation__c> newList) {
        for (Investigation__c i : newList) {
            if (i.Id != null && investigationIdToLitigationMap.get(i.Id) != null && activeLitigationStatuses.contains(investigationIdToLitigationStatusMap.get(i.Id))) {
                i.Litigation_Status__c = 'Active';
            } else {
                i.Litigation_Status__c = 'Inactive';
            }
        }
    }

    @TestVisible private static void setStatus(List<Investigation__c> newList) {
        for (Investigation__c i : newList) {
            setSuspendedStatus(i);
            if (i.Investigation_Outcome__c != 'Suspension Agreement') {
                setPrelimStatus(i);
                setAmendedPrelimStatus(i);
                setFinalStatus(i);
                setPendingOrderStatus(i);
                setHoldStatus(i);
                setLitigationStatus(i);
                setCustomsStatus(i);
                setClosedStatus(i);
            }
        }
    }

    @TestVisible private static void setSuspendedStatus(Investigation__c i) {
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (i.Investigation_Outcome__c == 'Suspension Agreement') {
                i.Status__c = 'Suspended';
            }
        }
    }

    @TestVisible private static void setPrelimStatus(Investigation__c i) {
        Date prelimPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).preliminaryPublishedDate : null;
        }
        if (i.AD_Investigation_Aligned_To__c == null) {
            if ((i.Actual_Preliminary_Signature__c == null || prelimPublished == null) && !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c)) {
                i.Status__c = 'Prelim';
            }
        }
    }

    @TestVisible private static void setAmendedPrelimStatus(Investigation__c i) {
        Date prelimPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).preliminaryPublishedDate : null;
        }
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (prelimPublished != null && 
                i.Actual_Preliminary_Signature__c != null &&
                i.Amend_the_Preliminary_Determination__c == 'Yes' && 
                i.Actual_Amended_Prelim_Determination_Sig__c == null && 
                !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c)) {
                i.Status__c = 'Amend Prelim';
            }
        }  
    }

    @TestVisible private static void setFinalStatus(Investigation__c i) {
        Date prelimPublished = null;
        Date finalPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).preliminaryPublishedDate : null;
            finalPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).finalPublishedDate : null;
        }
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (i.Actual_Preliminary_Signature__c != null &&
                prelimPublished != null &&
                (finalPublished == null || i.Actual_Final_Signature__c == null) 
                && !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c) &&
                (i.Amend_the_Preliminary_Determination__c != 'Yes' || i.Actual_Amended_Prelim_Determination_Sig__c != null)) {
                i.Status__c = 'Final';
            }
        }
    }

    @TestVisible private static void setPendingOrderStatus(Investigation__c i) {
        Date prelimPublished = null;
        Date finalPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).preliminaryPublishedDate : null;
            finalPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).finalPublishedDate : null;
        }
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (prelimPublished != null &&
                finalPublished != null &&
                i.Actual_Preliminary_Signature__c != null &&
                i.Actual_Final_Signature__c != null &&
                i.Investigation_Outcome__c == null) {
                i.Status__c = 'Pending Order';
            }
            if ((i.Actual_Preliminary_Signature__c == null 
                || i.Actual_Final_Signature__c == null
                || prelimPublished == null
                || finalPublished == null)
                && i.Investigation_Outcome__c == 'Order') {
                i.addError('Preliminary and final actual signatures and Federal Registers are required to set Investigation Outcome to Order.');
            }
        }
    }

    @TestVisible private static void setHoldStatus(Investigation__c i) {
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (i.Litigation_Hold_Expiration_Date__c != null && i.Litigation_YesNo__c == null) {
                i.Status__c = 'Hold';
            }
        }
    }

    @TestVisible private static void setLitigationStatus(Investigation__c i) {
        if (i.AD_Investigation_Aligned_To__c == null) {
            if (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'No' && i.Investigation_Outcome__c != null) {
                i.Status__c = 'Litigation';
            }
        }
    }

    @TestVisible private static void setCustomsStatus(Investigation__c i) {
        if (i.AD_Investigation_Aligned_To__c == null) {
            if ((i.Litigation_YesNo__c == 'No' || (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'Yes')) && 
                i.Have_Custom_Instruction_been_sent__c != 'Yes') { 
                i.Status__c = 'Customs';
            }
        }
    }

    @TestVisible private static void setClosedStatus(Investigation__c i) {
        if (i.AD_Investigation_Aligned_To__c == null) {
            if ((i.Litigation_YesNo__c == 'No' || (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'Yes')) && 
                i.Have_Custom_Instruction_been_sent__c == 'Yes') { 
                i.Status__c = 'Closed';
            }
        }
    }
}