@isTest (SeeAllData = false)

public class CP_SaveContactRequestFlowActionTest {
    
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
    static void testUnvverifedUser(){
        list<user> userList = new list<user>();
        list<group> groupList = new list<group>();
        list<lead> leadList = new list<lead>();
        list<Contact> contactList = new list<contact>();
        contactlist = [ select id from contact];
        leadList = [select id from Lead];
        groupList = [select id, name from group where name like 'cp_contact_%'];
        userList = [select id from user where userName =: 'cpEXTTestUser2@cpDanDev.com'];
        
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        list< CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new list< CP_SaveContactRequestFlowAction.RequestVariables>();
        list<contactRequest> savedRecords = new list<ContactRequest>();
        
        screenData.ownerId = groupList[3].id;
        screenData.contactId = contactlist[0].id;
        screenData.converted = 'false';
        screenData.country = 'China';
        screenData.email = 'mycptest1@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReasson = '';
        screenData.zipCode = '78250';
        screenData.lastNAme = 'test';
        screenData.leadId = leadList[0].Id;
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
        system.runAs(userlist[0]){
   		savedRecords = [select id, whoId from contactRequest];
        }
        system.assert( savedRecords[0].whoId == leadList[0].id);
    }
    
    @istest
    static void testverifedUser(){
        list<user> userList = new list<user>();
        list<group> groupList = new list<group>();
        list<lead> leadList = new list<lead>();
        list<Contact> contactList = new list<contact>();
        contactlist = [select id from contact];
        leadList = [select id from Lead];
        groupList = [select id, name from group where name like 'cp_contact_%'];
        
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        list< CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new list< CP_SaveContactRequestFlowAction.RequestVariables>();
        list<contactRequest> savedRecords = new list<ContactRequest>();
        userList = [select id from user where userName =: 'cpEXTTestUser2@cpDanDev.com'];
 
        screenData.ownerId = groupList[3].id;
        screenData.contactId = contactlist[0].id;
        screenData.converted = 'true';
        screenData.country = 'China';
        screenData.email = 'mycptest1@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReasson = '';
        screenData.zipCode = '78250';
        screenData.lastNAme = 'test';
        screenData.leadId = leadList[0].Id;
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
        
        system.runAs(userlist[0]){
      		  savedRecords = [select id, whoId from contactRequest];
        }
        system.assert(savedRecords[0].whoId == contactlist[0].id);
    }
    
     @IsTest
    static void testUnregisteredUser(){
        list<user> userList = new list<user>();
        list<group> groupList = new list<group>();
        list<lead> leadList = new list<lead>();
        list<Contact> contactList = new list<contact>();
        contactlist = [ select id from contact];
        leadList = [select id from Lead];
        groupList = [select id, name from group where name like 'cp_contact_%'];
        userList = [select id from user where userName =: 'cpEXTTestUser2@cpDanDev.com'];
        
        CP_SaveContactRequestFlowAction.RequestVariables screenData = new CP_SaveContactRequestFlowAction.RequestVariables();
        list< CP_SaveContactRequestFlowAction.RequestVariables> reqVars = new list< CP_SaveContactRequestFlowAction.RequestVariables>();
        list<contactRequest> savedRecords = new list<ContactRequest>();
        
        screenData.ownerId = groupList[3].id;
        screenData.contactId = null;
        screenData.converted = 'false';
        screenData.country = 'China';
        screenData.email = 'mycptest1@ztest.com';
        screenData.firstName = 'test';
        screenData.requestReasson = '';
        screenData.zipCode = '78250';
        screenData.lastNAme = 'test';
        screenData.leadId = 'NONE';
        reqVars.add(screenData);
        CP_SaveContactRequestFlowAction.createRecord(reqVars);
        system.runAs(userlist[0]){
   		savedRecords = [select id, whoId from contactRequest];
        }
        system.assert( savedRecords[0].whoId == null);
    }
}