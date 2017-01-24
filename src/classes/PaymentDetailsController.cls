public without sharing class PaymentDetailsController {

    public PaymentDetailsController(ApexPages.StandardController controller) {
        this.showDetailsButton = true;
        Payment__c payment= (Payment__c)controller.getRecord();  //Only gets the ID field
        Payment__c paymentObject = [SELECT ID, Name, Opportunity__c, Pay_Gov_Tracking_Id__c FROM PAYMENT__C WHERE id= :payment.id limit 1];
        agencyTrackingId = String.valueOf(paymentObject.Name);
        payGovTrackingId = String.valueOf(paymentObject.Pay_Gov_Tracking_Id__c);
    }

    public void getDetails() {
        System.debug('AgencyTrackingId: ' + agencyTrackingId);
        System.debug('PayGovTrackingId: ' + payGovTrackingId);
        if (payGovTrackingId != null) {
            getPaymentDetails(agencyTrackingId, PRIVACY_SHIELD_APP_ID, payGovTrackingId, true);
            this.showDetailsButton = false;            
        }
    }
    
    //Used for testing
    /*public PaymentDetailsController() {
        //getPaymentDetails('SP000000132', PRIVACY_SHIELD_APP_ID, '3FP3542I', true);  //Credit Card
        getPaymentDetails('SP000000124', PRIVACY_SHIELD_APP_ID, '3FP35JN8', true);  //ACH
    }*/
    
    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSHQA';  //QA
    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSH';  //Production
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENUQA';  //QA
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENU';  //Production
    //private static final String PRIVACY_SHIELD_APP = 'PS';  //Used to determine what to show on the Payment page
    //private static final String EVENTS_SERVICES_APP = 'ES';  //Used to determine what to show on the Payment page
    
    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c; 
    @TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c; 
    @TestVisible private static final String AGENCY_ID= PaymentSettings__c.getAll().get('AGENCY_ID').value__c; 
    
    public boolean showDetailsButton{get;set;}
    public boolean isCreditCard{get;set;}
    public boolean isAch{get;set;}    
    
    
    //Inputs
    public String agencyTrackingId{get;set;}
    public String tcsAppId{get;set;}
    public String payGovTrackingId{get;set;}
    
    //Outputs
    
    //PC Sale
    public String approvalCode{get;set;}
    public String authResponseCode{get;set;}
    public String authResponseText{get;set;}
    public String avsResponseCode{get;set;}
    public String cscResult{get;set;}
    public String billingAddress{get;set;}
    public String billingAddress2{get;set;}
    public String billingCity{get;set;}
    public String billingState{get;set;}
    public String billingZip{get;set;}
    public String billingCountry{get;set;}
    
    //Common Items
    public String returnCode{get;set;}
    public String returnDetail{get;set;}
    public String transactionStatus{get;set;}
    public String transactionAmount{get;set;}
    public String accountNumber{get;set;}
    public String accountHolderName{get;set;}
    public String transactionDate{get;set;}
    //public PayGovTCSSingleQueryService.query_custom_fields custom_fields{get;set;}
    //public String accountHolderEmailAddress{get;set;}
    //public String batchId{get;set;}
    
    //ACH Debit
    public String accountType{get;set;}
    public String effectiveDate{get;set;}
    public String routingTransitNumber{get;set;}
    public String secCode{get;set;}
    public String returnReasonCode{get;set;}
    public String depositTicketNumber{get;set;}
    public String debitVoucherNumber{get;set;}
    //public String installmentNumber{get;set;}
    //public String total_installments{get;set;}
    //public String payment_frequency{get;set;}
    
    @TestVisible private void getPaymentDetails(String agencyTrackingId, String tcsAppId, String payGovTrackingId, boolean isPayment) {
        this.agencyTrackingId= agencyTrackingId;
        this.tcsAppId= tcsAppId;
        this.payGovTrackingId= payGovTrackingId;
    
        PayGovTCSSingleQueryService.TCSSingleQuery_Port singleQueryPort = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();
        
        System.debug('origPayGovTrackingId = ' + payGovTrackingId);
        System.debug('origAgencyTrackingId= ' + agencyTrackingId);
        System.debug('AGENCY_ID= ' + AGENCY_ID);
        System.debug('tcsAppId= ' + tcsAppId);  
        
        System.debug('Determining Payment Type');   
        
        //For whatever reason, the processTCSSingleQuery method sometimes fails.  The workaround is to attempt it up to 5 times.
        
        Integer maximumAttempts = 20;
        Integer currentAttempt = 1;
        PayGovTCSSingleQueryService.tcs_query_result queryResult;
        
        while (maximumAttempts >= currentAttempt) {
            try {   
                if(Test.isRunningTest()) {
                    System.debug('Current Page = ' + ApexPages.currentPage());
                    PageReference pageRef = ApexPages.currentPage();
                    if (pageRef.getUrl().equals('creditCard')) {
                        System.debug('Current Page is Credit Card Test');
                        Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryCCMockImpl());
                    } else if (pageRef.getUrl().equals('ach')) {
                        System.debug('Current Page is ACH Test');
                        Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryAchMockImpl());
                    } else {
                        //This shouldn't happen in current testing as only credit card and ach payments are allowed.
                        return;
                    }
                }
                queryResult = singleQueryPort.processTCSSingleQuery(AGENCY_ID, tcsAppId, agencyTrackingId, payGovTrackingId, '');
                break;
            } catch (Exception e) {
                System.debug('Current Attempt ' + currentAttempt + ' failed');
                currentAttempt += 1;
            }
        }
        
        System.debug('queryResult = ' + queryResult);
        
        System.debug('Gettting payment type results');
        
        PayGovTCSSingleQueryService.tcs_plastic_card_results plasticCardResults = queryResult.tcs_pc_results;
        
        System.debug('Got plastic card results');
        
        PayGovTCSSingleQueryService.tcs_ach_results achResults = queryResult.tcs_ach_results; 
        
        System.debug('Got ACH results');
        
        if (isPayment) {
            if (plasticCardResults != null) {
                //Credit Card Payment Details
                isCreditCard = true;
                PayGovTCSSingleQueryService.PCSaleQueryResponse[] pcSaleQueryResponse = plasticCardResults.pc_sale_query_response;
                this.transactionStatus = pcSaleQueryResponse[0].transaction_status;
                this.transactionAmount= pcSaleQueryResponse[0].transaction_amount;
                this.returnCode = pcSaleQueryResponse[0].return_code;
                this.returnDetail = pcSaleQueryResponse[0].return_detail;
                this.accountHolderName = pcSaleQueryResponse[0].account_holder_name;
                this.transactionDate = pcSaleQueryResponse[0].transaction_date;
                this.approvalCode = pcSaleQueryResponse[0].approval_code;
                this.authResponseCode = pcSaleQueryResponse[0].auth_response_code;
                this.authResponseText = pcSaleQueryResponse[0].auth_response_text;
                this.avsResponseCode = pcSaleQueryResponse[0].avs_response_code;
                this.cscResult = pcSaleQueryResponse[0].csc_result;
                this.billingAddress = pcSaleQueryResponse[0].billing_info.billing_address;
                this.billingAddress2 = pcSaleQueryResponse[0].billing_info.billing_address_2;
                this.billingCity = pcSaleQueryResponse[0].billing_info.billing_city;
                this.billingState = pcSaleQueryResponse[0].billing_info.billing_state;
                this.billingZip = pcSaleQueryResponse[0].billing_info.billing_zip;
                this.billingCountry = pcSaleQueryResponse[0].billing_info.billing_country;
                System.debug('Done with credit card details');
            } else {
                //ACH Payment Details
                isAch = true;
                PayGovTCSSingleQueryService.ACHDebitQueryResponse[] achDebitQueryResponse = achResults.ach_debit_query_response;
                this.transactionStatus = achDebitQueryResponse[0].transaction_status;
                this.transactionAmount= achDebitQueryResponse[0].transaction_amount;
                this.returnCode = achDebitQueryResponse[0].return_code;
                this.returnDetail = achDebitQueryResponse[0].return_detail;
                this.accountHolderName = achDebitQueryResponse[0].account_holder_name;
                this.transactionDate = achDebitQueryResponse[0].transaction_date;
                this.accountType = achDebitQueryResponse[0].account_type;
                this.effectiveDate = achDebitQueryResponse[0].effective_date;
                this.routingTransitNumber = achDebitQueryResponse[0].routing_transit_number;
                this.secCode = achDebitQueryResponse[0].sec_code;
                this.returnReasonCode = achDebitQueryResponse[0].return_reason_code;
                this.depositTicketNumber = achDebitQueryResponse[0].deposit_ticket_number;
                System.debug('Done with ACH details');
            }
        } else {
            //Checking the details for a refund
            PayGovTCSSingleQueryService.PCRefundQueryResponse[] pcRefundQueryResponse = plasticCardResults.pc_refund_with_paygov_tracking_id_query_response;
        }
    }
    
}