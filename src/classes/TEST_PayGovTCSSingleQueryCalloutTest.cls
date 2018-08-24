@isTest
private class TEST_PayGovTCSSingleQueryCalloutTest {

    @isTest static void processTCSSingleQuery() { 
        
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleQueryMockImpl());
        
        // Call the method that invokes a callout
        String agencyTrackingId = 'SP000000001';
        String tcsAppId = 'TCSITAUSMASSHQA';
        String payGovTrackingId = '3FP35JN8';
        
        PayGovTCSSingleQueryService.tcs_query_result query_result = TEST_PayGovTCSSingleQueryCallout.processTCSSingleQuery();
        //PayGovTCSSingleQueryService.tcs_plastic_card_results plasticCardResults = query_result.tcs_pc_results;
        //PayGovTCSSingleQueryService.tcs_ach_results achResults = queryResult.tcs_ach_results;
        
        System.assertEquals('0000', query_result.return_code);
    }
}