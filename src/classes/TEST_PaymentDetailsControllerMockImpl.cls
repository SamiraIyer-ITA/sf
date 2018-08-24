@isTest
global class TEST_PaymentDetailsControllerMockImpl implements WebServiceMock {
    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               
            System.debug('Starting TEST_PaymentDetailsControllerMockImpl');
               
            Account account = new Account(Name='tAccount');
            insert account;
             
            Order order = new Order();
            order.Name = '14TPE000001';
            order.AccountId = account.Id;
            order.EffectiveDate = Date.Today();
            order.Status = 'Draft';
            insert order;
            
            Payment__c payment = new Payment__c(Order__c = order.id, Pay_Gov_Tracking_Id__c = 'payGovTrackingId');
            insert payment;
           
           	ApexPages.StandardController sc = new ApexPages.StandardController(payment);
            PaymentDetailsController paymentDetailsController = new PaymentDetailsController(sc);
            paymentDetailsController.showDetailsButton = false;
            paymentDetailsController.isCreditCard = true;
            paymentDetailsController.isAch = false;
            paymentDetailsController.agencyTrackingId = 'agencyTrackingId';
            paymentDetailsController.tcsAppId = 'tcsAppId';
            paymentDetailsController.payGovTrackingId = 'payGovTrackingId';
            paymentDetailsController.approvalCode = 'approvalCode';
            paymentDetailsController.authResponseCode = 'authResponseCode';
            paymentDetailsController.authResponseText = 'authResponseText';               
            paymentDetailsController.avsResponseCode = 'avsResponseCode';
            paymentDetailsController.cscResult = 'cscResult';
            paymentDetailsController.billingAddress = 'billingAddress';
            paymentDetailsController.billingAddress2 = 'billingAddress2';
            paymentDetailsController.billingCity = 'billingCity';
            paymentDetailsController.billingState = 'billingState';
            paymentDetailsController.billingZip = 'billingZip';
            paymentDetailsController.billingCountry = 'billingCountry';
            paymentDetailsController.returnCode = 'returnCode';
            paymentDetailsController.returnDetail = 'returnDetail';
            paymentDetailsController.transactionStatus = 'transactionStatus';
            paymentDetailsController.transactionAmount = 'transactionAmount';
            paymentDetailsController.accountNumber = 'accountNumber';
            paymentDetailsController.accountHolderName = 'accountHolderName';
            paymentDetailsController.transactionDate = 'transactionDate';
            paymentDetailsController.accountType = 'accountType';               
            paymentDetailsController.effectiveDate = 'effectiveDate';
            paymentDetailsController.routingTransitNumber = 'routingTransitNumber';
            paymentDetailsController.secCode = 'secCode';
            paymentDetailsController.returnReasonCode = 'returnReasonCode';
            paymentDetailsController.depositTicketNumber = 'depositTicketNumber';
            paymentDetailsController.debitVoucherNumber = 'debitVoucherNumber';

           response.put('response_x', paymentDetailsController );
            
}

}