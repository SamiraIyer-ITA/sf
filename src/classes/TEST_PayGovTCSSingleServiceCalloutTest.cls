@isTest
private class TEST_PayGovTCSSingleServiceCalloutTest {
    
    static String agencyId = 'agencyId';
    static String tcsAppId = 'tcsAppId';
    
    @isTest static void testProcessPCRefund() { 
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
        Test.startTest();
        
        PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
        pcRefund.orig_paygov_tracking_id = 'origPayGovTrackingId';
        pcRefund.transaction_amount = 'transactionAmount';
        pcRefund.orig_agency_tracking_id = 'origAgencyTrackingId';
        
        PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = TEST_PayGovTCSSingleServiceCallout.processPCRefund(agencyId, tcsAppId, pcRefund);
        System.assertEquals('agencyId', pcRefundResponse.agency_id);
    }
    
    @isTest static void testProcessPCCancel() { 
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
        Test.startTest();
        
        PayGovTCSSingleService.PCCancelRequestType pcCancel = new PayGovTCSSingleService.PCCancelRequestType();
        pcCancel.orig_paygov_tracking_id = 'origPayGovTrackingId';
        pcCancel.transaction_amount = 'transactionAmount';
        pcCancel.agency_tracking_id = 'origAgencyTrackingId';
        
        PayGovTCSSingleService.PCCancelResponse_element pcCancelResponse = TEST_PayGovTCSSingleServiceCallout.processPCCancel(agencyId, tcsAppId, pcCancel);
        System.assertEquals('agencyId', pcCancelResponse.agency_id);
    }

}