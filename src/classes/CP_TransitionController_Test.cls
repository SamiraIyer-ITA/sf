@isTest
public class CP_TransitionController_Test {
    
    
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
     testAccount.Name='Test Account';
        testAccount.OwnerId = standardUser.id;
        //Avoid mix DML   
        system.runAs(standardUser)  {  
      insert testAccount;
         }
        
        Contact testContact = new Contact();
        testContact.FirstName = 'test';
        testContact.LastName = 'test';
        testContact.CP_Conversion_Date__c = mydt;
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
            insert u; 
      }
        lead testLead = new lead();
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.email = 'mycptest1@ztest.com';
        testLead.LeadSource = null;
        testLead.Company = 'Test Co';
           //avoid mix dml     
        system.runAs(standardUser)  {  
            insert(testLead);
       }
    }  
     @IsTest
    static void testUpgradeAccount1(){
        CP_TransitionController testController = new CP_TransitionController();
        testController.upgeadeAccount();
    }
      @IsTest
    static void testUpgradeAccount2(){
        list<User> userList = new list<User>();
        userList = [SELECT Id from User where Alias = 'ExtUser'];
        system.runAs(userList[0]){
        CP_TransitionController testController = new CP_TransitionController();
        testController.upgeadeAccount();
        
        }
    }

}