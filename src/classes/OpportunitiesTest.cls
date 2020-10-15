@IsTest
private class OpportunitiesTest {

	static Map<String, Id> recordTypeMap = Utils.getRecordTypeMapBySObject(Opportunity.SObjectType);
	static Id orderServicesRecordTypeId = Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(Order.SObjectType, 'Services');
	static Id orderEventsRecordTypeId = Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(Order.SObjectType, 'Events');
	static Id contractParticipationAgreementRecordTypeId
		= Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(Contract.SObjectType, 'Participation_Agreement');
	static Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
	static Id opportunityId = fflib_IDGenerator.generate(Opportunity.SObjectType);
	static Id companyQuestionnaireId = fflib_IDGenerator.generate(Client_Form__c.SObjectType);

	private static Opportunity getContractOrderOpportunity(String recordTypeDeveloperName, String stageName) {
		Opportunity opp = new Opportunity(
			Id = opportunityId,
			AccountId = accountId,
			Name = 'Test ' + recordTypeDeveloperName + ' Opp',
			CloseDate = Date.today(),
			Export_Ready__c = 'Yes',
			Company_Questionnaire__c = companyQuestionnaireId,
			RecordTypeId = recordTypeMap.get(recordTypeDeveloperName),
			StageName = stageName,
			Requested_Service_Start_Date__c	= Date.today(),
			Requested_Service_End_Date__c = Date.today().addDays(1)
		);
		return (Opportunity)fflib_ApexMocksUtils.setReadOnlyFields(
			opp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => recordTypeDeveloperName}
		);
	}

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
	static void test_OpportunitiesTrigger_WithDml() {
		// Insert opportunity with required fields to test Opportunities trigger as rest of tests are not using dml
		insert new Opportunity(
			Name = 'Test Events Opp',
			CloseDate = Date.today(),
			StageName = 'Qualification'
		);
	}

	@IsTest
	static void test_OnAfterInsert_CreateEventsContractsAndOrdersWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Events', 'Needs Analysis');

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
				new List<Map<SObjectField, Object>> {
					new Map<SObjectField, Object> {
						Contract.AccountId => accountId,
						Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
						Contract.StartDate => testOpp.CloseDate,
						Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => testOpp.Requested_Service_Start_Date__c,
						Order.EndDate => testOpp.Requested_Service_End_Date__c,
						Order.Type => 'Events',
						Order.RecordTypeId => orderEventsRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_OnAfterInsert_CreateServicesContractsAndOrdersWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Services', 'Needs Analysis');

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify our unit of work
		((fflibext_ISObjectUnitOfWork)mocks.verify(mockUow, mocks.times(1)
			.description('Verify a contract and order were created with correct values')))
			.registerNew(fflib_Match.sObjectsWith(
				new List<Map<SObjectField, Object>> {
					new Map<SObjectField, Object> {
							Contract.AccountId => accountId,
							Contract.RecordTypeId => contractParticipationAgreementRecordTypeId,
							Contract.StartDate => testOpp.CloseDate,
							Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => testOpp.Requested_Service_Start_Date__c,
						Order.EndDate => testOpp.Requested_Service_End_Date__c,
						Order.Type => 'Services',
						Order.RecordTypeId => orderServicesRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_OnBeforeUpdate_CreateEventsContractsAndOrdersWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity existingTestOpp = getContractOrderOpportunity('Events', 'Qualification');

		Opportunity testOpp = existingTestOpp.clone(true, true, false, false);
		testOpp.StageName = 'Needs Analysis';

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>(
				new List<Opportunity>{ existingTestOpp }
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
						Contract.StartDate => testOpp.CloseDate,
						Contract.ContractTerm => 12
					},
					new Map<SObjectField,Object> {
						Order.OpportunityId => opportunityId,
						Order.AccountId => accountId,
						Order.Status => 'Draft',
						Order.EffectiveDate => testOpp.Requested_Service_Start_Date__c,
						Order.EndDate => testOpp.Requested_Service_End_Date__c,
						Order.Type => 'Events',
						Order.RecordTypeId => orderEventsRecordTypeId
					}
				}
			));
	}

	@IsTest
	static void test_OnBeforeUpdate_CreateServicesContractsAndOrdersWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity existingTestOpp = getContractOrderOpportunity('Services', 'Qualification');

		Opportunity testOpp = existingTestOpp.clone(true, true, false, false);
		testOpp.StageName = 'Needs Analysis';

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>(
				new List<Opportunity>{ existingTestOpp }
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
					Contract.StartDate => testOpp.CloseDate,
					Contract.ContractTerm => 12
				},
				new Map<SObjectField,Object> {
					Order.OpportunityId => opportunityId,
					Order.AccountId => accountId,
					Order.Status => 'Draft',
					Order.EffectiveDate => testOpp.Requested_Service_Start_Date__c,
					Order.EndDate => testOpp.Requested_Service_End_Date__c,
					Order.Type => 'Services',
					Order.RecordTypeId => orderServicesRecordTypeId
				}
			}
		));
	}

	@IsTest
	static void test_OnBeforeUpdate_VerifyEventsOrdersAreNotCreatedMoreThanOnceWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOrdersSelector mockSelector = (IOrdersSelector) mocks.mock(IOrdersSelector.class);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Events', 'Needs Analysis');

		// Create mock data with an order using the opportunity Id in our update method
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
			new List<Opportunity>{ testOpp },
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
	static void test_OnBeforeUpdate_VerifyServicesOrdersAreNotCreatedMoreThanOnceWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);
		IOrdersSelector mockSelector = (IOrdersSelector) mocks.mock(IOrdersSelector.class);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Services', 'Needs Analysis');

		// Create mock data with an order using the opportunity Id in our update method
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
			new List<Opportunity>{ testOpp },
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
	static void test_OnBeforeUpdate_VerifyEventsContractsAreNotCreatedMoreThanOnceWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Events', 'Needs Analysis');

		// When - Pass an opportunity with a contract Id so it will not create a new one
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
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
	static void test_OnBeforeUpdate_VerifyServicesContractsAreNotCreatedMoreThanOnceWhenNeedsAnalysis_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);

		// Given - Create mock data
		Opportunity testOpp = getContractOrderOpportunity('Services', 'Needs Analysis');

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
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
	static void test_OnBeforeInsert_SetServicesStages_NoDml() {
		// Given - Create mocks (we need to mock this as it's used in other triggers and will cause errors)
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		// Given - Create mock data
		Opportunity testOpp = new Opportunity(
			Id = opportunityId,
			AccountId = accountId,
			ContractId = fflib_IDGenerator.generate(Contract.SObjectType),
			Name = 'Test Services Opp',
			CloseDate = Date.today(),
			RecordTypeId = recordTypeMap.get('Services')
		);
		testOpp = (Opportunity)fflib_ApexMocksUtils.setReadOnlyFields(
			testOpp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => 'Services'}
		);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Qualification', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Company_Questionnaire__c = companyQuestionnaireId;
		testOpp.Export_Ready__c = 'Yes';

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Needs Analysis', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Conference_Call_Scheduled__c = true;

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Value Proposition', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Conference_Call_Completed__c = true;

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Proposal/Price Quote', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.PA_Sent__c = true;

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Opportunity>{ testOpp });
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Negotiation/Review', testOpp.StageName);
	}

	@IsTest
	static void test_OnBeforeUpdate_SetServicesStages_NoDml() {
		// Given - Create mocks (we need to mock this as it's used in other triggers and will cause errors)
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mockUow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Given - Inject mocks
		fflibext_Application.UnitOfWork.setMock(mockUow);
		// Given - Create mock data
		Opportunity existingTestOpp = new Opportunity(
			Id = opportunityId,
			AccountId = accountId,
			ContractId = fflib_IDGenerator.generate(Contract.SObjectType),
			Name = 'Test Services Opp',
			CloseDate = Date.today(),
			RecordTypeId = recordTypeMap.get('Events')
		);
		existingTestOpp = (Opportunity)fflib_ApexMocksUtils.setReadOnlyFields(
			existingTestOpp,
			Opportunity.class,
			new Map<SObjectField, Object> {Opportunity.Record_Type_Developer_Name__c => 'Services'}
		);
		Opportunity testOpp = existingTestOpp.clone(true, true, false, false);

		// Given - Set criteria to check next stage
		testOpp.Company_Questionnaire__c = companyQuestionnaireId;

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>( new List<Opportunity>{ existingTestOpp })
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Qualification', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Export_Ready__c = 'Yes';

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>( new List<Opportunity>{ existingTestOpp })
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Needs Analysis', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Conference_Call_Scheduled__c = true;

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>( new List<Opportunity>{ existingTestOpp })
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Value Proposition', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.Conference_Call_Completed__c = true;

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>( new List<Opportunity>{ existingTestOpp })
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Proposal/Price Quote', testOpp.StageName);

		// Given - Set criteria to check next stage
		testOpp.PA_Sent__c = true;

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Opportunity>{ testOpp },
			new Map<Id, Opportunity>( new List<Opportunity>{ existingTestOpp })
		);
		fflib_SObjectDomain.triggerHandler(Opportunities.class);

		// Then - Verify the status
		System.assertEquals('Negotiation/Review', testOpp.StageName);
	}
}