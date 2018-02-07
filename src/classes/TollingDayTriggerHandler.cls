/**
 * 
 *    Created by Tim Barsotti
 *    on Feb 6 2017
 *    MIL Corporation
 * 
 *    Updated by Joshua Moody
 *    Updated by Cal Smith
 * 
 **/

public without sharing class TollingDayTriggerHandler {

    /***********************************************************
   * This class handles all trigger contexts for the Tolling_Day__c
   * object.  It provides methods that:
   * 1. Organize the flow of logic for each trigger context
   * 2. Initialize class variables
   * 3. Call batch service classes to update the records in scope
   ***********************************************************/

    public static boolean preventRecursion = false;
    public static void mainEntry(List<Tolling_Day__c> newList, List<Tolling_Day__c> oldList, Map<Id, Tolling_Day__c> newMap, 
        Map<Id, Tolling_Day__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        
        if (!AppConfigService.triggerEnabled) {return;}

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
    @TestVisible private static Date maxLatestDate = date.parse('01/02/2001');
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
            if(maxLatestDate < latestDate) maxLatestDate=latestDate;
            
        }
        system.debug('maxLatestDate = ' + maxLatestDate);
    }

    @TestVisible private static void recalculatePetitionTollingDay(List<Tolling_Day__c> tdList) {
        setDatesInScope(tdList);
        string initialState = '1';
        string queryObject = 'Petition__c';   
        string lastDate = string.valueOf(maxLatestDate);
        system.debug('lastDate = ' + lastDate);
        ID batchprocessid = Database.executeBatch(new AddTollingDayBatch(initialState, queryObject, lastDate));
        system.debug('Returned batch process ID: ' + batchProcessId);        
    }

}