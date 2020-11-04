@IsTest
private class PaymentReceiptOrderItemsTest {

	@IsTest
	static void testGetOrderITems() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IPaymentsSelector2 mockPaymentSelector = (IPaymentsSelector2 ) mocks.mock(IPaymentsSelector2 .class);
		IOrdersSelector mockOrderSelector = (IOrdersSelector) mocks.mock(IOrdersSelector.class);
		IProductsSelector mockProductSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);

		// Given - Create mock data

		// Payment
		Id paymentId = fflib_IDGenerator.generate(Payment2__c.SObjectType);
		List<Payment2__c> mockPayments = new List<Payment2__c>{
			new Payment2__c(
				Id = paymentId,
				Payment_2__c = paymentId,
				Payment_Type__c = 'NIST-Handled Refund'
			)
		};

		// Product
		Id productId = fflib_IDGenerator.generate(Product2.SObjectType);
		List<Product2> mockProducts = new List<Product2>{
			new Product2(
				Id = productId,
				Name = 'Test Product'
			)
		};

		// Order and OrderItem
		Id orderId = fflib_IDGenerator.generate(Order.SObjectType);
		Order mockOrder = new Order(Id = orderId);
		List<OrderItem> mockOrderItems = new List<OrderItem>{
			new OrderItem(
				Id = fflib_IDGenerator.generate(OrderItem.SObjectType),
				Product2Id = productId
			)
		};
		// Make relationship between Order and OrderItems
		List<Order> mockOrders = (List<Order>)
			fflib_ApexMocksUtils.makeRelationship(
				List<Order>.class,
				new List<Order> { mockOrder },
				OrderItem.OrderId,
				new List<List<OrderItem>> { mockOrderItems });

		mocks.startStubbing();
		mocks.when(mockPaymentSelector.sObjectType()).thenReturn(Payment2__c.SObjectType);
		mocks.when(mockPaymentSelector.selectById(new Set<Id>{ paymentId }))
			.thenReturn(mockPayments);
		mocks.when(mockOrderSelector.sObjectType()).thenReturn(Order.SObjectType);
		mocks.when(mockOrderSelector.selectByPaymentId(new Set<Id>{ paymentId }))
			.thenReturn(mockOrders);
		mocks.when(mockProductSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mockProductSelector.selectById(new Set<Id>{ productId }))
			.thenReturn(mockProducts);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockPaymentSelector);
		fflibext_Application.Selector.setMock(mockOrderSelector);
		fflibext_Application.Selector.setMock(mockProductSelector);

		// Then - Verify the correct product string is returned.
		PaymentReceiptOrderItems testReceipt = new PaymentReceiptOrderItems();
		testReceipt.paymentId = paymentId;
		System.assertEquals('<ul><li>Test Product</li></ul>', testReceipt.getOrderItems());
	}
}