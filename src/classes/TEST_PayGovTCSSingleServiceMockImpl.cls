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
				pcRefund.transaction_amount = '5.00';
				pcRefund.masked_account_number = 'maskedAccountNumber';
				pcRefund.return_code = 'ABCD';
				pcRefund.return_detail = 'returnDetail';
				pcRefund.transaction_status = 'Success';
				pcRefund.transaction_date = String.valueOf(System.now());

				pcRefundResponse.PCRefund = pcRefund;
				response.put('response_x', pcRefundResponse);

			} else if (responseName.equals('PCCancelResponse')) {
				PayGovTCSSingleService.PCCancelResponse_element pcCancelResponse = new PayGovTCSSingleService.PCCancelResponse_element();
				pcCancelResponse.agency_id = 'agencyId';
				pcCancelResponse.tcs_app_id = 'tcsAppId';

				PayGovTCSSingleService.PCCancelResponseType pcCancel = new PayGovTCSSingleService.PCCancelResponseType();
				pcCancel.orig_paygov_tracking_id = 'origPayGovTrackingId';
				pcCancel.agency_tracking_id = 'origAgencyTrackingId';
				pcCancel.transaction_amount = '5.00';
				pcCancel.masked_account_number = 'maskedAccountNumber';
				pcCancel.return_code = 'ABCD';
				pcCancel.return_detail = 'returnDetail';
				pcCancel.transaction_status = 'Success';
				pcCancel.transaction_date = String.valueOf(System.now());
				pcCancelResponse.PCCancel = pcCancel;
				response.put('response_x', pcCancelResponse);
			}
   }
}