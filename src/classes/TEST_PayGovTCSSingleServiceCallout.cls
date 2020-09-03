public class TEST_PayGovTCSSingleServiceCallout {
    
    public static PayGovTCSSingleService.PCRefundResponse_element processPCRefund(String agencyId, String tcsAppId, PayGovTCSSingleService.PCRefundRequestType pcRefund) {
    
        PayGovTCSSingleService.TCSSinglePort tcsSinglePort = new  PayGovTCSSingleService.TCSSinglePort();
        return tcsSinglePort.processPCRefund(agencyId, tcsAppId, pcRefund);
    } 
    
    public static PayGovTCSSingleService.PCCancelResponse_element processPCCancel(String agencyId, String tcsAppId, PayGovTCSSingleService.PCCancelRequestType pcCancel) {
    
        PayGovTCSSingleService.TCSSinglePort tcsSinglePort = new  PayGovTCSSingleService.TCSSinglePort();
        return tcsSinglePort.processPCCancel(agencyId, tcsAppId, pcCancel);
    } 

}