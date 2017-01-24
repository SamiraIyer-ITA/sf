//Methods to communicate with pay.gov (synchronously)

public class PayGovTCSSingleService {
    public static final String SERVICE_ENDPOINT = 'https://qa.tcs.pay.gov:443/tcscollections/services/TCSSingleService';

    public class baseLineItemType {
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
    }
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
    public class PCForceResponse_element {
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
    }
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
    public class ach_payment_options {
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
    }
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
    public class PCForceRequest_element {
        public String agency_id;
        public String tcs_app_id;
        public PayGovTCSSingleService.PCForceRequestType PCForce;
        private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] PCForce_type_info = new String[]{'PCForce','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForce'};
    }
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
    public class PCForceWithoutPaygovTrackingIdResponse_element {
        public String agency_id;
        public String tcs_app_id;
        public PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponseType PCForceWithoutPaygovTrackingId;
        private String[] agency_id_type_info = new String[]{'agency_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] PCForceWithoutPaygovTrackingId_type_info = new String[]{'PCForceWithoutPaygovTrackingId','http://fms.treas.gov/tcs/schemas',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/tcs/schemas','true','false'};
        private String[] field_order_type_info = new String[]{'agency_id','tcs_app_id','PCForceWithoutPaygovTrackingId'};
    }
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
    public class PCManualAuthorizationRequestType {
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
    }
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
    public class classificationDataType {
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
    }
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
    public class PCForceWithoutPaygovTrackingIdResponseType {
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
    }
    
    public class TCSSinglePort {
        public String endpoint_x = SERVICE_ENDPOINT;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;

        public String clientCertPasswd_x = 'itapassword1';
        public Integer timeout_x = 60000;
        @TestVisible private String[] ns_map_type_info = new String[]{'http://fms.treas.gov/tcs/schemas', 'PayGovTCSSingleService'};
        
        @TestVisible private void setClientCert() {
            Boolean isSandBox = [Select IsSandbox from Organization limit 1].isSandbox;
            if (isSandBox) {
                //QA
                clientCert_x = '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';
            } else {
                //Prod
                clientCert_x = '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';
            }
        }
        
        public PayGovTCSSingleService.PCForceResponse_element processPCForce(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCForceRequestType PCForce) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.PCSaleResponse_element processPCSale(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCSaleRequestType PCSale) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.PCCancelResponse_element processPCCancel(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCCancelRequestType PCCancel) {
            setClientCert();
            PayGovTCSSingleService.PCCancelRequest_element request_x = new PayGovTCSSingleService.PCCancelRequest_element();
            request_x.agency_id = agency_id;
            request_x.tcs_app_id = tcs_app_id;
            request_x.PCCancel = PCCancel;
            PayGovTCSSingleService.PCCancelResponse_element response_x;
            Map<String, PayGovTCSSingleService.PCCancelResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCCancelResponse_element>();
            response_map_x.put('response_x', response_x);
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
        public PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdResponse_element processPCRefundWithoutPaygovTrackingId(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCRefundWithoutPaygovTrackingIdRequestType PCRefundWithoutPaygovTrackingId) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.ACHDebitResponse_element processACHDebit(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHDebitRequestType ACHDebit) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdResponse_element processPCForceWithoutPaygovTrackingId(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCForceWithoutPaygovTrackingIdRequestType PCForceWithoutPaygovTrackingId) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.ACHCancelResponse_element processACHCancel(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHCancelRequestType ACHCancel) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.PCRefundResponse_element processPCRefund(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCRefundRequestType PCRefund) {
            setClientCert();
            PayGovTCSSingleService.PCRefundRequest_element request_x = new PayGovTCSSingleService.PCRefundRequest_element();
            request_x.agency_id = agency_id;
            request_x.tcs_app_id = tcs_app_id;
            request_x.PCRefund = PCRefund;
            PayGovTCSSingleService.PCRefundResponse_element response_x;
            Map<String, PayGovTCSSingleService.PCRefundResponse_element> response_map_x = new Map<String, PayGovTCSSingleService.PCRefundResponse_element>();
            response_map_x.put('response_x', response_x);
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
        public PayGovTCSSingleService.ACHPrenotificationResponse_element processACHPrenotification(String agency_id,String tcs_app_id,PayGovTCSSingleService.ACHPrenotificationRequestType ACHPrenotification) {
            setClientCert();
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
        }
        public PayGovTCSSingleService.PCAuthorizationResponse_element processPCAuthorization(String agency_id,String tcs_app_id,PayGovTCSSingleService.PCAuthorizationRequestType PCAuthorization) {
            setClientCert();
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
        }
    }
}