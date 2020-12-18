@IsTest
private class QuotesTest {

	static Id quoteId = fflib_IDGenerator.generate(Quote.SObjectType);
	static Id opportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);
	static Map<String, Id> recordTypeIdsByNames = Utils.getRecordTypeMapBySObject(Quote.SObjectType);

	@IsTest
	static void testNewInstanceOfQuotesDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Quote> quoteList  = new List<Quote>{ new Quote() };
		IQuotes iQuotes = (IQuotes) Quotes.newInstance(quoteList);
		System.assertNotEquals(iQuotes, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfQuotesDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> quoteIds = new Set<Id>{ quoteId };
		IQuotes iQuotes = (IQuotes) Quotes.newInstance(quoteIds);
		System.assertNotEquals(iQuotes, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testOrdersTrigger_InsertOrderRecord_TriggerIsCovered() {
		try { insert new Quote(); } catch (Exception e) {}
	}

	@IsTest
	static void test_OnBeforeUpdate_ServicesUpdateOpportunitySOWAppproved() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOpportunitiesSelector mockOppSelector = (IOpportunitiesSelector) mocks.mock(IOpportunitiesSelector.class);

		// Given - Create mock data
		Quote existingTestQuote = new Quote(
			Id = quoteId,
			OpportunityId = opportunityId,
			Status = 'In Review'
		);
		existingTestQuote = (Quote)fflib_ApexMocksUtils.setReadOnlyFields(
			existingTestQuote,
			Quote.class,
			new Map<SObjectField, Object>{ Quote.Record_Type_Developer_Name__c => 'Services' }
		);
		Quote testQuote = existingTestQuote.clone(true, true, false, false);
		testQuote.Status = 'Approved';

		Opportunity testOpp = new Opportunity(Id = opportunityId, SyncedQuoteId = quoteId);
		testOpp = (Opportunity)fflib_ApexMocksUtils.setReadOnlyFields(
			testOpp,
			Opportunity.class,
			new Map<SObjectField, Object>{ Opportunity.Record_Type_Developer_Name__c => 'Services' }
		);
		List<Opportunity> mockOpps = new List<Opportunity>{ testOpp };

		mocks.startStubbing();
		mocks.when(mockOppSelector.sObjectType()).thenReturn(Opportunity.SObjectType);
		mocks.when(mockOppSelector.selectById(new Set<Id>{ opportunityId }))
			.thenReturn(mockOpps);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockOppSelector);
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Quote>{ testQuote },
			new Map<Id, Quote>(
				new List<Quote>{ existingTestQuote }
			)
		);
		fflib_SObjectDomain.triggerHandler(Quotes.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify opportunity was updated.')))
			.registerDirty(fflib_Match.sObjectWith(
				new Map<SObjectField, Object>{
					Opportunity.Id 				=> opportunityId,
					Opportunity.SOW_Approved__c => true
				}
			));
		((IOpportunitiesSelector)
			mocks.verify(mockOppSelector)).selectById(new Set<Id>{ opportunityId });

	}

	@IsTest
	static void test_OnBeforeInsert_DefaultRecordTypeFromOpportunity_Services() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOpportunitiesSelector mockSelector = (IOpportunitiesSelector) mocks.mock(IOpportunitiesSelector.class);

		// Given - Create mock data
		Opportunity testOpp = new Opportunity(Id = opportunityId);
		testOpp = (Opportunity) fflib_ApexMocksUtils.setReadOnlyFields(
			testOpp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => 'Services'}
		);
		Quote testQuote = new Quote(Id = quoteId, OpportunityId = testOpp.Id);

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Opportunity.SObjectType);
		mocks.when(mockSelector.selectById(new Set<Id>{ opportunityId }))
			.thenReturn(new List<Opportunity>{testOpp});
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Quote>{ testQuote });
		fflib_SObjectDomain.triggerHandler(Quotes.class);

		// Then - Verify the record type
		System.assertEquals(recordTypeIdsByNames.get('Services'), testQuote.RecordTypeId);
	}

	@IsTest
	static void test_OnBeforeInsert_DefaultRecordTypeFromOpportunity_Events() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IOpportunitiesSelector mockSelector = (IOpportunitiesSelector) mocks.mock(IOpportunitiesSelector.class);

		// Given - Create mock data
		Opportunity testOpp = new Opportunity(Id = opportunityId);
		testOpp = (Opportunity) fflib_ApexMocksUtils.setReadOnlyFields(
			testOpp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => 'Events'}
		);
		Quote testQuote = new Quote(Id = quoteId, OpportunityId = testOpp.Id);

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Opportunity.SObjectType);
		mocks.when(mockSelector.selectById(new Set<Id>{ opportunityId }))
			.thenReturn(new List<Opportunity>{testOpp});
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Quote>{ testQuote });
		fflib_SObjectDomain.triggerHandler(Quotes.class);

		// Then - Verify the record type
		System.assertEquals(recordTypeIdsByNames.get('Events'), testQuote.RecordTypeId);
	}
}