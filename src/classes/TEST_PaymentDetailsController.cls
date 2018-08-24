@isTest
public class TEST_PaymentDetailsController {
    private static String PRIVACY_SHIELD_APP_ID;
    private static String PRIVACY_SHIELD_APP;
    private static String EVENTS_SERVICES_APP_ID;
    private static String EVENTS_SERVICES_APP;
    private static final String AGENCY_ID;
    
    static{
        Paymentsettings__c[] psTypes = new Paymentsettings__c[]{};
        PaymentSettings__c ps1 = new PaymentSettings__c(Value__c='TCSITAUSMASSHQA', name ='PRIVACY_SHIELD_APP_ID');
        PaymentSettings__c ps2 = new PaymentSettings__c(Value__c='PS', name ='PRIVACY_SHIELD_APP');
        PaymentSettings__c ps3 = new PaymentSettings__c(Value__c='TCSITAUSFCSEMENUQA', name ='EVENTS_SERVICES_APP_ID');
        PaymentSettings__c ps4 = new PaymentSettings__c(Value__c='ES', name ='EVENTS_SERVICES_APP');
        PaymentSettings__c ps5 = new PaymentSettings__c(Value__c='967', name ='AGENCY_ID');
        psTypes.add(ps1);
        psTypes.add(ps2);
        psTypes.add(ps3);
        psTypes.add(ps4);
        psTypes.add(ps5);
        insert psTypes;
        
        PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c; 
        PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
        EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
        EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
        AGENCY_ID = PaymentSettings__c.getAll().get('AGENCY_ID').value__c;
    }
    
    static testMethod void testMethod1(){
        System.debug('TEST_PaymentDetailsController.testMethod1()');
        
        Account account = new Account(Name='tAccount');
		insert account;
        
        Order order = new Order();
		order.Name = '14TPE000001';
        order.AccountId = account.Id;
        order.EffectiveDate = Date.Today();
        order.Status = 'Draft';
        insert order;
        
        Payment__c payment = new Payment__c(Order__c = order.id, Pay_Gov_Tracking_Id__c = 'payGovTrackingId');
        insert payment;
        
		ApexPages.StandardController sc = new ApexPages.StandardController(payment);
        PaymentDetailsController myController = new PaymentDetailsController(sc);
        System.assertEquals(myController.payGovTrackingId, 'payGovTrackingId');                            
        
        //Test credit card
        Test.startTest();
        Test.setMock(WebServiceMock.class, new TEST_PaymentDetailsControllerMockImpl());
        PageReference ccPageRef = new PageReference('creditCard');
        Test.setCurrentPage(ccPageRef);  //Necessary for the PaymentDetailsController to know whether it should test for credit card or ach data to be returned
        PaymentDetailsController paymentDetailsController = TEST_PaymentDetailsControllerCallout.getDetails(myController);
        //System.assertEquals(paymentDetailsController.isCreditCard, true);
        //Test.stopTest();
        
        //Test ACH
        //Test.startTest();
        Test.setMock(WebServiceMock.class, new TEST_PaymentDetailsControllerMockImpl());
		PageReference achPageRef = new PageReference('ach');
        Test.setCurrentPage(achPageRef);  //Necessary for the PaymentDetailsController to know whether it should test for credit card or ach data to be returned
        paymentDetailsController = TEST_PaymentDetailsControllerCallout.getDetails(myController);
        //System.assertEquals(paymentDetailsController.isCreditCard, true);
        Test.stopTest();

       
        
    }
}