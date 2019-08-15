@IsTest
private class AccountServiceTest {

	static final String EXPECTED_STREET = '123 Main St.';
	static final String EXPECTED_CITY = 'Cleveland';
	static final String EXPECTED_STATE = 'Ohio';
	static final String EXPECTED_POSTAL_CODE = '12345';
	static final String EXPECTED_PHONE = '1234567890';
	static final String EXPECTED_FAX = '1234567890';
	static final String GENERIC_USER_PROFILE_NAME = 'Core Team';

	@IsTest
	static void useTheService_NullListPassed_EmptyAccountListReturned(){
		System.assertEquals(new List<Account>(), AccountServiceImpl.updateAccountAddresses(null), 'Service did not return an empty list');
	}

	@IsTest
	static void useTheService_EmptyParticipationListPassed_EmptyAccountListReturned() {
		System.assertEquals(new List<Account>(), AccountServiceImpl.updateAccountAddresses(new List<Participation__c>()), 'Service did not return an empty list');
	}

	@IsTest
	static void useTheService_ParticipationPassedWithoutACountry_ErrorThrown(){
		try {
			AccountServiceImpl.updateAccountAddresses(new List<Participation__c> { new Participation__c(Postal_Code__c = '12345') });
			System.assert(false, 'This should never run because the method above this should fail');
		} catch (AccountService.AccountServiceException e){
			System.assert(true); // Should always be true and be the only assert (that succeeds) in this method
		}
	}

	@IsTest
	static void useTheService_NonInsertedParticipationListWithOneEntryPassed_AccountListReturnedWithChangedAddress(){

		Account acct = new Account(
			Id = fflib_IDGenerator.generate(Account.SObjectType)
		);

		Participation__c p = new Participation__c(
			Organization__c = acct.Id,
			Street__c = EXPECTED_STREET,
			City__c = EXPECTED_CITY,
			State__c = EXPECTED_STATE,
			Postal_Code__c = EXPECTED_POSTAL_CODE,
			Phone__c = EXPECTED_PHONE,
			Fax__c = EXPECTED_FAX,
			Country__c = 'US'
		);

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IAccountSelector mockAccountsSelector = (IAccountSelector) mocks.mock(IAccountSelector.class);
		mocks.startStubbing();
		mocks.when(mockAccountsSelector.sObjectType()).thenReturn(Account.SObjectType);
		mocks.when(mockAccountsSelector.selectById(new Set<Id> {acct.Id})).thenReturn(new List<Account> {acct});
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockAccountsSelector);

		List<Account> results = AccountServiceImpl.updateAccountAddresses(new List<Participation__c>{p});

		System.assertEquals(1, results.size(), 'Service did not return any accounts');
		acct = results.get(0);
		System.assertEquals(EXPECTED_STREET, acct.BillingStreet, 'Account does not have the correct street address');
		System.assertEquals(EXPECTED_CITY, acct.BillingCity, 'Account does not have the correct city');
		System.assertEquals(EXPECTED_STATE, acct.BillingState, 'Account does not have the correct state');
		System.assertEquals(EXPECTED_POSTAL_CODE, acct.BillingPostalCode, 'Account does not have the correct postal code');
		System.assertEquals(EXPECTED_PHONE, acct.Phone, 'Account does not have the correct phone number');
		System.assertEquals(EXPECTED_FAX, acct.Fax, 'Account does not have the correct fax number');
		System.assertEquals('United States', acct.BillingCountry, 'Account does not have the correct country');
	}

	@IsTest
	static void isAddressFieldUpdatable_MultipleConditions_AssertsDoNotFail(){
		System.assertEquals(true, AccountServiceImpl.isAddressFieldUpdatable('Some Value', ''));
		System.assertEquals(false, AccountServiceImpl.isAddressFieldUpdatable('Some Value', 'Other Value'));
		System.assertEquals(false, AccountServiceImpl.isAddressFieldUpdatable('', 'Some value'));
		System.assertEquals(false, AccountServiceImpl.isAddressFieldUpdatable('', ''));
		System.assertEquals(false, AccountServiceImpl.isAddressFieldUpdatable(null, null));
	}

}