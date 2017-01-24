global class mccdBatchProcess implements Database.Batchable<sObject>, Database.Stateful {

  global String accountQuery;
  global String countryName = 'United States';
  global Database.SaveResult[] accUpdateResult,ResultSet;
  global integer successVal=0, failVal=0;
  global String errorMsg='';
  global String failedId='';
  global Datetime startTime;
  //global AsyncApexJob aSysJobStatus;
  global Blob csvFailedIdBlob;
  
  global mccdBatchProcess(){

    if(!Test.isRunningTest())
        accountQuery = 'SELECT Id,BillingPostalCode,County_Name__c,Congressional_District__c '+
    			   ' FROM Account WHERE zipCodeLen__c =9 AND BillingCountry = \''+countryName+'\'';  
    else
        accountQuery = 'SELECT Id,BillingPostalCode,County_Name__c,Congressional_District__c '+
             ' FROM Account WHERE zipCodeLen__c =9 AND BillingCountry = \''+countryName+'\' LIMIT 1';
  }
  
  global Database.QueryLocator start(Database.BatchableContext BC){
      startTime = Datetime.now();
      return Database.getQueryLocator(accountQuery);
    }

   global void execute(Database.BatchableContext BC,List<sObject> scope){

      Set<String> zipCodeSet=new Set<String>();
      List<Account> accountList = new List<Account>();
      Set<String> zipCodes = new Set<String>();//Patch as on 5/7/2015
      Set<String> zip4 = new Set<String>();
      //Datetime startTime,endTime;
        
      Map<string,Master_CongressionalDistrict__c> mapCD = new Map<String,Master_CongressionalDistrict__c>();
        
       for(sObject obj:scope)
       {
        Account a = (Account)obj;
        accountList.add(a);
       }

       List<Account> accList = new List<Account>();
      for(Account accFor: accountList)
      {

        Account acc = new Account();
        String tempZip='';
        if(accFor.BillingPostalCode != NULL ){
        Pattern zipCodSpecChar = Pattern.compile('[0-9]{5}-[0-9]{4}');
        Matcher zipMatch = zipCodSpecChar.matcher(accFor.BillingPostalCode);
        List<Master_CongressionalDistrict__c> maccdList = new List<Master_CongressionalDistrict__c>();
        //Condition to check if the Country is US and it has proper formate of zip [XXXXX-XXXX]
        //This conditon will be used only for US address only.
        if(accFor.BillingPostalCode != NULL  && zipMatch.matches())
        {
          tempZip= accFor.BillingPostalCode.trim().replace('-','');
        //}
       // if(tempZip.length() == 9)
       // {
          String zip5 = tempZip.SubString(0,5);
          String zip4Val = tempZip.SubString(5,9);
          maccdList = [SELECT Id, Congressional_Dist__c, 
                            State_Code__c,   
                             County_Name__c,
                             Zip_Plus4__c,
                             Min4__c,
                             Max4__c
                      FROM  Master_CongressionalDistrict__c 
                      WHERE Max4__c>= :zip4Val 
                      AND Min4__c <= :zip4Val
                      AND Zip_Plus4__c = :zip5
                      LIMIT 1];
          //added the If condition to validate the zipcode. 
          if(maccdList.size() > 0)
          {
            accFor.Congressional_District__c = maccdList[0].Congressional_Dist__c;
            accFor.County_Name__c = maccdList[0].County_Name__c;
            accFor.State_Code__c = maccdList[0].State_Code__c;
          }
        }
        else
        {
          accFor.Congressional_District__c = '';
          accFor.County_Name__c = '';
          accFor.State_Code__c = '';
        }
      }
      }
       accUpdateResult =Database.update(accountList,false);

      ////////////// Error message value ////////////////
       for(Integer i=0; i<accUpdateResult.size();i++) 
       {
            if(accUpdateResult.get(i).isSuccess())
              successVal++;
            if(!accUpdateResult.get(i).isSuccess())
            {
               failVal++;  
               Database.Error e = accUpdateResult.get(i).getErrors().get(0);
               errorMsg += e.getMessage();  
               failedID +=  accUpdateResult.get(i).id +',\n';
            }
           System.debug('** successVal ** '+successVal+'** failVal ** '+failVal+'** errorMsg ** '+errorMsg);
        } 
      ////////////////////////////////////////////////
  
    }

    public static void sendMailtoUser(Blob csvArg,Boolean flag,String eBody)
    {
       List<Messaging.SingleEmailMessage> sendMail = new List<Messaging.SingleEmailMessage>();
       Messaging.SingleEmailMessage sendMailSet = new Messaging.SingleEmailMessage();
       
       String emailId = UserInfo.getUserEmail();
      
       sendMailSet.setToAddresses(new String[]{emailId});
       sendMailSet.setSubject('Batch Job completed successufully');
       //If there are failed records. The value will be sent as an attachment the running user.
       Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
       attachment.setBody(csvArg);
       attachment.setFileName('ErrorList.csv');
       attachment.setinline(false);
       if(flag == true)
       {
         sendMailSet.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
       }
       sendMailSet.setHtmlBody(eBody);
       sendMail.add(sendMailSet);
       Messaging.sendEmail(sendMail);

    }

   global void finish(Database.BatchableContext BC){
    try{
      
      AsyncApexJob aSysJobStatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                          CompletedDate,ExtendedStatus,
                                          TotalJobItems, CreatedBy.Email
                                   FROM AsyncApexJob WHERE Id =:BC.getJobId()];

      String emailBody ='Your batch has been completed <br> No of Success Records : '+successVal
                                +'<br> No of Failed Records : '+failVal
                                +'<br> Date and Time  Job completed '+aSysJobStatus.CompletedDate
                                +'<br> Error Message : '+aSysJobStatus.ExtendedStatus
                                +'<br> Number of Error Message : '+aSysJobStatus.NumberOfErrors
                                +'<br> Status of the Job : '+aSysJobStatus.Status
                                +'<br> Total Number of Batch Processed : '+aSysJobStatus.TotalJobItems
                                +'<br> Save result Error Message : ' + errorMsg;
      Boolean funFlag;
     
      Blob csvFailedIdBlob= Blob.valueOf(failedID);
       if(csvFailedIdBlob.size()>0)
        funFlag = true;

      sendMailtoUser(csvFailedIdBlob,funFlag,emailBody);
      BatchTriggerFlag__c updateBatchFlag = BatchTriggerFlag__c.getInstance('isActiveFlag');
       
       ///////////////////////  Updateing the Status values /////////////////////////////////

      
      //List<BatchJobScheduler__c> batSchList = new List<BatchJobScheduler__c>();
       
      if(updateBatchFlag != NULL)
      {
         List<BatchJobScheduler__c> batSchList = new List<BatchJobScheduler__c>([SELECT Id,
                                          Error_Message__c,Number_of_Failed_Values__c,
                                          Number_of_Success_Values__c,Batch_Start_Time__c,Batch_End_Time__c
                                      FROM BatchJobScheduler__c 
                                      WHERE Id = :updateBatchFlag.RecordId__c]);
        List<BatchJobScheduler__c> batchUpdateList = new List<BatchJobScheduler__c>();
        BatchJobScheduler__c setBatchJob = new BatchJobScheduler__c();
         if(batSchList.size() > 0)
         {
             
             for(BatchJobScheduler__c b: batSchList)
             {
                 //BatchJobScheduler__c setBatchJob = new BatchJobScheduler__c();
                 setBatchJob.Id = b.Id;
                 setBatchJob.Error_Message__c = aSysJobStatus.ExtendedStatus;
                 setBatchJob.Number_of_Failed_Values__c = failVal;
                 setBatchJob.Number_of_Success_Values__c = successVal; 
                 setBatchJob.Batch_Start_Time__c = startTime;
                 setBatchJob.Batch_End_Time__c = aSysJobStatus.CompletedDate;
                 setBatchJob.Job_Status__c = aSysJobStatus.Status;
                 batchUpdateList.add(setBatchJob);
             }
             update batchUpdateList;
         }
      }
      
       
       List<BatchJobScheduler__c> batchSchObj = new List<BatchJobScheduler__c>();
       if(updateBatchFlag != NULL)
       {
           updateBatchFlag.isActive__c = false;
           updateBatchFlag.RecordId__c ='';
           Update updateBatchFlag;
       }
     }
     catch(Exception err)
     {
      // Setting this value is very important. If this value is not set to Null the batch 
      //can not be submitted by the user.
      System.debug('The Error is : '+err);
     }
   }
}