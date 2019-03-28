public without sharing class PaymentConfirmationController {
    
    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP_NAME = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_NAME').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;

    public String token {get;set;}
    public String agencyTrackingId {get;set;}
    public String application {get;set;}  //PS for Privacy Shield, ES for Event or Service
    public boolean paymentError {get;set;} //if true, a payment error was received from pay.gov.  Allow the payment to be attempted again.
    
    public Payment__c paymentObject {get; set;}
    public Payment payment {get; set;}
    public PayGovTCSOnline.CompleteOnlineCollectionWithDetailsResponse completeOnlineCollectionWithDetailsResponse {get; set;}

    public PaymentConfirmationController(){
        //Empty constructor
        //Code was moved to paymentConfirmationInit() to allow for DML in RecordLog.emit().
    }

    private void paymentConfirmationInit() {
        RecordLog.push('PaymentConfirmationController.paymentConfirmationInit');
        this.payment = new payment();
        this.token = System.currentPageReference().getParameters().get('token');
        this.agencyTrackingId = System.currentPageReference().getParameters().get('id');
        RecordLog.message('Agency Tracking Id: ' + this.agencyTrackingId);
        String appAbbr = System.currentPageReference().getParameters().get('app');
        if (String.isNotEmpty(appAbbr)) {
            if (appAbbr.equals(PRIVACY_SHIELD_APP)) {
                this.application = PRIVACY_SHIELD_APP_NAME;
                RecordLog.message('Payment for ' + PRIVACY_SHIELD_APP_NAME);
            } else if (appAbbr.equals(EVENTS_SERVICES_APP)) {
                this.application = EVENTS_SERVICES_APP_NAME;
                RecordLog.message('Payment for ' + EVENTS_SERVICES_APP_NAME);
            } else {
                this.application = 'Unknown';
                RecordLog.message('Payment for Unknown application');
            }
        }
        RecordLog.message('Retrieving the payment information');
        this.paymentObject = [SELECT Id, Name, Opportunity__c, Transaction_Amount__c, Transaction_Status__c, Payment_Date__c, Transaction_Date__c, Pay_Gov_Tracking_Id__c FROM PAYMENT__C WHERE name = :this.agencyTrackingId limit 1];
        RecordLog.message('Payment information retrieved');
        RecordLog.pop();
        //RecordLog.emit(this.paymentObject.Id);  //DML is not allowed in constructors
    }

    //This method is called after completePayment()
    public void saveTransactionDetails() {
        RecordLog.push('PaymentConfirmationController.saveTransactionDetails');
        //payment.saveTransactionDetails calls RecordLog.emit()
        this.paymentObject = this.payment.saveTransactionDetails(this.paymentObject, this.completeOnlineCollectionWithDetailsResponse);      
    }

    public void completePayment() {
        RecordLog.push('PaymentConfirmationController.completePayment');
        paymentConfirmationInit();
        this.paymentError = false;
        paymentObject.Application__c = this.application;
        if (application.equals(PRIVACY_SHIELD_APP_NAME)) {
            //Privacy Shield
            this.completeOnlineCollectionWithDetailsResponse = this.payment.completeTransaction(this.paymentObject.Id, token, PRIVACY_SHIELD_APP_ID);
        } else if (application.equals(EVENTS_SERVICES_APP_NAME)) {
            //Other, such as Event or Service
            this.completeOnlineCollectionWithDetailsResponse = this.payment.completeTransaction(this.paymentObject.Id, token, EVENTS_SERVICES_APP_ID);
        } else {
            RecordLog.message('Error: Unknown application');
            RecordLog.emit(this.paymentObject.Id);
            return;
        }
        RecordLog.message('completeOnlineCollectionWithDetailsResponse: ' + this.completeOnlineCollectionWithDetailsResponse);
        if (this.completeOnlineCollectionWithDetailsResponse == null) {
            //Mark this payment as failed.
            RecordLog.message('Mark the payment as failed');
            paymentObject.Transaction_Status__c = 'Failed';
            RecordLog.message('Payment ' + agencyTrackingId + ' marked as failed');
            this.paymentError = true;
            RecordLog.message('paymentError = true');
        }

        RecordLog.message('Updating the Payment Object');
        try {
            update paymentObject;
        } catch (Exception e) {
            RecordLog.message('Exception: ' + e.getMessage());
            throw e;
        } finally {
            RecordLog.emit(this.paymentObject.Id);
        }

    }    

    public pageReference doRedirect(){
        RecordLog.push('PaymentConfirmationController.doRedirect');
        if (this.token == null) {
            //Only call paymentConfirmationInit() if it wasn't already called by completePayment()
            paymentConfirmationInit();
        }
        String pageReference;
        if(ApexPages.currentPage().getParameters().get('opp') != null){
            pageReference = '/apex/Payment?error=true&app=' + this.application+'&opp='+ApexPages.currentPage().getParameters().get('opp');
            RecordLog.message('PageReference: ' + pageReference);
            PageReference away = new PageReference(pageReference);
            away.setRedirect(true);
            RecordLog.emit(this.paymentObject.Id);
            return away;    
        }else{
            pageReference = '/apex/Payment?error=true&app=' + this.application;
            RecordLog.message('PageReference: ' + pageReference);
            PageReference away = new PageReference(pageReference);
            away.setRedirect(true);
            RecordLog.emit(this.paymentObject.Id);
            return away;
        }
    }
}