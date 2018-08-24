@isTest
global class TEST_PayGovTCSSingleServiceMockImpl implements WebServiceMock {
    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               
           System.debug(responseName);
               
            if (responseName.equals('PCRefundResponse')) {
                PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = new PayGovTCSSingleService.PCRefundResponse_element();
                pcRefundResponse.agency_id = 'agencyId';
                pcRefundResponse.tcs_app_id = 'tcsAppId';
                
                PayGovTCSSingleService.PCRefundResponseType pcRefund = new PayGovTCSSingleService.PCRefundResponseType();
                pcRefund.orig_paygov_tracking_id = 'origPayGovTrackingId';
                pcRefund.orig_agency_tracking_id = 'origAgencyTrackingId';
                pcRefund.paygov_tracking_id = 'payGovTrackingId';
                pcRefund.agency_tracking_id = 'agencyTrackingId';
                pcRefund.transaction_amount = 'transactionAmount';
                pcRefund.masked_account_number = 'maskedAccountNumber';
                pcRefund.return_code = 'returnCode';
                pcRefund.return_detail = 'returnDetail';
                pcRefund.transaction_status = 'transactionStatus';
                pcRefund.transaction_date = 'transactionDate';
                
                pcRefundResponse.PCRefund = pcRefund;
                response.put('response_x', pcRefundResponse);   
                
            } /* else if (responseName.equals('processPCSale')) {
                PayGovTCSSingleService.PCSaleResponse_element pcSaleResponse = new PayGovTCSSingleService.PCSaleResponse_element();
                pcSaleResponse.agency_id = 'agencyId';
                pcSaleResponse.tcs_app_id = 'tcsAppId';
                
                PayGovTCSSingleService.PCSaleResponseType pcSale = new PayGovTCSSingleService.PCSaleResponseType();
                pcSale.paygov_tracking_id = 'payGovTrackingId';
                pcSale.agency_tracking_id = 'agencyTrackingId';
                pcSale.transaction_amount = 'transactionAmount';
                pcSale.masked_account_number = 'maskedAccountNumber';
                pcSale.return_code = 'returnCode';
                pcSale.return_detail = 'returnDetail';
                pcSale.transaction_status = 'transactionStatus';
                pcSale.transaction_date = 'transactionDate';
                pcSale.approval_code = 'approvalCode';
                pcSale.auth_response_code = 'authResponseCode';
                pcSale.auth_response_text = 'authResponseText';
                pcSale.avs_response_code = 'avsResponseCode';
                pcSale.csc_result = 'cscResult';
                pcSale.authorized_amount = 'authorizedAmount';
                pcSale.remaining_balance = 'remainingBalance';
                
                pcSaleResponse.PCSale = pcSale;
                response.put('response_x', pcSaleResponse);

            }*/
            
   }
}