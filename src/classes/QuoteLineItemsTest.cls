@IsTest
private class QuoteLineItemsTest {

	static Id quoteLineItemId = fflib_IDGenerator.generate(QuoteLineItem.SObjectType);

	@IsTest
	static void testNewInstanceOfQuoteLineItemsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<QuoteLineItem> quotelineitemList  = new List<QuoteLineItem>{ new QuoteLineItem() };
		IQuoteLineItems iQuoteLineItems = (IQuoteLineItems) QuoteLineItems.newInstance(quotelineitemList);
		System.assertNotEquals(iQuoteLineItems, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfQuoteLineItemsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> quoteLineItemIds = new Set<Id>{ quoteLineItemId };
		IQuoteLineItems iQuoteLineItems = (IQuoteLineItems) QuoteLineItems.newInstance(quoteLineItemIds);
		System.assertNotEquals(iQuoteLineItems, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testOrdersTrigger_InsertOrderRecord_TriggerIsCovered() {
		try { insert new QuoteLineItem(); } catch (Exception e) {}
	}

	@IsTest
	static void test_OnBeforeInsert_SetServicesFieldsWhenProductIsPrimary() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IProductsSelector mockProductSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		// Given - Create mock data
		Product2 testProduct = new Product2(
			Id = fflib_IDGenerator.generate(Product2.SObjectType),
			Statement_of_Work__c = 'SOW',
			Client_Form_Type__c = 'Test Form Type',
			Family = 'Test Family'
		);

		Quote testQuote = new Quote(Id = fflib_IDGenerator.generate(Quote.SObjectType));
		QuoteLineItem testQuoteLineItem = new QuoteLineItem(
			Product2Id = testProduct.Id,
			QuoteId = testQuote.Id
		);
		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class,
			new Map<SObjectField, Object> {
				QuoteLineItem.IsPrimary__c 							=> true,
				QuoteLineItem.Quote_Record_Type_Developer_Name__c 	=> 'Services'
			}
		);
		List<QuoteLineItem> testQuoteLineItems = new List<QuoteLineItem>{ testQuoteLineItem };

		mocks.startStubbing();
		mocks.when(mockProductSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mockProductSelector.selectById(new Set<Id>{ testProduct.Id }))
			.thenReturn(new List<Product2>{ testProduct });
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectById(new Set<Id>{ testQuote.Id }))
			.thenReturn(new List<Quote>{ testQuote });
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockProductSelector);
		fflibext_Application.Selector.setMock(mockQuoteSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(testQuoteLineItems);
		fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify quote was updated.')))
			.registerDirty(fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
					Quote.Id 						=> testQuote.Id,
					Quote.Client_Form_Type__c 		=> testProduct.Client_Form_Type__c,
					Quote.PrimaryProductFamily__c	=> 'Test Family'
				}
			));

		// Then verify the QuoteLineItem was updated from the product
		System.assertEquals(testProduct.Statement_of_Work__c, testQuoteLineItem.Statement_of_Work__c);
		System.assertEquals(testProduct.Client_Form_Type__c, testQuoteLineItem.Client_Form_Type__c);
	}

	@IsTest
	static void test_OnBeforeInsert_SetServicesFieldsWhenProductIsPrimary_ExistingPrimaryProduct() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IProductsSelector mockProductSelector = (IProductsSelector) mocks.mock(IProductsSelector.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		// Given - Create mock data
		Product2 testProduct = new Product2(
			Id = fflib_IDGenerator.generate(Product2.SObjectType),
			Statement_of_Work__c = 'SOW',
			Client_Form_Type__c = 'Test Form Type',
			Family = 'Test Family'
		);

		Quote testQuote = new Quote(
			Id = fflib_IDGenerator.generate(Quote.SObjectType),
			PrimaryProductFamily__c = 'Test Family'
		);
		QuoteLineItem testQuoteLineItem = new QuoteLineItem(
			Product2Id = testProduct.Id,
			QuoteId = testQuote.Id
		);
		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class,
			new Map<SObjectField, Object> {
				QuoteLineItem.IsPrimary__c 							=> true,
				QuoteLineItem.Quote_Record_Type_Developer_Name__c 	=> 'Services'
			}
		);
		List<QuoteLineItem> testQuoteLineItems = new List<QuoteLineItem>{ testQuoteLineItem };

		mocks.startStubbing();
		mocks.when(mockProductSelector.sObjectType()).thenReturn(Product2.SObjectType);
		mocks.when(mockProductSelector.selectById(new Set<Id>{ testProduct.Id }))
			.thenReturn(new List<Product2>{ testProduct });
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectById(new Set<Id>{ testQuote.Id }))
			.thenReturn(new List<Quote>{ testQuote });
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockProductSelector);
		fflibext_Application.Selector.setMock(mockQuoteSelector);

		try {
			// When - Use the test database to mock an onBeforeInsert
			fflib_SObjectDomain.Test.Database.onInsert(testQuoteLineItems);
			fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		} catch (Exception e) {
			// Verify the exception for an already existing primary product
			System.assertEquals(Label.Line_Item_One_Primary_Per_Quote, e.getMessage());
		}
	}

	@IsTest
	static void test_OnBeforeUpdate_UpdateRelatedServicesOrderItems() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IQuoteLineItemsSelector mockQuoteLineItemSelector = (IQuoteLineItemsSelector) mocks.mock(IQuoteLineItemsSelector.class);

		QuoteLineItem existingTestQuoteLineItem = new QuoteLineItem(
			Id = quoteLineItemId,
			Description = 'Test Description',
			Quantity = 1,
			ServiceDate = Date.today(),
			UnitPrice = 100.00
		);
		existingTestQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			existingTestQuoteLineItem,
			QuoteLineItem.class,
			new Map<SObjectField, Object> {
				QuoteLineItem.IsPrimary__c 							=> true,
				QuoteLineItem.Quote_Record_Type_Developer_Name__c 	=> 'Services'
			}
		);
		QuoteLineItem testQuoteLineItem = existingTestQuoteLineItem.clone(true, true, false, false);
		testQuoteLineItem.Description = 'Test New Description';
		testQuoteLineItem.Quantity = 2;
		testQuoteLineItem.ServiceDate = Date.today().addDays(1);
		testQuoteLineItem.UnitPrice = 200.00;

		Id orderItemId = fflib_IDGenerator.generate(OrderItem.SObjectType);
		List<OrderItem> testOrderItem = new List<OrderItem>{
			new OrderItem(
				Id = orderItemId,
				Description = 'Test Description',
				Quantity = 1,
				ServiceDate = Date.today(),
				UnitPrice = 100.00
			)
		};

		// Make relationship between quote line items and order items
		List<QuoteLineItem> mockQuoteLineItems = (List<QuoteLineItem>)
			fflib_ApexMocksUtils.makeRelationship(
				List<QuoteLineItem>.class,
				new List<QuoteLineItem> { existingTestQuoteLineItem },
				OrderItem.QuoteLineItemId,
				new List<List<OrderItem>> { testOrderItem });

		mocks.startStubbing();
		mocks.when(mockQuoteLineItemSelector.sObjectType()).thenReturn(QuoteLineItem.SObjectType);
		mocks.when(mockQuoteLineItemSelector
			.selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(new Set<Id>{ quoteLineItemId }))
			.thenReturn(mockQuoteLineItems);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockQuoteLineItemSelector);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<QuoteLineItem>{ testQuoteLineItem },
			new Map<Id, QuoteLineItem>( new List<QuoteLineItem>{ existingTestQuoteLineItem })
		);
		fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify order item was updated')))
			.registerDirty(fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
					OrderItem.Id 			=> orderItemId,
					OrderItem.Description  	=> testQuoteLineItem.Description,
					OrderItem.Quantity		=> testQuoteLineItem.Quantity,
					OrderItem.ServiceDate	=> testQuoteLineItem.ServiceDate,
					OrderItem.UnitPrice		=> testQuoteLineItem.UnitPrice
				}
			));
	}

	@IsTest
	static void test_OnBeforeDelete_DeleteRelatedServicesOrderItems() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IQuoteLineItemsSelector mockQuoteLineItemSelector = (IQuoteLineItemsSelector) mocks.mock(IQuoteLineItemsSelector.class);

		QuoteLineItem testQuoteLineItem = new QuoteLineItem(Id = quoteLineItemId);
		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class, new Map<SObjectField, Object>{
				QuoteLineItem.Quote_Record_Type_Developer_Name__c => 'Services'
			}
		);
		List<QuoteLineItem> testQuoteLineItems = new List<QuoteLineItem>{ testQuoteLineItem };

		Id orderItemId = fflib_IDGenerator.generate(OrderItem.SObjectType);
		List<OrderItem> testOrderItem = new List<OrderItem>{
			new OrderItem(Id = orderItemId)
		};

		// Make relationship between quote and quote line items
		List<QuoteLineItem> mockQuoteLineItems = (List<QuoteLineItem>)
			fflib_ApexMocksUtils.makeRelationship(
				List<QuoteLineItem>.class,
				new List<QuoteLineItem> { testQuoteLineItem },
				OrderItem.QuoteLineItemId,
				new List<List<OrderItem>>{ testOrderItem });

		mocks.startStubbing();
		mocks.when(mockQuoteLineItemSelector.sObjectType()).thenReturn(QuoteLineItem.SObjectType);
		mocks.when(mockQuoteLineItemSelector
			.selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(new Set<Id>{ quoteLineItemId }))
			.thenReturn(mockQuoteLineItems);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockQuoteLineItemSelector);

		// When - Use the test database to mock an onBeforeDelete
		fflib_SObjectDomain.Test.Database.onDelete(new Map<Id, QuoteLineItem>(testQuoteLineItems));
		fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify order item was deleted')))
			.registerDeleted(testOrderItem);
	}

	@IsTest
	static void test_OnBeforeDelete_PreventServicesDeleteWhenPrimaryAndSynced() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		Quote testQuote = new Quote(Id = fflib_IDGenerator.generate(Quote.SObjectType));
		testQuote = (Quote) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuote,
			Quote.class, new Map<SObjectField, Object>{
				Quote.Record_Type_Developer_Name__c => 'Services',
				Quote.IsSyncing => true
			}
		);
		QuoteLineItem testQuoteLineItem = new QuoteLineItem(Id = quoteLineItemId, QuoteId = testQuote.Id);
		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class, new Map<SObjectField, Object>{
				QuoteLineItem.IsPrimary__c => true,
				QuoteLineItem.Quote_Record_Type_Developer_Name__c => 'Services'
			}
		);
		List<QuoteLineItem> testQuoteLineItems = new List<QuoteLineItem>{ testQuoteLineItem };

		// Make relationship between Quote and QuoteLineItems
		List<Quote> mockQuotes = (List<Quote>)
			fflib_ApexMocksUtils.makeRelationship(
				List<Quote>.class,
				new List<Quote> { testQuote },
				QuoteLineItem.QuoteId,
				new List<List<QuoteLineItem>> { testQuoteLineItems });

		mocks.startStubbing();
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectById(new Set<Id>{ testQuote.Id }))
			.thenReturn(mockQuotes);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockQuoteSelector);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onInsert(testQuoteLineItems);
		fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		try {
			// When - Use the test database to mock an onBeforeDelete
			fflib_SObjectDomain.Test.Database.onDelete(new Map<Id, QuoteLineItem>(testQuoteLineItems));
			fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		} catch (Exception e) {
			// Verify the exception for an already existing primary product
			System.assertEquals(Label.Line_Item_Cannot_Be_Deleted, e.getMessage());
		}
	}

	@IsTest
	static void test_OnBeforeDelete_setServicesQuoteFieldsWhenPrimaryProductDeleted() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		Quote testQuote = new Quote(
			Id = fflib_IDGenerator.generate(Quote.SObjectType),
			PrimaryProductFamily__c = 'Test Family'
		);
		QuoteLineItem testQuoteLineItem = new QuoteLineItem(Id = quoteLineItemId, QuoteId = testQuote.Id);
		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class, new Map<SObjectField, Object> {
				QuoteLineItem.IsPrimary__c => true,
				QuoteLineItem.Quote_Record_Type_Developer_Name__c => 'Services'
			}
		);

		mocks.startStubbing();
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectById(new Set<Id>{ testQuote.Id }))
			.thenReturn(new List<Quote>{ testQuote });
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockQuoteSelector);

		// When - Use the test database to mock an onBeforeDelete
		fflib_SObjectDomain.Test.Database.onDelete(
			new Map<Id, QuoteLineItem>(new List<QuoteLineItem>{ testQuoteLineItem }));
		fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify order item was updated')))
			.registerDirty(fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
					Quote.Id => testQuote.Id,
					Quote.PrimaryProductFamily__c	=> null,
					Quote.Client_Form__c 			=> null
				}
		));
	}

}