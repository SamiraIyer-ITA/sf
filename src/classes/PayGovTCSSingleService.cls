//Methods to communicate with pay.gov (synchronously)

public class PayGovTCSSingleService {
	@TestVisible private static final String METADATA_SETTINGS_NAME = 'PayGov';

	/*public class baseLineItemType {
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{};
	}
	public class amexLevel3Type {
		public String item_descriptor;
		public String item_quantity;
		public String unit_cost;
		private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'item_descriptor','item_quantity','unit_cost'};
	}
	public class PCAuthorizationResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCAuthorizationResponseType PCAuthorization;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCAuthorization_type_info = new String[]{'PCAuthorization','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCAuthorization'};
	}
	public class PCManualAuthorizationResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCManualAuthorizationResponseType PCManualAuthorization;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCManualAuthorization_type_info = new String[]{'PCManualAuthorization','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCManualAuthorization'};
	}
	public class ACHPrenotificationRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHPrenotificationRequestType ACHPrenotification;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHPrenotification_type_info = new String[]{'ACHPrenotification','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHPrenotification'};
	}
	public class PCRefundWithoutPaygovTrackingIdRequestType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String account_number;
		public String credit_card_expiration_date;
		public String business_name;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		public String order_id;
		public String order_tax_amount;
		public PayGovTCSSingleService.order_level3_data order_level3_data;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] credit_card_expiration_date_type_info = new String[]{'credit_card_expiration_date','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] order_id_type_info = new String[]{'order_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_tax_amount_type_info = new String[]{'order_tax_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_level3_data_type_info = new String[]{'order_level3_data','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','account_number','credit_card_expiration_date','business_name','first_name','middle_initial','last_name','billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country','order_id','order_tax_amount','order_level3_data','custom_fields','account_holder_email_address'};
	}
	public class PCForceWithoutPaygovTrackingIdRequestType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String account_number;
		public String credit_card_expiration_date;
		public String approval_code;
		public String business_name;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		public String order_id;
		public String order_tax_amount;
		public PayGovTCSSingleService.order_level3_data order_level3_data;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		public PayGovTCSSingleService.classification classification;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] credit_card_expiration_date_type_info = new String[]{'credit_card_expiration_date','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] order_id_type_info = new String[]{'order_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_tax_amount_type_info = new String[]{'order_tax_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_level3_data_type_info = new String[]{'order_level3_data','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','account_number','credit_card_expiration_date','approval_code','business_name','first_name','middle_initial','last_name','billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country','order_id','order_tax_amount','order_level3_data','custom_fields','account_holder_email_address','classification'};
	}*/
	public class PCCancelResponseType {
		public String orig_paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date'};
	}
	public class PCCancelRequestType {
		public String orig_paygov_tracking_id;
		public String transaction_amount;
		public String agency_tracking_id;
		public String account_holder_email_address;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','transaction_amount','agency_tracking_id','account_holder_email_address'};
	}
	/*public class PCForceResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCForceResponseType PCForce;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCForce_type_info = new String[]{'PCForce','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForce'};
	}
	public class PCForceRequestType {
		public String orig_paygov_tracking_id;
		public String transaction_amount;
		public String orig_agency_tracking_id;
		public PayGovTCSSingleService.classification classification;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] orig_agency_tracking_id_type_info = new String[]{'orig_agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','transaction_amount','orig_agency_tracking_id','classification'};
	}
	public class PCSaleResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCSaleResponseType PCSale;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCSale_type_info = new String[]{'PCSale','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCSale'};
	}
	public class PCManualAuthorizationRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCManualAuthorizationRequestType PCManualAuthorization;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCManualAuthorization_type_info = new String[]{'PCManualAuthorization','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCManualAuthorization'};
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
		private String[] custom_field_1_type_info = new String[]{'custom_field_1','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_2_type_info = new String[]{'custom_field_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_3_type_info = new String[]{'custom_field_3','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_4_type_info = new String[]{'custom_field_4','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_5_type_info = new String[]{'custom_field_5','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_6_type_info = new String[]{'custom_field_6','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_7_type_info = new String[]{'custom_field_7','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_8_type_info = new String[]{'custom_field_8','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_9_type_info = new String[]{'custom_field_9','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_10_type_info = new String[]{'custom_field_10','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_11_type_info = new String[]{'custom_field_11','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_12_type_info = new String[]{'custom_field_12','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'custom_field_1','custom_field_2','custom_field_3','custom_field_4','custom_field_5','custom_field_6','custom_field_7','custom_field_8','custom_field_9','custom_field_10','custom_field_11','custom_field_12'};
	}
	public class level_2_element {
		public String dest_country;
		public String dest_zip;
		public String duty_amount;
		public String from_zip;
		public String order_date;
		public String tax_amount;
		private String[] dest_country_type_info = new String[]{'dest-country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] dest_zip_type_info = new String[]{'dest-zip','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] duty_amount_type_info = new String[]{'duty-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] from_zip_type_info = new String[]{'from-zip','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_date_type_info = new String[]{'order-date','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] tax_amount_type_info = new String[]{'tax-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'dest_country','dest_zip','duty_amount','from_zip','order_date','tax_amount'};
	}
	public class PCRefundWithoutPaygovTrackingIdRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequestType PCRefundWithoutPaygovTrackingId;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCRefundWithoutPaygovTrackingId_type_info = new String[]{'PCRefundWithoutPaygovTrackingId','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCRefundWithoutPaygovTrackingId'};
	}
	public class ACHDebitResponseType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String effective_date;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String paygov_tracking_id;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','masked_account_number','effective_date','return_code','return_detail','transaction_status','transaction_date','paygov_tracking_id'};
	}
	public class classification {
		public PayGovTCSSingleService.classificationDataType[] classification_data;
		private String[] classification_data_type_info = new String[]{'classification_data','http://fms.treas.gov/tcs/schemas',null,'0','-1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'classification_data'};
	}
	public class PCForceResponseType {
		public String orig_paygov_tracking_id;
		public String orig_agency_tracking_id;
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] orig_agency_tracking_id_type_info = new String[]{'orig_agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','orig_agency_tracking_id','paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date'};
	}
	public class ACHCancelResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHCancelResponseType ACHCancel;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHCancel_type_info = new String[]{'ACHCancel','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHCancel'};
	}
	public class ACHDebitRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHDebitRequestType ACHDebit;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHDebit_type_info = new String[]{'ACHDebit','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHDebit'};
	}
	public class ACHCancelRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHCancelRequestType ACHCancel;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHCancel_type_info = new String[]{'ACHCancel','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHCancel'};
	}
	public class query_custom_fields {
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_1;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_2;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_3;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_4;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_5;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_6;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_7;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_8;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_9;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_10;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_11;
		public PayGovTCSSingleService.CustomCollectionLabelAndFieldType custom_field_12;
		private String[] custom_field_1_type_info = new String[]{'custom_field_1','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_2_type_info = new String[]{'custom_field_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_3_type_info = new String[]{'custom_field_3','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_4_type_info = new String[]{'custom_field_4','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_5_type_info = new String[]{'custom_field_5','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_6_type_info = new String[]{'custom_field_6','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_7_type_info = new String[]{'custom_field_7','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_8_type_info = new String[]{'custom_field_8','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_9_type_info = new String[]{'custom_field_9','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_10_type_info = new String[]{'custom_field_10','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_11_type_info = new String[]{'custom_field_11','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_field_12_type_info = new String[]{'custom_field_12','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'custom_field_1','custom_field_2','custom_field_3','custom_field_4','custom_field_5','custom_field_6','custom_field_7','custom_field_8','custom_field_9','custom_field_10','custom_field_11','custom_field_12'};
	}
	public class ACHCancelResponseType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String effective_date;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String orig_paygov_tracking_id;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','masked_account_number','effective_date','return_code','return_detail','transaction_status','transaction_date','orig_paygov_tracking_id'};
	}
	public class PCRefundWithoutPaygovTrackingIdResponseType {
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date'};
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
		private String[] discount_indicator_type_info = new String[]{'discount-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] discount_amount_type_info = new String[]{'discount-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] alternate_tax_identifier_type_info = new String[]{'alternate-tax-identifier','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] product_code_type_info = new String[]{'product-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] unit_of_measure_type_info = new String[]{'unit-of-measure','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] net_indicator_type_info = new String[]{'net-indicator','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] db_cr_indicator_type_info = new String[]{'db-cr-indicator','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] type_of_supply_type_info = new String[]{'type-of-supply','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] item_commodity_code_type_info = new String[]{'item-commodity-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'discount_indicator','discount_amount','alternate_tax_identifier','product_code','item_descriptor','item_quantity','unit_of_measure','unit_cost','net_indicator','db_cr_indicator','type_of_supply','item_commodity_code'};
	}
	public class PCAuthorizationRequestType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String account_number;
		public String credit_card_expiration_date;
		public String business_name;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String card_security_code;
		public String credit_card_track2;
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		public String order_id;
		public String order_tax_amount;
		public PayGovTCSSingleService.order_level3_data order_level3_data;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] credit_card_expiration_date_type_info = new String[]{'credit_card_expiration_date','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] card_security_code_type_info = new String[]{'card_security_code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] credit_card_track2_type_info = new String[]{'credit_card_track2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] order_id_type_info = new String[]{'order_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_tax_amount_type_info = new String[]{'order_tax_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_level3_data_type_info = new String[]{'order_level3_data','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','account_number','credit_card_expiration_date','business_name','first_name','middle_initial','last_name','card_security_code','credit_card_track2','billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country','order_id','order_tax_amount','order_level3_data','custom_fields','account_holder_email_address'};
	}*/
	public class PCCancelRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCCancelRequestType PCCancel;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCCancel_type_info = new String[]{'PCCancel','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCCancel'};
	}
	/*public class ach_payment_options {
		public String payment_frequency;
		public String payment_date;
		public String total_installments;
		private String[] payment_frequency_type_info = new String[]{'payment_frequency','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] payment_date_type_info = new String[]{'payment_date','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] total_installments_type_info = new String[]{'total_installments','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'payment_frequency','payment_date','total_installments'};
	}
	public class ACHDebitResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHDebitResponseType ACHDebit;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHDebit_type_info = new String[]{'ACHDebit','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHDebit'};
	}
	public class ACHDebitRequestType {
		public String agency_tracking_id;
		public String account_number;
		public String routing_transit_number;
		public String account_type;
		public String transaction_amount;
		public PayGovTCSSingleService.ach_payment_options payment_options;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String business_name;
		public String check_number;
		public String sec_code;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		public PayGovTCSSingleService.classification classification;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] routing_transit_number_type_info = new String[]{'routing_transit_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_type_type_info = new String[]{'account_type','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] payment_options_type_info = new String[]{'payment_options','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] check_number_type_info = new String[]{'check_number','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] sec_code_type_info = new String[]{'sec_code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','account_number','routing_transit_number','account_type','transaction_amount','payment_options','first_name','middle_initial','last_name','business_name','check_number','sec_code','custom_fields','account_holder_email_address','classification'};
	}
	public class PCSaleResponseType {
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		public String authorized_amount;
		public String remaining_balance;
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] authorized_amount_type_info = new String[]{'authorized_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] remaining_balance_type_info = new String[]{'remaining_balance','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result','authorized_amount','remaining_balance'};
	}
	public class order_level3_data {
		public PayGovTCSSingleService.level_2_element level_2;
		public PayGovTCSSingleService.baseLineItemType[] line_item;
		private String[] level_2_type_info = new String[]{'level-2','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] line_item_type_info = new String[]{'line-item','http://fms.treas.gov/tcs/schemas',null,'1','1000','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'level_2','line_item'};
	}
	public class PCManualAuthorizationResponseType {
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String authorized_amount;
		public String remaining_balance;
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] authorized_amount_type_info = new String[]{'authorized_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] remaining_balance_type_info = new String[]{'remaining_balance','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date','authorized_amount','remaining_balance'};
	}
	public class PCAuthorizationResponseType {
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String approval_code;
		public String auth_response_code;
		public String auth_response_text;
		public String avs_response_code;
		public String csc_result;
		public String authorized_amount;
		public String remaining_balance;
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] auth_response_code_type_info = new String[]{'auth_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] auth_response_text_type_info = new String[]{'auth_response_text','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] avs_response_code_type_info = new String[]{'avs_response_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] csc_result_type_info = new String[]{'csc_result','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] authorized_amount_type_info = new String[]{'authorized_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] remaining_balance_type_info = new String[]{'remaining_balance','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date','approval_code','auth_response_code','auth_response_text','avs_response_code','csc_result','authorized_amount','remaining_balance'};
	}
	public class PCSaleRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCSaleRequestType PCSale;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCSale_type_info = new String[]{'PCSale','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCSale'};
	}*/
	public class PCRefundRequestType {
		public String orig_paygov_tracking_id;
		public String transaction_amount;
		public String orig_agency_tracking_id;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] orig_agency_tracking_id_type_info = new String[]{'orig_agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','transaction_amount','orig_agency_tracking_id'};
	}
	/*public class PCForceRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCForceRequestType PCForce;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCForce_type_info = new String[]{'PCForce','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForce'};
	}*/
	public class PCRefundResponseType {
		public String orig_paygov_tracking_id;
		public String orig_agency_tracking_id;
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] orig_agency_tracking_id_type_info = new String[]{'orig_agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','orig_agency_tracking_id','paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date'};
	}
	/*public class PCForceWithoutPaygovTrackingIdResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponseType PCForceWithoutPaygovTrackingId;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCForceWithoutPaygovTrackingId_type_info = new String[]{'PCForceWithoutPaygovTrackingId','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForceWithoutPaygovTrackingId'};
	}*/
	public class PCRefundRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCRefundRequestType PCRefund;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCRefund_type_info = new String[]{'PCRefund','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCRefund'};
	}
	/*public class PCManualAuthorizationRequestType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String account_number;
		public String credit_card_expiration_date;
		public String approval_code;
		public String business_name;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		public String order_id;
		public String order_tax_amount;
		public PayGovTCSSingleService.order_level3_data order_level3_data;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] credit_card_expiration_date_type_info = new String[]{'credit_card_expiration_date','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] approval_code_type_info = new String[]{'approval_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] order_id_type_info = new String[]{'order_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_tax_amount_type_info = new String[]{'order_tax_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_level3_data_type_info = new String[]{'order_level3_data','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','account_number','credit_card_expiration_date','approval_code','business_name','first_name','middle_initial','last_name','billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country','order_id','order_tax_amount','order_level3_data','custom_fields','account_holder_email_address'};
	}
	public class CustomCollectionLabelAndFieldType {
		public String label;
		public String value;
		private String[] label_type_info = new String[]{'label','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] value_type_info = new String[]{'value','http://fms.treas.gov/tcs/schemas',null,'0','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'label','value'};
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
		private String[] discount_indicator_type_info = new String[]{'discount-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] discount_amount_type_info = new String[]{'discount-amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] alternate_tax_identifier_type_info = new String[]{'alternate-tax-identifier','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] product_code_type_info = new String[]{'product-code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] item_descriptor_type_info = new String[]{'item-descriptor','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] item_quantity_type_info = new String[]{'item-quantity','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] unit_of_measure_type_info = new String[]{'unit-of-measure','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] unit_cost_type_info = new String[]{'unit-cost','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] net_indicator_type_info = new String[]{'net-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] db_cr_indicator_type_info = new String[]{'db-cr-indicator','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] type_of_supply_type_info = new String[]{'type-of-supply','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] item_commodity_code_type_info = new String[]{'item-commodity-code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'discount_indicator','discount_amount','alternate_tax_identifier','product_code','item_descriptor','item_quantity','unit_of_measure','unit_cost','net_indicator','db_cr_indicator','type_of_supply','item_commodity_code'};
	}
	public class ACHCancelRequestType {
		public String orig_paygov_tracking_id;
		public String transaction_amount;
		public String agency_tracking_id;
		private String[] orig_paygov_tracking_id_type_info = new String[]{'orig_paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'orig_paygov_tracking_id','transaction_amount','agency_tracking_id'};
	}
	public class address {
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country'};
	}
	public class PCAuthorizationRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCAuthorizationRequestType PCAuthorization;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCAuthorization_type_info = new String[]{'PCAuthorization','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCAuthorization'};
	}*/
	public class PCCancelResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCCancelResponseType PCCancel;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCCancel_type_info = new String[]{'PCCancel','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCCancel'};
	}
	/*public class classificationDataType {
		public String classification_id;
		public String amount;
		private String[] classification_id_att_info = new String[]{'classification_id'};
		private String[] amount_att_info = new String[]{'amount'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{};
	}
	public class PCSaleRequestType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String account_number;
		public String credit_card_expiration_date;
		public String business_name;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String card_security_code;
		public String credit_card_track2;
		public String billing_address;
		public String billing_address_2;
		public String billing_city;
		public String billing_state;
		public String billing_zip;
		public String billing_country;
		public String order_id;
		public String order_tax_amount;
		public PayGovTCSSingleService.order_level3_data order_level3_data;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		public PayGovTCSSingleService.classification classification;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] credit_card_expiration_date_type_info = new String[]{'credit_card_expiration_date','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] card_security_code_type_info = new String[]{'card_security_code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] credit_card_track2_type_info = new String[]{'credit_card_track2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_address_2_type_info = new String[]{'billing_address_2','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] order_id_type_info = new String[]{'order_id','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_tax_amount_type_info = new String[]{'order_tax_amount','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] order_level3_data_type_info = new String[]{'order_level3_data','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','account_number','credit_card_expiration_date','business_name','first_name','middle_initial','last_name','card_security_code','credit_card_track2','billing_address','billing_address_2','billing_city','billing_state','billing_zip','billing_country','order_id','order_tax_amount','order_level3_data','custom_fields','account_holder_email_address','classification'};
	}*/
	public class PCRefundResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCRefundResponseType PCRefund;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCRefund_type_info = new String[]{'PCRefund','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCRefund'};
	}
	/*public class PCForceWithoutPaygovTrackingIdResponseType {
		public String paygov_tracking_id;
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','masked_account_number','return_code','return_detail','transaction_status','transaction_date'};
	}
	public class PCForceWithoutPaygovTrackingIdRequest_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequestType PCForceWithoutPaygovTrackingId;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCForceWithoutPaygovTrackingId_type_info = new String[]{'PCForceWithoutPaygovTrackingId','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForceWithoutPaygovTrackingId'};
	}
	public class ACHPrenotificationResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.ACHPrenotificationResponseType ACHPrenotification;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] ACHPrenotification_type_info = new String[]{'ACHPrenotification','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','ACHPrenotification'};
	}
	public class ACHPrenotificationResponseType {
		public String agency_tracking_id;
		public String transaction_amount;
		public String masked_account_number;
		public String effective_date;
		public String return_code;
		public String return_detail;
		public String transaction_status;
		public String transaction_date;
		public String paygov_tracking_id;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] masked_account_number_type_info = new String[]{'masked_account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] effective_date_type_info = new String[]{'effective_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/tcs/schemas',null,'1','1','true'};
		private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','transaction_amount','masked_account_number','effective_date','return_code','return_detail','transaction_status','transaction_date','paygov_tracking_id'};
	}
	public class ACHPrenotificationRequestType {
		public String agency_tracking_id;
		public String account_number;
		public String routing_transit_number;
		public String account_type;
		public String transaction_amount;
		public String first_name;
		public String middle_initial;
		public String last_name;
		public String business_name;
		public String check_number;
		public String sec_code;
		public PayGovTCSSingleService.custom_fields custom_fields;
		public String account_holder_email_address;
		private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_number_type_info = new String[]{'account_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] routing_transit_number_type_info = new String[]{'routing_transit_number','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] account_type_type_info = new String[]{'account_type','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] first_name_type_info = new String[]{'first_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] middle_initial_type_info = new String[]{'middle_initial','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] last_name_type_info = new String[]{'last_name','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] business_name_type_info = new String[]{'business_name','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] check_number_type_info = new String[]{'check_number','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] sec_code_type_info = new String[]{'sec_code','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] account_holder_email_address_type_info = new String[]{'account_holder_email_address','http://fms.treas.gov/tcs/schemas',null,'0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_tracking_id','account_number','routing_transit_number','account_type','transaction_amount','first_name','middle_initial','last_name','business_name','check_number','sec_code','custom_fields','account_holder_email_address'};
	}
	public class PCRefundWithoutPaygovTrackingIdResponse_element {
		public String agency_id;
		public String tcs_app_id;
		public PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponseType PCRefundWithoutPaygovTrackingId;
		private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] PCRefundWithoutPaygovTrackingId_type_info = new String[]{'PCRefundWithoutPaygovTrackingId','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
		private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCRefundWithoutPaygovTrackingId'};
	}*/

	public class TCSSinglePort {
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public Integer timeout_x = 60000;
		@TestVisible private String[] ns_map_type_info = new String[]{'http://fms.treas.gov/tcs/schemas', 'PayGovTCSSingleService'};

		/*public PayGovTCSSingleService.PCForceResponse_element processPCForce(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCForceRequestType PCForce) {
			PayGovTCSSingleService.PCForceRequest_element request_x = new PayGovTCSSingleService.PCForceRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCForce = PCForce;
			PayGovTCSSingleService.PCForceResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCForceResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCForceResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessPCForce',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCForceRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCForceResponse',
			  'PayGovTCSSingleService.PCForceResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		/*public PayGovTCSSingleService.PCSaleResponse_element processPCSale(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCSaleRequestType PCSale) {
			PayGovTCSSingleService.PCSaleRequest_element request_x = new PayGovTCSSingleService.PCSaleRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCSale = PCSale;
			PayGovTCSSingleService.PCSaleResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCSaleResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCSaleResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessPCSale',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCSaleRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCSaleResponse',
			  'PayGovTCSSingleService.PCSaleResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		public PayGovTCSSingleService.PCCancelResponse_element processPCCancel(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCCancelRequestType PCCancel) {
			PayGovTCSSingleService.PCCancelRequest_element request_x = new PayGovTCSSingleService.PCCancelRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCCancel = PCCancel;
			PayGovTCSSingleService.PCCancelResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCCancelResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCCancelResponse_element>();
			response_map_x.put('response_x', response_x);
			String endpoint_x = (String) paymentSettingsMap.get('Refund_Endpoint__c');
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
					'urn:ProcessPCCancel',
					'http://fms.treas.gov/tcs/schemas',
					'PCCancelRequest',
					'http://fms.treas.gov/tcs/schemas',
					'PCCancelResponse',
					'PayGovTCSSingleService.PCCancelResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}
		/*public PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element processPCRefundWithoutPaygovTrackingId(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequestType PCRefundWithoutPaygovTrackingId) {
			PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequest_element request_x = new PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCRefundWithoutPaygovTrackingId = PCRefundWithoutPaygovTrackingId;
			PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessPCRefundWithoutPaygovTrackingId',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCRefundWithoutPaygovTrackingIdRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCRefundWithoutPaygovTrackingIdResponse',
			  'PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		/*public PayGovTCSSingleService.ACHDebitResponse_element processACHDebit(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHDebitRequestType ACHDebit) {
			PayGovTCSSingleService.ACHDebitRequest_element request_x = new PayGovTCSSingleService.ACHDebitRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.ACHDebit = ACHDebit;
			PayGovTCSSingleService.ACHDebitResponse_element response_x;
			Map<String, PayGovTCSSingleService.ACHDebitResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.ACHDebitResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessACHDebit',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHDebitRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHDebitResponse',
			  'PayGovTCSSingleService.ACHDebitResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		/*public PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element processPCForceWithoutPaygovTrackingId(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequestType PCForceWithoutPaygovTrackingId) {
			PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequest_element request_x = new PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCForceWithoutPaygovTrackingId = PCForceWithoutPaygovTrackingId;
			PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessPCForceWithoutPaygovTrackingId',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCForceWithoutPaygovTrackingIdRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCForceWithoutPaygovTrackingIdResponse',
			  'PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		/*public PayGovTCSSingleService.ACHCancelResponse_element processACHCancel(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHCancelRequestType ACHCancel) {
			PayGovTCSSingleService.ACHCancelRequest_element request_x = new PayGovTCSSingleService.ACHCancelRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.ACHCancel = ACHCancel;
			PayGovTCSSingleService.ACHCancelResponse_element response_x;
			Map<String, PayGovTCSSingleService.ACHCancelResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.ACHCancelResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessACHCancel',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHCancelRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHCancelResponse',
			  'PayGovTCSSingleService.ACHCancelResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		public PayGovTCSSingleService.PCRefundResponse_element processPCRefund(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCRefundRequestType PCRefund) {
			PayGovTCSSingleService.PCRefundRequest_element request_x = new PayGovTCSSingleService.PCRefundRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCRefund = PCRefund;
			PayGovTCSSingleService.PCRefundResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCRefundResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCRefundResponse_element>();
			response_map_x.put('response_x', response_x);
			String endpoint_x = (String) paymentSettingsMap.get('Refund_Endpoint__c');
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
					'urn:ProcessPCRefund',
					'http://fms.treas.gov/tcs/schemas',
					'PCRefundRequest',
					'http://fms.treas.gov/tcs/schemas',
					'PCRefundResponse',
					'PayGovTCSSingleService.PCRefundResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}
		/*public PayGovTCSSingleService.ACHPrenotificationResponse_element processACHPrenotification(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHPrenotificationRequestType ACHPrenotification) {
			PayGovTCSSingleService.ACHPrenotificationRequest_element request_x = new PayGovTCSSingleService.ACHPrenotificationRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.ACHPrenotification = ACHPrenotification;
			PayGovTCSSingleService.ACHPrenotificationResponse_element response_x;
			Map<String, PayGovTCSSingleService.ACHPrenotificationResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.ACHPrenotificationResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:processACHPrenotification',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHPrenotificationRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'ACHPrenotificationResponse',
			  'PayGovTCSSingleService.ACHPrenotificationResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
		/*public PayGovTCSSingleService.PCAuthorizationResponse_element processPCAuthorization(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCAuthorizationRequestType PCAuthorization) {
			PayGovTCSSingleService.PCAuthorizationRequest_element request_x = new PayGovTCSSingleService.PCAuthorizationRequest_element();
			request_x.agency_id = agency_id;
			request_x.tcs_app_id = tcs_app_id;
			request_x.PCAuthorization = PCAuthorization;
			PayGovTCSSingleService.PCAuthorizationResponse_element response_x;
			Map<String, PayGovTCSSingleService.PCAuthorizationResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCAuthorizationResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
			  this,
			  request_x,
			  response_map_x,
			  new String[]{endpoint_x,
			  'urn:ProcessPCAuthorization',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCAuthorizationRequest',
			  'http://fms.treas.gov/tcs/schemas',
			  'PCAuthorizationResponse',
			  'PayGovTCSSingleService.PCAuthorizationResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x;
		}*/
	}
}