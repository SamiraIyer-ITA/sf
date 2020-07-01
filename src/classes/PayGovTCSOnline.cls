//Methods to communicate with pay.gov for Hosted Collection pages (synchronously)

public class PayGovTCSOnline {

	private static final String METADATA_SETTINGS_NAME = 'PayGov';
	
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
		public String payment_type;
		@TestVisible private String[] payment_type_type_info = new String[]{'payment_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
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
		public String payment_type;
		private String[] payment_type_type_info = new String[]{'payment_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
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
		public String payment_type;
		private String[] payment_type_type_info = new String[]{'payment_type','http://fms.treas.gov/services/tcsonline',null,'1','1','false'};
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
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public Integer timeout_x = 60000;
		@TestVisible private String[] ns_map_type_info = new String[]{'http://fms.treas.gov/services/common', 'PayGovCommon', 'http://fms.treas.gov/services/tcsonline', 'PayGovTCSOnline'};

		public PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollection(PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest, String paymentId) {
			RecordLog.push('PayGovTCSOnline.startOnlineCollection');
			PayGovTCSOnline.StartOnlineCollection request_x = new PayGovTCSOnline.StartOnlineCollection();
			request_x.startOnlineCollectionRequest = startOnlineCollectionRequest;
			String endpoint_x = (String) paymentSettingsMap.get('Token_Endpoint__c');
			RecordLog.message('Endpoint: ' + endpoint_x);
			PayGovTCSOnline.StartOnlineCollectionResponseType response_x;
			Map<String, PayGovTCSOnline.StartOnlineCollectionResponseType> response_map_x = new Map<String, PayGovTCSOnline.StartOnlineCollectionResponseType>();
			response_map_x.put('response_x', response_x);
			RecordLog.message('Request: ' + request_x);
			RecordLog.message('WebServiceCallout.invoke');
			try {
				WebServiceCallout.invoke(
					this,
					request_x,
					response_map_x,
					new String[]{
						endpoint_x,
						'',
						'http://fms.treas.gov/services/tcsonline',
						'startOnlineCollection',
						'http://fms.treas.gov/services/tcsonline',
						'startOnlineCollectionResponse',
						'PayGovTCSOnline.StartOnlineCollectionResponseType'
					}
				);
			} catch (Exception e) {
				RecordLog.message('Exception: ' + e.getMessage());
				throw e;
			} finally {
				//The response map to this callout is not really useful, so don't record it.  Also, if there's an error, it won't populate.
				//RecordLog.message('Response Map: ' + response_map_x);
				RecordLog.emit(paymentId);
			}
			response_x = response_map_x.get('response_x');
			return response_x.startOnlineCollectionResponse;
		}
		public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetails(PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest, String paymentId) {
			RecordLog.push('PayGovTCSOnline.completeOnlineCollectionWithDetails');
			PayGovTCSOnline.CompleteOnlineCollectionWithDetails request_x = new PayGovTCSOnline.CompleteOnlineCollectionWithDetails();
			request_x.completeOnlineCollectionWithDetailsRequest = completeOnlineCollectionWithDetailsRequest;
			String endpoint_x = (String) paymentSettingsMap.get('Completion_Endpoint__c');
			RecordLog.message('Endpoint: ' + endpoint_x);
			PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType response_x;
			Map<String, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType> response_map_x = new Map<String, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType>();
			response_map_x.put('response_x', response_x);
			try {
				WebServiceCallout.invoke(
					this,
					request_x,
					response_map_x,
					new String[]{
						endpoint_x,
						'',
						'http://fms.treas.gov/services/tcsonline',
						'completeOnlineCollectionWithDetails',
						'http://fms.treas.gov/services/tcsonline',
						'completeOnlineCollectionWithDetailsResponse',
						'PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponseType'
					}
				);
			} catch (Exception e) {
				RecordLog.message('Exception: ' + e.getMessage());
				throw e;
			} finally {
				RecordLog.message('Response Map: ' + response_map_x);
				RecordLog.emit(paymentId);
			}
			response_x = response_map_x.get('response_x');
			return response_x.completeOnlineCollectionWithDetailsResponse;
		}
		/*public PayGovTCSOnline.CreateForceWithDetailsResponse createForceWithDetails(PayGovTCSOnline.CreateForceWithDetailsRequest createForceWithDetailsRequest) {
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