//Methods to communicate with pay.gov (synchronously)

public class PayGovTCSSingleQueryService {
	@TestVisible private static final String METADATA_SETTINGS_NAME = 'PayGov';

	public class tcs_query_single_request {
		public String agency_id;
		public String tcs_app_id;
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String recurring_payment_number;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] recurring_payment_number_type_info = new String[]{'recurring_payment_number','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','agency_tracking_id','paygov_tracking_id','recurring_payment_number'};
	}
	public class baseLineItemType {
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{};
	}
	public class amexLevel3Type {
		public String item_descriptor;
		public String item_quantity;
		public String unit_cost;
		@TestVisible private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'item_descriptor','item_quantity','unit_cost'};
	}
	public class ACHCancelBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String effective_date;
		public String orig_paygov_tracking_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','effective_date','orig_paygov_tracking_id'};
	}
	public class FailedTransactionQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String return_code;
		public String return_detail;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','return_code','return_detail'};
	}
	public class tcsBatchItems {
		public PayGovTCSSingleQueryService.ACHDebitQueryResponse[] ach_debit_query_response;
		public PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse[] ach_prenotification_query_response;
		public PayGovTCSSingleQueryService.ACHCancelQueryResponse[] ach_cancel_query_response;
		public PayGovTCSSingleQueryService.PCAuthorizationQueryResponse[] pc_authorization_query_response;
		public PayGovTCSSingleQueryService.PCRefundQueryResponse[] pc_refund_with_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCRefundQueryResponse[] pc_refund_without_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCForceQueryResponse[] pc_force_query_response;
		public PayGovTCSSingleQueryService.PCForceQueryResponse[] pc_force_without_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse[] pc_manual_authorization_query_response;
		public PayGovTCSSingleQueryService.PCSaleQueryResponse[] pc_sale_query_response;
		public PayGovTCSSingleQueryService.PCCancelQueryResponse[] pc_cancel_query_response;
		public PayGovTCSSingleQueryService.batchResponseFailedTransaction[] failed_results;
		@TestVisible private String[] ach_debit_query_response_type_info = new String[]{'ach_debit_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] ach_prenotification_query_response_type_info = new String[]{'ach_prenotification_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] ach_cancel_query_response_type_info = new String[]{'ach_cancel_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_authorization_query_response_type_info = new String[]{'pc_authorization_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_refund_with_paygov_tracking_id_query_response_type_info = new String[]{'pc_refund_with_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_refund_without_paygov_tracking_id_query_response_type_info = new String[]{'pc_refund_without_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_force_query_response_type_info = new String[]{'pc_force_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_force_without_paygov_tracking_id_query_response_type_info = new String[]{'pc_force_without_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_manual_authorization_query_response_type_info = new String[]{'pc_manual_authorization_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_sale_query_response_type_info = new String[]{'pc_sale_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_cancel_query_response_type_info = new String[]{'pc_cancel_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] failed_results_type_info = new String[]{'failed_results','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'ach_debit_query_response','ach_prenotification_query_response','ach_cancel_query_response','pc_authorization_query_response','pc_refund_with_paygov_tracking_id_query_response','pc_refund_without_paygov_tracking_id_query_response','pc_force_query_response','pc_force_without_paygov_tracking_id_query_response','pc_manual_authorization_query_response','pc_sale_query_response','pc_cancel_query_response','failed_results'};
	}
	public class order_level3_data {
		public PayGovTCSSingleQueryService.level_2_element level_2;
		public PayGovTCSSingleQueryService.baseLineItemType[] line_item;
		@TestVisible private String[] level_2_type_info = new String[]{'level-2','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] line_item_type_info = new String[]{'line-item','http://fms.treas.gov/tcs/schemas',null,'1','1000','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'level_2','line_item'};
	}
	public class tcs_batch_results_request {
		public String agency_id;
		public String tcs_app_id;
		public String app_batch_id;
		public String paygov_batch_id;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_batch_id_type_info = new String[]{'paygov_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','app_batch_id','paygov_batch_id'};
	}
	public class PCCancelQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','app_batch_id'};
	}
	public class PCForceQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String approval_code;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','approval_code','app_batch_id'};
	}
	public class PCRefundQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','app_batch_id'};
	}
	public class PCAuthorizationQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result','app_batch_id'};
	}
	public class ACHDebitQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public String account_type;
		public String effective_date;
		public String routing_transit_number;
		public String sec_code;
		public String return_reason_code;
		public String deposit_ticket_number;
		public String debit_voucher_number;
		public String installment_number;
		public String total_installments;
		public String payment_frequency;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_type_type_info = new String[]{'account_type','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] routing_transit_number_type_info = new String[]{'routing_transit_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] sec_code_type_info = new String[]{'sec_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_reason_code_type_info = new String[]{'return_reason_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] deposit_ticket_number_type_info = new String[]{'deposit_ticket_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] debit_voucher_number_type_info = new String[]{'debit_voucher_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] installment_number_type_info = new String[]{'installment_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] total_installments_type_info = new String[]{'total_installments','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] payment_frequency_type_info = new String[]{'payment_frequency','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','account_type','effective_date','routing_transit_number','sec_code','return_reason_code','deposit_ticket_number','debit_voucher_number','installment_number','total_installments','payment_frequency','app_batch_id'};
	}
	public class PCRefundBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String orig_paygov_tracking_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','orig_paygov_tracking_id'};
	}
	public class ACHPrenotificationBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String effective_date;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','effective_date'};
	}
	public class CustomCollectionLabelAndFieldType {
		public String label;
		public String value;
		@TestVisible private String[] label_type_info = new String[]{'label','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] value_type_info = new String[]{'value','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'label','value'};
	}
	public class mastercardLevel3Type {
		public String discount_indicator;
		public String discount_amount;
		public Integer alternate_tax_identifier;
		public String product_code;
		public String item_descriptor;
		public String item_quantity;
		public String unit_of_measure;
		public String unit_cost;
		public String net_indicator;
		public String db_cr_indicator;
		public String type_of_supply;
		public String item_commodity_code;
		@TestVisible private String[] discount_indicator_type_info = new String[]{'discount-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] discount_amount_type_info = new String[]{'discount-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] alternate_tax_identifier_type_info = new String[]{'alternate-tax-identifier','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] product_code_type_info = new String[]{'product-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] unit_of_measure_type_info = new String[]{'unit-of-measure','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] net_indicator_type_info = new String[]{'net-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] db_cr_indicator_type_info = new String[]{'db-cr-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] type_of_supply_type_info = new String[]{'type-of-supply','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] item_commodity_code_type_info = new String[]{'item-commodity-code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'discount_indicator','discount_amount','alternate_tax_identifier','product_code','item_descriptor','item_quantity','unit_of_measure','unit_cost','net_indicator','db_cr_indicator','type_of_supply','item_commodity_code'};
	}
	public class error_message {
		public String message_id;
		public String message_description;
		@TestVisible private String[] message_id_type_info = new String[]{'message_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] message_description_type_info = new String[]{'message_description','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'message_id','message_description'};
	}
	public class tcs_multiple_item_query_response {
		public String agency_id;
		public String tcs_app_id;
		public String start_date_time;
		public String duration;
		public String app_batch_id;
		public String paygov_batch_id;
		public String return_code;
		public String return_detail;
		public PayGovTCSSingleQueryService.tcs_plastic_card_results tcs_pc_results;
		public PayGovTCSSingleQueryService.tcs_ach_results tcs_ach_results;
		public PayGovTCSSingleQueryService.batchResponseFailedTransaction[] failed_results;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] start_date_time_type_info = new String[]{'start_date_time','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] duration_type_info = new String[]{'duration','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_batch_id_type_info = new String[]{'paygov_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] tcs_pc_results_type_info = new String[]{'tcs_pc_results','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] tcs_ach_results_type_info = new String[]{'tcs_ach_results','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] failed_results_type_info = new String[]{'failed_results','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','start_date_time','duration','app_batch_id','paygov_batch_id','return_code','return_detail','tcs_pc_results','tcs_ach_results','failed_results'};
	}
	public class address {
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		@TestVisible private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country'};
	}
	public class custom_fields {
		public String custom_field_1;
		public String custom_field_2;
		public String custom_field_3;
		public String custom_field_4;
		public String custom_field_5;
		public String custom_field_6;
		public String custom_field_7;
		public String custom_field_8;
		public String custom_field_9;
		public String custom_field_10;
		public String custom_field_11;
		public String custom_field_12;
		@TestVisible private String[] custom_field_1_type_info = new String[]{'custom_field_1','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_2_type_info = new String[]{'custom_field_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_3_type_info = new String[]{'custom_field_3','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_4_type_info = new String[]{'custom_field_4','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_5_type_info = new String[]{'custom_field_5','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_6_type_info = new String[]{'custom_field_6','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_7_type_info = new String[]{'custom_field_7','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_8_type_info = new String[]{'custom_field_8','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_9_type_info = new String[]{'custom_field_9','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_10_type_info = new String[]{'custom_field_10','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_11_type_info = new String[]{'custom_field_11','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_12_type_info = new String[]{'custom_field_12','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'custom_field_1','custom_field_2','custom_field_3','custom_field_4','custom_field_5','custom_field_6','custom_field_7','custom_field_8','custom_field_9','custom_field_10','custom_field_11','custom_field_12'};
	}
	public class level_2_element {
		public String dest_country;
		public String dest_zip;
		public String duty_amount;
		public String from_zip;
		public String order_date;
		public String tax_amount;
		@TestVisible private String[] dest_country_type_info = new String[]{'dest-country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] dest_zip_type_info = new String[]{'dest-zip','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] duty_amount_type_info = new String[]{'duty-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] from_zip_type_info = new String[]{'from-zip','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] order_date_type_info = new String[]{'order-date','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] tax_amount_type_info = new String[]{'tax-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'dest_country','dest_zip','duty_amount','from_zip','order_date','tax_amount'};
	}
	public class ACHPrenotificationQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public String account_type;
		public String effective_date;
		public String routing_transit_number;
		public String sec_code;
		public String return_reason_code;
		public String deposit_ticket_number;
		public String debit_voucher_number;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_type_type_info = new String[]{'account_type','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] routing_transit_number_type_info = new String[]{'routing_transit_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] sec_code_type_info = new String[]{'sec_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_reason_code_type_info = new String[]{'return_reason_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] deposit_ticket_number_type_info = new String[]{'deposit_ticket_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] debit_voucher_number_type_info = new String[]{'debit_voucher_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','account_type','effective_date','routing_transit_number','sec_code','return_reason_code','deposit_ticket_number','debit_voucher_number','app_batch_id'};
	}
	public class PCManualAuthorizationQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String approval_code;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','approval_code','app_batch_id'};
	}
	public class classificationDataType {
		public String classification_id;
		public String amount;
		@TestVisible private String[] classification_id_att_info = new String[]{'classification_id'};
		@TestVisible private String[] amount_att_info = new String[]{'amount'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{};
	}
	public class ACHRefundWithPaygovTrackingIDResultsResponse {
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{};
	}
	public class ACHCancelQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public String account_type;
		public String effective_date;
		public String routing_transit_number;
		public String sec_code;
		public String return_reason_code;
		public String deposit_ticket_number;
		public String debit_voucher_number;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_type_type_info = new String[]{'account_type','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] routing_transit_number_type_info = new String[]{'routing_transit_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] sec_code_type_info = new String[]{'sec_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_reason_code_type_info = new String[]{'return_reason_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] deposit_ticket_number_type_info = new String[]{'deposit_ticket_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] debit_voucher_number_type_info = new String[]{'debit_voucher_number','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','account_type','effective_date','routing_transit_number','sec_code','return_reason_code','deposit_ticket_number','debit_voucher_number','app_batch_id'};
	}
	public class classification {
		public PayGovTCSSingleQueryService.classificationDataType[] classification_data;
		@TestVisible private String[] classification_data_type_info = new String[]{'classification_data','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'classification_data'};
	}
	public class tcs_ach_results {
		public PayGovTCSSingleQueryService.ACHDebitQueryResponse[] ach_debit_query_response;
		public PayGovTCSSingleQueryService.ACHPrenotificationQueryResponse[] ach_prenotification_query_response;
		public PayGovTCSSingleQueryService.ACHCancelQueryResponse[] ach_cancel_query_response;
		@TestVisible private String[] ach_debit_query_response_type_info = new String[]{'ach_debit_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] ach_prenotification_query_response_type_info = new String[]{'ach_prenotification_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] ach_cancel_query_response_type_info = new String[]{'ach_cancel_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'ach_debit_query_response','ach_prenotification_query_response','ach_cancel_query_response'};
	}
	public class PCSaleBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result'};
	}
	public class tcs_query_result {
		public String agency_id;
		public String tcs_app_id;
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String recurring_payment_number;
		public String return_code;
		public String return_detail;
		public PayGovTCSSingleQueryService.tcs_plastic_card_results tcs_pc_results;
		public PayGovTCSSingleQueryService.tcs_ach_results tcs_ach_results;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] recurring_payment_number_type_info = new String[]{'recurring_payment_number','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] tcs_pc_results_type_info = new String[]{'tcs_pc_results','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] tcs_ach_results_type_info = new String[]{'tcs_ach_results','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','agency_tracking_id','paygov_tracking_id','recurring_payment_number','return_code','return_detail','tcs_pc_results','tcs_ach_results'};
	}
	public class PCForceBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String approval_code;
		public String orig_paygov_tracking_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','approval_code','orig_paygov_tracking_id'};
	}
	public class tcs_batch_results_response {
		public String agency_id;
		public String tcs_app_id;
		public String app_batch_id;
		public String paygov_batch_id;
		public String batch_create_date;
		public String net_amount;
		public String total_amount;
		public String transaction_count;
		public String batch_status;
		public String return_code;
		public String return_detail;
		public PayGovTCSSingleQueryService.tcsBatchItems batch_results;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] paygov_batch_id_type_info = new String[]{'paygov_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] batch_create_date_type_info = new String[]{'batch_create_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] net_amount_type_info = new String[]{'net_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] total_amount_type_info = new String[]{'total_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] transaction_count_type_info = new String[]{'transaction_count','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] batch_status_type_info = new String[]{'batch_status','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] batch_results_type_info = new String[]{'batch_results','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','app_batch_id','paygov_batch_id','batch_create_date','net_amount','total_amount','transaction_count','batch_status','return_code','return_detail','batch_results'};
	}
	public class query_custom_fields {
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_1;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_2;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_3;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_4;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_5;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_6;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_7;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_8;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_9;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_10;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_11;
		public PayGovTCSSingleQueryService.CustomCollectionLabelAndFieldType custom_field_12;
		@TestVisible private String[] custom_field_1_type_info = new String[]{'custom_field_1','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_2_type_info = new String[]{'custom_field_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_3_type_info = new String[]{'custom_field_3','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_4_type_info = new String[]{'custom_field_4','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_5_type_info = new String[]{'custom_field_5','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_6_type_info = new String[]{'custom_field_6','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_7_type_info = new String[]{'custom_field_7','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_8_type_info = new String[]{'custom_field_8','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_9_type_info = new String[]{'custom_field_9','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_10_type_info = new String[]{'custom_field_10','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_11_type_info = new String[]{'custom_field_11','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] custom_field_12_type_info = new String[]{'custom_field_12','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'custom_field_1','custom_field_2','custom_field_3','custom_field_4','custom_field_5','custom_field_6','custom_field_7','custom_field_8','custom_field_9','custom_field_10','custom_field_11','custom_field_12'};
	}
	public class batchResponseFailedTransaction {
		public PayGovTCSSingleQueryService.FailedTransactionQueryResponse[] failed_item_response;
		@TestVisible private String[] failed_item_response_type_info = new String[]{'failed_item_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'failed_item_response'};
	}
	public class PCCancelBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String orig_paygov_tracking_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','orig_paygov_tracking_id'};
	}
	public class PCManualAuthorizationBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String approval_code;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','approval_code'};
	}
	public class PCAuthorizationBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result'};
	}
	public class visaLevel3Type {
		public String discount_indicator;
		public String discount_amount;
		public Integer alternate_tax_identifier;
		public String product_code;
		public String item_descriptor;
		public String item_quantity;
		public String unit_of_measure;
		public String unit_cost;
		public String net_indicator;
		public String db_cr_indicator;
		public String type_of_supply;
		public String item_commodity_code;
		@TestVisible private String[] discount_indicator_type_info = new String[]{'discount-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] discount_amount_type_info = new String[]{'discount-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] alternate_tax_identifier_type_info = new String[]{'alternate-tax-identifier','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] product_code_type_info = new String[]{'product-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] unit_of_measure_type_info = new String[]{'unit-of-measure','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] net_indicator_type_info = new String[]{'net-indicator','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] db_cr_indicator_type_info = new String[]{'db-cr-indicator','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] type_of_supply_type_info = new String[]{'type-of-supply','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] item_commodity_code_type_info = new String[]{'item-commodity-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'discount_indicator','discount_amount','alternate_tax_identifier','product_code','item_descriptor','item_quantity','unit_of_measure','unit_cost','net_indicator','db_cr_indicator','type_of_supply','item_commodity_code'};
	}
	public class tcs_multiple_item_query_request {
		public String agency_id;
		public String tcs_app_id;
		public String start_date_time;
		public String duration;
		public String app_batch_id;
		public String paygov_batch_id;
		@TestVisible private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] start_date_time_type_info = new String[]{'start_date_time','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] duration_type_info = new String[]{'duration','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_batch_id_type_info = new String[]{'paygov_batch_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','start_date_time','duration','app_batch_id','paygov_batch_id'};
	}
	public class PCSaleQueryResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		public String return_code;
		public String return_detail;
		public String account_holder_name;
		public String account_holder_email_address;
		public String transaction_date;
		public PayGovTCSSingleQueryService.address billing_info;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		public String app_batch_id;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] billing_info_type_info = new String[]{'billing_info','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] app_batch_id_type_info = new String[]{'app_batch_id','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','custom_fields','return_code','return_detail','account_holder_name','account_holder_email_address','transaction_date','billing_info','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result','app_batch_id'};
	}
	public class ACHDebitBatchResultsResponse {
		public String agency_tracking_id;
		public String paygov_tracking_id;
		public String transaction_status;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_date;
		public String account_holder_name;
		public String effective_date;
		@TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		@TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		@TestVisible private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'agency_tracking_id','paygov_tracking_id','transaction_status','transaction_amount','masked_account_number','return_code','return_detail','transaction_date','account_holder_name','effective_date'};
	}
	public class tcs_plastic_card_results {
		public PayGovTCSSingleQueryService.PCAuthorizationQueryResponse[] pc_authorization_query_response;
		public PayGovTCSSingleQueryService.PCRefundQueryResponse[] pc_refund_with_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCRefundQueryResponse[] pc_refund_without_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCForceQueryResponse[] pc_force_query_response;
		public PayGovTCSSingleQueryService.PCForceQueryResponse[] pc_force_without_paygov_tracking_id_query_response;
		public PayGovTCSSingleQueryService.PCManualAuthorizationQueryResponse[] pc_manual_authorization_query_response;
		public PayGovTCSSingleQueryService.PCSaleQueryResponse[] pc_sale_query_response;
		public PayGovTCSSingleQueryService.PCCancelQueryResponse[] pc_cancel_query_response;
		@TestVisible private String[] pc_authorization_query_response_type_info = new String[]{'pc_authorization_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_refund_with_paygov_tracking_id_query_response_type_info = new String[]{'pc_refund_with_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_refund_without_paygov_tracking_id_query_response_type_info = new String[]{'pc_refund_without_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_force_query_response_type_info = new String[]{'pc_force_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_force_without_paygov_tracking_id_query_response_type_info = new String[]{'pc_force_without_paygov_tracking_id_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_manual_authorization_query_response_type_info = new String[]{'pc_manual_authorization_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_sale_query_response_type_info = new String[]{'pc_sale_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] pc_cancel_query_response_type_info = new String[]{'pc_cancel_query_response','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		@TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		@TestVisible private String[] field_order_type_info = new String[]{'pc_authorization_query_response','pc_refund_with_paygov_tracking_id_query_response','pc_refund_without_paygov_tracking_id_query_response','pc_force_query_response','pc_force_without_paygov_tracking_id_query_response','pc_manual_authorization_query_response','pc_sale_query_response','pc_cancel_query_response'};
	}
	public class TCSSingleQuery_Port {
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public Integer timeout_x = 60000;
		@TestVisible private String[] ns_map_type_info = new String[]{'http://fms.treas.gov/tcs/schemas', 'PayGovTCSSingleQueryService'};

		public PayGovTCSSingleQueryService.tcs_query_result processTCSSingleQuery(String agency_id,String tcs_app_id,String agency_tracking_id,String paygov_tracking_id,String recurring_payment_number) {
			PayGovTCSSingleQueryService.tcs_query_single_request request_x = new PayGovTCSSingleQueryService.tcs_query_single_request();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.agency_tracking_id = agency_tracking_id;
			request_x.paygov_tracking_id = paygov_tracking_id;
			if (String.isNotBlank(recurring_payment_number)) {
				request_x.recurring_payment_number = recurring_payment_number;
			}
			PayGovTCSSingleQueryService.tcs_query_result response_x;
			Map<String, PayGovTCSSingleQueryService.tcs_query_result> response_map_x = new Map<String, PayGovTCSSingleQueryService.tcs_query_result>();
			response_map_x.put('response_x', response_x);

			String endpoint_x = (String) paymentSettingsMap.get('Query_Endpoint__c');

			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'processTCSSingleQuery',
			  'http://fms.treas.gov/tcs/schemas',
			  'tcs_query_single_request',
			  'http://fms.treas.gov/tcs/schemas',
			  'tcs_query_response',
			  'PayGovTCSSingleQueryService.tcs_query_result'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}
	}
}