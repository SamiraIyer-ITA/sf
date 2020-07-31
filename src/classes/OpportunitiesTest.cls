@IsTest
private class OpportunitiesTest {

	static Map<String, Schema.RecordTypeInfo> recordTypeMap
		= Opportunity.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
	static Id orderServicesRecordTypeId = OpportunitiesSvcLibrary.orderServicesRecordTypeId;
	static Id contractParticipationAgreementRecordTypeId
		= OpportunitiesSvcLibrary.contractParticipationAgreementRecordTypeId;
	static Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
	static Id opportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);

	@IsTest
	static void testNewInstanceOfOpportunitiesDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Opportunity> oppList  = new List<Opportunity>{ new Opportunity() };
		IOpportunities iOpportunities = (IOpportunities) Opportunities.newInstance(oppList);
		System.assertNotEquals(iOpportunities, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfOpportunitiesDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> opportunityIds = new Set<Id>{ opportunityId };
		IOpportunities iOpportunities = (IOpportunities) Opportunities.newInstance(opportunityIds);
		System.assertNotEquals(iOpportunities, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void test_opportunitiesTrigger_withDml() {
		// Insert opportunity with required fields to test Opportunities trigger as rest of tests are not using dml
		insert new Opportunity(
			Name = 'Test Events Opp',
			CloseDate = Date.today(),
			StageName = 'Qualification'
		);
	}

	@IsTest
	static void test_onAfterInsert_createEventsContractsAndOrdersWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onInsert(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Events Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Events'
				)
			}
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
				new List<Map<SObjectField, Object>> {
					new Map<SObjectField, Object> {
						Contract.AccountId => accountId,
						Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
						Contract.StartDate => Date.today(),
						Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => Date.today(),
						Order.RecordTypeId => orderServicesRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_onAfterInsert_createServicesContractsAndOrdersWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onInsert(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Services Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Services').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Services'
				)
			}
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
			new List<Map<SObjectField, Object>> {
				new Map<SObjectField, Object> {
					Contract.AccountId => accountId,
					Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
					Contract.StartDate => Date.today(),
					Contract.ContractTerm => 12
				},
				new Map<SObjectField,Object> {
					Order.OpportunityId => opportunityId,
					Order.AccountId => accountId,
					Order.Status => 'Draft',
					Order.EffectiveDate => Date.today(),
					Order.RecordTypeId => orderServicesRecordTypeId
				}
			}
		));
	}

	@IsTest
	static void test_onBeforeUpdate_createEventsContractsAndOrdersWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Events Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Events'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId,
						StageName = 'Qualification'
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
				new List<Map<SObjectField, Object>> {
					new Map<SObjectField, Object> {
						Contract.AccountId => accountId,
						Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
						Contract.StartDate => Date.today(),
						Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => Date.today(),
						Order.RecordTypeId => orderServicesRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_onBeforeUpdate_createServicesContractsAndOrdersWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Services Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Services').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Services'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId,
						StageName = 'Qualification'
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow,mocks.times(1)
			.description('two accounts sb created')))
			.registerNew(fflib_Match.sObjectsWith(
				new List<Map<SObjectField, Object>> {
					new Map<SObjectField, Object> {
						Contract.AccountId => accountId,
						Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
						Contract.StartDate => Date.today(),
						Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => Date.today(),
						Order.RecordTypeId => orderServicesRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_onBeforeUpdate_verifyEventsOrdersAreNotCreatedMoreThanOnceWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOrdersSelector mockSelector = (IOrdersSelector) mocks.mock(IOrdersSelector.class);

		// Give - Create mock data with an order using the opportunity Id in our update method
		List<Order> mockOrders = new List<Order>{
			new Order(
				Id = fflib_IDGenerator.generate(Order.SObjectType),
				AccountId = accountId,
				OpportunityId = opportunityId,
				Status = 'Draft',
				EffectiveDate = Date.today()
			)
		};
		Set<Id> testOppSet = new Set<Id>{ opportunityId };

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Order.SObjectType);
		mocks.when(mockSelector.selectOrdersByOpportunities(new Set<Id>{ opportunityId }))
			.thenReturn(mockOrders);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Events Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Events'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(0)
			.description('Verify no contract and order were created')))
			.registerNew(new List<SObject>());
		((IOrdersSelector)
			mocks.verify(mockSelector)).selectOrdersByOpportunities(testOppSet);
	}

	@IsTest
	static void test_onBeforeUpdate_verifyServicesOrdersAreNotCreatedMoreThanOnceWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOrdersSelector mockSelector = (IOrdersSelector) mocks.mock(IOrdersSelector.class);

		// Give - Create mock data with an order using the opportunity Id in our update method
		List<Order> mockOrders = new List<Order>{
			new Order(
				Id = fflib_IDGenerator.generate(Order.SObjectType),
				AccountId = accountId,
				OpportunityId = opportunityId,
				Status = 'Draft',
				EffectiveDate = Date.today()
			)
		};
		Set<Id> testOppSet = new Set<Id>{ opportunityId };

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Order.SObjectType);
		mocks.when(mockSelector.selectOrdersByOpportunities(new Set<Id>{ opportunityId }))
			.thenReturn(mockOrders);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						Name = 'Test Services Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Services'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(0)
			.description('Verify no contract and order were created')))
			.registerNew(new List<SObject>());
		((IOrdersSelector)
			mocks.verify(mockSelector)).selectOrdersByOpportunities(testOppSet);
	}

	@IsTest
	static void test_onBeforeUpdate_verifyEventsContractsAreNotCreatedMoreThanOnceWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Pass an opportunity with a contract Id so it will not create a new one
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						ContractId = fflib_IDGenerator.generate(Contract.SObjectType),
						Name = 'Test Events Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Events'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(0)
			.description('Verify no contract and order were created')))
			.registerNew(new List<SObject>());
	}

	@IsTest
	static void test_onBeforeUpdate_verifyServicesContractsAreNotCreatedMoreThanOnceWhenNeedsAnalysis_noDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// When - Pass an opportunity with a contract Id so it will not create a new one
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{
				getOpportunityWithRecordTypeNameFormulaField(
					new Opportunity(
						Id = opportunityId,
						AccountId = accountId,
						ContractId = fflib_IDGenerator.generate(Contract.SObjectType),
						Name = 'Test Services Opp',
						CloseDate = Date.today(),
						RecordTypeId = recordTypeMap.get('Events').getRecordTypeId(),
						StageName = 'Needs Analysis'
					), 'Services'
				)
			},
			new Map<Id, Opportunity>(
				new List<Opportunity>{
					new Opportunity(
						Id = opportunityId
					)
				}
			)
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(0)
			.description('Verify no contract and order were created')))
			.registerNew(new List<SObject>());
	}

	/*
	 * We need to set the read only record type developer name using the apex mock utils method
	 */
	private static Opportunity getOpportunityWithRecordTypeNameFormulaField(Opportunity opp, String mockFormula) {
		opp = (Opportunity)fflib_ApexMocksUtils.setReadOnlyFields(
			opp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => mockFormula}
		);
		return opp;
	}
}