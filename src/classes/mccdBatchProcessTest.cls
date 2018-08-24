@isTest
public class mccdBatchProcessTest {
	
	public static testmethod void testMccdBatchJob()
	{   
        Profile p = [SELECT Id FROM Profile WHERE Name='Data Team Admin']; 
        User testUser = new User();
        testUser.LastName = 'demo';
        testUser.UserName = 'testuser@trade.gov';
        testUser.Email ='testuser@trade.gov';
        testUser.Alias ='tUser';
        testUser.EmailEncodingKey='UTF-8';
        testUser.LanguageLocaleKey='en_US'; 
        testUser.LocaleSidKey='en_US';
        testUser.ProfileId = p.Id;
        testUser.TimeZoneSidKey='America/Los_Angeles';
        //insert testuser;
/*
        List<DandBCompany> dnb = new List<DandBCompany>();
        DandBCompany dbSet = new DandBCompany();
        dbSet.DunsNumber ='1234';
        dbSet.Name =' DnB company';
        dbSet.UsTaxId ='89765';
        dnb.add(dbSet);
        insert dnb;*/
        System.runAs(testUser)
        {
            List<Account> accRecord = new List<Account>();
            for(integer i= 100 ;i < 300; i++)
            {
                Account setAccount = new Account();
                setAccount.name = 'Test Account Name ' + i;
                setAccount.BillingPostalCode = '98765-9' + i;
                setAccount.Congressional_District__c = '02';
                setAccount.County_Name__c = 'Franklin County';
                setAccount.billingStatecode ='MD';
                setAccount.BillingCountry = 'United States'; 
                //setAccount.DunsNumber = dnb[0].DunsNumber;   
                accRecord.add(setAccount);
            }
            
            insert accRecord;
            
            List<Master_CongressionalDistrict__c> mCCDList = new List<Master_CongressionalDistrict__c>();
            for(integer i=100; i<600; i++)
            {
                Master_CongressionalDistrict__c mCCDSet = new Master_CongressionalDistrict__c();
                mCCDSet.County_Name__c = 'Lehigh Valley';
                mCCDSet.State_Code__c = 'PA';
                mCCDSet.zip_Plus4__c = '987659'+i;
                mCCDList.add(mCCDSet);
            }
            insert mCCDList;
            
            Test.startTest();
            mccdBatchProcess mccdBatchApexClass = new mccdBatchProcess();
            //mccdBatchApexClass.start(BatchableContext BC) 
            String tmpcountry = 'United States';
            if(!Test.isRunningTest()){
                mccdBatchApexClass.accountQuery = 'SELECT Id,BillingPostalCode,County_Name__c,Congressional_District__c '+
                   ' FROM Account WHERE zipCodeLen__c =9 AND BillingCountry = \''+tmpcountry+'\'';  
            }
           
            mccdBatchApexClass.accountQuery ='SELECT Id,BillingPostalCode,County_Name__c,Congressional_District__c '+
                ' FROM Account ';
            
            Id processId = Database.executeBatch(mccdBatchApexClass);
            System.assertNotEquals(processId, '');
            List<BatchJobScheduler__c> batchSch = new List<BatchJobScheduler__c>();
            BatchJobScheduler__c bSet = new BatchJobScheduler__c();
            bSet.Batch_End_Time__c = Datetime.now() +10;
            bSet.Batch_Start_Time__c = Datetime.now();
            bSet.Batch_Name__c = 'Test Batch';
            batchSch.add(bSet);
            insert batchSch;
            List<BatchJobScheduler__c> batchCount = [SELECT Id,
                                          Error_Message__c,Number_of_Failed_Values__c,
                                          Number_of_Success_Values__c,Batch_Start_Time__c,Batch_End_Time__c
                                      FROM BatchJobScheduler__c WHERE Id = :batchSch[0].Id];
            System.assertNotEquals(batchCount.size(), 0);
            List<BatchJobScheduler__c> batchUpdateList = new List<BatchJobScheduler__c>();
            if(batchCount.size()>0)
            {
               // List<BatchJobScheduler__c> batchUpdateList = new List<BatchJobScheduler__c>();
                for(BatchJobScheduler__c b: batchCount)
                {
                 BatchJobScheduler__c setBatchJob = new BatchJobScheduler__c();
                 setBatchJob.Id = b.Id;
                 setBatchJob.Error_Message__c = '';
                 setBatchJob.Number_of_Failed_Values__c = 0;
                 setBatchJob.Number_of_Success_Values__c = 10; 
                 setBatchJob.Batch_Start_Time__c = Datetime.now();
                 setBatchJob.Batch_End_Time__c = Datetime.now()+30;
                 setBatchJob.Job_Status__c = 'Success';
                 batchUpdateList.add(setBatchJob);
                }
             update batchUpdateList;
            }
            System.assertNotEquals(batchUpdateList.size(),0);

            BatchTriggerFlag__c updateBatchFlag = new BatchTriggerFlag__c();
            updateBatchFlag.Name = 'isActiveFlag';
            updateBatchFlag.isActive__c = false;
            updateBatchFlag.RecordId__c ='';
            insert updateBatchFlag;

            BatchTriggerFlag__c checkVal = BatchTriggerFlag__c.getInstance('isActiveFlag');
            System.assertEquals(checkVal.isActive__c,false);

            Blob testBlob =Blob.valueOf('This is the test class');
            Boolean funFlag = true;
            String emailBody ='This is test body';
            //mccdBatchProcess.sendMailtoUser(testBlob,funFlag,emailBody);
            Test.stopTest();
        }
	}
}