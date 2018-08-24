public without sharing class Payment {
    
    public static final String LANGUAGE = 'en';
    //public static final String PAY_GOV_URL = 'https://qa.pay.gov/tcsonline/payment.do';  //QA
    //public static final String PAY_GOV_URL = 'https://www.pay.gov/tcsonline/payment.do';  //Production
    
    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSHQA';  //QA
    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSH';  //Production
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENUQA';  //QA
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENU';  //Production
    
    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c; 
    @TestVisible private static final String PAY_GOV_URL = PaymentSettings__c.getAll().get('PAY_GOV_TCS_ONLINE_URL').value__c; 
    
    public String getAgencyTrackingId() {
        Payment__c paymentObject = new Payment__c();
        insert paymentObject;
        //Since name is an Auto-Number field, must query the paymentObject to get the value
        paymentObject = [SELECT Name FROM payment__c WHERE Id = :paymentObject.id LIMIT 1];
        return paymentObject.Name;
    }
    
    public String getAgencyTrackingId(Id OrderId){
        Payment__c paymentObject = new Payment__c();
            paymentObject.Order__c = OrderId;
        insert paymentObject;
        //Since Name is an Auto-Number field, must query the paymentObject to get the value
        paymentObject = [SELECT Name FROM payment__c WHERE Id = :paymentObject.id LIMIT 1];
        return paymentObject.Name;        
    }
    public String getAgencyTrackingId(String PaymentName, Id OrderId){
        //List<Payment__c> pmtList = [SELECT Name FROM payment__c WHERE Name = :PaymentName AND Transaction_Status__c = '' AND Order__c =: OrderId LIMIT 1];
        //if(pmtList.size() > 0) {
        //    return pmtList[0].Name;
        //} else {
            Payment__c paymentObject = new Payment__c();
            paymentObject.Order__c = OrderId;
            insert paymentObject;
            //Since Name is an Auto-Number field, must query the paymentObject to get the value
            paymentObject = [SELECT Name FROM payment__c WHERE Id = :paymentObject.Id LIMIT 1];
            return paymentObject.Name;     
        //}
           
    }
    
    //Step 1: Get a token FROM pay.gov for the transaction    
    public String getToken(String agency_tracking_id, String tcs_app_id, String transaction_type, String transaction_amount, String url_success, String url_cancel ) {
        return getToken(agency_tracking_id, tcs_app_id, transaction_type, transaction_amount, url_success, url_cancel, null, null, null, null, null, null, null, null);
    }
    
    public String getToken(String agency_tracking_id, String tcs_app_id, String transaction_type, String transaction_amount, String url_success, String url_cancel,
        String account_holder_name, String billing_address, String billing_address2, String billing_city, String billing_state, String billing_zip,
        String billing_country, String email_address) {
            
        PayGovTCSOnline.StartOnlineCollectionRequest startOnlineCollectionRequest = new PayGovTCSOnline.StartOnlineCollectionRequest();
        
        //POPULATE REQUIRED ELEMENTS
        startOnlineCollectionRequest.tcs_app_id = tcs_app_id;
        startOnlineCollectionRequest.agency_tracking_id = agency_tracking_id;  //21 char LIMIT in general, but 11 char LIMIT for Vantiv.  SP + 9 digits
        startOnlineCollectionRequest.transaction_type = transaction_type;  //'Authorization' or 'Sale'
        startOnlineCollectionRequest.transaction_amount = transaction_amount;  //cannot be negative
        startOnlineCollectionRequest.language = Payment.LANGUAGE;
        startOnlineCollectionRequest.url_success = url_success;
        startOnlineCollectionRequest.url_cancel = url_cancel;
        //END REQUIRED ELEMENTS
        
        //POPULATE OPTIONAL ELEMENTS
        if (account_holder_name != null) {
            startOnlineCollectionRequest.account_holder_name = account_holder_name.substring(0,80); //80 char limit
        }
        if (billing_address != null) {
            startOnlineCollectionRequest.billing_address = billing_address.substring(0,80);  //80 char limit
        }
        if (billing_address2 != null) {        
            startOnlineCollectionRequest.billing_address2 = billing_address2.substring(0,80); //80 char limit
        }
        if (billing_city != null) {
            startOnlineCollectionRequest.billing_city = billing_city.substring(0,40); //40 char limit
        }
        if (billing_state != null) {
            startOnlineCollectionRequest.billing_state = billing_state.substring(0,2); //2 char limit
        }
        if (billing_zip != null) {
            startOnlineCollectionRequest.billing_zip = billing_zip.substring(0,20); //20 char limit
        }
        if (billing_country != null) {
            startOnlineCollectionRequest.billing_country = billing_country.substring(0,3);  //3 digit ISO code
        }
        if (email_address != null) {
            startOnlineCollectionRequest.email_address = email_address.substring(0,80);  //80 char limit
        }
        //END OPTIONAL ELEMENTS
        
        PayGovTCSOnline.CustomCollectionFields customFields = new PayGovTCSOnline.CustomCollectionFields();
        if (tcs_app_id.equals(PRIVACY_SHIELD_APP_ID)) {
            //Privacy Shield
            //TODO: Does the Fund Code Fiscal Year (3rd element below) need to be dynamic?
            customFields.custom_field_1 = '55:0023:' + getCurrentFiscalYear() + ':SAFH232-000:35-05-0001-01-00-00-00:05-20-00-00:' + transaction_amount + '::::::::';  //Product #1 of this transaction.  transaction_amount must have 2 decimals, e.g. 100.00
        } else {
            //Events/Services - To be dynamically filled in
            customFields.custom_field_1 = '::::::::::::::';
        }
        customFields.custom_field_2 = '::::::::::::::';  //Product #2 of this transaction 
        customFields.custom_field_3 = '::::::::::::::';  //Product #3 of this transaction
        customFields.custom_field_4 = '::::::::::::::';  //Product #4 of this transaction
        customFields.custom_field_5 = '::::::::::::::';  //Product #5 of this transaction
        customFields.custom_field_6 = '::::::::::::::';  //Product #6 of this transaction
        customFields.custom_field_7 = '::::::::::::::';  //Product #7 of this transaction
        customFields.custom_field_8 = '::::::::::::::';  //Product #8 of this transaction
        customFields.custom_field_9 = '::::::::::::::';  //Product #9 of this transaction
        customFields.custom_field_10 = '::::::::::::::';  //Product #10 of this transaction
        customFields.custom_field_11 = '::::::::::::::';  //For shipping charges
        customFields.custom_field_12 = '::::::::::::::';  //For reconciliation purposes
        
        startOnlineCollectionRequest.custom_fields= customFields;
        
        //system.debug(startOnlineCollectionRequest);
        
        PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new  PayGovTCSOnline.TCSOnlineServicePort();
        PayGovTCSOnline.StartOnlineCollectionResponse startOnlineCollectionResponse = payGovOnline.startOnlineCollection(startOnlineCollectionRequest);
        return startOnlineCollectionResponse.token;
    }
    
    //Step 2: Use the token in a Url redirect to pay.gov
    public PageReference redirectToPayGov(String token, String tcs_app_id) {
        String redirectUrl = Payment.PAY_GOV_URL + '?token=' + token + '&tcsAppID=' + tcs_app_id;
        //System.debug('Pay.gov redirect URL = ' + redirectUrl);
        return new PageReference(redirectUrl);
    }
    
    //Step 3: Complete the transaction, receiving and saving the transaction details
    public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeTransaction(String token, String tcs_app_id) {
        PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest completeOnlineCollectionWithDetailsRequest = new PayGovTCSOnline.CompleteOnlineCollectionWithDetailsRequest();
        completeOnlineCollectionWithDetailsRequest.tcs_app_id = tcs_app_id;
        completeOnlineCollectionWithDetailsRequest.token = token;
        PayGovTCSOnline.TCSOnlineServicePort payGovOnline = new  PayGovTCSOnline.TCSOnlineServicePort();
        PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse;
        try {
            completeOnlineCollectionWithDetailsResponse = payGovOnline.completeOnlineCollectionWithDetails(completeOnlineCollectionWithDetailsRequest);
        } catch (Exception e) {
            //The payment failed
            //Return null and handle this in the calling controller
            return null;
        }
        return completeOnlineCollectionWithDetailsResponse;
    }
    
    //Step 4: Save the transaction details
    public Payment__c saveTransactionDetails(Payment__c paymentObject, PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse) {
        paymentObject.Pay_Gov_Tracking_Id__c = String.valueOf(completeOnlineCollectionWithDetailsResponse.paygov_tracking_id);
        paymentObject.Transaction_Amount__c = Decimal.valueof(completeOnlineCollectionWithDetailsResponse.transaction_amount);
        
        //The transaction datetime returned from pay.gov is correct for EST, but the timezone thinks it's GMT
        //So convert the datetime to GMT for it to be properly stored
        DateTime transDate = completeOnlineCollectionWithDetailsResponse.transaction_date;
        DateTime transDateGMT = transDate.addSeconds(getTimeZoneOffset());
        paymentObject.Transaction_Date__c = transDateGMT;  //Datetimes need to be either GMT or have a timezone specified
       
        String paymentDate = String.valueOf(completeOnlineCollectionWithDetailsResponse.payment_date);
        paymentObject.Payment_Date__c = Date.valueOf(paymentDate);
        paymentObject.Transaction_Status__c = completeOnlineCollectionWithDetailsResponse.transaction_status;
        paymentObject.Payment_Type__c = completeOnlineCollectionWithDetailsResponse.payment_type;
         
        update paymentObject;
        
        return paymentObject;
    }
    
    /*@TestVisible private static Datetime getEST(Datetime dtTime)
    {    
        Date d = dtTime.dateGmt();
        Time t = dtTime.timeGmt();
        return Datetime.newInstance(d,t);
    }*/
    
    @TestVisible private static Integer getTimeZoneOffset() {
        Timezone tz = Timezone.getTimeZone('America/New_York');

        // Create a date after the 2007 shift of DST into November
        DateTime dtpost = system.now();
        system.debug(tz.getOffset(dtpost));  //-18000000 (= -5 hours = EST)
        
        Integer offsetSeconds = tz.getOffset(dtpost)/1000*-1;  //1000 is to convert milliseconds to seconds and -1 is to add seconds instead of subtract
        return offsetSeconds;
    }
    
    @TestVisible private static String getCurrentFiscalYear() {
    
        Date currentDate = Date.today();
        Integer year = currentDate.year();
        Integer month = currentDate.month();

        if (month > 9) {
            year++;
        }

        return String.valueOf(year);
    }

}