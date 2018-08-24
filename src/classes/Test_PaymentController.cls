@isTest
public class Test_PaymentController {
    private static String PRIVACY_SHIELD_APP_ID;
    private static String PRIVACY_SHIELD_APP;
    private static String EVENTS_SERVICES_APP_ID;
    private static String EVENTS_SERVICES_APP;
    private static String PAY_GOV_URL;
    private static String AGENCY_ID;
    private static String SERVICE_ENDPOINT;
    
    static{
        Paymentsettings__c[] psTypes = new Paymentsettings__c[]{};
        PaymentSettings__c ps = new PaymentSettings__c(Value__c='TCSITAUSMASSHQA', name ='PRIVACY_SHIELD_APP_ID');
        PaymentSettings__c ps2 = new PaymentSettings__c(Value__c='PS', name ='PRIVACY_SHIELD_APP');
        PaymentSettings__c ps3 = new PaymentSettings__c(Value__c='https://qa.pay.gov/tcsonline/payment.do', name ='PAY_GOV_TCS_ONLINE_URL');
        PaymentSettings__c ps4 = new PaymentSettings__c(Value__c='https://qa.tcs.pay.gov:443/services/TCSOnlineService/2.0/', name ='PAY_GOV_TCS_ONLINE_ENDPOINT');
        PaymentSettings__c ps5 = new PaymentSettings__c(Value__c='TCSITAUSFCSEMENUQA', name ='EVENTS_SERVICES_APP_ID');
        PaymentSettings__c ps6 = new PaymentSettings__c(Value__c='ES', name ='EVENTS_SERVICES_APP');
        PaymentSettings__c ps7 = new PaymentSettings__c(Value__c='967', name ='AGENCY_ID');
        PaymentSettings__c ps8 = new PaymentSettings__c(value__c='https://qa.tcs.pay.gov:443/tcssinglequery/services/TCSSingleQueryService',name='PAY_GOV_TCS_QUERY_ENDPOINT');
        PaymentSettings__c ps9 = new PaymentSettings__c(value__c='PS APP NAME', name ='PRIVACY_SHIELD_APP_NAME');
        psTypes.add(ps);
        psTypes.add(ps2);
        psTypes.add(ps3);
        psTypes.add(ps4);
        psTypes.add(ps5);
        psTypes.add(ps6);
        psTypes.add(ps7);
        psTypes.add(ps8);
        psTypes.add(ps9);
        insert psTypes;
        
        PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c; 
        PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
        EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
        EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
        PAY_GOV_URL = PaymentSettings__c.getAll().get('PAY_GOV_TCS_ONLINE_URL').value__c;
        AGENCY_ID = PaymentSettings__c.getAll().get('AGENCY_ID').value__c;
        SERVICE_ENDPOINT = PaymentSettings__c.getAll().get('PAY_GOV_TCS_QUERY_ENDPOINT').value__c;
    }
    
    static testMethod void testClass1(){
        PageReference pageRef = Page.Payment;
        Test.setCurrentPage(pageRef);
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentController myController = new PaymentController();
        
        system.assertEquals(myController.getBaseUrl(), myController.getBaseUrl());
        system.assertEquals(myController.agencyTrackingId, null);
        myController.amount = '5.00';
        myController.PrivacyShieldPayment();
        myController.eventsServicesPayment();
        myController.agencyTrackingId = 'Thisismytestid';
        
        myController.getAgencyTrackingId();
        system.assertNotEquals(myController.agencyTrackingId, null);
        system.assertEquals(ApexPages.currentPage().getParameters().get('opp'), null);
    }
    static testMethod void testClass2(){
        //SETUP TEST DATA
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Opportunity myOpportunityTest = new Opportunity(name = 'Testing', accountid = myAccountTest.id, closedate = Date.today(), StageName = 'Prospecting');
        insert myOpportunityTest;
        //END SETUP TEST DATA
        PageReference pageRef = Page.Payment;
        Test.setCurrentPage(pageRef);
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentController myController = new PaymentController();
        system.assertEquals(myController.agencyTrackingId, null);
        myController.getAgencyTrackingId();
        system.assertNotEquals(myController.agencyTrackingId, null);
    }
    static testMethod void testClass2Opp(){
        //SETUP TEST DATA
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Order myOpportunityTest = new Order(accountid = myAccountTest.id, effectivedate = Date.today(), status='Draft');
        insert myOpportunityTest;
        //END SETUP TEST DATA
        PageReference pageRef = Page.Payment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('opp', myOpportunityTest.id);
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentController myController = new PaymentController();
        system.assertEquals(myController.agencyTrackingId, null);
        myController.getAgencyTrackingId();
        system.assertNotEquals(myController.agencyTrackingId, null);
    }
    static testMethod void testClass3(){
        PageReference pageRef = Page.Payment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', 'SomeValue123');
        ApexPages.currentPage().getParameters().put('cancel', 'true');
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentController myController = new PaymentController();
        
        system.assertEquals(ApexPages.currentPage().getParameters().get('id'), 'SomeValue123');
        system.assertEquals(myController.agencyTrackingId, 'SomeValue123');
        system.assertEquals(myController.paymentCancelled, true);
    }
    static testMethod void testClass4(){
        PageReference pageRef = Page.Payment;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('error', 'true');
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentController myController = new PaymentController();
        
        system.assertEquals(ApexPages.currentPage().getParameters().get('error'), 'true');
        system.assertEquals(myController.paymentError, true);
    }
    static testMethod void testClass5(){
        Test.startTest();
            Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());     
            PaymentController myController = new PaymentController(); 
            
            myController.agencyTrackingId = 'sp000968';
            myController.getAgencyTrackingId();
            myController.PrivacyShieldPayment();
         Test.stopTest();
    }
    static testMethod void testClass6(){
        Test.startTest();
            Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
            PaymentController myController = new PaymentController();
            
            myController.agencyTrackingId = 'sp000968';
            myController.getAgencyTrackingId();
            myController.eventsServicesPayment();
         Test.stopTest();
    }
    static testMethod void testClass7(){
        Payment__c paymentObject = new Payment__c();
        insert paymentObject;
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Opportunity myOpportunityTest = new Opportunity(name = 'Testing', accountid = myAccountTest.id, closedate = Date.today(), StageName = 'Prospecting');
        insert myOpportunityTest;
        
        String AgencyID = [SELECT Name FROM Payment__c WHERE id = :paymentObject.Id limit 1].name;
        System.debug(AgencyID);
        Test.startTest();
            PageReference confirm = Page.PaymentConfirmation;
            Test.setCurrentPage(confirm);
            ApexPages.currentPage().getParameters().put('id', AgencyID);
            ApexPages.currentPage().getParameters().put('token', 'token');
            ApexPages.currentPage().getParameters().put('app', 'PS');
            ApexPages.currentPage().getParameters().put('opp', myOpportunityTest.id);
            
            Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
            
            PaymentConfirmationController myComfirmation = new PaymentConfirmationController();
            
            myComfirmation.completePayment();
            myComfirmation.saveTransactionDetails();
            myComfirmation.doRedirect();
        
            system.debug(myComfirmation.completeOnlineCollectionWithDetailsResponse);
            system.assertEquals(ApexPages.currentPage().getParameters().get('opp'), myOpportunityTest.id);
         Test.stopTest();
    }
    static testMethod void testClass8(){
        Payment__c paymentObject = new Payment__c();
        insert paymentObject;
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Opportunity myOpportunityTest = new Opportunity(name = 'Testing', accountid = myAccountTest.id, closedate = Date.today(), StageName = 'Prospecting');
        insert myOpportunityTest;
        
        String AgencyID = [SELECT Name FROM Payment__c WHERE id = :paymentObject.Id limit 1].name;
        Test.startTest();        
            PageReference confirm = Page.PaymentConfirmation;
            Test.setCurrentPage(confirm);
            ApexPages.currentPage().getParameters().put('id', AgencyID);
            ApexPages.currentPage().getParameters().put('token', 'token');
            ApexPages.currentPage().getParameters().put('app', 'ES');
            ApexPages.currentPage().getParameters().put('opp', myOpportunityTest.id);
            
            PaymentConfirmationController myComfirmation = new PaymentConfirmationController();
            myComfirmation.completePayment();
            myComfirmation.doRedirect();
            system.assertEquals(ApexPages.currentPage().getParameters().get('opp'), myOpportunityTest.id); 
         Test.stopTest();
    }
    static testMethod void testClass9(){
        Payment__c paymentObject = new Payment__c();
        insert paymentObject;
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Order myOpportunityTest = new Order(accountid = myAccountTest.id, effectivedate = Date.today(), status = 'Draft');
        insert myOpportunityTest;
        
        String AgencyID = [SELECT Name FROM Payment__c WHERE id = :paymentObject.Id limit 1].name;
        Test.startTest();        
            PageReference confirm = Page.PaymentConfirmation;
            Test.setCurrentPage(confirm);
            ApexPages.currentPage().getParameters().put('id', AgencyID);
            ApexPages.currentPage().getParameters().put('token', 'token');
            ApexPages.currentPage().getParameters().put('app', 'ES');
            
            PaymentConfirmationController myComfirmation = new PaymentConfirmationController();
            system.assertEquals(ApexPages.currentPage().getParameters().get('opp'), null);
            myComfirmation.doRedirect();
         Test.stopTest();
    }
    
    static testMethod void testClass10(){
        Payment__c paymentObject = new Payment__c();
        insert paymentObject ;
        Payment payment = new Payment();
        Account myAccountTest = new Account(name = 'Testing');
        insert myAccountTest;
        Order myOpportunityTest = new Order(accountid = myAccountTest.id, effectivedate = Date.today(), status = 'Draft');
        insert myOpportunityTest;
        
        String AgencyID = [SELECT Name FROM Payment__c WHERE id = :paymentObject.Id limit 1].name;
        Test.startTest();        
            PageReference confirm = Page.PaymentConfirmation;
            Test.setCurrentPage(confirm);
            ApexPages.currentPage().getParameters().put('id', AgencyID);
            ApexPages.currentPage().getParameters().put('token', 'token');
            ApexPages.currentPage().getParameters().put('app', 'ES');
            
            PaymentConfirmationController controller = new PaymentConfirmationController();
            controller.token = 'token';
            controller.agencyTrackingId = 'agencyTrackingId';
            controller.application = 'application';
            controller.paymentError = false;
            controller.paymentObject = paymentObject;
            controller.payment = payment;
            system.assertEquals(ApexPages.currentPage().getParameters().get('opp'), null);
            controller.doRedirect();
         Test.stopTest();
    }
    
    /*static testMethod void testClass11(){
        PageReference pageRef = Page.PaymentDetails;
        Test.setCurrentPage(pageRef);
        
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        PaymentDetailsController myController = new PaymentDetailsController();
    }*/
}