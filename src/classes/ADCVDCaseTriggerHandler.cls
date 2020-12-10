public without sharing class ADCVDCaseTriggerHandler {
    /******************
    This class handles all trigger contexts for the ADCVD_Case__c object.
    1. For after update it check for changes in the 5 standardized case fields,
    and if there are changes, it schedules the ADCVDStandardCaseFieldsBatch class
    to update all related child records.
     ******************/
    

    public static void mainEntry(List<ADCVD_Case__c> newList, List<ADCVD_Case__c> oldList, Map<Id, ADCVD_Case__c> newMap,
            Map<Id, ADCVD_Case__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete,
            Boolean isBefore, Boolean isAfter) {

        if (!AppConfigService.triggerEnabled) {return;}

        if (isBefore && isInsert) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            updateCaseSearchTextFields(newList);
        }
        if (isBefore && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            updateCaseSearchTextFields(newList);
        }
        if (isAfter && isInsert) {

        }
        if (isAfter && isUpdate) {
            newList = new LockedRecordHandler().removeLockedRecords(newList);
            updateCaseChildren(newList, oldMap);
        }
    }

    /*****************************************
    * Methods called directly by mainEntry()
    *****************************************/

    @TestVisible private static void updateCaseSearchTextFields(List<ADCVD_Case__c> newList){
        //Method update 3 standardized fields on adcvd case, upon creation of case.
        //Case Country Text field, concatenated case field, adcvd case number
        for(ADCVD_Case__c adcvdCase: newList){
            adcvdCase.ADCVD_Case_Number__c = adcvdCase.Name;
            adcvdCase.Case_Concat_Text_Values__c = adcvdCase.Commodity__c+'; '+adcvdCase.Country__c+'; '+adcvdCase.ADCVD_Case_Type__c;
        }
    }

    @TestVisible private static void updateCaseChildren(List<ADCVD_Case__c> newList, Map<Id, ADCVD_Case__c> oldMap){
        List<ADCVD_Case__c> changedCasesList = getChangedCases(newList, oldMap);
        if(!changedCasesList.isEmpty()){
            //If there is a queued batch job, use getRecentlyModifiedCases method to combine the records from that job
            //into the current context, and run one batch for all modified case records
            Boolean queuedBatchJob = checkCron();
            if(queuedBatchJob) changedCasesList = getRecentlyModifiedCases(changedCasesList);
            scheduleBatchJob(changedCasesList);

        }
    }

    @TestVisible private static List<ADCVD_Case__c> getChangedCases(List<ADCVD_Case__c> newList, Map<Id, ADCVD_Case__c> oldMap){
        List<ADCVD_Case__c> changedCasesList = new List<ADCVD_Case__c>();
        for(ADCVD_Case__c adcvdCase: newList){
            if(adcvdCase.ADCVD_Case_Type__c != oldMap.get(adcvdCase.Id).ADCVD_Case_Type__c || adcvdCase.Commodity__c != oldMap.get(adcvdCase.Id).Commodity__c ||
                    adcvdCase.Country__c != oldMap.get(adcvdCase.Id).Country__c || adcvdCase.Product__c != oldMap.get(adcvdCase.Id).Product__c ||
                    adcvdCase.Product_Short_Name__c != oldMap.get(adcvdCase.Id).Product_Short_Name__c || adcvdCase.Batch_Update__c != oldMap.get(adcvdCase.Id).Batch_Update__c){
                changedCasesList.add(adcvdCase);
            }
        }
        return changedCasesList;
    }

    @TestVisible private static List<ADCVD_Case__c> getRecentlyModifiedCases(List<ADCVD_Case__c> changedCasesList){
        //Construct set of ids to check against, to avoid returning duplicate case records
        Set<Id> alreadyIncludedCasesIds = new Set<Id>();
        for(ADCVD_Case__c adcvdCase: changedCasesList){
            alreadyIncludedCasesIds.add(adcvdCase.Id);
        }
        Datetime dt  = System.now().addHours(-24);
        //Check for most recent completed batch job.
        List<AsyncApexJob> recentAdcvdCaseBatchJob = [select id,JobType,CompletedDate,MethodName,Status, ApexClassId from AsyncApexJob Where JobType = 'BatchApex' and ApexClassId IN (SELECT Id FROM ApexClass WHERE Name = 'ADCVDStandardCaseFieldsBatch') Order by CompletedDate DESC Limit 1];
        //If a batch job was completed recently, use that completed date as most recently updated changes to case
        //and set a batch for all cases that have been edited since then
        if(!recentAdcvdCaseBatchJob.isEmpty()) dt = recentAdcvdCaseBatchJob[0].CompletedDate;
        //Query cases with last modified > dt. From when the last batch job was complete to now.
        List<ADCVD_Case__c> recentlyModifiedCases = [SELECT Id FROM ADCVD_Case__c Where (LastModifiedDate >: dt OR LastModifiedDate >= YESTERDAY) AND Id NOT IN: alreadyIncludedCasesIds];
        recentlyModifiedCases.addAll(changedCasesList);
        return recentlyModifiedCases;

    }

    @TestVisible private static void scheduleBatchJob(List<ADCVD_Case__c> changedCasesList){
        //Get batch size from custom settings
        Decimal batchSize = (Decimal) AppConfig__c.getValues('ADCVDStandardCaseFieldsBatch').get('Batch_Size__c');
        String currentHour = System.now().format('HH');
        Integer minutesTillMidnight = (24 - Integer.valueOf(currentHour)) * 60;
        //Schedule to run today at sometime between 12am and 1am
        //Added a random number at the end of the scheduled batch name, to avoid failures due to duplicate names
        If(!Test.isRunningTest()) System.scheduleBatch(new ADCVDStandardCaseFieldsBatch(changedCasesList), 'Standardized ADCVD Case Fields Update', minutesTillMidnight, (Integer)batchSize);
    }

    @TestVisible private static Boolean checkCron(){
        //Check for batches in queue and if one is there, abort it in order to be able to schedule another
        List<CronTrigger> queuedJob = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType, OwnerId, CronExpression, StartTime FROM CronTrigger Where CronJobDetail.Name = 'Standardized ADCVD Case Fields Update'];
        if(!queuedJob.isEmpty()){
            System.abortJob(queuedJob[0].Id);
            return true;
        }
        return false;
    }

}