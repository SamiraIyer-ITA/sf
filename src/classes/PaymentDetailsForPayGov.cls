public with sharing class PaymentDetailsForPayGov implements IPaymentDetails {

	public static final String METADATA_SETTINGS_NAME = 'PayGov';

	public static String getPaymentDetails(String paymentIdentifier, String remoteAccountName, String remoteTrackingId) {
		PayGovTCSSingleQueryService.TCSSingleQuery_Port singleQueryPort = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();

		//For whatever reason, the processTCSSingleQuery method sometimes fails.  The workaround is to attempt it up to 5 times.

		Integer maximumAttempts = 20;
		Integer currentAttempt = 1;
		PayGovTCSSingleQueryService.tcs_query_result queryResult;
		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		String agencyId = (String) paymentSettingsMap.get('Agency_Id__c');

		while (maximumAttempts >= currentAttempt) {
			try {
				queryResult = singleQueryPort.processTCSSingleQuery(agencyId, remoteAccountName, paymentIdentifier, remoteTrackingId, '');
				break;
			} catch (Exception e) {
				currentAttempt += 1;
			}
		}

		PayGovTCSSingleQueryService.tcs_plastic_card_results plasticCardResults = queryResult.tcs_pc_results;
		PayGovTCSSingleQueryService.tcs_ach_results achResults = queryResult.tcs_ach_results;
		PaymentDetailsForPayGov.ReturnValue returnValue = new PaymentDetailsForPayGov.ReturnValue();

			if (plasticCardResults != null) {
				//Credit Card Payment Details
				returnValue.isCreditCard = true;
				PayGovTCSSingleQueryService.PCSaleQueryResponse[] pcSaleQueryResponse = plasticCardResults.pc_sale_query_response;
				returnValue.accountNumber = pcSaleQueryResponse[0].masked_account_number;
				returnValue.transactionStatus = pcSaleQueryResponse[0].transaction_status;
				returnValue.transactionAmount= pcSaleQueryResponse[0].transaction_amount;
				returnValue.returnCode = pcSaleQueryResponse[0].return_code;
				returnValue.returnDetail = pcSaleQueryResponse[0].return_detail;
				returnValue.accountHolderName = pcSaleQueryResponse[0].account_holder_name;
				returnValue.transactionDate = pcSaleQueryResponse[0].transaction_date;
				returnValue.approvalCode = pcSaleQueryResponse[0].approval_code;
				returnValue.authResponseCode = pcSaleQueryResponse[0].auth_response_code;
				returnValue.authResponseText = pcSaleQueryResponse[0].auth_response_text;
				returnValue.avsResponseCode = pcSaleQueryResponse[0].avs_response_code;
				returnValue.cscResult = pcSaleQueryResponse[0].csc_result;
				returnValue.billingAddress = pcSaleQueryResponse[0].billing_info.billing_address;
				returnValue.billingAddress2 = pcSaleQueryResponse[0].billing_info.billing_address_2;
				returnValue.billingCity = pcSaleQueryResponse[0].billing_info.billing_city;
				returnValue.billingState = pcSaleQueryResponse[0].billing_info.billing_state;
				returnValue.billingZip = pcSaleQueryResponse[0].billing_info.billing_zip;
				returnValue.billingCountry = pcSaleQueryResponse[0].billing_info.billing_country;
			} else if (achResults!= null) {
				//ACH Payment Details
				returnValue.isAch = true;
				PayGovTCSSingleQueryService.ACHDebitQueryResponse[] achDebitQueryResponse = achResults.ach_debit_query_response;
				returnValue.accountNumber = achDebitQueryResponse[0].masked_account_number;
				returnValue.transactionStatus = achDebitQueryResponse[0].transaction_status;
				returnValue.transactionAmount= achDebitQueryResponse[0].transaction_amount;
				returnValue.returnCode = achDebitQueryResponse[0].return_code;
				returnValue.returnDetail = achDebitQueryResponse[0].return_detail;
				returnValue.accountHolderName = achDebitQueryResponse[0].account_holder_name;
				returnValue.transactionDate = achDebitQueryResponse[0].transaction_date;
				returnValue.accountType = achDebitQueryResponse[0].account_type;
				returnValue.effectiveDate = achDebitQueryResponse[0].effective_date;
				returnValue.routingTransitNumber = achDebitQueryResponse[0].routing_transit_number;
				returnValue.secCode = achDebitQueryResponse[0].sec_code;
				returnValue.returnReasonCode = achDebitQueryResponse[0].return_reason_code;
				returnValue.depositTicketNumber = achDebitQueryResponse[0].deposit_ticket_number;
				returnValue.debitVoucherNumber = achDebitQueryResponse[0].debit_voucher_number;
			} else{
				// This payment is not at Pay.gov
				return '';
			}
		return JSON.serialize(returnValue);
	}

	public class ReturnValue {
		public boolean isCreditCard = false;
		public boolean isAch = false;

		//Inputs
		public String agencyTrackingId;
		public String tcsAppId;
		public String payGovTrackingId;

		//Outputs

		//PC Sale
		public String approvalCode;
		public String authResponseCode;
		public String authResponseText;
		public String avsResponseCode;
		public String cscResult;
		public String billingAddress;
		public String billingAddress2;
		public String billingCity;
		public String billingState;
		public String billingZip;
		public String billingCountry;

		//Common Items
		public String returnCode;
		public String returnDetail;
		public String transactionStatus;
		public String transactionAmount;
		public String accountNumber;
		public String accountHolderName;
		public String transactionDate;
		//public PayGovTCSSingleQueryService.query_custom_fields custom_fields;
		//public String accountHolderEmailAddress;
		//public String batchId;

		//ACH Debit
		public String accountType;
		public String effectiveDate;
		public String routingTransitNumber;
		public String secCode;
		public String returnReasonCode;
		public String depositTicketNumber;
		public String debitVoucherNumber;
		//public String installmentNumber;
		//public String total_installments;
		//public String payment_frequency;*/
	}


}