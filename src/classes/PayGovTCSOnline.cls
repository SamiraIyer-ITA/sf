//Methods to communicate with pay.gov for Hosted Collection pages (synchronously)

public class PayGovTCSOnline {
    
    //public static final String SERVICE_ENDPOINT = 'https://qa.tcs.pay.gov:443/services/TCSOnlineService/2.0/';  //QA
    //public static final String SERVICE_ENDPOINT = 'https://tcs.pay.gov:443/services/TCSOnlineService/2.0/';  //Production
    
    private static final String SERVICE_ENDPOINT = PaymentSettings__c.getAll().get('PAY_GOV_TCS_ONLINE_ENDPOINT').value__c;
    
    public class CompleteOnlineCollectionWithDetails {
        public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest;
        @TestVisible private String[] completeOnlineCollectionWithDetailsRequest_type_info = new String[]{'completeOnlineCollectionWithDetailsRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'completeOnlineCollectionWithDetailsRequest'};
    }
    public class CompleteOnlineCollectionWithDetailsRequest {
        public String tcs_app_id;
        public String token;
        @TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] token_type_info = new String[]{'token','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'tcs_app_id','token'};
    }
    public class CompleteOnlineCollectionWithDetailsResponse {
        public String paygov_tracking_id;
        public String agency_tracking_id;
        public String transaction_amount;
        public String transaction_type;
        public DateTime transaction_date;
        public Date payment_date;
        public String transaction_status;
        @TestVisible private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] transaction_type_type_info = new String[]{'transaction_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] payment_date_type_info = new String[]{'payment_date','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','transaction_type','transaction_date','payment_date','transaction_status'};
    }
    public class CustomCollectionFields {
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
        @TestVisible private String[] custom_field_1_type_info = new String[]{'custom_field_1','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_2_type_info = new String[]{'custom_field_2','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_3_type_info = new String[]{'custom_field_3','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_4_type_info = new String[]{'custom_field_4','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_5_type_info = new String[]{'custom_field_5','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_6_type_info = new String[]{'custom_field_6','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_7_type_info = new String[]{'custom_field_7','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_8_type_info = new String[]{'custom_field_8','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_9_type_info = new String[]{'custom_field_9','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_10_type_info = new String[]{'custom_field_10','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_11_type_info = new String[]{'custom_field_11','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_field_12_type_info = new String[]{'custom_field_12','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'custom_field_1','custom_field_2','custom_field_3','custom_field_4','custom_field_5','custom_field_6','custom_field_7','custom_field_8','custom_field_9','custom_field_10','custom_field_11','custom_field_12'};
    }
    public class CompleteOnlineCollectionWithDetailsResponseType {
        public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse;
        @TestVisible private String[] completeOnlineCollectionWithDetailsResponse_type_info = new String[]{'completeOnlineCollectionWithDetailsResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'completeOnlineCollectionWithDetailsResponse'};
    }
    public class StartOnlineCollectionResponseType {
        public PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollectionResponse;
        @TestVisible private String[] startOnlineCollectionResponse_type_info = new String[]{'startOnlineCollectionResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'startOnlineCollectionResponse'};
    }
    public class classification {
        public PayGovTCSOnline.classificationData[] classification_data;
        @TestVisible private String[] classification_data_type_info = new String[]{'classification_data','http://fms.treas.gov/services/tcsonline',null,'0','-1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'classification_data'};
    }
    public class StartOnlineCollectionRequest {
        public String tcs_app_id;
        public String agency_tracking_id;
        public String transaction_type;
        public String transaction_amount;
        public String language;
        public String url_success;
        public String url_cancel;
        public String account_holder_name;
        public String billing_address;
        public String billing_address2;
        public String billing_city;
        public String billing_state;
        public String billing_zip;
        public String billing_country;
        public String email_address;
        public PayGovTCSOnline.CustomCollectionFields custom_fields;
        public PayGovTCSOnline.classification classification;
        @TestVisible private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] transaction_type_type_info = new String[]{'transaction_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] language_type_info = new String[]{'language','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] url_success_type_info = new String[]{'url_success','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] url_cancel_type_info = new String[]{'url_cancel','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] account_holder_name_type_info = new String[]{'account_holder_name','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_address_type_info = new String[]{'billing_address','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_address2_type_info = new String[]{'billing_address2','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_city_type_info = new String[]{'billing_city','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_state_type_info = new String[]{'billing_state','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_zip_type_info = new String[]{'billing_zip','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] billing_country_type_info = new String[]{'billing_country','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] email_address_type_info = new String[]{'email_address','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] custom_fields_type_info = new String[]{'custom_fields','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'tcs_app_id','agency_tracking_id','transaction_type','transaction_amount','language','url_success','url_cancel','account_holder_name','billing_address','billing_address2','billing_city','billing_state','billing_zip','billing_country','email_address','custom_fields','classification'};
    }
    public class StartOnlineCollection {
        public PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest;
        @TestVisible private String[] startOnlineCollectionRequest_type_info = new String[]{'startOnlineCollectionRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'startOnlineCollectionRequest'};
    }
    public class classificationData {
        public String classification_id;
        public String amount;
        @TestVisible private String[] classification_id_att_info = new String[]{'classification_id'};
        @TestVisible private String[] amount_att_info = new String[]{'amount'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{};
    }
    public class StartOnlineCollectionResponse {
        public String token;
        @TestVisible private String[] token_type_info = new String[]{'token','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        @TestVisible private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        @TestVisible private String[] field_order_type_info = new String[]{'token'};
    }
    public class TCSServiceFault {
        public String return_code;
        public String return_detail;
        private String[] return_code_type_info = new String[]{'return_code','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] return_detail_type_info = new String[]{'return_detail','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'return_code','return_detail'};
    }
    /*public class CompleteOnlineCollectionRequest {
        public String tcs_app_id;
        public String token;
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] token_type_info = new String[]{'token','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'tcs_app_id','token'};
    }*/
    /*public class CompleteOnlineCollection {
        public PayGovTCSOnline.CompleteOnlineCollectionRequest completeOnlineCollectionRequest;
        private String[] completeOnlineCollectionRequest_type_info = new String[]{'completeOnlineCollectionRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'completeOnlineCollectionRequest'};
    }*/
    /*public class transactionData {
        public String paygov_tracking_id;
        public String agency_tracking_id;
        public String transaction_amount;
        public String transaction_type;
        public DateTime transaction_date;
        public Date payment_date;
        public String transaction_status;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_type_type_info = new String[]{'transaction_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] payment_date_type_info = new String[]{'payment_date','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','transaction_type','transaction_date','payment_date','transaction_status'};
    }*/
    /*public class transactions {
        public PayGovTCSOnline.transactionData[] transaction_x;
        private String[] transaction_x_type_info = new String[]{'transaction','http://fms.treas.gov/services/tcsonline',null,'1','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'transaction_x'};
    }*/
    /*public class CompleteOnlineCollectionResponse {
        public String paygov_tracking_id;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id'};
    }*/
    /*public class CompleteOnlineCollectionResponseType {
        public PayGovTCSOnline.CompleteOnlineCollectionResponse completeOnlineCollectionResponse;
        private String[] completeOnlineCollectionResponse_type_info = new String[]{'completeOnlineCollectionResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'completeOnlineCollectionResponse'};
    }*/
    /*public class GetDetailsRequest {
        public String tcs_app_id;
        public String agency_tracking_id;
        public String paygov_tracking_id;
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'tcs_app_id','agency_tracking_id','paygov_tracking_id'};
    }*/
    /*public class CreateForceResponseType {
        public PayGovTCSOnline.CreateForceResponse createForceResponse;
        private String[] createForceResponse_type_info = new String[]{'createForceResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'createForceResponse'};
    }*/
    /*public class GetDetails {
        public PayGovTCSOnline.GetDetailsRequest getDetailsRequest;
        private String[] getDetailsRequest_type_info = new String[]{'getDetailsRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'getDetailsRequest'};
    }*/
    /*public class CreateForceWithDetailsRequest {
        public String paygov_tracking_id;
        public String agency_tracking_id;
        public String tcs_app_id;
        public String transaction_amount;
        public PayGovTCSOnline.classification classification;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','tcs_app_id','transaction_amount','classification'};
    }*/
    /*public class CreateForceRequest {
        public String paygov_tracking_id;
        public String agency_tracking_id;
        public String tcs_app_id;
        public String transaction_amount;
        public PayGovTCSOnline.classification classification;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] tcs_app_id_type_info = new String[]{'tcs_app_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] classification_type_info = new String[]{'classification','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','tcs_app_id','transaction_amount','classification'};
    }*/
    /*public class GetDetailsResponse {
        public PayGovTCSOnline.transactions transactions;
        private String[] transactions_type_info = new String[]{'transactions','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'transactions'};
    }*/
    /*public class CreateForceWithDetailsResponse {
        public String paygov_tracking_id;
        public String agency_tracking_id;
        public String transaction_amount;
        public String transaction_type;
        public DateTime transaction_date;
        public Date payment_date;
        public String transaction_status;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] agency_tracking_id_type_info = new String[]{'agency_tracking_id','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_amount_type_info = new String[]{'transaction_amount','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_type_type_info = new String[]{'transaction_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] transaction_date_type_info = new String[]{'transaction_date','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] payment_date_type_info = new String[]{'payment_date','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] transaction_status_type_info = new String[]{'transaction_status','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id','agency_tracking_id','transaction_amount','transaction_type','transaction_date','payment_date','transaction_status'};
    }*/ 
    /*public class CreateForce {
        public PayGovTCSOnline.CreateForceRequest createForceRequest;
        private String[] createForceRequest_type_info = new String[]{'createForceRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'createForceRequest'};
    }
    public class GetDetailsResponseType {
        public PayGovTCSOnline.GetDetailsResponse getDetailsResponse;
        private String[] getDetailsResponse_type_info = new String[]{'getDetailsResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'getDetailsResponse'};
    }*/
    /*public class CreateForceWithDetails {
        public PayGovTCSOnline.CreateForceWithDetailsRequest createForceWithDetailsRequest;
        private String[] createForceWithDetailsRequest_type_info = new String[]{'createForceWithDetailsRequest','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'createForceWithDetailsRequest'};
    }*/
    /*public class CreateForceWithDetailsResponseType {
        public PayGovTCSOnline.CreateForceWithDetailsResponse createForceWithDetailsResponse;
        private String[] createForceWithDetailsResponse_type_info = new String[]{'createForceWithDetailsResponse','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'createForceWithDetailsResponse'};
    }*/
    /*public class CreateForceResponse {
        public String paygov_tracking_id;
        private String[] paygov_tracking_id_type_info = new String[]{'paygov_tracking_id','http://fms.treas.gov/services/tcsonline',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://fms.treas.gov/services/tcsonline','false','false'};
        private String[] field_order_type_info = new String[]{'paygov_tracking_id'};
    }*/
    public class TCSOnlineServicePort {
        public String endpoint_x = PayGovTCSOnline.SERVICE_ENDPOINT;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        
        /*The certificate string below was created using the following steps:
        1.  Obtain the security certificate from pay.gov.  When you download it, you create a password.  Use that password below.
        2.  Install the windows distribution of openssl (http://www.slproweb.com/products/Win32OpenSSL.html)
        3.  Create a folder and copy the security certificate into that folder.
        4.  Open a command prompt, navigate to the folder you created and run the following commands:
            a. set OPENSSL_CONF=c:\openssl-win64\bin\openssl.cfg (change the path if necessary)
            b. set PATH=%PATH%;C:\openssl-win64\bin
            c. openssl
            d. base64 -in <input file name> -out <output file name>.
        5. Open the output file in any text editor, copy the encoded text, and paste it below.*/
        
        public String clientCert_x;
        
        public String clientCertPasswd_x = 'itapassword1';
        public Integer timeout_x = 60000;
        @TestVisible private String[] ns_map_type_info = new String[]{'http://fms.treas.gov/services/common', 'PayGovCommon', 'http://fms.treas.gov/services/tcsonline', 'PayGovTCSOnline'};
        
        private void setClientCert() {
            Boolean isSandBox = [Select IsSandbox from Organization limit 1].isSandbox;
            //System.debug('IsSandBox = ' + isSandBox);
            if (isSandBox) {
                //QA
                clientCert_x = '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';
            } else {
                //Prod
                clientCert_x = 'MIIgiAIBAzCCIEQGCSqGSIb3DQEHAaCCIDUEgiAxMIIgLTCCBg4GCSqGSIb3DQEHAaCCBf8EggX7MIIF9zCCBfMGCyqGSIb3DQEMCgECoIIE/jCCBPowHAYKKoZIhvcNAQwBAzAOBAhYoJQKM2hQWQICB9AEggTYI3FjKS1vFMJF2+pBN4tmJh4V+HaB7WBmDiVK2o88L+NZ33BCqhUQv0PZC/3K+uSCI4B9H8j4xY7d8WQ1MyaBoCEMoDIE0AGe7yTA5GkUUr6Qr9ka8gJvD84LUvaXvMCgHQmNx5N8F+t/RPbM8Nle8eZ51FYgyFNVUnE8HeINPew/ahJJdmgbdvb3hxbRApe4GEAZs32ucK8ngjPYHwshLOLkOuDW39rP+l50W92ggrcHlZ94WorHIT1bbvHDZmSwvedj7xSProBQqkjILdCMM0CxYtMfJRhx8FoVdDG3IyPQkwJ0Y+sjWC8JRyJghNNS690oXNunY91RLJFQcY3bHO062L3DU4vR9qtNtiL8eNmSQkepIzCkGSZ4HnnQnE5HFRcJSp8FZE9LtOM7qlSKtiMyHkRuG8Z4M/zL06NWyvfxUnUw4PKBpzq7pepr8T3e4X39u7xchwBOdMUMoGq46vnZ5IYATRyGxaSMK/zeuM3f1VBDFYhY9cy/pgtvqO+gTSLqOsTdMPp+fVXdcNg2in9oCItAclK4iRvnqsd21Av9qoAUJg25RRch4lfdXXPKEC8LmERAIa+4+YEglCbhwYviOC18TFfjJo7Im3hJFVCz/hcOhk5jwpGJ6pzLgSGShviGfC3MJK5blljHd0pPozlOE4N/8Ez4ZlQBx7SrgkhIBuUtdFynJ0GSz/Yzw0YsdZIgNuaCyYGLLB+dDjR1yJgW/jKi/V3lgF2OZNtTMbQOpreSEUad2ifR2JvbMRcxs3owV/m4XqXGqfpmNqsKuINDxe5csHPmkZyJBTP2exGsB0+HUHRSL0MrEIWo1ydIQYrifO1UFJkZ84ZsZeQfpMIm/tpKtmOCOuPyaLI4crT4kZ7Qavzq/0/9lhlfcueF4skAvhaJq+NZjAGzICWqhk7u7IP9kMXj2QJe3r+78vXY9J+VPp/Yv3OAEZcay9DgbZPG0w4IXtl6HQNqEste2820GOtjxkac8+R111fsCZK22IaBlysmmn5ioE6+5lJTbX/rooe6ULN97oVo1DbMODaO4KEReFJU9uSnvq1Ae8V+2QmQkj/Npbyg9RMdMySzcDQp4a9aQlLEBJEG916PGWuH+i8w4aSHVk53AgCQfCSVpLJD09qmTp7PLNtZhEfM7Oryx9cFrDweKmv5tQ/qBMizhF2jXNjA9Qfs9vSGK2gWaf8Nt3H5ot18l8h+RdblIR0AUIQC+TSbQviDBAJv7BrlifXoGZdvumGmzmynJvy6fH38w6bfYkMKQ72SgJ94z49TMIOFD1Czrwyjhxs1lmO37Su+/ioXt//liLP/1vw8y0pfjTjvJpUYBcaCHx/ynKePOFfzyI0riinq0dBdGh/7I+LWce2VshoIoTUSzDU8kT43oSkGhMdNCW9VkxsEVCpsWQLZii952Kl7Ku+/C8aRJY+nAP2WtPQAdFh4JXEDbv8mXbGxPJqEZI7TWv30dV8zrXj8EFwTmqB/E+I62OGnOBKUt7TFuv12HWu0M1KVskIx3rERCJ5YRxXhNX/DUI4T1JbkzuCJSdOj4Es3OgvdCvl560RcUVRwSHjlyGs8BPt4V+5Dzb2lsEFMOcbVTeSx4RRcFz1p+AvmDEEWHsEiJs/0dO2lQ8PUxUaXOwVXOJGe3iUydDGB4TATBgkqhkiG9w0BCRUxBgQEAQAAADBdBgkqhkiG9w0BCRQxUB5OAGwAZQAtAGMAYwA0AGMAMwA5ADkAOAAtAGEAOABkAGIALQA0ADAAMABjAC0AOAAyAGEANwAtADIAOAA4ADkAMABjAGUAZgAyAGIAMwBlMGsGCSsGAQQBgjcRATFeHlwATQBpAGMAcgBvAHMAbwBmAHQAIABFAG4AaABhAG4AYwBlAGQAIABDAHIAeQBwAHQAbwBnAHIAYQBwAGgAaQBjACAAUAByAG8AdgBpAGQAZQByACAAdgAxAC4AMDCCGhcGCSqGSIb3DQEHBqCCGggwghoEAgEAMIIZ/QYJKoZIhvcNAQcBMBwGCiqGSIb3DQEMAQYwDgQIHqtaBORwAbUCAgfQgIIZ0PgKacGlD2nMynOzoBVBKZtYLItG/0zUH6Mqx1UdhSNL6E2qUqkb018b+rclHfMZaLiLmQ+pi6WW2I1e9rHPnTXa20iOnFGUdCTT0uljZbXhL1/3mivyRIxhHlcGGxwAZYn894Q7K3q5ILjAsXsMVOnIDH3j/q/1BAxKrdil79Fu4t6Q4JJv0xyPfrV/dnJ7VVD39HzBmEdXFQHJz/e1nSGOXL6BhvLAlQDcFExaBAe7PVP8yXZ09wP0bIin7eJkR6tJpbAP+4vwnyROXIICix5vCbDxn2SQOSnXPsQ3584up/994xCrrN7XXzuE8khnrkHpSA8rF0GhnxCPwMG9W+5WrZVoFeejqFUIXAEzm7iBYNAnkFn4KyJINvfDEC/SyzPf11v3Rj0dY7i33Yj0ic8sJW6mwiYMZ8xJZYpQfgO8dVpJZUlCeXRfLNyFiPNehAINBXc73E+ClZK8voRuxWUSVAccQGetvO7Kk0HQQd97yBf1uP7T0+kUy0ODcAnWtFyPieDAGTE7E2Cx8oxaFGK4R8016S3SZpMYbcDIUrwk/xZc2ejsK9EWWHVW7Q7oWctJ4Cv3FBXkzV/ESC7OEkglq97lAa83G6NNhJfBPFPb2I5K7zhhSOy0CD1SAeFA0gVKM+5udUUOXY3BN9/zLRU4/jUgJ5I7+X1d9Pouq56anpaLX5jUsOeEbUAuGBA9X/dUZzId3dlzDFcYp3vTBV+CmrToHr25zuS13Pp6vl2RrnQeCgXnKDQJlRRfcIomEuiD+4ZNT5mdXuBbBuQW4yU1En0mAJqFxDi9sd+b1jLtjbpKgQvQXPa9V0LEFLYL4Y7ZpQwWczg+2ocMB4QHVMpTnUOS6a3e02NCkzbiCI3UKfUaU6NumtEQCd60f9ZaEQCSIRNdWMxVZKtVW1Gvyzr4owA29GX//qcR/xtLYCfa3tsUXGYXk/Q5aDSlDMzJfLXpjeU78wlXHzG8sE0ng4Y8slRIALVnTdODfc6lKQg4041dWNGJDb8FqsNofC4PiaIVQAzm7jhXiwPcRYoKWU518apnkEG5uRMr/BNYjyohsi+V1bMogtHulYaCQQFZRm8zHcDcf2W51zMVDojE37fBWHVVdjhk7EmyyQjbYF86gHoZl2fh42shZ44iwBuARa51xpzn9lK8oQToUUyEaFZSL8+4V0lApPz0JMK8DewN6mLPV1vsMuWtemJQ+sjdvTWpM30Ij9N6TkDYQSgL53i2HTqOchJCzxRx7GRx6YqkAZufiH4Ynhi9PuwRWvBH7RhHxTLmczt0o+d4JGOh64UoqjfP/I/eC0Lmtg+2PsOVE3Zb9XZXpWqwyJzYKvxKePg12OWIE4n9A0y2eRbtBzP/6V0XXdqo6CC7cTqejUFfgfYCDB1V2BvVkjh4abqrFXXl/EWcjBKvS5PZVSHkMhHC1PMsF2dTMYpQP2H0uXcR+1pr1QpesuoKHwqIwGZsbu6S76MQxb99MhkrtVjVKUphLYyOk6y+BX/6WC1l/cIipxFmYRAYMoVJRhzOwk0r3lVKt2QKNC5YxN22MOK+gBtidUkUJuzRpJ7yYIoDULk8nj+1mxioZK7ABO3G1NF6xIRxXJAovx0L+WOGmS4YWSGatDQ6u2Z0hoec0TgbVYFDOmbvcwbOj6sDyZ2EHKPp4JyQDnZqJJkA5sMMrpDhJMl+z8pjp3KRYgXTp37MkRC8XXutH1qSxNBsY6Q3iwMRT/o/9iovW7dXRipzickW9IdSD1MJOHV+h7tfrw9APE9SftISBWz12Tv2RH5UyqfWhZziNOVnHxLw7SJthskACHdH6KosdTj4G/66wttHgxsHIND3HpgWB1JNs/i0/Ry5NcxqA6+FseD1SEJt4JRvDftsNNclgzaUMCkmo0opguzJEaAVRsaEd1pGdBbfYjEkbNn6kbWEBx7/+3hDO4w3JIdi6C6e6xvAVsQ88dT2WdEfXTAbxrhgHBHB7JXxOeMCVeOPKAz+Fw6Agift3k5Kzi1uwdlPJgODAG8UZNOXIVyVWdbTXlS3wjXCMgfL08FXz9Ca5jfPszCZJMqFslvtcv8CvEBn//RZNFh7rtbDg24+isNnEKgb6Wmjx79t2Y+dhQCDUFPFHWBFRTDlxT5Plz0933scrX5ZGi5tNsOQAdbg1+WahTfk//EgfFDxJaBkpXf0Y6fr6hRR6vHqkLZU7tZqCgxueXAQPOPxbdwdLlbdNNGkoWZS3itL3cvWl++c9+qPEwi0QJv9TcO5e6MVqvHsW7KsSVS7AusTqYLQNi1F+BT1nZ0353mYHJL0mTRTlbNIGhb2MA6IiF97JMxQwSl+8B1/4fk1W+Bqw+JnlOdtzEBa5Or4b2A2jR3pxEL3VjtFVoIFnTC3N7kpRgUO54onXCnSiLdQ4Ch9247vV4uTnjnkfA2PMuAVfd/Fo86IpJU2YHXQt39vqWi6naexOnY7YNmtlKCIWLr1eEV8UwRl1sLYELTRHJo7xWEPd2lJvCJNAY9vgBmQpbg0MYfTT0SOkqp/7GQJfaDY8qSkevw0UjhJaT5GPkfl82xmQZ7NwCQv8EZ9vJ+JZdYFha5+TmJ5oeumNgKkZzWnD0zXowF+uM6Y5J/MFBI2hZ4AFhcoGgkz+sKSxEmjuhXVkc8/YMUHgpZEziku27xHodEL177J7WbRXrVTLDrwOSckBe+kw4fwMCqOcZGXvNs67y+dPJSK3PhpPnS1qukgpJY7UOHdUq997mdk/QNOxRNKhL9u+P/RfKbeh+ipKnSvHpM8URKpHS9Hgglc81wrUiZUD1JM8+xBRe4nNwk0Zn31ge8QKMvZbs9bRCKpQMVcDhbiZURZNxLYfGD1lELD7i1lLPBRxlGs8/VS97ZQHbnbHjXn+GLAykhAL5QxJkiYySDqkABQAfAQIeLgueB1c9wNrCDDYQKaa0i4RoNTqZm1hCk7cZiCg49/X1sPZLCcdGlo8w7ikYf/b+wSFeV5vbLQUOU/D1m9FSTOgyejBzL4YsVXAWui50Am9UzdLq3Wchjha5mQK1YkbGuBMAfeS9EbSeB/ixB0uqhLRzAWQyj5QXeVVN7KKJUMQCjcdIct8od4PnPbVDUDFYt6DhVE6nmIISroVXhqGXwSmy+hMDAWlQPOr8hz0Mf/sV4sUHNG5ytYRDzfvpm3Ik+ZlpEU4r4yEuFbPf6lZoYGVaQbJTc9dg5UG1pkWDuItb8Js36EloS1nBayCxYP0OIfuk4Vws2MQEFwEspwaS0fgklcRa5P86fiR4LUDmJAQDJ7ZK0IjK9hTQ6JYrFHrYDVzG5zc+yuqMQiF0YIrDujjTCakDb8gmvRo+gdQIRmZU754R0e+SAwD+Nj75Lpcq3tY/pto1Lz94IZ8m9Yij3fC9l/q3d1+NCLtzEdRMPK8I63BmzTjUkzaq9kTItUhyJzqCtQdF7rRVMq1V1cPDezNWJFgWqmLTohehzQk2cfeHkEZX0zVRIz2IoRlBCMF+4EZA3+9bWfoUdKscncpLkTI4eQ+AGwKS28diHdRuJCilz95EIquDALKKjlCvMXbl4FYQm+moaH2asZaMYBvulLjtuS5ZuJ9X2nwnF7K0oVc7J2uYPnUgtOvYM4D4MAm3+L38QyOBOfN1dxl3ZYj1SdjeqsxV1n3vIedMhfrQOq2VwD5GVojydwgIog+saTMqAuNvZvJbJ3VvGjGvYgstoVgq5pUEC0Ox55b0jKa7mIvB1r3H/d64QWQ0YS0rdj5LBNQ8h1R6xUEIiEgaYT3dzov0ZWnsce0oWMGZdunNEQp6W8+fet2Io6UrR+zQam6gl/kA7UflI7N0NS6IIHc5CV9fvdBbIpmooxEVkNcoss2EJn+tbj7VZs5/QjRbOqSndacsSDxRTERezQTn4EegD5kJCTBawyGJBux9zYqtcENW27V+rBQMFxcWmxmHDDAKchpZWAsztJX/tyExwnyFqr9VfpPMXtVUXa0F7dCEbWrc5/LN9DDKf8VUtZvATcgN7HO/7yL7ET4NUBDpGBjsCCwu5in3Etj4pFCcMmQ+JggXL91VKw2rGZDAxh8bAF+sjv2NcoytQA/VaY3SsQMp+kHHGvdfaD94HNYcJxw5vqH7NmVaskqHo9kG9xwvzfpt81M3g/JNhWkw5FYHp/++SRX4/S8cAgfPL4LGBybYjJCU3R9d5X7rpY4sZ15O9bswSwD/wMSOBdLmvTJycZJkUP7iawf8m5suXLcE1lyJfjYM3yzyikqUtYmliIGSKupvNERSJ+scIHSow6aoY0eGRGNk/ipuE8+bVDFZg5OIIIyXjDs/xw1BC1p5JyxBn3btGK7xpRysVlDfSlhEEow6fN0FzXVF3zbsQBuyWCk+5gTtrs6KK9SXAJLNItXQFUAP3wKKQlhW6+1jMZWsua8wVIPLktyypHEBAJ0mLGD+SpTCwF6c7M3bKPT1aVdY5Bc0u04NthHjfzlTtVPtChoOk4j/p/h7xUbq4Ar5c5+WkQxiAhVSmwWLcEgJTAQ1quDRccf+ZbnBwujEmUncjhMBQc3HHOQ7m7uoWs7hfYLnyq94XjnukgsCC1AnKvHQy+HfmVlsPmVLz1Civy+ERE1ui6GluT5sz6FMcmhFhCINz9zTgt9oeG6Z+Ihj+X7ANtc4XRY5z9pB45JfhXLVHrMYngH2HBwGgH333ijpARNNp8PfqGpqwHxcdG1jI7N2xSAZYjhpcNARzwh08BuLt3bjFc19g/AcW0o0Mc4Bcq3WVkK5nkGN3Hovt1j9CQth+gUlCO0GUApLIvycGthFIhRtz5XUPHbOU4TrCEjABn3Givi9Mg+NyKqpItVS3ai/GMA0urOT9Oktk/n2YTqdz6WHydk+L6pRjKYvaeiDUZwG+bt6xVEBhWDXy+K/jXiUlkWKQcarzjoUY9Hl7PFH1aeta3DX+ECK5u20P0TGTZre0ew/rUM12Untfg+7ziBN5urt9eogcu0HccIfNR+oi3emYhIoUlrj/N6V4dsteaOhc8p+YU3Soy9nbtwmrimnCoOgD/QVMn7sCeUmPc9UeppfbY7g6zXVmz6w9z47mGYCEqaiXZ37ryLyL17ExYPLrdlq6tTjkAWsmIz/X9JJMlwzRVdvGvlTdZY7KhQuzyfL9oBPsnkf4Db32I9+gIEXdhl00yqynXPSxmBvfN1hUbA3Ry75O3GZiKeksV6a0nfFPyh0Gb2eGPShfs4Hq5iwqxmBHzi5VkLRDTWn1vNI94QySRJAj70d8wwyke5W3RBBdD1cwXO4Vvg68Y0HOS+4ATISrkyHU8qw5Pl0sCITzGKHVxL0uuzgsD2QWLZHYLmW9ao7cdcB6COduhCFHZfkCSJyLc1RJna5n1afNFy5O8x/d+P+DwFvTjv5Pg15SE0iH24DYSSstL8L7diJeqbaUJMsQlagDogzXJ86pFIrpHl69lo4fUkmYYuu10hx88EORGsmgIPkvoYregydxMByOqLcul9/Jfp1d2KnBFInNLZCTBOD4hOBDQmeX/uZ7Uz8goa3GOhjCQPKZTSbtQI9xRCWBwVFm5nFY+A7pA3qo5k8J3xxHx7dlgalHnt94vFCNG7H6eviC+XUvMsE8j0249eJHR75XM+DC5cR1gBw34Dt5i0nrcMkebk7uvNlZHb8azZGKRlXu/Hcl6OIqGZPpuntXP/nkLMvhj88u2pfGh490kkCwvXCkAUAqrFBXqjfWD04il0QZ75j1F9vT1/0WJ6OAcpkQjlRAakOZnGWEc1vjn7w3xPxXyNYxaFiGyLyVKHQRneM/1TohFJyNFLyqrKTg0XEOeAxXGEd0WzXZHDE8S9t4R834e++beffeBcaENIWUqOtbTvrcZDIaTlrNCvUY7PPXcQWqNeL4eajbM3lD8yh8byRmSEBIQMEib1JQAJ8YAaM6SENHZ03jQrzNr6w4OaoVH8bx0VHpOlLGfEDpVAKo/j4wQiiQhawiUdfolPzfMvKNdw/cmNrR+RbuEw3d2TV59DWt2ztV8YHw/L2OxSlwGnxg/4qZM6RrP3/djQ+ubilHmCoJr6niUOkHgt9l9DopvpmfBR8cILfCv88/rIjuYIFXNBsZ7F4PRMqzdRXhbGSR4k1HRRJleE2WFbMtuGAnqrLw2DwiigWwTF4jSqvMcfweYJIm1r9gqKNouSs5OlslF9Q8UT9flLDSEMqfR2FEtjdauIhHgeNrqTmB4ZIx/LstjitoiupIy09KI6HDdF5jKU/ITGtrWKDLuo1ctWvqz4toFDstCwFMr+XBisilfW/TZXO1LuwfM02PQMWvyR9QKracqJzhTX8lfHa6qKc+fDV/HpCGQnSbD5V262/Aii8EDOMDELrwxOokmr6D/27p9iWiQuYUvw1tUtP/48tr8ABINZZWmHHckoOIwYi0v7h1PSHmRCvWdQ/2prxdQtAx/zi/R+KN/WA1Iv6mujG7AKCAm1ORr/MID4iF16WW3fGLcbbWqnm0KLQV+rQgo/C1E0NdPK2Vm5AWq/iy4fU4kQ6oxYeMC3cUjtBYQILzD6dqzOcaoQVtUf4ReBpUxhnJb/0pj5FhmHiBG3V7yiPIMuw2OTId7htfJA/K7SIh9XRwyQGpYlzwgk8y+F09kmi8sD0mKxXGh8Pe2RT/VBnMsHpdix9zTw6jKUaxCVaANKOLCYmbqkH3c8c9c+FaIq6B04Y3HbZLWwGGt8yJjiFDs4MmyhOeI9Yj6/pK47Vpg9ftMvFh4HI5119QDLAt6QEA+xQ1UH8d6SuUR+zeRgPmWHNUBcVZ3WbLbiw64py/lCRq+wlr+Hy7aQ0rdqcT1380mHa/8CbbtqHRdEJDCfH0gvbPhtuiCapMLaOKYaSM7XPXwAY4O93+xy4INOB7vIFjeGaNFLkgBkDBo+bxYYoEpE14H2DMfgs4LkPJCvSE239+ITLT8usUVXYWqCLCtG3scADdyhuhBKqT21/Dyok0ejcQ7VmUw0ebQubANzYgSeSsLi2v62kYxNJNC/qyxWFeaF56ypXDmIKourOvCVW4t76J+jXY5yaMMNUNcSAev/ItsOw3lapmwRWi0rzT5WW3DXYQF9+gqKliyLp7LqvETfSvuU2K6ZOyrE85yQ6+FMsrZla0cmxT1OuF3Srs0neHXDzu7MzJXd5zBheJcwnzh02HV5xaNPTlqxsCZmaw1TvHmrGWfovVnNBvOIc53AE2Dsv94WwUrT0rH/FPxVnx+GnKQH9C6/J5o8dP3V+uYIojrUBF2VxeeNyD4B/q2tAPrP2xmbC0cnjCZHPAq5MdUoZmJMCqom2DL/yFz0TDbtNQrlL01U4tFfwc+PodPu39CZju/K26fvIE5bvFKqzCYo2Ona/EBerkTgmXEtoFYyPkv0udd5Bw5kvC+8X/HNJ7ZhmK7cJFLkMkUyjcbfpMU/yI3zMMwjwzwi+Jju2Xo7aEm2FR78ypXa/NB6k+E1gMdwYf3/RCDQae+6VkCsnN+DijJn9TdgGDsPtLRCN/gUxSe2lgbzWOctLm9EAsNg9nlwlJrAP+vcL8GYN9MqrSa4sEotc9s1v1em32PmXKsNiiJ3hEUMHyDZPn44QKPgq8T77/m0jAM4TuH/HiADbonf1KgZH4AlB0RKdF1/kP5XCxVmINgbV0Rjz3TjcW0XsLLlafXPeHfEKEcnjF0pY6RW4P+YHxRRWp1fucvZE+nx++CkZi1g2tiJlrlUxxJ2oIWVArzVhRs5Ysy6+5kdrPcej9qqVirH43q0YlX4IR1QXEEJz4LupJF8oHL13Jt8Z/qr3JrsaBIPFV+UrlWGDCdWJw0pknoFLPebaFtRoekxIT5mpuIzv2N61QmtGChufgtfmJ/W4dD9YOmDdx1yg/9cPRVQWA45rZPayIVW5VQHNTRLA9+wb0J9B8uCEYN98s3apKJCfx9qQajhSlTukguLfoY1eHmT+MVGfXyyxUAdPpf/S3eJknOF+5QWWoz2BWPz/II4GVT4XRPZZfMlINqG5CZBfFPPlEAhfMlKvF2y64ebQ6Rk03iXfc78zHOdjLpdAArqhGm4j3PKQW4YnWHZNGExP5tLYDluU/kncvmkFiFGjThr3pFvZJK9PMVbD4crH7zlEZs3ur6GUqhb9k/2V+BjkBMFxTHjAQfN+w+fsYYEy3QP7x5NxVw/YdmerMvK992KnH0YNOCWoxLCg821DEXvvQ3Drt/nWROkr9vGfizn/lV/z1RG48QaY6IyijFgk902QOH4gRzXe1bkKJ3iHgX/lzBZOPpP/MIfbpXp1foxsCXGVYR7yCD/tJB8WvLlvj3Oiar5z9edj0H7n6JIhvNgZz7dFbi3/7r2oFYhffUrzIVWsn0SR4pVdWO+HXVCzFJCfzbudz0MIaMy2nD9jmrdpvE1x75wx7OWzqjBAmrhS436pgh1vNhUvk9lCnQ3qnik3iVuKUfRm9Vre4z5l+gfrIqFoWM1BSY/zWyllEBHjoZnwZbV+5OugwOu9xR2h3v30M2mB2J/9uxJz8d7+fe+oDDm7vAiighLEIVYkyHJLCmK6V1KhGiL6g4GN1KzUApO0X3kzlLKE/HZ4jyq04SUF4X7xzaaXiYBxww8I8u1FizelWWQHfNRHH+AhluEh2f+6albPSyBhAyVTRkX6j+Fh+VMRq101HeucieBC+IRvPhiFeFig3XGE0gA4Z9zk/vtimrD6rqEeCanH/pnteN/UmydPghSQUYVFwqM8owguP0739bC1IeVS0hHTQ+z0waXLHscid5eMAcCkXWSPUD8/VnR0m8ClyoeIAEOmiCbl1drczQmeMTk4L/fz2s40xFQcTYB9qpGxhJitOOEvMq9HqNMDswHzAHBgUrDgMCGgQUcVAuCs8e/5/i0tqUeD4Ul7S7pMoEFPLV+rseho+if4Yu5/hO4YYHyrD0AgIH0A==';
            }
        }
        
        
        public PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollection(PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest) {
            setClientCert();
            //System.debug(clientCert_x);
            PayGovTCSOnline.StartOnlineCollection request_x = new PayGovTCSOnline.StartOnlineCollection();
            request_x.startOnlineCollectionRequest = startOnlineCollectionRequest;
            PayGovTCSOnline.StartOnlineCollectionResponseType response_x;
            Map<String, PayGovTCSOnline.StartOnlineCollectionResponseType> response_map_x = new Map<String, PayGovTCSOnline.StartOnlineCollectionResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'startOnlineCollection',
              'http://fms.treas.gov/services/tcsonline',
              'startOnlineCollectionResponse',
              'PayGovTCSOnline.StartOnlineCollectionResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.startOnlineCollectionResponse;
        }
        public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetails(PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest) {
            setClientCert();
            PayGovTCSOnline.CompleteOnlineCollectionWithDetails request_x = new PayGovTCSOnline.CompleteOnlineCollectionWithDetails();
            request_x.completeOnlineCollectionWithDetailsRequest = completeOnlineCollectionWithDetailsRequest;
            PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType response_x;
            Map<String, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType> response_map_x = new Map<String, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'completeOnlineCollectionWithDetails',
              'http://fms.treas.gov/services/tcsonline',
              'completeOnlineCollectionWithDetailsResponse',
              'PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.completeOnlineCollectionWithDetailsResponse;
        }
        /*public PayGovTCSOnline.CreateForceWithDetailsResponse createForceWithDetails(PayGovTCSOnline.CreateForceWithDetailsRequest createForceWithDetailsRequest) {
            setClientCert();
            PayGovTCSOnline.CreateForceWithDetails request_x = new PayGovTCSOnline.CreateForceWithDetails();
            request_x.createForceWithDetailsRequest = createForceWithDetailsRequest;
            PayGovTCSOnline.CreateForceWithDetailsResponseType response_x;
            Map<String, PayGovTCSOnline.CreateForceWithDetailsResponseType> response_map_x = new Map<String, PayGovTCSOnline.CreateForceWithDetailsResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'createForceWithDetails',
              'http://fms.treas.gov/services/tcsonline',
              'createForceWithDetailsResponse',
              'PayGovTCSOnline.CreateForceWithDetailsResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.createForceWithDetailsResponse;
        }*/
        /*public PayGovTCSOnline.CompleteOnlineCollectionResponse completeOnlineCollection(PayGovTCSOnline.CompleteOnlineCollectionRequest completeOnlineCollectionRequest) {
            setClientCert();
            PayGovTCSOnline.CompleteOnlineCollection request_x = new PayGovTCSOnline.CompleteOnlineCollection();
            request_x.completeOnlineCollectionRequest = completeOnlineCollectionRequest;
            PayGovTCSOnline.CompleteOnlineCollectionResponseType response_x;
            Map<String, PayGovTCSOnline.CompleteOnlineCollectionResponseType> response_map_x = new Map<String, PayGovTCSOnline.CompleteOnlineCollectionResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'completeOnlineCollection',
              'http://fms.treas.gov/services/tcsonline',
              'completeOnlineCollectionResponse',
              'PayGovTCSOnline.CompleteOnlineCollectionResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.completeOnlineCollectionResponse;
        }*/
        /*public PayGovTCSOnline.CreateForceResponse createForce(PayGovTCSOnline.CreateForceRequest createForceRequest) {
            setClientCert();
            PayGovTCSOnline.CreateForce request_x = new PayGovTCSOnline.CreateForce();
            request_x.createForceRequest = createForceRequest;
            PayGovTCSOnline.CreateForceResponseType response_x;
            Map<String, PayGovTCSOnline.CreateForceResponseType> response_map_x = new Map<String, PayGovTCSOnline.CreateForceResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'createForce',
              'http://fms.treas.gov/services/tcsonline',
              'createForceResponse',
              'PayGovTCSOnline.CreateForceResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.createForceResponse;
        }*/
        /*public PayGovTCSOnline.GetDetailsResponse getDetails(PayGovTCSOnline.GetDetailsRequest getDetailsRequest) {
            setClientCert();
            PayGovTCSOnline.GetDetails request_x = new PayGovTCSOnline.GetDetails();
            request_x.getDetailsRequest = getDetailsRequest;
            PayGovTCSOnline.GetDetailsResponseType response_x;
            Map<String, PayGovTCSOnline.GetDetailsResponseType> response_map_x = new Map<String, PayGovTCSOnline.GetDetailsResponseType>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://fms.treas.gov/services/tcsonline',
              'getDetails',
              'http://fms.treas.gov/services/tcsonline',
              'getDetailsResponse',
              'PayGovTCSOnline.GetDetailsResponseType'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getDetailsResponse;
        }*/
    }
}