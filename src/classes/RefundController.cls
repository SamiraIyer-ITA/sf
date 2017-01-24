public without sharing class RefundController {

    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c; 
    @TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c; 
    @TestVisible private static final String AGENCY_ID= PaymentSettings__c.getAll().get('AGENCY_ID').value__c; 
    @TestVisible private static final String PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
    
    @TestVisible private static Integer UNKNOWN_PAYMENT_TYPE = 0;
    @TestVisible private static Integer CREDIT_CARD_PAYMENT = 1;
    @TestVisible private static Integer ACH_PAYMENT = 2;
    
    //Class globals
    public String origAgencyTrackingId{get;set;}
    public String origPayGovTrackingId{get;set;}
    public String transactionAmount{get;set;}
    public String tcsAppId{get;set;}
    public Payment__c paymentObject{get;set;}

    public refundController(ApexPages.StandardController controller) {
        //this.showRefundButton = true;
        Payment__c payment= (Payment__c)controller.getRecord();  //Only gets the ID field
        paymentObject = [SELECT ID, Name, Opportunity__c, Pay_Gov_Tracking_Id__c, Application__c, Transaction_Amount__c FROM PAYMENT__C WHERE id= :payment.id limit 1];
        origAgencyTrackingId= String.valueOf(paymentObject.Name);
        origPayGovTrackingId= String.valueOf(paymentObject.Pay_Gov_Tracking_Id__c);
        transactionAmount = String.valueOf(paymentObject.Transaction_Amount__c );
        String application = String.valueOf(paymentObject.Application__c);
        if (application != null) {
            if (application.equalsIgnoreCase(PRIVACY_SHIELD_APP_NAME)) {
                tcsAppId = PRIVACY_SHIELD_APP_ID;
                //EVENT_SERVICES_APP_NAME doesn't yet exist, so the following code is commented
            /*} else if (application.equalsIgnoreCase(EVENTS_SERVICES_APP_NAME)) {
                tcsAppId = EVENTS_SERVICES_APP_ID;*/
            } else {
                //ERROR: Don't know the value of tcsAppId
            }
        } else {
            //ERROR: Don't know the value of tcsAppId
        }
    }
    
    public PageReference issueRefund() {
    
        if (String.isBlank(tcsAppId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unknown TCS Application ID'));
            return null;
        }
    
        System.debug('inside issueRefund()');
        
        Integer paymentType;
        
        //try {
            paymentType = determinePaymentType();
        //} catch (Exception e) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Didn\'t receive a timely response from pay.gov to determine the payment type.  Please try again to issue the refund.'));
        //    return null;
        //}
        
        if (paymentType == CREDIT_CARD_PAYMENT) {
            //Credit card payment.  Try to refund instantly.
            System.debug('Attempting to refund credit card payment');
        
            PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
            pcRefund.orig_paygov_tracking_id = origPayGovTrackingId;
            pcRefund.transaction_amount = transactionAmount;
            //pcRefund.transaction_amount = '1.00';  //For testing only.  Use line above otherwise.
            pcRefund.orig_agency_tracking_id = origAgencyTrackingId;

            System.debug('Calling TCSSinglePort');
        
            PayGovTCSSingleService.TCSSinglePort  payGovSingleService = new  PayGovTCSSingleService.TCSSinglePort();
            System.debug('Calling processPCRefund');
            PayGovTCSSingleService.PCRefundResponse_element  pcRefundResponse = payGovSingleService.processPCRefund(agency_id, tcsAppId, pcRefund);
            
            System.debug('pcRefundReponse = ' + pcRefundResponse );

            String status = 'Completed';  //'Failed', 'In Process' are the other choices
            String payGovTrackingId = String.valueOf(pcRefundResponse.pcRefund.paygov_tracking_id);
            Decimal returnedTransactionAmount = Decimal.valueOf(pcRefundResponse.pcRefund.transaction_amount);
            String transactionDate = String.valueOf(pcRefundResponse.pcRefund.transaction_date);
           	DateTime transactionDateGMT = null;
            if(! String.isEmpty(transactionDate)) {
                transactionDateGMT = DateTime.Valueof(transactionDate.replace('T', ' ')); 
                System.debug('transactionDateGMT: ' + transactionDateGMT);
                transactionDateGMT = getEST(transactionDateGMT);
                System.debug('EST transactionDateGMT: ' + transactionDateGMT);
            }
            String transactionStatus = pcRefundResponse.pcRefund.transaction_status;
            String returnCode = pcRefundResponse.pcRefund.return_code;
            String returnDetail = pcRefundResponse.pcRefund.return_detail;
            
            System.debug('Creating refundObject');
            
            Refund__c refundObject = new Refund__c(Payment__c = paymentObject.id, Status__c = status, Pay_Gov_Tracking_Id__c = payGovTrackingId,
                                                   Transaction_Amount__c = returnedTransactionAmount, Transaction_Status__c = transactionStatus,
                                                   Return_Code__c = returnCode, Transaction_Date__c = transactionDateGMT,
                                                   Return_Detail__c = returnDetail);
                                                   
            System.debug('insert refundObject');
                                                               
            insert refundObject;
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'This refund was successfully processed.'));
            return new PageReference('/' + paymentObject.id);
            
            
            
        
        } else {
            System.debug('Not a credit card payment.  Must contact NIST for the refund.');
            //refundObject.status = 'In Process';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Not a credit card payment.  Must contact NIST for the refund.'));
            return null;
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unknown Exception'));
        return null;
    }
    
    @TestVisible private Integer determinePaymentType() {
        PayGovTCSSingleQueryService.TCSSingleQuery_Port singleQueryPort = new PayGovTCSSingleQueryService.TCSSingleQuery_Port();
        
        System.debug('origPayGovTrackingId = ' + origPayGovTrackingId);
        System.debug('transactionAmount= ' + transactionAmount);
        System.debug('origAgencyTrackingId= ' + origAgencyTrackingId);
        System.debug('AGENCY_ID= ' + AGENCY_ID);
        System.debug('tcsAppId= ' + tcsAppId);  
        
        System.debug('Determining Payment Type');   
        
        //For whatever reason, the processTCSSingleQuery method sometimes fails.  The workaround is to attempt it up to 5 times.
        
        Integer maximumAttempts = 5;
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
                        return UNKNOWN_PAYMENT_TYPE;
                    }
                }
                queryResult = singleQueryPort.processTCSSingleQuery(AGENCY_ID, tcsAppId, origAgencyTrackingId, origPayGovTrackingId, '');
                System.debug('Query Result: ' + queryResult);
                break;
            } catch (Exception e) {
                System.debug('Current Attempt ' + currentAttempt + ' failed');
                currentAttempt += 1;
            }
        }
        
        System.debug('Gettting payment type results');
        System.debug('Query Result: ' + queryResult);
        
        PayGovTCSSingleQueryService.tcs_plastic_card_results plasticCardResults; 
        PayGovTCSSingleQueryService.tcs_ach_results achResults;
        if (queryResult != null) {
            plasticCardResults = queryResult.tcs_pc_results;
            System.debug('Got plastic card results');
            achResults = queryResult.tcs_ach_results;
            System.debug('Got ACH results');
        }
        
        if (plasticCardResults != null) {
            //Credit Card Payment Details
            System.debug('Credit Card Payment');
            return CREDIT_CARD_PAYMENT;
        } else {
            //ACH Payment Details
            System.debug('ACH Payment');
            return ACH_PAYMENT;
        }
    } 
    
    @TestVisible private static Datetime getEST(Datetime dtTime)
    {    
        Date d = dtTime.dateGmt();
        System.debug('dateGmt: ' + d);
        Time t = dtTime.timeGmt();
        System.debug('timeGmt: ' + t);
        Datetime estDateTime = Datetime.newInstanceGmt(d,t);
        System.debug('estDateTime : ' + estDateTime);
        return estDateTime;
    }
    
    public PageReference redirectToPayment(){
        PageReference pr = new PageReference('/' + paymentObject.id);
        pr.setRedirect(true);
        return pr;
    }
   
    
}