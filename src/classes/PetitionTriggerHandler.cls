public without sharing class PetitionTriggerHandler {
    public static boolean preventRecursion = false;
    public static void mainEntry(List<Petition__c> newList, List<Petition__c> oldList, Map<Id, Petition__c> newMap, 
        Map<Id, Petition__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isAfter && isInsert) {

        }
        if(isAfter && isUpdate) {
            recalculateInvestigations(newMap);
        }
        if(isBefore && isInsert) {
            rollForwardNextBusinessDay(newList);
            calculatePetitionDates(newList);
        }
        if(isBefore && isUpdate) {
            rollForwardNextBusinessDay(newList);
            calculatePetitionDates(newList);
        }
    }
    @TestVisible private static void calculatePetitionDates(List<Petition__c> newList) {
        for (Petition__c p : newList){
            if((p.Petition_Outcome__c == 'Initiated' || p.Petition_Outcome__c == 'In Progress') && p.Petition_Filed__c != null){
                Integer maximumDays = 40;
                p.Calculated_Initiation_Signature__c = p.Petition_Filed__c.addDays(20);
                if(p.Initiation_Extension_of_days__c != null) {
                    p.Calculated_Initiation_Signature__c = p.Calculated_Initiation_Signature__c.addDays((integer)p.Initiation_Extension_of_days__c);
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
    @TestVisible private static void rollForwardNextBusinessDay(List<Petition__c> newList) {
        for (Petition__c p : newList) {
            if(p.Actual_Initiation_Signature__c != null) {
                ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Actual_Initiation_Signature__c);
            }
        }
    }
    @TestVisible private static void recalculateInvestigations(Map<Id,Petition__c> newMap) {
        List<Investigation__c> investigations = [SELECT Id FROM Investigation__c WHERE Petition__c IN: newMap.keySet()];
        update investigations;
    }
}