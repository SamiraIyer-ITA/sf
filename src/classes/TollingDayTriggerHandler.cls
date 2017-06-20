public without sharing class TollingDayTriggerHandler {
    public static boolean preventRecursion = false;
    public static void mainEntry(List<Tolling_Day__c> newList, List<Tolling_Day__c> oldList, Map<Id, Tolling_Day__c> newMap, 
        Map<Id, Tolling_Day__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isAfter && isInsert) {
            recalculatePetitionTollingDay(newList);
        }
        if(isAfter && isUpdate) {
            recalculatePetitionTollingDay(newList);
        }
        if(isBefore && isDelete) {
            recalculatePetitionTollingDay(oldList);
        }
    }
    //private static Set<Date> datesInScope = new Set<Date>();
    @TestVisible private static Date earliestDate = null;
    @TestVisible private static Date latestDate = null;
    /* method to build an earliest and latest set of dates in scope */ 
    @TestVisible private static void setDatesInScope(List<Tolling_Day__c> tdList) {
        for(Tolling_Day__c td: tdList) {
            Date loopDate = td.Start_Date__c;
            if(earliestDate == null || earliestDate > td.Start_Date__c) {
                earliestDate = td.Start_Date__c;
            }
            if(latestDate == null || latestDate < td.End_Date__c) {
                latestDate = td.End_Date__c;
            }
        }
    }
    @TestVisible private static Set<Id> findPetitionsInScope(List<Tolling_Day__c> tdList) {
        setDatesInScope(tdList);
        Set<Id> petitionIdSet = new Set<Id>();
        system.debug(latestDate);
        for(Petition__c p: [SELECT Id FROM Petition__c WHERE Petition_Filed__c <=: latestDate AND Petition_Outcome__c =: null]) {
            petitionIdSet.add(p.Id);
        }
        return petitionIdSet;
        
    }
    @TestVisible private static void recalculatePetitionTollingDay(List<Tolling_Day__c> tdList) {
        calculatePetitionsFuture(findPetitionsInScope(tdList));
    }
    @future
    private static void calculatePetitionsFuture(Set<Id> petitionIdSet) {
        List<Petition__c> petitionsToUpdate = [SELECT Id FROM Petition__c WHERE Id IN: petitionIdSet];
        database.update(petitionsToUpdate, false);
    }
}