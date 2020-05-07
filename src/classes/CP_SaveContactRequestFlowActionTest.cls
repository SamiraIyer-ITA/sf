@isTest (SeeAllData = false)

public class CP_SaveContactRequestFlowActionTest {
    @testSetup static void testSetup(){
        user superUSser = [SELECT Id FROM USER WHERE profile.name =: 'System Administrator' AND ISACTIVE = TRUE LIMIT 1];
        datetime mydt = dateTime.now();
        List<User> newUsers = new List<User>();
        UserRole r = new UserRole(DeveloperName = 'testingRole', Name = 'Test Role');
        Profile adminProfile = [SELECT Id FROM PROFILE WHERE Name='System Administrator']; 
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
        LIST<RecordType> myRecords = new LIST<RecordType>();
        myRecords = [SELECT Id FROM RecordType WHERE DeveloperName =: 'New_Registrant' LIMIT 1];
        Lead testLead = new lead();
        testLead.FirstName = 'test';
        testLead.LastName = 'test';
        testLead.email = 'mycptest1@ztest.com';
        testLead.LeadSource = null;
        testLead.Company = 'Test Co';
        testLead.RecordTypeId = myRecords[0].Id;
           //avoid mix dml     
        system.runAs(standardUser)  {  
                insert(testLead);
       }
    }  
    
    @IsTest
    static void testUnvverifedUser(){
        List<User> userList = new List<User>();
        List<Group> groupList = new List<Group>();
        List<Lead> leadList = new List<lead>();
        List<Contact> contactList = new List<Contact>();
        contactlist = [ SELECT Id FROM Contact];
        leadList = [SELECT Id from Lead];
        groupList = [SELECT Id, Name,DeveloperName FROM Group WHERE DeveloperName LIKE 'cp_contact_%'];
        userList = [SELECT Id FROM user WHERE UserName =: 'cpEXTTestUser2@cpDanDev.com'];
        Map<String,Id> queueList = new Map<String,Id>();
        
        for(group currentGroup :groupList){
            queueList.put(currentGroup.DeveloperName,currentGroup.Id);
        }
        
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        List< CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new List<CP_SaveContactRequestFlowAction.RequestVariables>();
        List<contactRequest> savedRecords = new List<ContactRequest>();
        
        screenData.ownerId = queueList.get('CP_Contact_US_3');
        screenData.contactId = (String) contactlist[0].id;
        screenData.converted = 'false';
        screenData.country = 'China';
        screenData.email = 'mycptest1@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReason = '';
        screenData.zipCode = '78250';
        screenData.lastName = 'test';
        screenData.leadId =  leadList[0].Id;
        screenData.queueName = 'CP_Contact_US_3';
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
        savedRecords = [select id, whoId from contactRequest];
        system.assert( savedRecords[0].whoId == leadList[0].id);
    }
    
    @istest
    static void testverifedUser(){
        List<User> userList = new List<User>();
        List<Group> groupList = new List<Group>();
        List<Lead> leadList = new List<lead>();
        List<Contact> contactList = new List<Contact>();
        contactlist = [SELECT Id FROM contact];
        leadList = [SELECT Id FROM Lead];
        groupList = [SELECT Id, Name, DeveloperName FROM group WHERE DeveloperName LIKE 'cp_contact_%'];
        Map<String,Id> queueList = new Map<String,Id>();
        for(group currentGroup :groupList){
            queueList.put(currentGroup.DeveloperName,currentGroup.Id);
        }
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        List<CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new List<CP_SaveContactRequestFlowAction.RequestVariables>();
        List<ContactRequest> savedRecords = new List<ContactRequest>();
        userList = [SELECT Id FROM user WHERE UserName =: 'cpEXTTestUser2@cpDanDev.com'];
        screenData.ownerId =  queueList.get('CP_Contact_US_3');
        screenData.contactId = contactlist[0].id;
        screenData.converted = 'true';
        screenData.country = 'China';
        screenData.email = 'mycptest1@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReason = '';
        screenData.zipCode = '78250';
        screenData.lastName = 'test';
        screenData.leadId = leadList[0].Id;
        screenData.queueName = 'CP_Contact_US_3';
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
        savedRecords = [SELECT Id, WhoId FROM ContactRequest];
        system.assert(savedRecords[0].whoId == contactlist[0].id);
    }
    
     @IsTest
    static void testUnregisteredUser(){
        List<User> userList = new List<User>();
        List<Group> groupList = new List<Group>();
        List<Lead> leadList = new List<lead>();
        List<Contact> contactList = new List<Contact>();
        contactlist = [ select Id FROM Contact];
        leadList = [SELECT Id FROM Lead];
        groupList = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName like 'cp_contact_%'];
        userList = [SELECT Id FROM user where userName =: 'cpEXTTestUser2@cpDanDev.com'];
        Map<String,Id> queueList = new Map<String,Id>();
        
        for(group currentGroup :groupList){
            queueList.put(currentGroup.DeveloperName,currentGroup.Id);
        }
        
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        List<CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new List<CP_SaveContactRequestFlowAction.RequestVariables>();
        List<ContactRequest> savedRecords = new List<ContactRequest>();
        
        screenData.ownerId = queueList.get('CP_Contact_US_3');
        screenData.contactId = null;
        screenData.converted = 'false';
        screenData.country = 'China';
        screenData.email = 'mycptestNOLEAD@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReason = '';
        screenData.zipCode = '78250';
        screenData.lastName = 'test';
        screenData.leadId = 'NONE';
        screenData.queueName = 'CP_Contact_US_3';
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
           savedRecords = [Select Id, WhoId FROM CONTACTREQUEST];
        system.assert( savedRecords[0].whoId == null);
    }
}