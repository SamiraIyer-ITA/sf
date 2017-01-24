@isTest//(seealldata=true)
public class BatchJobExecutionTest {
    public static testmethod void checkBatch()
    {
        Test.startTest();
        List<BatchJobScheduler__c> lstBatch = new List<BatchJobScheduler__c>();
        String country = 'United States';

        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingStreet = 'Test Billing Street';
        acc.BillingState = 'Ohio';
        acc.BillingCountry = 'United States';
        acc.Congressional_District__c = '02';
        acc.County_Name__c = 'Franklin';
        accList.add(acc);
        insert accList;

     	BatchJobScheduler__c batchJobSet = new BatchJobScheduler__c();
        batchJobSet.Batch_Name__c = 'TestBatchName';
        batchJobSet.Error_Message__c = '';
        batchJobSet.Number_of_Failed_Values__c = 0;
        batchJobSet.Number_of_Success_Values__c = 100; 
        batchJobSet.Batch_Start_Time__c =  Datetime.now();
        batchJobSet.Batch_End_Time__c = Datetime.now()+10;
        batchJobSet.Job_Status__c = 'Success';
        lstBatch.add(batchJobSet);
       	insert lstBatch;
        BatchTriggerFlag__c custSetting = new BatchTriggerFlag__c();
        custSetting.Name ='TestName';
        custSetting.RecordId__c = '9ikjuikljmnju98';
        custSetting.isActive__c = true;
        insert custSetting;
        Test.stopTest();
        Integer bCount =[SELECT count() FROM BatchJobScheduler__c];
        System.debug(' **** bCount '+ bCount);
        System.assertNotEquals(bCount,0);
    }
}