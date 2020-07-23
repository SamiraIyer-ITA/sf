/**
 * Created by Patrick Childers on 6/26/2020.
 */

public with sharing class CallAddTollingDayBatch {

    @TestVisible private static String initialState = '1';
    @TestVisible private static String queryObject = 'Petition__c';
    @TestVisible private static Id batchProcessId;
    @TestVisible private static ADCVD_TollingDayMapper tollingMapper = new ADCVD_TollingDayMapper().getInstance();
    @TestVisible private static List<Tolling_Day__c> tollingDayList {
        get {
            return tollingMapper.getMap(true).values();
        }
    }

    @InvocableMethod (Label = 'Add Tolling Day Batch Invocable Method')
    public static void callBatch(){
        batchProcessId = Database.executeBatch(new AddTollingDayBatch(initialState, queryObject, setLastDate()));
        System.debug('Returned batch process ID: ' + batchProcessId);
    }

    @TestVisible private static String setLastDate(){
        Date latestDate = null;
        Date maxLatestDate = Date.parse('01/02/2001');
        for(Tolling_Day__c td: tollingDayList) {

            if(latestDate == null || latestDate < td.End_Date__c) {
                latestDate = td.End_Date__c;
            }
            if(maxLatestDate < latestDate) maxLatestDate = latestDate;

        }
        System.debug('maxLatestDate = ' + maxLatestDate);
        return String.valueOf(maxLatestDate);
    }

    public class RequestVariables {

    }
}