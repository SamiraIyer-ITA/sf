public without sharing class RefundLightningController {

    @TestVisible private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    @TestVisible private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
    @TestVisible private static final String AGENCY_ID = PaymentSettings__c.getAll().get('AGENCY_ID').value__c;
    @TestVisible private static final String PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
    @TestVisible private static final String EVENTS_SERVICES_APP_NAME = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_NAME').value__c;

    @AuraEnabled
    public Refund__c refundObject{get;set;}

    @AuraEnabled
    public String errorMessage{get;set;}

    @AuraEnabled
    public static RefundLightningController issueRefund(Id paymentId) {

        RefundLightningController refundController = new RefundLightningController();

        try {
            Payment__c paymentObject = [SELECT Id, Name, Opportunity__c, Pay_Gov_Tracking_Id__c, Application__c, Transaction_Amount__c, Payment_Type__c FROM PAYMENT__C WHERE Id = :paymentId LIMIT 1];
            if (paymentObject.Payment_Type__c != 'PLASTIC_CARD') {
                refundController.errorMessage = 'Refunds are only allowed for credit card payments.  For ACH payments, contact NIST to perform the refund.';
                return refundController;
            }

            String origAgencyTrackingId = paymentObject.Name;
            String origPayGovTrackingId = paymentObject.Pay_Gov_Tracking_Id__c;
            String transactionAmount = String.valueOf(paymentObject.Transaction_Amount__c);
            String application = paymentObject.Application__c;
            String tcsAppId;
            if (application != null) {
                if (application.equalsIgnoreCase(PRIVACY_SHIELD_APP_NAME)) {
                    tcsAppId = PRIVACY_SHIELD_APP_ID;
                } else if (application.equalsIgnoreCase(EVENTS_SERVICES_APP_NAME)) {
                    tcsAppId = EVENTS_SERVICES_APP_ID;
                }
            }

            if (String.isBlank(tcsAppId)) {
                refundController.errorMessage = 'Unknown TCS Application ID.';
                return refundController;
            }

            PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
            pcRefund.orig_paygov_tracking_id = origPayGovTrackingId;
            pcRefund.transaction_amount = transactionAmount;
            pcRefund.orig_agency_tracking_id = origAgencyTrackingId;

            PayGovTCSSingleService.TCSSinglePort payGovSingleService = new PayGovTCSSingleService.TCSSinglePort();
            PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = payGovSingleService.processPCRefund(AGENCY_ID, tcsAppId, pcRefund);

            if (pcRefundResponse.pcRefund.transaction_status == 'Failed') {
                refundController.errorMessage = 'Pay.gov refused to accept the refund transaction.  Try to perform the refund on the pay.gov website.  Return code: ' + pcRefundResponse.pcRefund.return_code + '.  Return detail: ' + pcRefundResponse.pcRefund.return_detail;
                return refundController;
            } else if (pcRefundResponse.pcRefund.transaction_status == 'In Process'){
                refundController.errorMessage = 'The refund is in process with pay.gov.  No guarantee is made about it\'s success or failure.  Check it\'s status on the pay.gov website.  Return code: ' + pcRefundResponse.pcRefund.return_code + '.  Return detail: ' + pcRefundResponse.pcRefund.return_detail;
                return refundController;
            }

            String status = 'Completed';
            String payGovTrackingId = String.valueOf(pcRefundResponse.pcRefund.paygov_tracking_id);
            Decimal returnedTransactionAmount = Decimal.valueOf(pcRefundResponse.pcRefund.transaction_amount);
            String transactionDate = String.valueOf(pcRefundResponse.pcRefund.transaction_date);
            DateTime transactionDateGMT = null;
            if (!String.isEmpty(transactionDate)) {
                transactionDateGMT = DateTime.Valueof(transactionDate.replace('T', ' '));
                transactionDateGMT = getEST(transactionDateGMT);
            }
            String transactionStatus = pcRefundResponse.pcRefund.transaction_status;
            String returnCode = pcRefundResponse.pcRefund.return_code;
            String returnDetail = pcRefundResponse.pcRefund.return_detail;

            Refund__c refundObject = new Refund__c(Payment__c = paymentObject.id, Status__c = status, Pay_Gov_Tracking_Id__c = payGovTrackingId,
                Transaction_Amount__c = returnedTransactionAmount, Transaction_Status__c = transactionStatus,
                Return_Code__c = returnCode, Transaction_Date__c = transactionDateGMT,
                Return_Detail__c = returnDetail);

            insert refundObject;

            refundController.refundObject = refundObject;
            return refundController;

        } catch (Exception e) {
            System.debug(e.getMessage());
            refundController.errorMessage = 'Refund Error: ' + e.getMessage();
            return refundController;
        }

    }
    
    @TestVisible private static Datetime getEST(Datetime dtTime)
    {    
        Date d = dtTime.dateGmt();
        Time t = dtTime.timeGmt();
        Datetime estDateTime = Datetime.newInstanceGmt(d,t);
        return estDateTime;
    }
   
    
}