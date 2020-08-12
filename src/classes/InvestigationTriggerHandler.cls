/**
 * 
 *    Created by Joshua Moody
 *    on Feb 15 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class InvestigationTriggerHandler {
    
    /***********************************************************
   * This class handles all trigger contexts for the Investigation__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Call services classes to do date calculations
   * 5. Retrieve constant values saved in custom metadata
   * 6. Performs status calculations
   * 7. Performs custom validations not possible with validation rules
   ***********************************************************/ 
	
    @TestVisible private static Set<String> outcomesThatTermInvestigations = new Set<String>();
    @TestVisible private static Set<String> activeLitigationStatuses = new Set<String>();
    private static Map<String,Constant__mdt> investigationApiToConstants = setInvestigationApiToConstants();

	//FINAL Investigation Record Type Developer Names
	private static FINAL String ADRECORD = 'AD';//investigationApiToConstants.get('AD_Calc_Final_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String CVDRECORD = 'CVD';//investigationApiToConstants.get('CVD_Calc_Final_Sig').ADCVD_Objects__r.Record_Type_Name__c;
	private static FINAL String INVESTIGATION = 'Investigation__c';//investigationApiToConstants.get('AD_Calc_Final_Sig').ADCVD_Objects__r.Object_API_Name__c;

    public static void mainEntry(List<Investigation__c> newList, List<Investigation__c> oldList, Map<Id, Investigation__c> newMap, 
        Map<Id, Investigation__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter) {
        
        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            setRecordType(newList);
            setCaseValues(newList);
            syncToInvestigation(newList);
        	calculateInvestigationDates(newList);
            calculateInvestigationStatuses(newList);
            runValidations(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            syncToInvestigation(newList);
            calculateInvestigationDates(newList);
            calculateInvestigationStatuses(newList);
            runValidations(newList);
        }
        if (isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            new StaffingAssignmentService().createStaffFromDefaults(newList, 'Investigation__c');
        }
        if (isAfter && isUpdate) {
            initialize(newList, newMap);
            recalculateCVDinvestigations(newMap, oldMap);
            new ChatterPostWriter(INVESTIGATION, newMap, oldMap);
        }
    }
    
    /****************************************
    * Class Level Variables
    ****************************************/

    @TestVisible private static Map<Id,Petition__c> petitionsInScopeMap = new Map<Id,Petition__c>();
    //@TestVisible private static Set<Id> unfinishedPetitions = new Set<Id>();
    @TestVisible private static Map<Id,String> recordTypeNameMap = new Map<Id,String>();
    //@TestVisible private static Map<Id,ADCVD_FederalRegisterUtility> frUtilMap = new Map<Id,ADCVD_FederalRegisterUtility>();
    @TestVisible private static Map<Id,List<Litigation__c>> investigationIdToLitigationMap = new Map<Id,List<Litigation__c>>();
    @TestVisible private static Map<Id,String> investigationIdToLitigationStatusMap = new Map<Id,String>();
    @TestVisible private static Map<Id, FederalRegisterMapper.MappedFRs> frUtilMap = new Map<Id, FederalRegisterMapper.MappedFRs>();
    @TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
    @TestVisible private static InvestigationMapper invMapper;
    @TestVisible private static FederalRegisterMapper frMapper;

    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Investigation__c> newList, Map<Id,Investigation__c> newMap) {
        Set<Id> caseIdSet = getCaseIdSet(newList);
        caseMapper = caseMapper.getInstance(caseIdSet);
        recordTypeNameMap = utils.getRecordTypeDeveloperNameMap(INVESTIGATION);
        PetitionMapper ps = (PetitionMapper) caseMapper.getMapper('Petition__c').getInstance();
        petitionsInScopeMap = (Map<Id,Petition__c>) caseMapper.getMapper('Petition__c').getInstance().getMap(true);// findPetitionsInScopeMap(newList);
        
        if (newMap != null) {
            addNewInvToMappers(newMap);
            frMapper = (FederalRegisterMapper) caseMapper.getMapper('Federal_Register__c').getInstance();
            frUtilMap = frMapper.getMappedFRs(newMap.keySet(), caseMapper);
            setInvestigationIdToLitigationMap(newMap.keySet());
            setInvestigationIdToLitigationStatusMap();

        }
    }
    private static void setRecordType(List<Investigation__c> newList) {
        for (Investigation__c i: newList) {
            if (petitionsInScopeMap.get(i.Petition__c) != null) {
                String petitionType = petitionsInScopeMap.get(i.Petition__c).ADCVD_Case_Type_Text__c;    
                if (petitionType.contains(CVDRECORD)) {
                    i.RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, CVDRECORD);
                } else if (petitionType.contains(ADRECORD)) {
                    i.RecordTypeId = MetadataHelper.getRecordTypeIdByName(INVESTIGATION, ADRECORD);
                }
            }
        }
    }
    @TestVisible private static Set<Id> getCaseIdSet (List<Investigation__c> newList) {
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> petitionIdSet = new Set<Id>();
        for (Investigation__c i : newList) {
            petitionIdSet.add(i.Petition__c);
        }
        for (Petition__c p : [SELECT ADCVD_Case__c FROM Petition__c WHERE Id IN: petitionIdSet]) {
            caseIdSet.add(p.ADCVD_Case__c);
        }
        return caseIdSet;
    }
    @TestVisible private static void setCaseValues(List<Investigation__c> newList) {
        ParentValuesService pvs = new ParentValuesService();
        for (Investigation__c i : newList) {
            i = (Investigation__c) pvs.setCaseValuesFromParent(petitionsInScopeMap.get(i.Petition__c), i);
        }
    }
    @TestVisible private static void addNewInvToMappers(Map<Id,Investigation__c> newMap) {
        Map<Id,List<Investigation__c>> caseToInvMap = new Map<Id,List<Investigation__c>>();
        invMapper = (InvestigationMapper) caseMapper.getMapper('Investigation__c').getInstance();
        for (Investigation__c i : newMap.values()) {
            invMapper.addInvToMap(i);
            List<Investigation__c> tempList = caseToInvMap.get(i.ADCVD_Case__c) != null ?
                                                   caseToInvMap.get(i.ADCVD_Case__c) : new List<Investigation__c>();
            tempList.add(i);
            caseToInvMap.put(i.ADCVD_Case__c, tempList);
        }
        for (Id caseId : caseToInvMap.keySet()) {
            caseMapper.setCaseIdToInvestigationMap(caseId, caseToInvMap.get(caseId));
        }
    }
    //Syncs petition fields to investigation fields and AD to CVD if aligned
    @TestVisible private static void syncToInvestigation(List<Investigation__c> newList) {
        if (!newList.isEmpty()) {SyncUtility.syncObject(newList, null, true);}
    }
    //Primary calculation method for Trigger Handler
    @TestVisible private static void calculateInvestigationDates(List<Investigation__c> newList) {
        Map<String,List<Investigation__c>> recordTypeNameToInvestigationListMap = new Map<String,List<Investigation__c>>();
        for (Investigation__c i : newList) {
            if (recordTypeNameToInvestigationListMap.get(recordTypeNameMap.get(i.RecordTypeId)) != null) {//} && findCompletePetition(i)) {
                recordTypeNameToInvestigationListMap.get(recordTypeNameMap.get(i.RecordTypeId)).add(i);
            } else {// if (findCompletePetition(i)) {
                recordTypeNameToInvestigationListMap.put(recordTypeNameMap.get(i.RecordTypeId), new List<Investigation__c>{i});
            }
        }
        for (String recordTypeName : recordTypeNameToInvestigationListMap.keySet()) {
            DateCalculationService dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance(recordTypeName);
            dcs.getCalculatedDates(recordTypeNameToInvestigationListMap.get(recordTypeName), INVESTIGATION, recordTypeName);
        }
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
    @TestVisible private static void recalculateCVDinvestigations(Map<Id,Investigation__c> newMap, Map<Id,Investigation__c> oldMap) {
        Map<Id,Investigation__c> cvdInvestigations = new Map<Id,Investigation__c>();
        Set<Id> querySet = new Set<Id>();
        Id ADRecordType = Schema.SObjectType.Investigation__c.getRecordTypeInfosByDeveloperName().get('AD').getRecordTypeId();
        for (Investigation__c i : newMap.values()) {
            if (i.RecordTypeId == ADRecordType){
                querySet.add(i.Id);
            }
        }
        cvdInvestigations.putAll(InvestigationSelector.newInstance().selectByIdWithRelations(querySet));
        if(!cvdInvestigations.isEmpty() && !System.isBatch()){
            updateCVDinvestigations(cvdInvestigations.keySet());
            }
        }

     @Future
     @TestVisible public static void updateCVDinvestigations(Set<Id> cvdIdSet) {
         List <Investigation__c> updateCVDInvestigations = new List<Investigation__c> (InvestigationSelector.newInstance().selectById(cvdIdSet));
         update updateCVDInvestigations;
    }

    /***********************************
    * Helper Methods
    ***********************************/

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

    /*****************************
    * Validations
    *****************************/

    @TestVisible private static void validateITCNegativePrelim(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'ITC Negative Prelim') {return;}
        Date itcPrelim = null;
        if(i.Id != null && frUtilMap != null) {
            itcPrelim = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('ITC Preliminary') : null;
        }
        if (itcPrelim == null) {
            i.addError('You must enter a ITC Preliminary Federal Register to set Investigation Outcome to "ITC Negative Prelim".');
        }
    }

    @TestVisible private static void validateITCNegativeFinal(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'ITC Negative Final') {return;}
        Date itcFinal = null;
        if(i.Id != null && frUtilMap != null) {
            itcFinal = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('ITC Final') : null;
        }
        if (itcFinal == null) {
            i.addError('You must enter a ITC Final Federal Register to set Investigation Outcome to "ITC Negative Final".');
        }
    }

    @TestVisible private static void validateOrder(Investigation__c i) {
        if (i.Investigation_Outcome__c != 'Order') {return;}
        Date orderFR = null;
        if(i.Id != null && frUtilMap != null) {
            orderFR = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Order') : null;
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
        if (i.Investigation_Outcome__c == 'Suspension Agreement') {
            i.Status__c = 'Suspended';
        }
    }

    @TestVisible private static void setPrelimStatus(Investigation__c i) {
        Date prelimPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Preliminary') : null;
        }
        if ((i.Actual_Preliminary_Signature__c == null || prelimPublished == null) && !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c)) {
            i.Status__c = 'Prelim';
        }
    }

    @TestVisible private static void setAmendedPrelimStatus(Investigation__c i) {
        Date prelimPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Preliminary') : null;
        }
        if (prelimPublished != null &&
            i.Actual_Preliminary_Signature__c != null &&
            i.Amend_the_Preliminary_Determination__c == 'Yes' &&
            i.Actual_Amended_Prelim_Determination_Sig__c == null &&
            !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c)) {
            i.Status__c = 'Amend Prelim';
        }
    }

    @TestVisible private static void setFinalStatus(Investigation__c i) {
        Date prelimPublished = null;
        Date finalPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Preliminary') : null;
            finalPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Final') : null;
        }
        if (i.Actual_Preliminary_Signature__c != null &&
            prelimPublished != null &&
            (finalPublished == null || i.Actual_Final_Signature__c == null)
            && !outcomesThatTermInvestigations.contains(i.Investigation_Outcome__c) &&
            (i.Amend_the_Preliminary_Determination__c != 'Yes' || i.Actual_Amended_Prelim_Determination_Sig__c != null)) {
            i.Status__c = 'Final';
        }
    }

    @TestVisible private static void setPendingOrderStatus(Investigation__c i) {
        Date prelimPublished = null;
        Date finalPublished = null;
        if (i.Id != null && frUtilMap != null) {
            prelimPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Preliminary') : null;
            finalPublished = frUtilMap.get(i.Id) != null ? frUtilMap.get(i.Id).typeToPublishedDateMap.get('Final') : null;
        }
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

    @TestVisible private static void setHoldStatus(Investigation__c i) {
        if (i.Litigation_Hold_Expiration_Date__c != null && i.Litigation_YesNo__c == null) {
            i.Status__c = 'Hold';
        }
    }

    @TestVisible private static void setLitigationStatus(Investigation__c i) {
        if (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'No' && i.Investigation_Outcome__c != null) {
            i.Status__c = 'Litigation';
        }
    }

    @TestVisible private static void setCustomsStatus(Investigation__c i) {
        if ((i.Litigation_YesNo__c == 'No' || (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'Yes')) &&
            i.Have_Custom_Instruction_been_sent__c != 'Yes' && i.Investigation_Outcome__c != null) {
            i.Status__c = 'Customs';
        }
    }

    @TestVisible private static void setClosedStatus(Investigation__c i) {
        if ((i.Litigation_YesNo__c == 'No' || (i.Litigation_YesNo__c == 'Yes' && i.Litigation_Resolved__c == 'Yes')) &&
            i.Have_Custom_Instruction_been_sent__c == 'Yes' && i.Investigation_Outcome__c != null) {
            i.Status__c = 'Closed';
        }
    }
}