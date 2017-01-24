@isTest(seealldata = true)
public class Test_tradeRegistration_Controller {
    /*
    This class handles all of the unit tests related to the tradeRegistration_Controller controller.
    */
    static testMethod void emailNone(){
        //Start Setup Data
        //Document logo = [SELECT name
                        //FROM document
                        //Where name = 'logo.jpg'];
        //End Setup Data
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            system.assertEquals(controller.page , 0);
            String email = ''; 
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'Please enter a valid email address');         
        Test.stopTest();
    }
    static testMethod void emailNotValid(){
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller(); 
            String email = 'notproperformat';
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'Please enter a valid email address');
        	email = 'notproperformat@trade.gov';
            controller.c.email = email;
            controller.checkUser();
			system.debug(ApexPages.getMessages());
        Test.stopTest();
    }
    static testMethod void emailNoContact(){//NO EXISTING CONTACT RECORD
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            String email = 'real@mail.com';
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(controller.existingContact().size(), 0); 
            system.assertEquals(controller.page , 2);
            controller.c.firstName = '';
            controller.c.lastName = '';
            controller.a.name = '';
            controller.a.BillingStreet = '';
            controller.a.BillingCity = '';
            controller.a.Account_Type__c = null;
            controller.a.BillingCountrycode = '';
            controller.a.BillingPostalCode = '';
            controller.newContact();
            controller.a.Account_Type__c = 'Business';
            controller.a.name = '';
            controller.newContact();
            controller.a.BillingPostalCode = '';
            controller.a.BillingStateCode = '';
            controller.a.BillingCountrycode = 'US';
            controller.newContact();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(controller.page , 2);
        Test.stopTest();
    }
    static testMethod void emailBusiness(){//HAS BUSINESS REGISTRATION TYPE
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            String email = 'test@mail.com';
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(controller.existingContact().size(), 0); 
            system.assertEquals(controller.page , 2);
            controller.c.firstName = 'Luke';
            controller.c.lastName = 'Skywalker';
            controller.a.name = 'Darth Enterprises';
        	 controller.a.Account_Type__c = 'Business';
            controller.a.BillingStreet = 'DeathStar';
            controller.a.BillingCity = 'Deep Space';
            controller.a.BillingCountrycode = 'US';
            controller.a.BillingStateCode = 'MD';
            controller.a.BillingPostalCode = '1245A';
            controller.newContact();
            controller.a.BillingPostalCode = '12455';
            controller.newContact();
            //system.debug(ApexPages.getMessages());
            System.assertEquals(Apexpages.currentPage().getUrl(), '/apex/registration');
        Test.stopTest();
    }
    static testMethod void emailStudent(){//HAS STUDENT REGISTRATION TYPE
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            String email = 'test@mail.com';
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(controller.existingContact().size(), 0); 
            system.assertEquals(controller.page , 2);
            controller.c.firstName = 'Luke';
            controller.c.lastName = 'Skywalker';
            controller.a.Account_Type__c = 'Student';
            controller.a.BillingStreet = 'DeathStar';
            controller.a.BillingCity = 'Deep Space';
            controller.a.BillingCountrycode = 'US';
            controller.a.BillingStatecode = 'MD';
            controller.a.BillingPostalCode = '12455';
            controller.newContact();
            //system.debug(ApexPages.getMessages());
            System.assertEquals(Apexpages.currentPage().getUrl(), '/apex/registration');
        Test.stopTest();
    }
    static testMethod void activeContactNoUSer(){//HAS ACTIVE CONTACT NO USER
        //SETUP TEST DATA
        /*RecordType accRT = [SELECT id 
                            FROM recordtype 
                            WHERE sobjecttype ='Account' 
                            and name = 'Individual' 
                            LIMIT 1];
        RecordType rt = [SELECT id 
                         FROM recordtype 
                         WHERE sobjecttype ='Contact' 
                         and name = 'Individual' 
                         LIMIT 1]; */
        Account regAccount = new Account(name='Test Account'); //create an account
        insert regAccount;
        Contact regContact = new contact(LastName = 'Test', FirstName = 'Testcontact', email = 'test@mail.com', AccountId = regAccount.Id); //create a contact
        insert regContact;
        //END TEST DATA
        Test.startTest();
        	PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            system.assertEquals(controller.page , 0);
            controller.c.email = regContact.email;
            controller.checkUser();
        	System.assertEquals(Apexpages.currentPage().getUrl(), '/apex/registration');
        Test.stopTest();
    }
    static testMethod void emailContactUser(){//HAS CONTACT RECORD AND USER RECORD IN SYSTEM
        //SETUP TEST DATA
        /*RecordType accRT = [SELECT id 
                            FROM recordtype 
                            WHERE sobjecttype ='Account' 
                            and name = 'Individual' 
                            LIMIT 1];
        RecordType rt = [SELECT id 
                         FROM recordtype 
                         WHERE sobjecttype ='Contact' 
                         and name = 'Individual' 
                         LIMIT 1]; */
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        Account regAccount = new Account(name='Test Account'); //create an account
        insert regAccount;
        Contact regContact = new contact(LastName = 'Test', FirstName = 'Testcontact', email = 'test@mail.com', AccountId = regAccount.Id); //create a contact
        insert regContact;
        User u1 = new User( email= regContact.email,
                           UserName= regContact.email+'trade', 
                           Alias = 'nuser',
                           TimeZoneSidKey='America/New_York',
                           EmailEncodingKey='ISO-8859-1',
                           LocaleSidKey='en_US', 
                           LanguageLocaleKey='en_US',
                           ContactId = regContact.Id,
                           LastName = 'TestUser',
                           ProfileId = p.id,
                           IsActive = true,
                           CommunityNickname = 'nickname');
        insert(u1);
        //END TEST DATA
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            system.assertEquals(controller.page , 0);
            controller.c.email = regContact.email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            //system.debug(regContact.id+' '+u1.contactid);
            system.assertEquals(controller.page , 0);
        	system.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'test@mail.com is already registered');
        Test.stopTest();
    }
}