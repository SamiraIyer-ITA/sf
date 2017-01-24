public class TEST_PayGovTCSSingleQueryCallout {
    
    public static PayGovTCSSingleQueryService.tcs_query_result processTCSSingleQuery() {
        
        String agencyTrackingId = 'SP000000124';
        String tcsAppId = 'TCSITAUSMASSHQA';
        String payGovTrackingId = '3FP35JN8';
        String agencyId = '967';
        
        PayGovTCSSingleQueryService.TCSSingleQuery_Port singleQueryPort = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();
        PayGovTCSSingleQueryService.tcs_query_result queryResult = singleQueryPort.processTCSSingleQuery(agencyId, tcsAppId, agencyTrackingId, payGovTrackingId, '');
        
        return queryResult;
    }

}