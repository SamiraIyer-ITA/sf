public without sharing class PaymentConfirmationController {

    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSHQA';  //QA
    //private static final String PRIVACY_SHIELD_APP_ID = 'TCSITAUSMASSH';  //Production
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENUQA';  //QA
    //private static final String EVENTS_SERVICES_APP_ID = 'TCSITAUSFCSEMENU';  //Production
    
    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
    //@TestVisible private static final String PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c; 
    
    public String token {get;set;}
    public String agencyTrackingId {get;set;}
    public String application {get;set;}  //PS for Privacy Shield, ES for Event or Service
    public boolean paymentError {get;set;} //if true, a payment error was received from pay.gov.  Allow the payment to be attempted again.
    
    public Payment__c paymentObject {get; set;}
    public Payment payment {get; set;}
    public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse {get; set;}

    public PaymentConfirmationController() {
        this.payment = new payment();
        this.token = System.currentPageReference().getParameters().get('token');
        this.agencyTrackingId = System.currentPageReference().getParameters().get('id');
        String appAbbr = System.currentPageReference().getParameters().get('app');
        System.debug('Application: ' + appAbbr);
        System.debug('App: ' + PRIVACY_SHIELD_APP);
        if (appAbbr != null) {
            if (appAbbr.equals(PRIVACY_SHIELD_APP)) {
                this.application = 'Privacy Shield';    //PRIVACY_SHIELD_APP_NAME;
            } else {
                this.application = 'Unknown';
            }
        }
        this.paymentObject = [SELECT ID, Name, Opportunity__c, Transaction_Amount__c, Transaction_Status__c, Payment_Date__c, Transaction_Date__c, Pay_Gov_Tracking_Id__c FROM PAYMENT__C WHERE name = :this.agencyTrackingId limit 1];
    }
    
    public void saveTransactionDetails() {
        this.paymentObject = this.payment.saveTransactionDetails(this.paymentObject, this.completeOnlineCollectionWithDetailsResponse);      
    }

    public void completePayment() {
        //System.debug('completePayment()');
        this.paymentError = false;
        paymentObject.Application__c = application;
        System.debug('Application = ' + application);
        if (application.equals('Privacy Shield'/*PRIVACY_SHIELD_APP_NAME*/)) {
            //Privacy Shield
            this.completeOnlineCollectionWithDetailsResponse = this.payment.completeTransaction(token, PRIVACY_SHIELD_APP_ID);
        } else {
            //Other, such as Event or Service
            this.completeOnlineCollectionWithDetailsResponse = this.payment.completeTransaction(token, EVENTS_SERVICES_APP_ID);
        }
        //System.debug('completeOnlineCollectionWithDetailsResponse = ' + this.completeOnlineCollectionWithDetailsResponse);
        if (this.completeOnlineCollectionWithDetailsResponse == null) {
            //Mark this payment as failed.
            //System.debug('Mark the payment as failed');
            paymentObject.Transaction_Status__c = 'Failed';
            //System.debug('Payment ' + agencyTrackingId + ' marked as failed');
            this.paymentError = true;
            //System.debug('paymentError = true');
        }
        //if(! Test.isRunningTest()) {
          update paymentObject;
        //}
    }    

    public pageReference doRedirect(){
        if(ApexPages.currentPage().getParameters().get('opp') != null){
            PageReference away = new PageReference('/apex/Payment?error=true&app=' + this.application+'&opp='+ApexPages.currentPage().getParameters().get('opp') );
            away.setRedirect(true);
            return away;    
        }else{
            PageReference away = new PageReference('/apex/Payment?error=true&app=' + this.application );
            away.setRedirect(true);
            return away;
        }
    }
}