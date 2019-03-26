public with sharing class PaymentDetailsLightningController {

    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP_NAME = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_NAME').value__c;
    @TestVisible private static final String AGENCY_ID= PaymentSettings__c.getAll().get('AGENCY_ID').value__c;

    @AuraEnabled
    public boolean isCreditCard{get;set;}

    @AuraEnabled
    public boolean isAch{get;set;}


    //Inputs
    @AuraEnabled
    public String agencyTrackingId{get;set;}
    @AuraEnabled
    public String tcsAppId{get;set;}
    @AuraEnabled
    public String payGovTrackingId{get;set;}

    //Outputs

    //PC Sale
    @AuraEnabled
    public String approvalCode{get;set;}
    @AuraEnabled
    public String authResponseCode{get;set;}
    @AuraEnabled
    public String authResponseText{get;set;}
    @AuraEnabled
    public String avsResponseCode{get;set;}
    @AuraEnabled
    public String cscResult{get;set;}
    @AuraEnabled
    public String billingAddress{get;set;}
    @AuraEnabled
    public String billingAddress2{get;set;}
    @AuraEnabled
    public String billingCity{get;set;}
    @AuraEnabled
    public String billingState{get;set;}
    @AuraEnabled
    public String billingZip{get;set;}
    @AuraEnabled
    public String billingCountry{get;set;}

    //Common Items
    @AuraEnabled
    public String returnCode{get;set;}
    @AuraEnabled
    public String returnDetail{get;set;}
    @AuraEnabled
    public String transactionStatus{get;set;}
    @AuraEnabled
    public String transactionAmount{get;set;}
    @AuraEnabled
    public String accountNumber{get;set;}
    @AuraEnabled
    public String accountHolderName{get;set;}
    @AuraEnabled
    public String transactionDate{get;set;}
    //public PayGovTCSSingleQueryService.query_custom_fields custom_fields{get;set;}
    //public String accountHolderEmailAddress{get;set;}
    //public String batchId{get;set;}

    //ACH Debit
    @AuraEnabled
    public String accountType{get;set;}
    @AuraEnabled
    public String effectiveDate{get;set;}
    @AuraEnabled
    public String routingTransitNumber{get;set;}
    @AuraEnabled
    public String secCode{get;set;}
    @AuraEnabled
    public String returnReasonCode{get;set;}
    @AuraEnabled
    public String depositTicketNumber{get;set;}
    @AuraEnabled
    public String debitVoucherNumber{get;set;}
    //public String installmentNumber{get;set;}
    //public String total_installments{get;set;}
    //public String payment_frequency{get;set;}

    @AuraEnabled
    public static PaymentDetailsLightningController getPaymentDetails(Id paymentId) {
        System.debug('Payment Id: ' + paymentId);
        PaymentDetailsLightningController paymentDetailsLightningController = new PaymentDetailsLightningController();
        Payment__c paymentObject = [SELECT Id, Name, Opportunity__c, Pay_Gov_Tracking_Id__c, Application__c FROM PAYMENT__C WHERE Id= :paymentId LIMIT 1];
        paymentDetailsLightningController.agencyTrackingId = String.valueOf(paymentObject.Name);
        paymentDetailsLightningController.payGovTrackingId = String.valueOf(paymentObject.Pay_Gov_Tracking_Id__c);
        if (paymentDetailsLightningController.payGovTrackingId != null) {
            if (paymentObject.Application__c == PRIVACY_SHIELD_APP_NAME) {
                paymentDetailsLightningController = getPaymentDetails(paymentDetailsLightningController.agencyTrackingId, PRIVACY_SHIELD_APP_ID, paymentDetailsLightningController.payGovTrackingId, paymentDetailsLightningController, true);
            } else {
                //paymentObject.Application__c == EVENTS_SERVICES_APP_NAME
                paymentDetailsLightningController = getPaymentDetails(paymentDetailsLightningController.agencyTrackingId, EVENTS_SERVICES_APP_ID, paymentDetailsLightningController.payGovTrackingId, paymentDetailsLightningController, true);
            }
        }
        return paymentDetailsLightningController;
    }

    @TestVisible private static PaymentDetailsLightningController getPaymentDetails(String agencyTrackingId, String tcsAppId, String payGovTrackingId, PaymentDetailsLightningController paymentDetailsLightningController, boolean isPayment) {
        paymentDetailsLightningController.agencyTrackingId= agencyTrackingId;
        paymentDetailsLightningController.tcsAppId= tcsAppId;
        paymentDetailsLightningController.payGovTrackingId= payGovTrackingId;

        PayGovTCSSingleQueryService.TCSSingleQuery_Port singleQueryPort = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();

        //For whatever reason, the processTCSSingleQuery method sometimes fails.  The workaround is to attempt it up to 5 times.

        Integer maximumAttempts = 20;
        Integer currentAttempt = 1;
        PayGovTCSSingleQueryService.tcs_query_result queryResult;

        while (maximumAttempts >= currentAttempt) {
            try {
                queryResult = singleQueryPort.processTCSSingleQuery(AGENCY_ID, tcsAppId, agencyTrackingId, payGovTrackingId, '');
                break;
            } catch (Exception e) {
                System.debug('Current Attempt ' + currentAttempt + ' failed');
                currentAttempt += 1;
            }
        }

        PayGovTCSSingleQueryService.tcs_plastic_card_results plasticCardResults = queryResult.tcs_pc_results;

        PayGovTCSSingleQueryService.tcs_ach_results achResults = queryResult.tcs_ach_results;

        if (isPayment) {
            if (plasticCardResults != null) {
                //Credit Card Payment Details
                paymentDetailsLightningController.isCreditCard = true;
                PayGovTCSSingleQueryService.PCSaleQueryResponse[] pcSaleQueryResponse = plasticCardResults.pc_sale_query_response;
                if (pcSaleQueryResponse != null && pcSaleQueryResponse.size() > 0) {
                    paymentDetailsLightningController.accountNumber = pcSaleQueryResponse[0].masked_account_number;
                    paymentDetailsLightningController.transactionStatus = pcSaleQueryResponse[0].transaction_status;
                    paymentDetailsLightningController.transactionAmount = pcSaleQueryResponse[0].transaction_amount;
                    paymentDetailsLightningController.returnCode = pcSaleQueryResponse[0].return_code;
                    paymentDetailsLightningController.returnDetail = pcSaleQueryResponse[0].return_detail;
                    paymentDetailsLightningController.accountHolderName = pcSaleQueryResponse[0].account_holder_name;
                    paymentDetailsLightningController.transactionDate = pcSaleQueryResponse[0].transaction_date;
                    paymentDetailsLightningController.approvalCode = pcSaleQueryResponse[0].approval_code;
                    paymentDetailsLightningController.authResponseCode = pcSaleQueryResponse[0].auth_response_code;
                    paymentDetailsLightningController.authResponseText = pcSaleQueryResponse[0].auth_response_text;
                    paymentDetailsLightningController.avsResponseCode = pcSaleQueryResponse[0].avs_response_code;
                    paymentDetailsLightningController.cscResult = pcSaleQueryResponse[0].csc_result;
                    paymentDetailsLightningController.billingAddress = pcSaleQueryResponse[0].billing_info.billing_address;
                    paymentDetailsLightningController.billingAddress2 = pcSaleQueryResponse[0].billing_info.billing_address_2;
                    paymentDetailsLightningController.billingCity = pcSaleQueryResponse[0].billing_info.billing_city;
                    paymentDetailsLightningController.billingState = pcSaleQueryResponse[0].billing_info.billing_state;
                    paymentDetailsLightningController.billingZip = pcSaleQueryResponse[0].billing_info.billing_zip;
                    paymentDetailsLightningController.billingCountry = pcSaleQueryResponse[0].billing_info.billing_country;
                }
            } else {
                //ACH Payment Details
                paymentDetailsLightningController.isAch = true;
                PayGovTCSSingleQueryService.ACHDebitQueryResponse[] achDebitQueryResponse = achResults.ach_debit_query_response;
                if (achDebitQueryResponse != null && achDebitQueryResponse.size() > 0) {
                    paymentDetailsLightningController.accountNumber = achDebitQueryResponse[0].masked_account_number;
                    paymentDetailsLightningController.transactionStatus = achDebitQueryResponse[0].transaction_status;
                    paymentDetailsLightningController.transactionAmount = achDebitQueryResponse[0].transaction_amount;
                    paymentDetailsLightningController.returnCode = achDebitQueryResponse[0].return_code;
                    paymentDetailsLightningController.returnDetail = achDebitQueryResponse[0].return_detail;
                    paymentDetailsLightningController.accountHolderName = achDebitQueryResponse[0].account_holder_name;
                    paymentDetailsLightningController.transactionDate = achDebitQueryResponse[0].transaction_date;
                    paymentDetailsLightningController.accountType = achDebitQueryResponse[0].account_type;
                    paymentDetailsLightningController.effectiveDate = achDebitQueryResponse[0].effective_date;
                    paymentDetailsLightningController.routingTransitNumber = achDebitQueryResponse[0].routing_transit_number;
                    paymentDetailsLightningController.secCode = achDebitQueryResponse[0].sec_code;
                    paymentDetailsLightningController.returnReasonCode = achDebitQueryResponse[0].return_reason_code;
                    paymentDetailsLightningController.depositTicketNumber = achDebitQueryResponse[0].deposit_ticket_number;
                    paymentDetailsLightningController.debitVoucherNumber = achDebitQueryResponse[0].debit_voucher_number;
                }
            }
        } else {
            //Checking the details for a refund
            PayGovTCSSingleQueryService.PCRefundQueryResponse[] pcRefundQueryResponse = plasticCardResults.pc_refund_with_paygov_tracking_id_query_response;
        }
        return paymentDetailsLightningController;
    }

}