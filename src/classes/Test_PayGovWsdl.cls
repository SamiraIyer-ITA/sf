@isTest
public class Test_PayGovWsdl {
    static testmethod void test59(){
        PayGovTCSSingleQueryService.TCSSingleQuery_Port tmp = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        tmp.processTCSSingleQuery(null,null,null,null,null);
    }
    
    static testmethod void testFieldsDefined() {
        PayGovTCSSingleQueryService.tcs_plastic_card_results tpcr = new PayGovTCSSingleQueryService.tcs_plastic_card_results();
        tpcr.pc_authorization_query_response = null;
        tpcr.pc_refund_with_paygov_tracking_id_query_response = null;
        tpcr.pc_refund_without_paygov_tracking_id_query_response = null;
        tpcr.pc_force_query_response = null;
        tpcr.pc_force_without_paygov_tracking_id_query_response = null;
        tpcr.pc_manual_authorization_query_response = null;
        tpcr.pc_sale_query_response = null;
        tpcr.pc_cancel_query_response = null;
        
        PayGovTCSSingleQueryService.ACHDebitBatchResultsResponse adbr = new PayGovTCSSingleQueryService.ACHDebitBatchResultsResponse();
        adbr.agency_tracking_id = null;
        adbr.paygov_tracking_id = null;
        adbr.transaction_status = null;
        adbr.transaction_amount = null;
        adbr.masked_account_number = null;
        adbr.return_code = null;
        adbr.return_detail = null;
        adbr.transaction_date = null;
        adbr.account_holder_name = null;
        adbr.effective_date = null;

        PayGovTCSSingleQueryService.PCSaleQueryResponse sqr = new PayGovTCSSingleQueryService.PCSaleQueryResponse();

        sqr.agency_tracking_id = null;
        sqr.paygov_tracking_id = null;
        sqr.transaction_status = null;
        sqr.transaction_amount = null;
        sqr.masked_account_number = null;
        sqr.custom_fields = null;
        sqr.return_code = null;
        sqr.return_detail = null;
        sqr.account_holder_name = null;
        sqr.account_holder_email_address = null;
        sqr.transaction_date = null;
        sqr.billing_info = null;
        sqr.approval_code = null;
        sqr.auth_response_code = null;
        sqr.auth_response_text = null;
        sqr.avs_response_code = null;
        sqr.csc_result = null;
        sqr.app_batch_id = null;

        PayGovTCSSingleQueryService.tcs_multiple_item_query_request tcs_multiple_item_query_requestTmp = new PayGovTCSSingleQueryService.tcs_multiple_item_query_request();
        tcs_multiple_item_query_requestTmp.agency_id = null;
        tcs_multiple_item_query_requestTmp.tcs_app_id = null;
        tcs_multiple_item_query_requestTmp.start_date_time = null;
        tcs_multiple_item_query_requestTmp.duration = null;
        tcs_multiple_item_query_requestTmp.app_batch_id = null;
        tcs_multiple_item_query_requestTmp.paygov_batch_id = null;

        PayGovTCSSingleQueryService.visaLevel3Type visaLevel3TypeTmp = new PayGovTCSSingleQueryService.visaLevel3Type();
        visaLevel3TypeTmp.discount_indicator = null;
        visaLevel3TypeTmp.discount_amount = null;
        visaLevel3TypeTmp.alternate_tax_identifier = null;
        visaLevel3TypeTmp.product_code = null;
        visaLevel3TypeTmp.item_descriptor = null;
        visaLevel3TypeTmp.item_quantity = null;
        visaLevel3TypeTmp.unit_of_measure = null;
        visaLevel3TypeTmp.unit_cost = null;
        visaLevel3TypeTmp.net_indicator = null;
        visaLevel3TypeTmp.db_cr_indicator = null;
        visaLevel3TypeTmp.type_of_supply = null;
        visaLevel3TypeTmp.item_commodity_code = null;

        PayGovTCSSingleQueryService.PCAuthorizationBatchResultsResponse PCAuthorizationBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCAuthorizationBatchResultsResponse();
        PCAuthorizationBatchResultsResponseTmp.agency_tracking_id = null;
        PCAuthorizationBatchResultsResponseTmp.paygov_tracking_id = null;
        PCAuthorizationBatchResultsResponseTmp.transaction_status = null;
        PCAuthorizationBatchResultsResponseTmp.transaction_amount = null;
        PCAuthorizationBatchResultsResponseTmp.masked_account_number = null;
        PCAuthorizationBatchResultsResponseTmp.return_code = null;
        PCAuthorizationBatchResultsResponseTmp.return_detail = null;
        PCAuthorizationBatchResultsResponseTmp.transaction_date = null;
        PCAuthorizationBatchResultsResponseTmp.account_holder_name = null;
        PCAuthorizationBatchResultsResponseTmp.approval_code = null;
        PCAuthorizationBatchResultsResponseTmp.auth_response_code = null;
        PCAuthorizationBatchResultsResponseTmp.auth_response_text = null;
        PCAuthorizationBatchResultsResponseTmp.avs_response_code = null;
        PCAuthorizationBatchResultsResponseTmp.csc_result = null;

        PayGovTCSSingleQueryService.PCManualAuthorizationBatchResultsResponse PCManualAuthorizationBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCManualAuthorizationBatchResultsResponse();
        PCManualAuthorizationBatchResultsResponseTmp.agency_tracking_id = null;
        PCManualAuthorizationBatchResultsResponseTmp.paygov_tracking_id = null;
        PCManualAuthorizationBatchResultsResponseTmp.transaction_status = null;
        PCManualAuthorizationBatchResultsResponseTmp.transaction_amount = null;
        PCManualAuthorizationBatchResultsResponseTmp.masked_account_number = null;
        PCManualAuthorizationBatchResultsResponseTmp.return_code = null;
        PCManualAuthorizationBatchResultsResponseTmp.return_detail = null;
        PCManualAuthorizationBatchResultsResponseTmp.transaction_date = null;
        PCManualAuthorizationBatchResultsResponseTmp.account_holder_name = null;
        PCManualAuthorizationBatchResultsResponseTmp.approval_code = null;

        PayGovTCSSingleQueryService.PCCancelBatchResultsResponse PCCancelBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCCancelBatchResultsResponse();
        PCCancelBatchResultsResponseTmp.agency_tracking_id = null;
        PCCancelBatchResultsResponseTmp.paygov_tracking_id = null;
        PCCancelBatchResultsResponseTmp.transaction_status = null;
        PCCancelBatchResultsResponseTmp.transaction_amount = null;
        PCCancelBatchResultsResponseTmp.masked_account_number = null;
        PCCancelBatchResultsResponseTmp.return_code = null;
        PCCancelBatchResultsResponseTmp.return_detail = null;
        PCCancelBatchResultsResponseTmp.transaction_date = null;
        PCCancelBatchResultsResponseTmp.account_holder_name = null;
        PCCancelBatchResultsResponseTmp.orig_paygov_tracking_id = null;

        PayGovTCSSingleQueryService.query_custom_fields query_custom_fieldsTmp = new PayGovTCSSingleQueryService.query_custom_fields();
        query_custom_fieldsTmp.custom_field_1 = null;
        query_custom_fieldsTmp.custom_field_2 = null;
        query_custom_fieldsTmp.custom_field_3 = null;
        query_custom_fieldsTmp.custom_field_4 = null;
        query_custom_fieldsTmp.custom_field_5 = null;
        query_custom_fieldsTmp.custom_field_6 = null;
        query_custom_fieldsTmp.custom_field_7 = null;
        query_custom_fieldsTmp.custom_field_8 = null;
        query_custom_fieldsTmp.custom_field_9 = null;
        query_custom_fieldsTmp.custom_field_10 = null;
        query_custom_fieldsTmp.custom_field_11 = null;
        query_custom_fieldsTmp.custom_field_12 = null;

        PayGovTCSSingleQueryService.tcs_batch_results_response tcs_batch_results_responseTmp = new PayGovTCSSingleQueryService.tcs_batch_results_response();
        tcs_batch_results_responseTmp.agency_id = null;
        tcs_batch_results_responseTmp.tcs_app_id = null;
        tcs_batch_results_responseTmp.app_batch_id = null;
        tcs_batch_results_responseTmp.paygov_batch_id = null;
        tcs_batch_results_responseTmp.batch_create_date = null;
        tcs_batch_results_responseTmp.net_amount = null;
        tcs_batch_results_responseTmp.total_amount = null;
        tcs_batch_results_responseTmp.transaction_count = null;
        tcs_batch_results_responseTmp.batch_status = null;
        tcs_batch_results_responseTmp.return_code = null;
        tcs_batch_results_responseTmp.return_detail = null;
        tcs_batch_results_responseTmp.batch_results = null;

        PayGovTCSSingleQueryService.PCForceBatchResultsResponse PCForceBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCForceBatchResultsResponse();
        PCForceBatchResultsResponseTmp.agency_tracking_id = null;
        PCForceBatchResultsResponseTmp.paygov_tracking_id = null;
        PCForceBatchResultsResponseTmp.transaction_status = null;
        PCForceBatchResultsResponseTmp.transaction_amount = null;
        PCForceBatchResultsResponseTmp.masked_account_number = null;
        PCForceBatchResultsResponseTmp.return_code = null;
        PCForceBatchResultsResponseTmp.return_detail = null;
        PCForceBatchResultsResponseTmp.transaction_date = null;
        PCForceBatchResultsResponseTmp.account_holder_name = null;
        PCForceBatchResultsResponseTmp.approval_code = null;
        PCForceBatchResultsResponseTmp.orig_paygov_tracking_id = null;

        PayGovTCSSingleQueryService.tcs_query_result tcs_query_resultTmp = new PayGovTCSSingleQueryService.tcs_query_result();
        tcs_query_resultTmp.agency_id = null;
        tcs_query_resultTmp.tcs_app_id = null;
        tcs_query_resultTmp.agency_tracking_id = null;
        tcs_query_resultTmp.paygov_tracking_id = null;
        tcs_query_resultTmp.recurring_payment_number = null;
        tcs_query_resultTmp.return_code = null;
        tcs_query_resultTmp.return_detail = null;
        tcs_query_resultTmp.tcs_pc_results = null;
        tcs_query_resultTmp.tcs_ach_results = null;

        PayGovTCSSingleQueryService.PCSaleBatchResultsResponse PCSaleBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCSaleBatchResultsResponse();
        PCSaleBatchResultsResponseTmp.agency_tracking_id = null;
        PCSaleBatchResultsResponseTmp.paygov_tracking_id = null;
        PCSaleBatchResultsResponseTmp.transaction_status = null;
        PCSaleBatchResultsResponseTmp.transaction_amount = null;
        PCSaleBatchResultsResponseTmp.masked_account_number = null;
        PCSaleBatchResultsResponseTmp.return_code = null;
        PCSaleBatchResultsResponseTmp.return_detail = null;
        PCSaleBatchResultsResponseTmp.transaction_date = null;
        PCSaleBatchResultsResponseTmp.account_holder_name = null;
        PCSaleBatchResultsResponseTmp.approval_code = null;
        PCSaleBatchResultsResponseTmp.auth_response_code = null;
        PCSaleBatchResultsResponseTmp.auth_response_text = null;
        PCSaleBatchResultsResponseTmp.avs_response_code = null;
        PCSaleBatchResultsResponseTmp.csc_result = null;

        PayGovTCSSingleQueryService.tcs_ach_results tcs_ach_resultsTmp = new PayGovTCSSingleQueryService.tcs_ach_results();
        tcs_ach_resultsTmp.ach_debit_query_response = null;
        tcs_ach_resultsTmp.ach_prenotification_query_response = null;
        tcs_ach_resultsTmp.ach_cancel_query_response = null;

        PayGovTCSSingleQueryService.classification classificationTmp = new PayGovTCSSingleQueryService.classification();
        classificationTmp.classification_data = null;

        PayGovTCSSingleQueryService.ACHCancelQueryResponse ACHCancelQueryResponseTmp = new PayGovTCSSingleQueryService.ACHCancelQueryResponse();
        ACHCancelQueryResponseTmp.agency_tracking_id = null;
        ACHCancelQueryResponseTmp.paygov_tracking_id = null;
        ACHCancelQueryResponseTmp.transaction_status = null;
        ACHCancelQueryResponseTmp.transaction_amount = null;
        ACHCancelQueryResponseTmp.masked_account_number = null;
        ACHCancelQueryResponseTmp.custom_fields = null;
        ACHCancelQueryResponseTmp.return_code = null;
        ACHCancelQueryResponseTmp.return_detail = null;
        ACHCancelQueryResponseTmp.account_holder_name = null;
        ACHCancelQueryResponseTmp.account_holder_email_address = null;
        ACHCancelQueryResponseTmp.transaction_date = null;
        ACHCancelQueryResponseTmp.account_type = null;
        ACHCancelQueryResponseTmp.effective_date = null;
        ACHCancelQueryResponseTmp.routing_transit_number = null;
        ACHCancelQueryResponseTmp.sec_code = null;
        ACHCancelQueryResponseTmp.return_reason_code = null;
        ACHCancelQueryResponseTmp.deposit_ticket_number = null;
        ACHCancelQueryResponseTmp.debit_voucher_number = null;
        ACHCancelQueryResponseTmp.app_batch_id = null;

        PayGovTCSSingleQueryService.classificationDataType classificationDataTypeTmp = new PayGovTCSSingleQueryService.classificationDataType();
        classificationDataTypeTmp.classification_id = null;
        classificationDataTypeTmp.amount = null;

        PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse PCManualAuthorizationQueryResponseTmp = new PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse();
        PCManualAuthorizationQueryResponseTmp.agency_tracking_id = null;
        PCManualAuthorizationQueryResponseTmp.paygov_tracking_id = null;
        PCManualAuthorizationQueryResponseTmp.transaction_status = null;
        PCManualAuthorizationQueryResponseTmp.transaction_amount = null;
        PCManualAuthorizationQueryResponseTmp.masked_account_number = null;
        PCManualAuthorizationQueryResponseTmp.custom_fields = null;
        PCManualAuthorizationQueryResponseTmp.return_code = null;
        PCManualAuthorizationQueryResponseTmp.return_detail = null;
        PCManualAuthorizationQueryResponseTmp.account_holder_name = null;
        PCManualAuthorizationQueryResponseTmp.account_holder_email_address = null;
        PCManualAuthorizationQueryResponseTmp.transaction_date = null;
        PCManualAuthorizationQueryResponseTmp.billing_info = null;
        PCManualAuthorizationQueryResponseTmp.approval_code = null;
        PCManualAuthorizationQueryResponseTmp.app_batch_id = null;

        PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse ACHPrenotificationQueryResponseTmp = new PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse();
        ACHPrenotificationQueryResponseTmp.agency_tracking_id = null;
        ACHPrenotificationQueryResponseTmp.paygov_tracking_id = null;
        ACHPrenotificationQueryResponseTmp.transaction_status = null;
        ACHPrenotificationQueryResponseTmp.transaction_amount = null;
        ACHPrenotificationQueryResponseTmp.masked_account_number = null;
        ACHPrenotificationQueryResponseTmp.custom_fields = null;
        ACHPrenotificationQueryResponseTmp.return_code = null;
        ACHPrenotificationQueryResponseTmp.return_detail = null;
        ACHPrenotificationQueryResponseTmp.account_holder_name = null;
        ACHPrenotificationQueryResponseTmp.account_holder_email_address = null;
        ACHPrenotificationQueryResponseTmp.transaction_date = null;
        ACHPrenotificationQueryResponseTmp.account_type = null;
        ACHPrenotificationQueryResponseTmp.effective_date = null;
        ACHPrenotificationQueryResponseTmp.routing_transit_number = null;
        ACHPrenotificationQueryResponseTmp.sec_code = null;
        ACHPrenotificationQueryResponseTmp.return_reason_code = null;
        ACHPrenotificationQueryResponseTmp.deposit_ticket_number = null;
        ACHPrenotificationQueryResponseTmp.debit_voucher_number = null;
        ACHPrenotificationQueryResponseTmp.app_batch_id = null;

        PayGovTCSSingleQueryService.level_2_element level_2_elementTmp = new PayGovTCSSingleQueryService.level_2_element();
        level_2_elementTmp.dest_country = null;
        level_2_elementTmp.dest_zip = null;
        level_2_elementTmp.duty_amount = null;
        level_2_elementTmp.from_zip = null;
        level_2_elementTmp.order_date = null;
        level_2_elementTmp.tax_amount = null;

        PayGovTCSSingleQueryService.custom_fields custom_fieldsTmp = new PayGovTCSSingleQueryService.custom_fields();
        custom_fieldsTmp.custom_field_1 = null;
        custom_fieldsTmp.custom_field_2 = null;
        custom_fieldsTmp.custom_field_3 = null;
        custom_fieldsTmp.custom_field_4 = null;
        custom_fieldsTmp.custom_field_5 = null;
        custom_fieldsTmp.custom_field_6 = null;
        custom_fieldsTmp.custom_field_7 = null;
        custom_fieldsTmp.custom_field_8 = null;
        custom_fieldsTmp.custom_field_9 = null;
        custom_fieldsTmp.custom_field_10 = null;
        custom_fieldsTmp.custom_field_11 = null;
        custom_fieldsTmp.custom_field_12 = null;

        PayGovTCSSingleQueryService.address addressTmp = new PayGovTCSSingleQueryService.address();
        addressTmp.billing_address = null;
        addressTmp.billing_address_2 = null;
        addressTmp.billing_city = null;
        addressTmp.billing_state = null;
        addressTmp.billing_zip = null;
        addressTmp.billing_country = null;

        PayGovTCSSingleQueryService.tcs_multiple_item_query_response tcs_multiple_item_query_responseTmp = new PayGovTCSSingleQueryService.tcs_multiple_item_query_response();
        tcs_multiple_item_query_responseTmp.agency_id = null;
        tcs_multiple_item_query_responseTmp.tcs_app_id = null;
        tcs_multiple_item_query_responseTmp.start_date_time = null;
        tcs_multiple_item_query_responseTmp.duration = null;
        tcs_multiple_item_query_responseTmp.app_batch_id = null;
        tcs_multiple_item_query_responseTmp.paygov_batch_id = null;
        tcs_multiple_item_query_responseTmp.return_code = null;
        tcs_multiple_item_query_responseTmp.return_detail = null;
        tcs_multiple_item_query_responseTmp.tcs_pc_results = null;
        tcs_multiple_item_query_responseTmp.tcs_ach_results = null;
        tcs_multiple_item_query_responseTmp.failed_results = null;

        PayGovTCSSingleQueryService.error_message error_messageTmp = new PayGovTCSSingleQueryService.error_message();
        error_messageTmp.message_id = null;
        error_messageTmp.message_description = null;

        PayGovTCSSingleQueryService.mastercardLevel3Type mastercardLevel3TypeTmp = new PayGovTCSSingleQueryService.mastercardLevel3Type();
        mastercardLevel3TypeTmp.discount_indicator = null;
        mastercardLevel3TypeTmp.discount_amount = null;
        mastercardLevel3TypeTmp.alternate_tax_identifier = null;
        mastercardLevel3TypeTmp.product_code = null;
        mastercardLevel3TypeTmp.item_descriptor = null;
        mastercardLevel3TypeTmp.item_quantity = null;
        mastercardLevel3TypeTmp.unit_of_measure = null;
        mastercardLevel3TypeTmp.unit_cost = null;
        mastercardLevel3TypeTmp.net_indicator = null;
        mastercardLevel3TypeTmp.db_cr_indicator = null;
        mastercardLevel3TypeTmp.type_of_supply = null;
        mastercardLevel3TypeTmp.item_commodity_code = null;

        PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType CustomCollectionLabelAndFieldTypeTmp = new PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType();
        CustomCollectionLabelAndFieldTypeTmp.label = null;
        CustomCollectionLabelAndFieldTypeTmp.value = null;

        PayGovTCSSingleQueryService.ACHPrenotificationBatchResultsResponse ACHPrenotificationBatchResultsResponseTmp = new PayGovTCSSingleQueryService.ACHPrenotificationBatchResultsResponse();
        ACHPrenotificationBatchResultsResponseTmp.agency_tracking_id = null;
        ACHPrenotificationBatchResultsResponseTmp.paygov_tracking_id = null;
        ACHPrenotificationBatchResultsResponseTmp.transaction_status = null;
        ACHPrenotificationBatchResultsResponseTmp.transaction_amount = null;
        ACHPrenotificationBatchResultsResponseTmp.masked_account_number = null;
        ACHPrenotificationBatchResultsResponseTmp.return_code = null;
        ACHPrenotificationBatchResultsResponseTmp.return_detail = null;
        ACHPrenotificationBatchResultsResponseTmp.transaction_date = null;
        ACHPrenotificationBatchResultsResponseTmp.account_holder_name = null;
        ACHPrenotificationBatchResultsResponseTmp.effective_date = null;

        PayGovTCSSingleQueryService.PCRefundBatchResultsResponse PCRefundBatchResultsResponseTmp = new PayGovTCSSingleQueryService.PCRefundBatchResultsResponse();
        PCRefundBatchResultsResponseTmp.agency_tracking_id = null;
        PCRefundBatchResultsResponseTmp.paygov_tracking_id = null;
        PCRefundBatchResultsResponseTmp.transaction_status = null;
        PCRefundBatchResultsResponseTmp.transaction_amount = null;
        PCRefundBatchResultsResponseTmp.masked_account_number = null;
        PCRefundBatchResultsResponseTmp.return_code = null;
        PCRefundBatchResultsResponseTmp.return_detail = null;
        PCRefundBatchResultsResponseTmp.transaction_date = null;
        PCRefundBatchResultsResponseTmp.account_holder_name = null;
        PCRefundBatchResultsResponseTmp.orig_paygov_tracking_id = null;

        PayGovTCSSingleQueryService.ACHDebitQueryResponse ACHDebitQueryResponseTmp = new PayGovTCSSingleQueryService.ACHDebitQueryResponse();
        ACHDebitQueryResponseTmp.agency_tracking_id = null;
        ACHDebitQueryResponseTmp.paygov_tracking_id = null;
        ACHDebitQueryResponseTmp.transaction_status = null;
        ACHDebitQueryResponseTmp.transaction_amount = null;
        ACHDebitQueryResponseTmp.masked_account_number = null;
        ACHDebitQueryResponseTmp.custom_fields = null;
        ACHDebitQueryResponseTmp.return_code = null;
        ACHDebitQueryResponseTmp.return_detail = null;
        ACHDebitQueryResponseTmp.account_holder_name = null;
        ACHDebitQueryResponseTmp.account_holder_email_address = null;
        ACHDebitQueryResponseTmp.transaction_date = null;
        ACHDebitQueryResponseTmp.account_type = null;
        ACHDebitQueryResponseTmp.effective_date = null;
        ACHDebitQueryResponseTmp.routing_transit_number = null;
        ACHDebitQueryResponseTmp.sec_code = null;
        ACHDebitQueryResponseTmp.return_reason_code = null;
        ACHDebitQueryResponseTmp.deposit_ticket_number = null;
        ACHDebitQueryResponseTmp.debit_voucher_number = null;
        ACHDebitQueryResponseTmp.installment_number = null;
        ACHDebitQueryResponseTmp.total_installments = null;
        ACHDebitQueryResponseTmp.payment_frequency = null;
        ACHDebitQueryResponseTmp.app_batch_id = null;


    PayGovTCSSingleQueryService.tcs_query_single_request tcs_query_single_requestTmp = new PayGovTCSSingleQueryService.tcs_query_single_request();
        tcs_query_single_requestTmp.agency_id = null;
        tcs_query_single_requestTmp.tcs_app_id = null;
        tcs_query_single_requestTmp.agency_tracking_id = null;
        tcs_query_single_requestTmp.paygov_tracking_id = null;
        tcs_query_single_requestTmp.recurring_payment_number = null;
        
    PayGovTCSSingleQueryService.baseLineItemType baseLineItemTypeTmp = new PayGovTCSSingleQueryService.baseLineItemType();
        
    PayGovTCSSingleQueryService.amexLevel3Type amexLevel3TypeTmp = new PayGovTCSSingleQueryService.amexLevel3Type();
        amexLevel3TypeTmp.item_descriptor = null;
        amexLevel3TypeTmp.item_quantity = null;
        amexLevel3TypeTmp.unit_cost = null;
        
    PayGovTCSSingleQueryService.ACHCancelBatchResultsResponse ACHCancelBatchResultsResponseTmp = new PayGovTCSSingleQueryService.ACHCancelBatchResultsResponse();
        ACHCancelBatchResultsResponseTmp.agency_tracking_id = null;
        ACHCancelBatchResultsResponseTmp.paygov_tracking_id = null;
        ACHCancelBatchResultsResponseTmp.transaction_status = null;
        ACHCancelBatchResultsResponseTmp.transaction_amount = null;
        ACHCancelBatchResultsResponseTmp.masked_account_number = null;
        ACHCancelBatchResultsResponseTmp.return_code = null;
        ACHCancelBatchResultsResponseTmp.return_detail = null;
        ACHCancelBatchResultsResponseTmp.transaction_date = null;
        ACHCancelBatchResultsResponseTmp.account_holder_name = null;
        ACHCancelBatchResultsResponseTmp.effective_date = null;
        ACHCancelBatchResultsResponseTmp.orig_paygov_tracking_id = null;
        
    PayGovTCSSingleQueryService.FailedTransactionQueryResponse FailedTransactionQueryResponseTmp = new PayGovTCSSingleQueryService.FailedTransactionQueryResponse();
        FailedTransactionQueryResponseTmp.agency_tracking_id = null;
        FailedTransactionQueryResponseTmp.paygov_tracking_id = null;
        FailedTransactionQueryResponseTmp.return_code = null;
        FailedTransactionQueryResponseTmp.return_detail = null;
        
    PayGovTCSSingleQueryService.tcsBatchItems tcsBatchItemsTmp = new PayGovTCSSingleQueryService.tcsBatchItems();
        tcsBatchItemsTmp.ach_debit_query_response = null;
        tcsBatchItemsTmp.ach_prenotification_query_response = null;
        tcsBatchItemsTmp.ach_cancel_query_response = null;
        tcsBatchItemsTmp.pc_authorization_query_response = null;
        tcsBatchItemsTmp.pc_refund_with_paygov_tracking_id_query_response = null;
        tcsBatchItemsTmp.pc_refund_without_paygov_tracking_id_query_response = null;
        tcsBatchItemsTmp.pc_force_query_response = null;
        tcsBatchItemsTmp.pc_force_without_paygov_tracking_id_query_response = null;
        tcsBatchItemsTmp.pc_manual_authorization_query_response = null;
        tcsBatchItemsTmp.pc_sale_query_response = null;
        tcsBatchItemsTmp.pc_cancel_query_response = null;
        tcsBatchItemsTmp.failed_results = null;
        
    PayGovTCSSingleQueryService.order_level3_data order_level3_dataTmp = new PayGovTCSSingleQueryService.order_level3_data();
        order_level3_dataTmp.level_2 = null;
        order_level3_dataTmp.line_item = null;

    PayGovTCSSingleQueryService.tcs_batch_results_request tcs_batch_results_requestTmp = new PayGovTCSSingleQueryService.tcs_batch_results_request();
        tcs_batch_results_requestTmp.agency_id = null;
        tcs_batch_results_requestTmp.tcs_app_id = null;
        tcs_batch_results_requestTmp.app_batch_id = null;
        tcs_batch_results_requestTmp.paygov_batch_id = null;
        
    PayGovTCSSingleQueryService.PCCancelQueryResponse PCCancelQueryResponseTmp = new PayGovTCSSingleQueryService.PCCancelQueryResponse();
        PCCancelQueryResponseTmp.agency_tracking_id = null;
        PCCancelQueryResponseTmp.paygov_tracking_id = null;
        PCCancelQueryResponseTmp.transaction_status = null;
        PCCancelQueryResponseTmp.transaction_amount = null;
        PCCancelQueryResponseTmp.masked_account_number = null;
        PCCancelQueryResponseTmp.custom_fields = null;
        PCCancelQueryResponseTmp.return_code = null;
        PCCancelQueryResponseTmp.return_detail = null;
        PCCancelQueryResponseTmp.account_holder_name = null;
        PCCancelQueryResponseTmp.account_holder_email_address = null;
        PCCancelQueryResponseTmp.transaction_date = null;
        PCCancelQueryResponseTmp.billing_info = null;
        PCCancelQueryResponseTmp.app_batch_id = null;
        
    PayGovTCSSingleQueryService.PCForceQueryResponse PCForceQueryResponseTmp = new PayGovTCSSingleQueryService.PCForceQueryResponse();
        PCForceQueryResponseTmp.agency_tracking_id = null;
        PCForceQueryResponseTmp.paygov_tracking_id = null;
        PCForceQueryResponseTmp.transaction_status = null;
        PCForceQueryResponseTmp.transaction_amount = null;
        PCForceQueryResponseTmp.masked_account_number = null;
        PCForceQueryResponseTmp.custom_fields = null;
        PCForceQueryResponseTmp.return_code = null;
        PCForceQueryResponseTmp.return_detail = null;
        PCForceQueryResponseTmp.account_holder_name = null;
        PCForceQueryResponseTmp.account_holder_email_address = null;
        PCForceQueryResponseTmp.transaction_date = null;
        PCForceQueryResponseTmp.billing_info = null;
        PCForceQueryResponseTmp.approval_code = null;
        PCForceQueryResponseTmp.app_batch_id = null;
        
    PayGovTCSSingleQueryService.PCRefundQueryResponse PCRefundQueryResponseTmp = new PayGovTCSSingleQueryService.PCRefundQueryResponse();
        PCRefundQueryResponseTmp.agency_tracking_id = null;
        PCRefundQueryResponseTmp.paygov_tracking_id = null;
        PCRefundQueryResponseTmp.transaction_status = null;
        PCRefundQueryResponseTmp.transaction_amount = null;
        PCRefundQueryResponseTmp.masked_account_number = null;
        PCRefundQueryResponseTmp.custom_fields = null;
        PCRefundQueryResponseTmp.return_code = null;
        PCRefundQueryResponseTmp.return_detail = null;
        PCRefundQueryResponseTmp.account_holder_name = null;
        PCRefundQueryResponseTmp.account_holder_email_address = null;
        PCRefundQueryResponseTmp.transaction_date = null;
        PCRefundQueryResponseTmp.billing_info = null;
        PCRefundQueryResponseTmp.app_batch_id = null;
        
    PayGovTCSSingleQueryService.PCAuthorizationQueryResponse PCAuthorizationQueryResponseTmp = new PayGovTCSSingleQueryService.PCAuthorizationQueryResponse();
        PCAuthorizationQueryResponseTmp.agency_tracking_id = null;
        PCAuthorizationQueryResponseTmp.paygov_tracking_id = null;
        PCAuthorizationQueryResponseTmp.transaction_status = null;
        PCAuthorizationQueryResponseTmp.transaction_amount = null;
        PCAuthorizationQueryResponseTmp.masked_account_number = null;
        PCAuthorizationQueryResponseTmp.custom_fields = null;
        PCAuthorizationQueryResponseTmp.return_code = null;
        PCAuthorizationQueryResponseTmp.return_detail = null;
        PCAuthorizationQueryResponseTmp.account_holder_name = null;
        PCAuthorizationQueryResponseTmp.account_holder_email_address = null;
        PCAuthorizationQueryResponseTmp.transaction_date = null;
        PCAuthorizationQueryResponseTmp.billing_info = null;
        PCAuthorizationQueryResponseTmp.approval_code = null;
        PCAuthorizationQueryResponseTmp.auth_response_code = null;
        PCAuthorizationQueryResponseTmp.auth_response_text = null;
        PCAuthorizationQueryResponseTmp.avs_response_code = null;
        PCAuthorizationQueryResponseTmp.csc_result = null;
        PCAuthorizationQueryResponseTmp.app_batch_id = null;
    }
    
    static testmethod void test1() {

    PayGovTCSSingleService.baseLineItemType tmp = new PayGovTCSSingleService.baseLineItemType();
    }
    static testmethod void test2() {
        
    PayGovTCSSingleService.amexLevel3Type tmp = new PayGovTCSSingleService.amexLevel3Type();
        tmp.item_descriptor = null;
        tmp.item_quantity = null;
        tmp.unit_cost = null;
    }
    static testmethod void test3() {
        
    PayGovTCSSingleService.PCAuthorizationResponse_element tmp = new PayGovTCSSingleService.PCAuthorizationResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCAuthorization = null;
    }
    static testmethod void test4() {
        
    PayGovTCSSingleService.PCManualAuthorizationResponse_element tmp = new PayGovTCSSingleService.PCManualAuthorizationResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCManualAuthorization = null;
    }
    static testmethod void test5() {
        
    PayGovTCSSingleService.ACHPrenotificationRequest_element tmp = new PayGovTCSSingleService.ACHPrenotificationRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHPrenotification = null;
    }
    static testmethod void test6() {
        
    PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequestType tmp = new PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequestType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.account_number = null;
        tmp.credit_card_expiration_date = null;
        tmp.business_name = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
        tmp.order_id = null;
        tmp.order_tax_amount = null;
        tmp.order_level3_data = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
    }
    static testmethod void test7() {

    PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequestType tmp = new PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequestType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.account_number = null;
        tmp.credit_card_expiration_date = null;
        tmp.approval_code = null;
        tmp.business_name = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
        tmp.order_id = null;
        tmp.order_tax_amount = null;
        tmp.order_level3_data = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
        tmp.classification = null;
    }
    static testmethod void test8() {

    PayGovTCSSingleService.PCCancelResponseType tmp = new PayGovTCSSingleService.PCCancelResponseType();
        tmp.orig_paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
    }
    static testmethod void test9() {

    PayGovTCSSingleService.PCCancelRequestType tmp = new PayGovTCSSingleService.PCCancelRequestType();
        tmp.orig_paygov_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.agency_tracking_id = null;
        tmp.account_holder_email_address = null;
    }
    static testmethod void test10() {
        
    PayGovTCSSingleService.PCForceResponse_element tmp = new PayGovTCSSingleService.PCForceResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCForce = null;
    }
    static testmethod void test11() {
        
    PayGovTCSSingleService.PCForceRequestType tmp = new PayGovTCSSingleService.PCForceRequestType();
        tmp.orig_paygov_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.orig_agency_tracking_id = null;
        tmp.classification = null;
    }
    static testmethod void test12() {
        
    PayGovTCSSingleService.PCSaleResponse_element tmp = new PayGovTCSSingleService.PCSaleResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCSale = null;
    }
    static testmethod void test13() {
        
    PayGovTCSSingleService.PCManualAuthorizationRequest_element tmp = new PayGovTCSSingleService.PCManualAuthorizationRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCManualAuthorization = null;
    }
    static testmethod void test14() {
        
    PayGovTCSSingleService.custom_fields tmp = new PayGovTCSSingleService.custom_fields();
        tmp.custom_field_1 = null;
        tmp.custom_field_2 = null;
        tmp.custom_field_3 = null;
        tmp.custom_field_4 = null;
        tmp.custom_field_5 = null;
        tmp.custom_field_6 = null;
        tmp.custom_field_7 = null;
        tmp.custom_field_8 = null;
        tmp.custom_field_9 = null;
        tmp.custom_field_10 = null;
        tmp.custom_field_11 = null;
        tmp.custom_field_12 = null;
    }
    static testmethod void test15() {

    PayGovTCSSingleService.level_2_element tmp = new PayGovTCSSingleService.level_2_element();
        tmp.dest_country = null;
        tmp.dest_zip = null;
        tmp.duty_amount = null;
        tmp.from_zip = null;
        tmp.order_date = null;
        tmp.tax_amount = null;
    }
    static testmethod void test16() {
        
    PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequest_element tmp = new PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCRefundWithoutPaygovTrackingId = null;
    }
    static testmethod void test17() {
        
    PayGovTCSSingleService.ACHDebitResponseType tmp = new PayGovTCSSingleService.ACHDebitResponseType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.effective_date = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.paygov_tracking_id = null;
    }
    static testmethod void test18() {

    PayGovTCSSingleService.classification tmp = new PayGovTCSSingleService.classification();
        tmp.classification_data = null;
    }
    static testmethod void test19() {
        
    PayGovTCSSingleService.PCForceResponseType tmp = new PayGovTCSSingleService.PCForceResponseType();
        tmp.orig_paygov_tracking_id = null;
        tmp.orig_agency_tracking_id = null;
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
    }
    static testmethod void test20() {

    PayGovTCSSingleService.ACHCancelResponse_element tmp = new PayGovTCSSingleService.ACHCancelResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHCancel = null;
    }
    static testmethod void test21() {
        
    PayGovTCSSingleService.ACHDebitRequest_element tmp = new PayGovTCSSingleService.ACHDebitRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHDebit = null;
    }
    static testmethod void test22() {
        
    PayGovTCSSingleService.ACHCancelRequest_element tmp = new PayGovTCSSingleService.ACHCancelRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHCancel = null;
    }
    static testmethod void test23() {
        
    PayGovTCSSingleService.query_custom_fields tmp = new PayGovTCSSingleService.query_custom_fields();
        tmp.custom_field_1 = null;
        tmp.custom_field_2 = null;
        tmp.custom_field_3 = null;
        tmp.custom_field_4 = null;
        tmp.custom_field_5 = null;
        tmp.custom_field_6 = null;
        tmp.custom_field_7 = null;
        tmp.custom_field_8 = null;
        tmp.custom_field_9 = null;
        tmp.custom_field_10 = null;
        tmp.custom_field_11 = null;
        tmp.custom_field_12 = null;
    }
    static testmethod void test24() {

    PayGovTCSSingleService.ACHCancelResponseType tmp = new PayGovTCSSingleService.ACHCancelResponseType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.effective_date = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.orig_paygov_tracking_id = null;
    }
    static testmethod void test25() {

    PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponseType tmp = new PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponseType();
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
    }
    static testmethod void test26() {

    PayGovTCSSingleService.visaLevel3Type tmp = new PayGovTCSSingleService.visaLevel3Type();
        tmp.discount_indicator = null;
        tmp.discount_amount = null;
        tmp.alternate_tax_identifier = 0;
        tmp.product_code = null;
        tmp.item_descriptor = null;
        tmp.item_quantity = null;
        tmp.unit_of_measure = null;
        tmp.unit_cost = null;
        tmp.net_indicator = null;
        tmp.db_cr_indicator = null;
        tmp.type_of_supply = null;
        tmp.item_commodity_code = null;
    }
    static testmethod void test27() {

    PayGovTCSSingleService.PCAuthorizationRequestType tmp = new PayGovTCSSingleService.PCAuthorizationRequestType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.account_number = null;
        tmp.credit_card_expiration_date = null;
        tmp.business_name = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.card_security_code = null;
        tmp.credit_card_track2 = null;
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
        tmp.order_id = null;
        tmp.order_tax_amount = null;
        tmp.order_level3_data = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
    }
    static testmethod void test28() {

    PayGovTCSSingleService.PCCancelRequest_element tmp = new PayGovTCSSingleService.PCCancelRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCCancel = null;
    }
    static testmethod void test29() {
        
    PayGovTCSSingleService.ach_payment_options tmp = new PayGovTCSSingleService.ach_payment_options();
        tmp.payment_frequency = null;
        tmp.payment_date = null;
        tmp.total_installments = null;
    }
    static testmethod void test30() {
        
    PayGovTCSSingleService.ACHDebitResponse_element tmp = new PayGovTCSSingleService.ACHDebitResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHDebit = null;
    }
    static testmethod void test31() {
        
    PayGovTCSSingleService.ACHDebitRequestType tmp = new PayGovTCSSingleService.ACHDebitRequestType();
        tmp.agency_tracking_id = null;
        tmp.account_number = null;
        tmp.routing_transit_number = null;
        tmp.account_type = null;
        tmp.transaction_amount = null;
        tmp.payment_options = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.business_name = null;
        tmp.check_number = null;
        tmp.sec_code = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
        tmp.classification = null;
    }
    static testmethod void test32() {

    PayGovTCSSingleService.PCSaleResponseType tmp = new PayGovTCSSingleService.PCSaleResponseType();
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.approval_code = null;
        tmp.auth_response_code = null;
        tmp.auth_response_text = null;
        tmp.avs_response_code = null;
        tmp.csc_result = null;
        tmp.authorized_amount = null;
        tmp.remaining_balance = null;
    }
    static testmethod void test33() {

    PayGovTCSSingleService.order_level3_data tmp = new PayGovTCSSingleService.order_level3_data();
        tmp.level_2 = null;
        tmp.line_item = null;
    }
    static testmethod void test34() {
        
    PayGovTCSSingleService.PCManualAuthorizationResponseType tmp = new PayGovTCSSingleService.PCManualAuthorizationResponseType();
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.authorized_amount = null;
        tmp.remaining_balance = null;
    }
    static testmethod void test35() {

    PayGovTCSSingleService.PCAuthorizationResponseType tmp = new PayGovTCSSingleService.PCAuthorizationResponseType();
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.approval_code = null;
        tmp.auth_response_code = null;
        tmp.auth_response_text = null;
        tmp.avs_response_code = null;
        tmp.csc_result = null;
        tmp.authorized_amount = null;
        tmp.remaining_balance = null;
    }
    static testmethod void test36() {

    PayGovTCSSingleService.PCSaleRequest_element tmp = new PayGovTCSSingleService.PCSaleRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCSale = null;
    }
    static testmethod void test37() {
        
    PayGovTCSSingleService.PCRefundRequestType tmp = new PayGovTCSSingleService.PCRefundRequestType();
        tmp.orig_paygov_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.orig_agency_tracking_id = null;
    }
    static testmethod void test38() {
        
    PayGovTCSSingleService.PCForceRequest_element tmp = new PayGovTCSSingleService.PCForceRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCForce = null;
    }
    static testmethod void test39() {
        
    PayGovTCSSingleService.PCRefundResponseType tmp = new PayGovTCSSingleService.PCRefundResponseType();
        tmp.orig_paygov_tracking_id = null;
        tmp.orig_agency_tracking_id = null;
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
    }
    static testmethod void test40() {

    PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element tmp = new PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCForceWithoutPaygovTrackingId = null;
    }
    static testmethod void test41() {
        
    PayGovTCSSingleService.PCRefundRequest_element tmp = new PayGovTCSSingleService.PCRefundRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCRefund = null;
    }
    static testmethod void test42() {
        
    PayGovTCSSingleService.PCManualAuthorizationRequestType tmp = new PayGovTCSSingleService.PCManualAuthorizationRequestType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.account_number = null;
        tmp.credit_card_expiration_date = null;
        tmp.approval_code = null;
        tmp.business_name = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
        tmp.order_id = null;
        tmp.order_tax_amount = null;
        tmp.order_level3_data = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
    }
    static testmethod void test43() {

    PayGovTCSSingleService.CustomCollectionLabelAndFieldType tmp = new PayGovTCSSingleService.CustomCollectionLabelAndFieldType();
        tmp.label = null;
        tmp.value = null;
    }
    static testmethod void test44() {
        
    PayGovTCSSingleService.mastercardLevel3Type tmp = new PayGovTCSSingleService.mastercardLevel3Type();
        tmp.discount_indicator = null;
        tmp.discount_amount = null;
        tmp.alternate_tax_identifier = null;
        tmp.product_code = null;
        tmp.item_descriptor = null;
        tmp.item_quantity = null;
        tmp.unit_of_measure = null;
        tmp.unit_cost = null;
        tmp.net_indicator = null;
        tmp.db_cr_indicator = null;
        tmp.type_of_supply = null;
        tmp.item_commodity_code = null;
    }
    static testmethod void test45() {

    PayGovTCSSingleService.ACHCancelRequestType tmp = new PayGovTCSSingleService.ACHCancelRequestType();
        tmp.orig_paygov_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.agency_tracking_id = null;
    }
    static testmethod void test46() {
        
    PayGovTCSSingleService.address tmp = new PayGovTCSSingleService.address();
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
    }
    static testmethod void test47() {
        
    PayGovTCSSingleService.PCAuthorizationRequest_element tmp = new PayGovTCSSingleService.PCAuthorizationRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCAuthorization = null;
    }
    static testmethod void test48() {
        
    PayGovTCSSingleService.PCCancelResponse_element tmp = new PayGovTCSSingleService.PCCancelResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCCancel = null;
    }
    static testmethod void test49() {
        
    PayGovTCSSingleService.classificationDataType tmp = new PayGovTCSSingleService.classificationDataType();
        tmp.classification_id = null;
        tmp.amount = null;
    }
    static testmethod void test50() {
        
    PayGovTCSSingleService.PCSaleRequestType tmp = new PayGovTCSSingleService.PCSaleRequestType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.account_number = null;
        tmp.credit_card_expiration_date = null;
        tmp.business_name = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.card_security_code = null;
        tmp.credit_card_track2 = null;
        tmp.billing_address = null;
        tmp.billing_address_2 = null;
        tmp.billing_city = null;
        tmp.billing_state = null;
        tmp.billing_zip = null;
        tmp.billing_country = null;
        tmp.order_id = null;
        tmp.order_tax_amount = null;
        tmp.order_level3_data = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
        tmp.classification = null;
    }
    static testmethod void test51() {

    PayGovTCSSingleService.PCRefundResponse_element tmp = new PayGovTCSSingleService.PCRefundResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCRefund = null;
    }
    static testmethod void test52() {
        
    PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponseType tmp = new PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponseType();
        tmp.paygov_tracking_id = null;
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
    }
    static testmethod void test53() {

    PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequest_element tmp = new PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequest_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCForceWithoutPaygovTrackingId = null;
    }
    static testmethod void test54() {
        
    PayGovTCSSingleService.ACHPrenotificationResponse_element tmp = new PayGovTCSSingleService.ACHPrenotificationResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.ACHPrenotification = null;
    }
    static testmethod void test55() {
        
    PayGovTCSSingleService.ACHPrenotificationResponseType tmp = new PayGovTCSSingleService.ACHPrenotificationResponseType();
        tmp.agency_tracking_id = null;
        tmp.transaction_amount = null;
        tmp.masked_account_number = null;
        tmp.effective_date = null;
        tmp.return_code = null;
        tmp.return_detail = null;
        tmp.transaction_status = null;
        tmp.transaction_date = null;
        tmp.paygov_tracking_id = null;
    }
    static testmethod void test56() {

    PayGovTCSSingleService.ACHPrenotificationRequestType tmp = new PayGovTCSSingleService.ACHPrenotificationRequestType();
        tmp.agency_tracking_id = null;
        tmp.account_number = null;
        tmp.routing_transit_number = null;
        tmp.account_type = null;
        tmp.transaction_amount = null;
        tmp.first_name = null;
        tmp.middle_initial = null;
        tmp.last_name = null;
        tmp.business_name = null;
        tmp.check_number = null;
        tmp.sec_code = null;
        tmp.custom_fields = null;
        tmp.account_holder_email_address = null;
    }
    static testmethod void test57() {

    PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element tmp = new PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element();
        tmp.agency_id = null;
        tmp.tcs_app_id = null;
        tmp.PCRefundWithoutPaygovTrackingId = null;
    }
    static testmethod void test58() {
        
    PayGovTCSSingleService.TCSSinglePort tmp = new PayGovTCSSingleService.TCSSinglePort();
        tmp.endpoint_x = null;
        tmp.inputHttpHeaders_x = null;
        tmp.outputHttpHeaders_x = null;
        tmp.clientCertName_x = null;
        tmp.clientCert_x = null;
        tmp.clientCertPasswd_x = null;
        tmp.timeout_x = 60000;
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        //tmp.processPCManualAuthorization('','',null);
        tmp.processPCForce(null, null, null);
        tmp.processPCSale(null, null, null);
        tmp.processPCCancel(null, null, null);
        tmp.processPCRefundWithoutPaygovTrackingId(null, null, null);
        tmp.processACHDebit(null, null, null);
        tmp.processPCForceWithoutPaygovTrackingId(null, null, null);
        tmp.processACHCancel(null, null, null);
        tmp.processPCRefund(null, null, null);
        tmp.processACHPrenotification(null, null, null);
        tmp.processPCAuthorization(null, null, null);
    }
}