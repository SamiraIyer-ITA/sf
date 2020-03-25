@istest
public class CP_scheduled_Upgrade_External_User_Test {
    
        @testSetup static void testSetup(){

        user superUSser = [select id from user where profile.name =: 'System Administrator' AND isActive = true limit 1];
        datetime mydt = dateTime.now();
		list<User> newUsers = new list<User>();
        UserRole r = new UserRole(DeveloperName = 'testingRole', Name = 'Test Role');
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
 		//avoid mix DML use for (System Objects)
        System.runAs(superUSser){
           insert r; 
        }

        User AdminUSer = new User(Alias = 'admUser', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = adminProfile.Id,UserRoleId = r.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='cpAdminStdTestUser1@cpDanDev.com');
       //Avoid mix DML Create Admin user with Role so that we can create portal user 
		System.runAs(superUSser){
        	insert AdminUser;
         }
        
         Profile pSTD = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         User standardUser = new User(Alias = 'StdUser', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = pSTD.Id,UserRoleId = r.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='cpStdTestUser1@cpDanDev.com');
       newUsers.add(standardUser);
      //Create standard user to avoid mix DML (use for standard objects)
        System.runAs(superUSser){
       		 insert(newUsers);
        }
        
        Account testAccount = new Account();
 		testAccount.Name= Label.MCP_ExternalUserAccount;
        testAccount.OwnerId = standardUser.id;
        //Avoid mix DML   
        system.runAs(standardUser)  {  
			insert testAccount;
         }
        
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'test';
        testContact.CP_Conversion_Date__c = null;
        testContact.email = 'mycptest1@ztest.com';
        testContact.AccountId = testAccount.Id;
       //Avoid mix DML   
        system.runAs(standardUser)  {  
        	insert (testContact);
        }
        
        Profile p = [SELECT Id FROM Profile WHERE Name='MCP-External-User']; 
        User u = new User(Alias = 'ExtUser', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, contactId = testContact.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='cpEXTTestUser2@cpDanDev.com');
      //Avoid mix DML Ensures that user has a Role (required for portal user creation)  
        System.runAs(AdminUSer) { 
             u.External_User_Upgrade_Request__c = true;
       		 insert u; 
    	}
        lead testLead = new lead();
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.email = 'mycptest1@ztest.com';
        testLead.LeadSource = null;
        testLead.Company = 'Test Co';
        testLead.Organization_Name__c = 'New Org';
        testLead.Registrant__c =  testContact.Id;   
           //avoid mix dml     
        system.runAs(standardUser)  {  
       		 insert(testLead);
       }
    }   
    
    
    
 static testmethod void test() {
   Test.startTest();
     list<user> testUserList = new list<User>();
     list<contact> conList = new list<Contact>();
     testUserList = [select id from user where Alias = 'ExtUser'];
     conList = [select id,name,account.name from contact];
     system.debug(conList[0].account.name);
     

       String CRON_EXP = '0 0 0 3 9 ? 2022';


      String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, new CP_scheduled_Upgrade_External_User());

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
   //   System.assertEquals(TestScheduledApexFromTestMethod, new TestScheduledApexFromTestMethod() );

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
   
   Test.stopTest();
  
   }
    
     static testmethod void testAccountAction() {
		     list<User> testUserList = new list<User>();
             list<Id> userIdList = new list<Id>();
    		 testUserList = [select id from user where Alias = 'ExtUser'];
             userIdList.add(testUserList[0].id);
             CP_scheduled_Upgrade_External_User.AccountAction();

     }
}