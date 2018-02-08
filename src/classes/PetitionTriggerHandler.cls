/**
 * 
 *    Created by Tim Barsotti
 *    on Feb 10 2017
 *    MIL Corporation
 *
 *    Updated by Joshua Moody
 *    
 **/

public without sharing class PetitionTriggerHandler {

    /***********************************************************
   * This class handles all trigger contexts for the Petition__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Help in the mapping of related objects
   * 4. Call services classes to do date calculations
   * 5. Retrieve constant values saved in custom metadata
   * 6. Performs status calculations
   * 7. Performs custom validations not possible with validation rules
   * 8. Calls service classes to create Staffing Assignments and Chatter Posts
   ***********************************************************/

    @TestVisible private static Set<String> outcomesThatStartCalculations = new Set<String>();
    @TestVisible private static Set<String> activeLitigationStatuses = new Set<String>();
    @TestVisible private static Map<String,Constant__mdt> petitionConstants = setPetitionConstants();

    //FINAL AD Record Type Offsets
    private static FINAL Integer CALC_INIT_SIG = ((Integer)petitionConstants.get('Petition_Calc_Initiation_Sig').Number_Value__c);//Calculated_Initiation_Signature__c

    public static boolean preventRecursion = false;
    public static void mainEntry(List<Petition__c> newList, List<Petition__c> oldList, Map<Id, Petition__c> newMap, 
        Map<Id, Petition__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        
        if (!AppConfigService.triggerEnabled) {return;}


        if(isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            alertsOnDates(newList);
            calculatePetitionDates(newList);
            calculatePetitionStatuses(newList);
        }
        if(isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            initialize(newList, newMap);
            alertsOnDates(newList);
            calculatePetitionDates(newList);
            calculatePetitionStatuses(newList);
        }
        if(isAfter && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(newList);
            
        }
        if(isAfter && isUpdate) {
            recalculateInvestigations(newMap, oldMap);
            new ChatterPostService().getChatterPosts(oldMap, newMap, 'Petition__c');
        }
    }


    /**************************
    * Class Level Variables
    **************************/

    @TestVisible private static Map<Id,List<Litigation__c>> petitionIdToLitigationMap = new Map<Id,List<Litigation__c>>();
    @TestVisible private static Map<Id,String> petitionIdToLitigationStatusMap = new Map<Id,String>();


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    /**
     * Sets class level variables
     * @param  newList new Petitions in scope, available before insert
     * @param  newMap  new Petitions in scope, null before insert
     * @return         [description]
     */
    @TestVisible private static void initialize(List<Petition__c> newList, Map<Id,Petition__c> newMap) {
        if(newMap != null) {
            setPetitionIdToLitigationMap(newMap.keySet());
            setPetitionIdToLitigationStatusMap();
        }
    }

    @TestVisible private static void alertsOnDates(List<Petition__c> newList) {
        for (Petition__c p : newList) {
            if(p.Actual_Initiation_Signature__c != null && !ADCVD_TollingDayUtility.isWeekday(p.Actual_Initiation_Signature__c)) {
                p.Actual_Initiation_Signature__c.addError('The Actual Initiation Signature date cannot be on a weekend.');
            } else if (p.Actual_Initiation_Signature__c != null && ADCVD_TollingDayUtility.isHoliday(p.Actual_Initiation_Signature__c)) {
                p.Actual_Initiation_Signature__c.addError('The Actual Initiation Signature date cannot be on a holiday');
            }
        }
    }

    /**
     * Primary method to call all date calculations.
     * @param  newList List of Petitions in scope
     * @return         void
     */
    @TestVisible private static void calculatePetitionDates(List<Petition__c> newList) {
        DateCalculationService petDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Petition__c');
        petDcs.getCalculatedDates(newList, 'Petition__c', '');
    }

    /**
     * Primary method to call all status calculations.
     * @param  newList List of Petitions in scope
     * @return         void
     */
    @TestVisible private static void calculatePetitionStatuses(List<Petition__c> newList) {
        setLitigationStatus(newList);
        setStatus(newList);
    }

    @TestVisible private static void recalculateInvestigations(Map<Id,Petition__c> newMap, Map<Id,Petition__c> oldMap) {
        Set<Id> querySet = new Set<Id>();
        for (Id i : newMap.keySet()) {
            if (newMap.get(i).Tolling_Update__c == oldMap.get(i).Tolling_Update__c) {
                querySet.add(i);
            }
        }
        List<Investigation__c> investigations = [SELECT Id FROM Investigation__c WHERE Petition__c IN: querySet AND Locked__c =: false];
        update investigations;
    }


    /***********************************
    * Helper Methods
    ***********************************/

    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> setPetitionConstants() {
        if(petitionConstants == null || petitionConstants.size() < 1) {
            Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
            /*List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
                                            FROM Constant__mdt 
                                            WHERE Petition_Calculation_Offset__c =: true];*/
            for(Constant__mdt ic : [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, String_Value__c, 
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c,
                                                    Litigation_Calculation_Offset__c 
                                            FROM Constant__mdt 
                                            WHERE Petition_Calculation_Offset__c =: true]) {
                if (ic.Used_with_Field_Named__c == 'Petition_Outcome__c') {
                    outcomesThatStartCalculations.add(ic.String_Value__c);
                }
                if (ic.Used_with_Field_Named__c == 'Status__c' && ic.Litigation_Calculation_Offset__c && ic.String_Value__c != null) {
                    activeLitigationStatuses.add(ic.String_Value__c);
                }
                returnMap.put(ic.QualifiedAPIName, ic);
            }
            return returnMap;
        } else {
            return petitionConstants;
        }
    }

    /**
     * Sets map of Petition Ids in scope to all of their Litigations.
     * @param  petitionIdSet [description]
     * @return            [description]
     */
    @TestVisible private static void setPetitionIdToLitigationMap(Set<Id> petitionIdSet) {
        for (Litigation__c l : [SELECT Id, Petition__c, Status__c FROM Litigation__c WHERE Petition__c IN: petitionIdSet]) {
            List<Litigation__c> tempList = new List<Litigation__c>();
            if (petitionIdToLitigationMap.get(l.Petition__c) != null) {
                tempList = petitionIdToLitigationMap.get(l.Petition__c);
            }
            tempList.add(l);
            petitionIdToLitigationMap.put(l.Petition__c, tempList);
        }
    }

    @TestVisible private static void setPetitionIdToLitigationStatusMap() {
        if (petitionIdToLitigationMap != null && !petitionIdToLitigationMap.isEmpty()) {
            for (Id petitionId : petitionIdToLitigationMap.keySet()) {
                for (Litigation__c l : petitionIdToLitigationMap.get(petitionId)) {
                    if (petitionIdToLitigationStatusMap.get(petitionId) == null || !activeLitigationStatuses.contains(petitionIdToLitigationStatusMap.get(petitionId))) {
                        petitionIdToLitigationStatusMap.put(petitionId, l.Status__c);
                    }
                }
            }
        }
    }


    /*****************************
    * Status Calculations
    *****************************/

    @TestVisible private static void setLitigationStatus(List<Petition__c> newList) {
        for (Petition__c p : newList) {
            if (p.Id != null && petitionIdToLitigationStatusMap.get(p.Id) != null && activeLitigationStatuses.contains(petitionIdToLitigationStatusMap.get(p.Id))) {
                p.Litigation_Status__c = 'Active';
            } else {
                p.Litigation_Status__c = 'Inactive';
            }
        }
    }

    @TestVisible private static void setStatus(List<Petition__c> newList) {
        for (Petition__c p : newList) {
            setInitialStatus(p);
            setLitigationStatus(p);
            setClosedStatus(p);

        }
    }

    @TestVisible private static void setInitialStatus(Petition__c p) {
        if ((p.Petition_Outcome__c == null || outcomesThatStartCalculations.contains(p.Petition_Outcome__c)) && p.Actual_Initiation_Signature__c == null) {
            p.Status__c = 'In Progress';
        }
    }

    @TestVisible private static void setLitigationStatus(Petition__c p) {
        if (p.Litigation_YesNo__c == 'Yes' && p.Litigation_Resolved__c == 'No' && p.Petition_Outcome__c != null) {
            p.Status__c = 'Litigation';
        }
    }

    @TestVisible private static void setClosedStatus(Petition__c p) {
        if ((p.Litigation_YesNo__c == 'No' || (p.Litigation_YesNo__c == 'Yes' && p.Litigation_Resolved__c == 'Yes')) && //not in Litigation status
            ((outcomesThatStartCalculations.contains(p.Petition_Outcome__c) && p.Petition_Outcome__c != null && p.Actual_Initiation_Signature__c != null) || //initiated with Actual Signature
            (!outcomesThatStartCalculations.contains(p.Petition_Outcome__c) && p.Petition_Outcome__c != null))) { //not initiated
            p.Status__c = 'Closed';
        }
    }
}
