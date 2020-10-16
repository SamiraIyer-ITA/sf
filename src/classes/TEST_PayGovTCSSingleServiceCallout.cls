public class TEST_PayGovTCSSingleServiceCallout {
    
    public static PayGovTCSSingleService.PCRefundResponse_element processPCRefund(String agencyId, String tcsAppId, PayGovTCSSingleService.PCRefundRequestType pcRefund) {
    
        PayGovTCSSingleService.TCSSinglePort tcsSinglePort = new  PayGovTCSSingleService.TCSSinglePort();
        return tcsSinglePort.processPCRefund(agencyId, tcsAppId, pcRefund);
    } 
    
    /*public static PayGovTCSSingleService.PCSaleResponse_element processPCSale(String agencyId, String tcsAppId, PayGovTCSSingleService.PCSaleRequestType pcSale) {
    
        PayGovTCSSingleService.TCSSinglePort tcsSinglePort = new  PayGovTCSSingleService.TCSSinglePort();
        return tcsSinglePort.processPCSale(agencyId, tcsAppId, pcSale);
    }*/  

}