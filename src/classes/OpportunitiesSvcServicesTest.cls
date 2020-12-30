@IsTest
private class OpportunitiesSvcServicesTest {

	static Id orderServicesRecordTypeId = Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(Order.SObjectType, 'Services');
	static Id contractParticipationAgreementRecordTypeId
		= Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(Contract.SObjectType, 'Participation_Agreement');
	static Id opportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);

	@IsTest
	static void testCreateContractOrderAndOrderItemsWhenSowApproved() {

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOpportunitiesSelector mockOppSelector = (IOpportunitiesSelector) mocks.mock(IOpportunitiesSelector.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		// Given - Create mock data
		Id quoteId = fflib_IDGenerator.generate(Quote.SObjectType);
		Opportunity testOpp = new Opportunity(
			Id = opportunityId,
			AccountId = fflib_IDGenerator.generate(Account.SObjectType),
			SyncedQuoteId = quoteId,
			Pricebook2Id = fflib_IDGenerator.generate(Pricebook2.SObjectType),
			Name = 'Test Services Opp',
			CloseDate = Date.today(),
			StageName = 'Proposal/Price Quote',
			Requested_Service_Start_Date__c	= Date.today(),
			Requested_Service_End_Date__c = Date.today().addDays(1)
		);

		Id productId = fflib_IDGenerator.generate(Product2.SObjectType);
		Product2 testProduct = new Product2(
			Name = 'Test Product'
		);

		Quote testQuote = new Quote(Id = quoteId, OpportunityId = opportunityId);
		QuoteLineItem testQuoteLineItem = new QuoteLineItem(
			Id = fflib_IDGenerator.generate(QuoteLineItem.SObjectType),
			Product2 = testProduct,
			Product2Id = productId,
			Description = 'Test Product Quote',
			PricebookEntryId = fflib_IDGenerator.generate(PricebookEntry.SObjectType),
			Quantity = 1,
			ServiceDate = Date.today(),
			UnitPrice = 100.00,
			Statement_of_Work__c = 'SOW'
		);

		testQuoteLineItem = (QuoteLineItem) fflib_ApexMocksUtils.setReadOnlyFields(
			testQuoteLineItem,
			QuoteLineItem.class,
			new Map<SObjectField, Object>{ QuoteLineItem.IsPrimary__c => true }
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
		mocks.when(mockOppSelector.sObjectType()).thenReturn(Opportunity.SObjectType);
		mocks.when(mockOppSelector.selectByIdNoContractNoOrdersSowApproved(new Set<Id>{ opportunityId }))
			.thenReturn(new List<Opportunity>{ testOpp });
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(new Set<Id>{ opportunityId }))
			.thenReturn(mockQuotes);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		fflibext_Application.Selector.setMock(mockOppSelector);
		fflibext_Application.Selector.setMock(mockQuoteSelector);

		// When - Call the service
		OpportunitiesService.createServicesContractOrderAndOrderItems(new Set<Id>{ opportunityId });

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
			new List<Map<SObjectField, Object>> {
				new Map<SObjectField, Object>{
					OrderItem.QuoteLineItemId 	=> testQuoteLineItems[0].Id,
					OrderItem.Description		=> testQuoteLineItems[0].Description,
					OrderItem.ListPrice			=> testQuoteLineItems[0].ListPrice,
					OrderItem.Product2Id		=> testQuoteLineItems[0].Product2Id,
					OrderItem.PricebookEntryId  => testQuoteLineItems[0].PricebookEntryId,
					OrderItem.Quantity			=> testQuoteLineItems[0].Quantity,
					OrderItem.ServiceDate		=> testQuoteLineItems[0].ServiceDate,
					OrderItem.UnitPrice			=> testQuoteLineItems[0].UnitPrice
				},
				new Map<SObjectField, Object>{
					Order.RecordTypeId 				=> orderServicesRecordTypeId,
					Order.Name 						=> 'Order-Test Services Opp',
					Order.OpportunityId				=> testOpp.Id,
					Order.AccountId 				=> testOpp.AccountId,
					Order.QuoteId 					=> testOpp.SyncedQuoteId,
					Order.Pricebook2Id 				=> testOpp.Pricebook2Id,
					Order.Status 					=> 'Draft',
					Order.EffectiveDate 			=> testOpp.Requested_Service_Start_Date__c,
					Order.EndDate 					=> testOpp.Requested_Service_End_Date__c,
					Order.Type 						=> 'Services',
					Order.Mid_Term_Report_Status__c => 'Not Required',
					Order.Final_Report_Status__c	=> 'Required',
					Order.Official_Letter_Status__c	=> 'Not Required'
				},
				new Map<SObjectField, Object>{
					Contract.RecordTypeId 			=> contractParticipationAgreementRecordTypeId,
					Contract.AccountId 				=> testOpp.AccountId,
					Contract.Pricebook2Id 			=> testOpp.Pricebook2Id,
					Contract.ContractTerm 			=> 12,
					Contract.StartDate 				=> testOpp.Requested_Service_Start_Date__c,
					Contract.Status					=> 'Draft',
					Contract.Statement_of_Work__c	=> testQuoteLineItems[0].Statement_of_Work__c
				}
			}
		));
	}

	@IsTest
	static void testCreateContractOrderAndOrderItemsWhenSowApproved_DoesNotMeetCriteria() {

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOpportunitiesSelector mockOppSelector = (IOpportunitiesSelector) mocks.mock(IOpportunitiesSelector.class);
		IQuotesSelector mockQuoteSelector = (IQuotesSelector) mocks.mock(IQuotesSelector.class);

		mocks.startStubbing();
		mocks.when(mockOppSelector.sObjectType()).thenReturn(Opportunity.SObjectType);
		mocks.when(mockOppSelector.selectByIdNoContractNoOrdersSowApproved(new Set<Id>{ opportunityId }))
			.thenReturn(new List<Opportunity>{ new Opportunity( Id = opportunityId) });
		// We will return an empty list for Quote so the exception can be thrown
		mocks.when(mockQuoteSelector.sObjectType()).thenReturn(Quote.SObjectType);
		mocks.when(mockQuoteSelector.selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(new Set<Id>{ opportunityId }))
			.thenReturn(new List<Quote>{});
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockOppSelector);

		try {
			// When - Call the service
			OpportunitiesService.createServicesContractOrderAndOrderItems(new Set<Id>{ opportunityId });
		} catch (Exception e) {
			// Then - verify the exception
			System.assertEquals(OpportunitiesSvcServices.oppDoesNotMeetCriteriaError, e.getMessage());
		}
	}
}