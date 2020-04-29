@isTest
global class TEST_PayGovSingleQueryCCMockImpl implements WebServiceMock {

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

		   System.debug('RequestName = ' + requestName);
		   System.debug('ResponseName = ' + responseName);
		   System.debug('ResponseNS = ' + responseNS);
		   System.debug('ResponseType = ' + responseType);
		   System.debug('SoapAction = ' + soapAction);

		   PayGovTCSSingleQueryService.tcs_query_result tcsQueryResult = new PayGovTCSSingleQueryService.tcs_query_result();
		   tcsQueryResult.agency_id = '967';

		   tcsQueryResult.agency_tracking_id = 'SP000000001';
		   tcsQueryResult.tcs_app_id = 'TCSITAUSMASSHQA';
		   tcsQueryResult.paygov_tracking_id = '3FP35JN8';
		   tcsQueryResult.recurring_payment_number = '';
		   tcsQueryResult.return_code = '0000';
		   tcsQueryResult.return_detail = '';

		   PayGovTCSSingleQueryService.tcs_plastic_card_results tcsPlasticCardResults = new PayGovTCSSingleQueryService.tcs_plastic_card_results();
		   PayGovTCSSingleQueryService.PCSaleQueryResponse pcSaleQueryResponse = new PayGovTCSSingleQueryService.PCSaleQueryResponse();

		   pcSaleQueryResponse.transaction_status = 'transactionStatus';
		   pcSaleQueryResponse.transaction_amount= 'transactionAmount';
		   pcSaleQueryResponse.return_code = 'returnCode';
		   pcSaleQueryResponse.return_detail = 'returnDetail';
		   pcSaleQueryResponse.account_holder_name = 'accountHolderName';
		   pcSaleQueryResponse.transaction_date = 'transactionDate';
		   pcSaleQueryResponse.approval_code = 'approvalCode';
		   pcSaleQueryResponse.auth_response_code = 'authResponseCode';
		   pcSaleQueryResponse.auth_response_text = 'authResponseText';
		   pcSaleQueryResponse.avs_response_code = 'avsResponseCode';
		   pcSaleQueryResponse.csc_result = 'cscResult';

		   PayGovTCSSingleQueryService.address billingInfo = new PayGovTCSSingleQueryService.address();
		   billingInfo.billing_address = 'billingAddress';
		   billingInfo.billing_address_2 = 'billingAddress2';
		   billingInfo.billing_city = 'billingCity';
		   billingInfo.billing_state = 'billingState';
		   billingInfo.billing_zip = 'billingZip';
		   billingInfo.billing_country = 'billingCountry';
		   pcSaleQueryResponse.billing_info = billingInfo;

		   List<PayGovTCSSingleQueryService.PCSaleQueryResponse> pcSaleQueryResponseList = new List<PayGovTCSSingleQueryService.PCSaleQueryResponse>();
		   pcSaleQueryResponseList.add(pcSaleQueryResponse);
		   tcsPlasticCardResults.pc_sale_query_response = pcSaleQueryResponseList;
		   tcsQueryResult.tcs_pc_results = tcsPlasticCardResults;

		   PayGovTCSSingleQueryService.baseLineItemType baseLineItemType = new PayGovTCSSingleQueryService.baseLineItemType();
		   PayGovTCSSingleQueryService.amexLevel3Type amexLevel3Type = new PayGovTCSSingleQueryService.amexLevel3Type();
		   PayGovTCSSingleQueryService.ACHCancelBatchResultsResponse ACHCancelBatchResultsResponse = new PayGovTCSSingleQueryService.ACHCancelBatchResultsResponse();
		   PayGovTCSSingleQueryService.FailedTransactionQueryResponse FailedTransactionQueryResponse = new PayGovTCSSingleQueryService.FailedTransactionQueryResponse();
		   PayGovTCSSingleQueryService.tcsBatchItems tcsBatchItems = new PayGovTCSSingleQueryService.tcsBatchItems();
		   PayGovTCSSingleQueryService.order_level3_data order_level3_data = new PayGovTCSSingleQueryService.order_level3_data();
		   PayGovTCSSingleQueryService.tcs_batch_results_request tcs_batch_results_request = new PayGovTCSSingleQueryService.tcs_batch_results_request();
		   PayGovTCSSingleQueryService.PCCancelQueryResponse PCCancelQueryResponse = new PayGovTCSSingleQueryService.PCCancelQueryResponse();
		   PayGovTCSSingleQueryService.PCForceQueryResponse PCForceQueryResponse = new PayGovTCSSingleQueryService.PCForceQueryResponse();
		   PayGovTCSSingleQueryService.PCRefundQueryResponse PCRefundQueryResponse = new PayGovTCSSingleQueryService.PCRefundQueryResponse();
		   PayGovTCSSingleQueryService.PCAuthorizationQueryResponse PCAuthorizationQueryResponse = new PayGovTCSSingleQueryService.PCAuthorizationQueryResponse();
		   PayGovTCSSingleQueryService.PCRefundBatchResultsResponse PCRefundBatchResultsResponse = new PayGovTCSSingleQueryService.PCRefundBatchResultsResponse();
		   PayGovTCSSingleQueryService.ACHPrenotificationBatchResultsResponse ACHPrenotificationBatchResultsResponse = new PayGovTCSSingleQueryService.ACHPrenotificationBatchResultsResponse();
		   PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType CustomCollectionLabelAndFieldType = new PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType();
		   PayGovTCSSingleQueryService.mastercardLevel3Type mastercardLevel3Type = new PayGovTCSSingleQueryService.mastercardLevel3Type();
		   PayGovTCSSingleQueryService.error_message error_message = new PayGovTCSSingleQueryService.error_message();
		   PayGovTCSSingleQueryService.tcs_multiple_item_query_response tcs_multiple_item_query_response = new PayGovTCSSingleQueryService.tcs_multiple_item_query_response();
		   PayGovTCSSingleQueryService.address address = new PayGovTCSSingleQueryService.address();
		   PayGovTCSSingleQueryService.custom_fields custom_fields = new PayGovTCSSingleQueryService.custom_fields();
		   PayGovTCSSingleQueryService.level_2_element level_2_element = new PayGovTCSSingleQueryService.level_2_element();
		   PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse ACHPrenotificationQueryResponse = new PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse();
		   PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse PCManualAuthorizationQueryResponse = new PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse();
		   PayGovTCSSingleQueryService.classificationDataType classificationDataType = new PayGovTCSSingleQueryService.classificationDataType();
		   PayGovTCSSingleQueryService.ACHRefundWithPaygovTrackingIDResultsResponse ACHRefundWithPaygovTrackingIDResultsResponse = new PayGovTCSSingleQueryService.ACHRefundWithPaygovTrackingIDResultsResponse();
		   PayGovTCSSingleQueryService.ACHCancelQueryResponse ACHCancelQueryResponse = new PayGovTCSSingleQueryService.ACHCancelQueryResponse();
		   PayGovTCSSingleQueryService.classification classification = new PayGovTCSSingleQueryService.classification();
		   PayGovTCSSingleQueryService.tcs_ach_results tcs_ach_results = new PayGovTCSSingleQueryService.tcs_ach_results();
		   PayGovTCSSingleQueryService.PCSaleBatchResultsResponse PCSaleBatchResultsResponse = new PayGovTCSSingleQueryService.PCSaleBatchResultsResponse();
		   PayGovTCSSingleQueryService.PCForceBatchResultsResponse PCForceBatchResultsResponse = new PayGovTCSSingleQueryService.PCForceBatchResultsResponse();
		   PayGovTCSSingleQueryService.tcs_batch_results_response tcs_batch_results_response = new PayGovTCSSingleQueryService.tcs_batch_results_response();
		   PayGovTCSSingleQueryService.query_custom_fields query_custom_fields = new PayGovTCSSingleQueryService.query_custom_fields();
		   PayGovTCSSingleQueryService.batchResponseFailedTransaction batchResponseFailedTransaction = new PayGovTCSSingleQueryService.batchResponseFailedTransaction();
		   PayGovTCSSingleQueryService.PCCancelBatchResultsResponse PCCancelBatchResultsResponse = new PayGovTCSSingleQueryService.PCCancelBatchResultsResponse();
		   PayGovTCSSingleQueryService.PCManualAuthorizationBatchResultsResponse PCManualAuthorizationBatchResultsResponse = new PayGovTCSSingleQueryService.PCManualAuthorizationBatchResultsResponse();
		   PayGovTCSSingleQueryService.PCAuthorizationBatchResultsResponse PCAuthorizationBatchResultsResponse = new PayGovTCSSingleQueryService.PCAuthorizationBatchResultsResponse();
		   PayGovTCSSingleQueryService.visaLevel3Type visaLevel3Type = new PayGovTCSSingleQueryService.visaLevel3Type();
		   PayGovTCSSingleQueryService.tcs_multiple_item_query_request tcs_multiple_item_query_request = new PayGovTCSSingleQueryService.tcs_multiple_item_query_request();
		   PayGovTCSSingleQueryService.ACHDebitBatchResultsResponse ACHDebitBatchResultsResponse = new PayGovTCSSingleQueryService.ACHDebitBatchResultsResponse();
		   PayGovTCSSingleQueryService.tcs_plastic_card_results tcs_plastic_card_results = new PayGovTCSSingleQueryService.tcs_plastic_card_results();

		   response.put('response_x', tcsQueryResult );

   }
}