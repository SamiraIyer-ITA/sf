public without sharing class PetitionTriggerHandler {

    private static Map<String,Constant__mdt> petitionConstants = setPetitionConstants();

    //FINAL AD Record Type Offsets
    private static FINAL Integer CALC_INIT_SIG = ((Integer)petitionConstants.get('Petition_Calc_Initiation_Sig').Number_Value__c);//Calculated_Initiation_Signature__c

    public static boolean preventRecursion = false;
    public static void mainEntry(List<Petition__c> newList, List<Petition__c> oldList, Map<Id, Petition__c> newMap, 
        Map<Id, Petition__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isBefore && isInsert) {
            alertsOnDates(newList);
            calculatePetitionDates(newList);
        }
        if(isBefore && isUpdate) {
            alertsOnDates(newList);
            calculatePetitionDates(newList);
        }
        if(isAfter && isInsert) {
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(newList);
        }
        if(isAfter && isUpdate) {
            recalculateInvestigations(newMap);
            recalculateIssues(newMap, oldMap);
        }
    }


    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    /**
     * Primary method to call all date calculations.
     * @param  newList List of Petitions in scope
     * @return         void
     */
    @TestVisible private static void calculatePetitionDates(List<Petition__c> newList) {
        for (Petition__c p : newList){
            setCalculatedInitiationSignature(p);
        }
    }

    @TestVisible private static void alertsOnDates(List<Petition__c> newList) {
        for (Petition__c p : newList) {
            if(p.Actual_Initiation_Signature__c != null && !ADCVD_TollingDayUtility.isWeekday(p.Actual_Initiation_Signature__c)) {
                p.Actual_Initiation_Signature__c.addError('The Actual Initiation Signature date cannot be on a weekend.');
            } else if (p.Actual_Initiation_Signature__c != null && !ADCVD_TollingDayUtility.isWeekday(p.Actual_Initiation_Signature__c)) {
                p.Actual_Initiation_Signature__c.addError('The Actual Initiation Signature date cannot be on a holiday');
            }
        }
    }
    @TestVisible private static void recalculateInvestigations(Map<Id,Petition__c> newMap) {
        List<Investigation__c> investigations = [SELECT Id FROM Investigation__c WHERE Petition__c IN: newMap.keySet()];
        update investigations;
    }
    @TestVisible private static void recalculateIssues(Map<Id,Petition__c> newMap, Map<Id,Petition__c> oldMap) {
        Set<Id> parentIds = getIssueParentIds(newMap, oldMap);
        List<Issue__c> issuesToUpdate = new List<Issue__c>();

        for (Issue__c i : [SELECT Id, Type__c, Issues_to_DAS__c, Concurrence_to_DAS__c FROM Issue__c WHERE Petition__c IN: parentIds]) {
            issuesToUpdate.add(i);
        }
        if (!issuesToUpdate.isEmpty()) update issuesToUpdate;
    }


    /***********************************
    * Helper Methods
    ***********************************/

    //used to set Offset Variables
    @TestVisible private static Map<String,Constant__mdt> setPetitionConstants() {
        if(petitionConstants == null || petitionConstants.size() < 1) {
            Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
            List<Constant__mdt> tempList = [SELECT QualifiedAPIName, Used_with_Field_Named__c, Number_Value__c, 
                                                    ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c 
                                            FROM Constant__mdt 
                                            WHERE Petition_Calculation_Offset__c =: true];
            for(Constant__mdt ic : tempList) {
                returnMap.put(ic.QualifiedAPIName, ic);
            }
            return returnMap;
        } else {
            return petitionConstants;
        }
    }

    @TestVisible private static Set<Id> getIssueParentIds(Map<Id,Petition__c> newMap, Map<Id,Petition__c> oldMap) {
        Set<Id> returnIdSet = new Set<Id>();
        for (Petition__c p : newMap.values()) {
            if (oldMap.get(p.Id) == null) {
                returnIdSet.add(p.Id);
            } else if (oldMap.get(p.Id) != null && oldMap.get(p.Id).Calculated_Initiation_Signature__c != p.Calculated_Initiation_Signature__c) {
                returnIdSet.add(p.Id);
            }
        }
        return returnIdSet;
    }


    /********************************
    * Date Calculations
    ********************************/

    @TestVisible private static void setCalculatedInitiationSignature(Petition__c p) {
        if((p.Petition_Outcome__c == 'Initiated' || p.Petition_Outcome__c == 'In Progress') && p.Petition_Filed__c != null){
            Integer maximumDays = 40;
            p.Calculated_Initiation_Signature__c = p.Petition_Filed__c.addDays(CALC_INIT_SIG);
            if(p.Initiation_Extension_of_days__c != null) {
                p.Calculated_Initiation_Signature__c = p.Calculated_Initiation_Signature__c.addDays((Integer)p.Initiation_Extension_of_days__c);
            }
            //roll back if more than 40 days or more between petition filed and calculated date, otherwise rollforward;
            boolean rollForward = true;
/*                
            if(p.Petition_Filed__c.daysBetween(p.Calculated_Initiation_Signature__c) >= (maximumDays - 1)) {
                rollForward = false;
             } else if (ADCVD_TollingDayUtility.dayOfWeek(p.Calculated_Initiation_Signature__c) == 'Sat' && p.Petition_Filed__c.daysBetween(p.Calculated_Initiation_Signature__c) >= (maximumDays - 2)) {
                rollforward = false;
            }
*/
            p.Calculated_Initiation_Signature__c = ADCVD_TollingDayUtility.getCalculatedDate(p.Petition_Filed__c, p.Calculated_Initiation_Signature__c, rollforward);
        }
    }
}