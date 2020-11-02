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
            System.assert(controller.getAccountTypeOptions() != null);
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
            controller.c.firstName = '';
            controller.c.lastName = '';
            controller.a.name = '';
            controller.a.BillingStreet = '';
            controller.a.BillingCity = '';
            controller.a.Account_Type__c = null;
            controller.a.BillingCountrycode = '';
            controller.a.BillingPostalCode = '';
            controller.password = 'password';
            controller.confirmPassword = 'password';
            controller.newContact();
            controller.a.Account_Type__c = 'U.S. Business';
            controller.a.name = '';
            controller.newContact();
            controller.a.BillingPostalCode = '';
            controller.a.BillingStateCode = '';
            controller.a.BillingCountrycode = 'US';
            controller.newContact();
            //system.debug(ApexPages.getMessages());
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
            controller.c.firstName = 'Luke';
            controller.c.lastName = 'Skywalker';
            controller.a.name = 'Darth Enterprises';
             controller.a.Account_Type__c = 'U.S. Business';
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
    static testMethod void emailIndividual(){//HAS INDIVIDUAL REGISTRATION TYPE
        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            String email = 'test@mail.com';
            controller.c.email = email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            system.assertEquals(controller.existingContact().size(), 0);
            controller.c.firstName = 'Luke';
            controller.c.lastName = 'Skywalker';
            controller.a.Account_Type__c = 'Researcher';
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
/*        Test.startTest();
            PageReference pageRef = Page.Registration;
            Test.setCurrentPage(pageRef);
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            controller.c.email = regContact.email;
            controller.checkUser();
            //system.debug(ApexPages.getMessages());
            //system.debug(regContact.id+' '+u1.contactid);
            system.assertEquals(ApexPages.getMessages().get(0).getDetail(), 'test@mail.com is already registered');
        Test.stopTest();*/
    }
    static testMethod void getUserIPAddress(){
        Test.startTest();
            String ipAddress = tradeRegistration_Controller.getUserIPAddress();
            system.assertEquals(ipAddress, null);
        Test.stopTest();
    }
    static testMethod void validate(){
        Test.startTest();
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            controller.errorOnLoad = false;
            PageReference pageReference = controller.validate();
            System.assertEquals(pageReference, null);
        Test.stopTest();
    }
    static testMethod void errorValidations(){
        Account regAccount = new Account(name='Test Account', BillingPostalCode = '', BillingCountryCode = 'US'); //create an account
        insert regAccount;
        Contact regContact = new contact(LastName = 'lastName', email = 'test@mail.com', AccountId = regAccount.Id); //create a contact
        insert regContact;
        Test.startTest();
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            controller.emailError = 'emailError';
            controller.emailFormatError = 'emailFormatError';
            controller.firstNameError = 'firstNameError';
            controller.lastNameError = 'lastNameError';
            controller.accountTypeError = 'accountTypeError';
            controller.accountNameError = 'accountNameError';
            controller.streetError = 'streetError';
            controller.cityError = 'cityError';
            controller.stateError = 'stateError';
            controller.countryError = 'countryError';
            controller.zipcodeError = 'zipcodeError';
            controller.zipcodeValidationError = 'zipcodeValidationError';
            controller.c = regContact;
            controller.a = regAccount;
            Boolean errorValidations = controller.errorValidations();
            System.assertNotEquals(controller.emailError, null);
        Test.stopTest();
    }
    static testMethod void getNickName(){
        Account regAccount = new Account(name='Test Account', BillingCountryCode = 'US', BillingPostalCode = '11111'); //create an account
        insert regAccount;
        Contact regContact = new contact(LastName = 'lastNameTest', FirstName = 'firstNameTest', email = 'test@mail.com', AccountId = regAccount.Id); //create a contact
        insert regContact;
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        System.debug('ProfileId=' + profile.Id);
        User user = new User(Alias = 'standt', Email='test9920199@mailinator.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='test9920199@mailinator.com',
            CommunityNickName = 'flastName');
        insert user;
        Test.startTest();
            String nickName = tradeRegistration_Controller.getNickName(regContact);
            System.assertNotEquals(nickName, null);
        Test.stopTest();
    }
    static testMethod void verify(){
        ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'true');
        Test.startTest();
            tradeRegistration_Controller controller = new tradeRegistration_Controller();
            boolean verify = controller.verify();
            System.assertEquals(verify, true);
        Test.stopTest();
    }

}
