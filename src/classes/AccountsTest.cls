@IsTest
private class AccountsTest {

	static Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
	static Map<String, Id> recordTypeMap = Utils.getRecordTypeMapBySObject(Account.SObjectType);

	private static Master_CongressionalDistrict__c getTestDistrict(String min4, String max4, String zipPlus4, String county) {
		Master_CongressionalDistrict__c testDistrict = new Master_CongressionalDistrict__c(
			Id = fflib_IDGenerator.generate(Master_CongressionalDistrict__c.SObjectType),
			State_Code__c = 'MD',
			County_Name__c = county,
			zip_Plus4__c = zipPlus4,
			Min4__c = min4,
			Max4__c = max4,
			Congressional_Dist__c ='01'
		);
		return (Master_CongressionalDistrict__c) fflib_ApexMocksUtils.setReadOnlyFields(
			testDistrict,
			Master_CongressionalDistrict__c.class,
			new Map<SObjectField, Object> {
				Master_CongressionalDistrict__c.Max9Zip__c => (zipPlus4 + max4),
				Master_CongressionalDistrict__c.Min9Zip__c => (zipPlus4+ min4)
			}
		);
	}

	private static Account getTestDistrictAccount(String name, String zipCode, Boolean setId) {
		Account testAccount = new Account(
			Name = name,
			BillingStreet ='Test Street',
			BillingCity ='Test City',
			BillingState = 'Maryland',
			BillingPostalCode = zipCode,
			BillingCountry = 'United States',
			RecordTypeId = recordTypeMap.get('Partner_Account')
		);
		if (setId) {
			testAccount.Id = fflib_IDGenerator.generate(Account.SObjectType);
		}
		return testAccount;
	}

	@IsTest
	static void testNewInstanceOfAccountsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Account> accountList  = new List<Account>{ new Account() };
		IAccounts iAccounts = (IAccounts) Accounts.newInstance(accountList);
		System.assertNotEquals(iAccounts, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfAccountsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> accountIds = new Set<Id>{ accountId };
		IAccounts iAccounts = (IAccounts) Accounts.newInstance(accountIds);
		System.assertNotEquals(iAccounts, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void test_OnBeforeInsert_UpdateCCDLookupId_ZipCodeMatch() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IMasterCongressionalDistrictsSelector mockSelector
			= (IMasterCongressionalDistrictsSelector) mocks.mock(IMasterCongressionalDistrictsSelector.class);

		// Given - Create mock data
		Account testAccount1 = getTestDistrictAccount('Test Account 1', '22020-1700', false);
		Account testAccount2 = getTestDistrictAccount('Test Account 2', '22021-1700', false);

		Master_CongressionalDistrict__c testDistrict1 = getTestDistrict('1600', '1700', '22020', 'Franklin');
		Master_CongressionalDistrict__c testDistrict2 = getTestDistrict('1600', '1700', '22021', 'Washington');

		List<Master_CongressionalDistrict__c> mockDistricts = new List<Master_CongressionalDistrict__c>{
			testDistrict1,
			testDistrict2
		};

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Master_CongressionalDistrict__c.SObjectType);
		mocks.when(mockSelector.selectByMin4Max4AndZipPlus4(new Set<String>{ '1700' }, new Set<String>{ '22020', '22021' }))
			.thenReturn(mockDistricts);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Account>{ testAccount1, testAccount2 });
		fflib_SObjectDomain.triggerHandler(Accounts.class);

		// Then - Verify the account values from district
		System.assertEquals(testDistrict1.Congressional_Dist__c, testAccount1.Congressional_District__c);
		System.assertEquals(testDistrict1.County_Name__c, testAccount1.County_Name__c);
		System.assertEquals(testDistrict1.State_Code__c, testAccount1.State_Code__c);
		System.assertEquals(testDistrict2.Congressional_Dist__c, testAccount2.Congressional_District__c);
		System.assertEquals(testDistrict2.County_Name__c, testAccount2.County_Name__c);
		System.assertEquals(testDistrict2.State_Code__c, testAccount2.State_Code__c);
	}

	@IsTest
	static void test_OnBeforeInsert_UpdateCCDLookupId_ZipCodeMatch_NoZip4() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IMasterCongressionalDistrictsSelector mockSelector
			= (IMasterCongressionalDistrictsSelector) mocks.mock(IMasterCongressionalDistrictsSelector.class);

		// Given - Create mock data
		Account testAccount1 = getTestDistrictAccount('Test Account 1', '22020', false);
		Account testAccount2 = getTestDistrictAccount('Test Account 2', '22021', false);

		Master_CongressionalDistrict__c testDistrict1 = getTestDistrict('1600', '1700', '22020', 'Franklin');
		Master_CongressionalDistrict__c testDistrict2 = getTestDistrict('1600', '1700', '22021', 'Washington');

		List<Master_CongressionalDistrict__c> mockDistricts = new List<Master_CongressionalDistrict__c>{
			testDistrict1,
			testDistrict2
		};

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Master_CongressionalDistrict__c.SObjectType);
		mocks.when(mockSelector.selectByzip_Plus4(new Set<String>{ '22020', '22021' }))
			.thenReturn(mockDistricts);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Account>{ testAccount1, testAccount2 });
		fflib_SObjectDomain.triggerHandler(Accounts.class);

		// Then - Verify the account values from district
		System.assertEquals(testDistrict1.Congressional_Dist__c, testAccount1.Congressional_District__c);
		System.assertEquals(testDistrict1.County_Name__c, testAccount1.County_Name__c);
		System.assertEquals(testDistrict1.State_Code__c, testAccount1.State_Code__c);
		System.assertEquals(testDistrict2.Congressional_Dist__c, testAccount2.Congressional_District__c);
		System.assertEquals(testDistrict2.County_Name__c, testAccount2.County_Name__c);
		System.assertEquals(testDistrict2.State_Code__c, testAccount2.State_Code__c);
	}

	@IsTest
	static void test_OnBeforeInsert_UpdateCCDLookupId_NoZipCodeMatch() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IMasterCongressionalDistrictsSelector mockSelector
			= (IMasterCongressionalDistrictsSelector) mocks.mock(IMasterCongressionalDistrictsSelector.class);

		// Given - Create mock data
		Account testAccount = getTestDistrictAccount('Test Account 1', '22020-1801', false);

		Master_CongressionalDistrict__c testDistrict = new Master_CongressionalDistrict__c(
			Id = fflib_IDGenerator.generate(Master_CongressionalDistrict__c.SObjectType),
			State_Code__c = 'MD',
			County_Name__c = 'Franklin',
			zip_Plus4__c = '22020',
			Min4__c = '1700',
			Max4__c = '1800',
			Congressional_Dist__c ='01'
		);
		// Set the Max9Zip__c formula field (zip_Plus4__c + Max4__c)
		testDistrict = (Master_CongressionalDistrict__c) fflib_ApexMocksUtils.setReadOnlyFields(
			testDistrict,
			Master_CongressionalDistrict__c.class,
			new Map<SObjectField, Object> { Master_CongressionalDistrict__c.Max9Zip__c => '220201800' }
		);
		List<Master_CongressionalDistrict__c> mockDistricts = new List<Master_CongressionalDistrict__c>{ testDistrict };

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Master_CongressionalDistrict__c.SObjectType);
		mocks.when(mockSelector.selectByMin4Max4AndZipPlus4(new Set<String>{ '1801' }, new Set<String>{ '22020' }))
			.thenReturn(mockDistricts);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Account>{ testAccount });
		fflib_SObjectDomain.triggerHandler(Accounts.class);

		// Then - Verify the account values were not set
		System.assertEquals(null, testAccount.Congressional_District__c);
		System.assertEquals(null, testAccount.County_Name__c);
		System.assertEquals(null, testAccount.State_Code__c);
	}

	@IsTest
	static void test_OnBeforeInsert_UpdateCCDLookupId_AccountDoesNotMeetCriteria() {
		// Given - Create mock data - Set account country to something other than 'United States', so criteria not met
		Account testAccount = new Account(
			Name = 'ABC company Ltd.',
			BillingStreet ='Test Street',
			BillingCity ='Test City',
			BillingState = 'Maryland',
			BillingPostalCode = '22020-1801',
			BillingCountry = 'Canada',
			RecordTypeId = recordTypeMap.get('Partner_Account')
		);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onInsert(new List<Account>{ testAccount });
		fflib_SObjectDomain.triggerHandler(Accounts.class);

		// Then - Verify the account values were not set
		System.assertEquals(null, testAccount.Congressional_District__c);
		System.assertEquals(null, testAccount.County_Name__c);
		System.assertEquals(null, testAccount.State_Code__c);
	}

	@IsTest
	static void test_OnBeforeUpdate_UpdateCCDLookupId_ZipCodeMatch() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IMasterCongressionalDistrictsSelector mockSelector
			= (IMasterCongressionalDistrictsSelector) mocks.mock(IMasterCongressionalDistrictsSelector.class);

		// Given - Create mock data
		Account existingTestAccount1 = getTestDistrictAccount('Test Account 1', null, true);
		Account testAccount1 = existingTestAccount1.clone(true, true, false, false);
		testAccount1.BillingPostalCode = '22020-1700';
		Account existingTestAccount2 = getTestDistrictAccount('Test Account 2', null, true);
		Account testAccount2 = existingTestAccount2.clone(true, true, false, false);
		testAccount2.BillingPostalCode = '22021-1700';

		Master_CongressionalDistrict__c testDistrict1 = getTestDistrict('1600', '1700', '22020', 'Franklin');
		Master_CongressionalDistrict__c testDistrict2 = getTestDistrict('1600', '1700', '22021', 'Washington');

		List<Master_CongressionalDistrict__c> mockDistricts = new List<Master_CongressionalDistrict__c>{
			testDistrict1,
			testDistrict2
		};

		mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(Master_CongressionalDistrict__c.SObjectType);
		mocks.when(mockSelector.selectByMin4Max4AndZipPlus4(new Set<String>{ '1700' }, new Set<String>{ '22020', '22021' }))
			.thenReturn(mockDistricts);
		mocks.stopStubbing();

		// Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Account>{ testAccount1, testAccount2 },
			new Map<Id, Account>(
				new List<Account>{ existingTestAccount1, existingTestAccount2 }
			)
		);
		fflib_SObjectDomain.triggerHandler(Accounts.class);

		// Then - Verify the account values from district
		System.assertEquals(testDistrict1.Congressional_Dist__c, testAccount1.Congressional_District__c);
		System.assertEquals(testDistrict1.County_Name__c, testAccount1.County_Name__c);
		System.assertEquals(testDistrict1.State_Code__c, testAccount1.State_Code__c);
		System.assertEquals(testDistrict2.Congressional_Dist__c, testAccount2.Congressional_District__c);
		System.assertEquals(testDistrict2.County_Name__c, testAccount2.County_Name__c);
		System.assertEquals(testDistrict2.State_Code__c, testAccount2.State_Code__c);
	}
}