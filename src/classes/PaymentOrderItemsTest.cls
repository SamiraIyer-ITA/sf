@IsTest
private class PaymentOrderItemsTest {
   
    @isTest
    static void testGetOrderITems() {
        // Given - Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IPaymentsSelector2 mockPaymentSelector = (IPaymentsSelector2 ) mocks.mock(IPaymentsSelector2 .class);
        // Given - Create mock data
        Id paymentId = fflib_IDGenerator.generate(Payment2__c.SObjectType);
        List<Payment2__c> mockPayments = new List<Payment2__c>{
            new Payment2__c(
                Id = paymentId,
                Payment_Type__c = 'NIST-Handled Refund'
            )
        };
        mocks.startStubbing();
        mocks.when(mockPaymentSelector.sObjectType()).thenReturn(Payment2__c.SObjectType);
        mocks.when(mockPaymentSelector.selectById(new Set<Id>{ paymentId }))
            .thenReturn(mockPayments);
        mocks.stopStubbing();
        // Given - Inject mocks
        fflibext_Application.Selector.setMock(mockPaymentSelector); 
        PaymentReceiptOrderItems testReceipt = new PaymentReceiptOrderItems();
        testReceipt.paymentId = paymentId;
        testReceipt.getOrderItems();
    }
    
}