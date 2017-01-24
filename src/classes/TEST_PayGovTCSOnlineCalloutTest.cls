@isTest
private class TEST_PayGovTCSOnlineCalloutTest {

    @isTest static void testStartOnlineCollection() { 
        insert new PaymentSettings__c(name='PAY_GOV_TCS_ONLINE_ENDPOINT', value__c = 'Test');
                
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        // Call the method that invokes a callout
        Test.startTest();
        PayGovTCSOnline.StartOnlineCollectionResponse  startOnlineCollectionResponse = TEST_PayGovTCSOnlineCallout.startOnlineCollection();
        System.assertEquals('token', startOnlineCollectionResponse.token);

        PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse = TEST_PayGovTCSOnlineCallout.completeOnlineCollectionWithDetails();
        System.assertEquals('Success', completeOnlineCollectionWithDetailsResponse.transaction_status);
        
        PayGovTCSOnline.TCSServiceFault tcsServiceFault = new PayGovTCSOnline.TCSServiceFault();
        tcsServiceFault.return_code = '0000';
        System.assertEquals('0000', tcsServiceFault.return_code);
    }
}