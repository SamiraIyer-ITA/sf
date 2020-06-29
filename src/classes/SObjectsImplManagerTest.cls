/**
 * This test class covers the SObjectsImplManager, ISObjectsTriggerService, SObjectsTriggerService, and TriggerImpl
 * classes.
 */
@IsTest
private class SObjectsImplManagerTest {

	/**
	 * Static test service that maps the ISObjectsTriggerService to MockSObjectsTriggerService implementation using the
	 * fflib Application Service Factory. We set this value in our TriggerImpl service test visible property.
	 *
	 * @return
	 */
	static fflib_Application.ServiceFactory service() {
		return new fflib_Application.ServiceFactory(
			new Map<Type, Type>{
				Type.forName('ISObjectsTriggerService') => Type.forName( 'MockSObjectsTriggerService')
			}
		);
	}

	/**
	 * Using a standard SObject to use in our test methods and trigger service
	 */
	static List<Account> testSObjects = new List<Account>{
		new Account(Id = fflib_IDGenerator.generate(Account.SObjectType), Name = 'TestImplementation')};

	@IsTest
	static void test_getInterfaceTypeByKey() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		Map<String, System.Type> expectedInterfaceTypeByKey = new Map<String, System.Type>{
			'TestImplementation' => ISObjectsTriggerService.class
		};
		System.assertEquals(expectedInterfaceTypeByKey, mockImplManager.getInterfaceTypeByKey());
	}

	@IsTest
	static void test_getRecordsByInterfaceType() {
		 TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		Map<System.Type, List<SObject>> expectedRecordsByInterfaceType = new Map<System.Type, List<SObject>>{
			ISObjectsTriggerService.class => testSObjects
		};
		System.assertEquals(expectedRecordsByInterfaceType, mockImplManager.getRecordsByInterfaceType());
	}

	@IsTest
	static void test_implWrapper_Constructor() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(
			new SObjectsImplManager.ImplWrapper(testSObjects, null));

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
	}

	@IsTest
	static void test_noServiceImplementationFoundMapperException() {
		String expectedExceptionMessage
			= 'No Application Factory Service custom metadata found with Service Implementation SObject, TestInvalidSObject.';
		try {
			// When
			new SObjectsImplManager.ImplMapper('TestInvalidSObject');
		} catch (Exception e) {
			// Then
			System.assertEquals(expectedExceptionMessage, e.getMessage(), 'Verify exception message');
		}

	}

	@IsTest
	static void test_triggerService_handleBeforeInsert() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onBeforeInsert(testSObjects);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);
		mockImplManager.triggerService().handleBeforeInsert();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		((MockSObjectsTriggerService)mocks.verify(mockService, mocks.times(1)
			.description('onBeforeInsert called once')))
			.onBeforeInsert((List<SObject>) fflib_Match.anyObject());
	}

	@IsTest
	static void test_triggerService_handleBeforeDelete() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onBeforeDelete(testSObjects);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects );
		mockImplManager.triggerService().handleBeforeDelete();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		((MockSObjectsTriggerService)mocks.verify(mockService, mocks.times(1)
			.description('onBeforeDelete called once')))
			.onBeforeDelete((List<SObject>) fflib_Match.anyObject());
	}

	@IsTest
	static void test_triggerService_handleBeforeUpdate() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onBeforeUpdate(testSObjects , new Map<Id, SObject>(testSObjects));
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager
			= new MockSObjectsImplManager(testSObjects , new Map<Id, SObject>(testSObjects ));
		mockImplManager.triggerService().handleBeforeUpdate();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');

		((MockSObjectsTriggerService)
			mocks.verify(mockService, mocks.times(1)
				.description('onBeforeUpdate called once')))
				.onBeforeUpdate((List<SObject>) fflib_Match.anyObject(), (Map<Id, SObject>) fflib_Match.anyObject());
	}

	@IsTest
	static void test_triggerService_handleAfterInsert() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onValidate(testSObjects);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onAfterInsert(testSObjects);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);
		mockImplManager.triggerService().handleAfterInsert();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');

		((MockSObjectsTriggerService)
			mocks.verify(mockService, mocks.times(1)
				.description('onValidate called once')))
				.onValidate((List<SObject>) fflib_Match.anyObject());

		((MockSObjectsTriggerService)mocks.verify(mockService, mocks.times(1)
			.description('onAfterInsert called once')))
			.onAfterInsert((List<SObject>) fflib_Match.anyObject());
	}

	@IsTest
	static void test_triggerService_handleAfterUpdate() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);

		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });

		mocks.startStubbing();

		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);

		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onValidate(testSObjects);

		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onValidate(testSObjects , new Map<Id, SObject>(testSObjects));

		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onAfterUpdate(testSObjects , new Map<Id, SObject>(testSObjects));

		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager
			= new MockSObjectsImplManager(testSObjects , new Map<Id, SObject>(testSObjects ));
		mockImplManager.triggerService().handleAfterUpdate();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');

		((MockSObjectsTriggerService)
			mocks.verify(mockService, mocks.times(1)
				.description('onValidate called once')))
				.onValidate((List<SObject>) fflib_Match.anyObject());

		((MockSObjectsTriggerService)
			mocks.verify(mockService, mocks.times(1)
				.description('onValidate called once')))
				.onValidate((List<SObject>) fflib_Match.anyObject(), (Map<Id, SObject>) fflib_Match.anyObject());

		((MockSObjectsTriggerService)
			mocks.verify(mockService, mocks.times(1)
				.description('onAfterUpdate called once')))
				.onAfterUpdate((List<SObject>) fflib_Match.anyObject(), (Map<Id, SObject>) fflib_Match.anyObject());
	}

	 @IsTest
	static void test_triggerService_handleAfterDelete() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onAfterDelete(testSObjects);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);
		mockImplManager.triggerService().handleAfterDelete();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		((MockSObjectsTriggerService)mocks.verify(mockService, mocks.times(1)
			.description('onAfterDeletecalled once')))
			.onAfterDelete((List<SObject>) fflib_Match.anyObject());
	}

	@IsTest
	static void test_triggerService_handleAfterUndelete() {
		TriggerImpl.service = service();

		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAppFactoryServicesMetadataSelector mockSelector
			= (IAppFactoryServicesMetadataSelector) mocks.mock(IAppFactoryServicesMetadataSelector.class);
		MockSObjectsTriggerService mockService = new MockSObjectsTriggerService();

		// Given - Configure mock responses
		ApplicationFactory_Service__mdt appFactoryService = new ApplicationFactory_Service__mdt(
			Id = fflib_IDGenerator.generate(ApplicationFactory_Service__mdt.SObjectType),
			DeveloperName = 'TestService',
			SObjectType__c = 'ISObjectsTriggerService',
			ServiceImplementationClass__c = 'MockSObjectsTriggerService',
			Service_Implementation_Key__c = 'TestImplementation'
		);
		AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
			= new AppFactoryServicesMetadataSelector.ImplementationWrapper(
				'Name', new List<ApplicationFactory_Service__mdt>{ appFactoryService });
		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(ApplicationFactory_Service__mdt.SObjectType);
		mocks.when(
			mockSelector.selectByServiceImplementationSObjectDeveloperName('Account')).thenReturn(metadataWrapper);
		((MockSObjectsTriggerService) mocks.doAnswer(
			 new MockSObjectsImplManagerAnswer(), mockService))
				.onAfterUndelete(testSObjects);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When
		MockSObjectsImplManager mockImplManager = new MockSObjectsImplManager(testSObjects);
		mockImplManager.triggerService().handleAfterUndelete();

		// Then
		((IAppFactoryServicesMetadataSelector)
			mocks.verify(mockSelector)).selectByServiceImplementationSObjectDeveloperName('Account');
		((MockSObjectsTriggerService)mocks.verify(mockService, mocks.times(1)
			.description('onAfterUndelete called once')))
			.onAfterUndelete((List<SObject>) fflib_Match.anyObject());
	}

	/**
	 * Mock class to test an extension of the SObjectsImplManager
	 */
	private class MockSObjectsImplManager extends SObjectsImplManager {

		public MockSObjectsImplManager(SObjectsImplManager.ImplWrapper implWrapper) {
			super(implWrapper);
		}

		public MockSObjectsImplManager(List<SObject> records) {
			super(records);
		}

		public MockSObjectsImplManager(List<SObject> records, Map<Id, SObject> existingRecords) {
			super(records, existingRecords);
		}
	}

	/**
	 * Required for fflib Apex Mocks when testing a void method
	 */
	private class MockSObjectsImplManagerAnswer implements fflib_Answer {

		public Object answer(fflib_InvocationOnMock invocation) {
			return null;
		}
	}
}