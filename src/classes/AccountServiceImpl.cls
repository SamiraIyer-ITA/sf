public class AccountServiceImpl implements IAccountService {

	public static final String COUNTRY_NOT_SELECTED_ERROR_MESSAGE = 'Please select a country';

	public static IAccountSelector acctSelector = AccountSelector.newInstance();

	public static List<Account> updateAccountAddresses(List<Participation__c> participationList) {
		if(participationList == null || participationList.isEmpty()){
			return new List<Account>();
		}

		Map<Id, Participation__c> accountIdToParticipationsMap = new Map<Id, Participation__c>();

		for(Participation__c p : (List<Participation__c>) participationList) {
			if(String.isEmpty(p.Country__c)) {
				throw new AccountService.AccountServiceException(COUNTRY_NOT_SELECTED_ERROR_MESSAGE);
			}
			accountIdToParticipationsMap.put(p.Organization__c, p);
		}

		List<Account> accountList = acctSelector.selectById(accountIdToParticipationsMap.keySet());

		if(accountList == null || accountList.isEmpty()){
			return new List<Account>();
		}

		for(Account account : accountList) {
			Participation__c participation = accountIdToParticipationsMap.get(account.Id);
			if(isAddressFieldUpdatable(participation.Street__c, account.BillingStreet)) {
				account.BillingStreet = participation.Street__c;
			}
			if(isAddressFieldUpdatable(participation.City__c, account.BillingCity)) {
				account.BillingCity = participation.City__c;
			}
			if(isAddressFieldUpdatable(participation.Postal_Code__c, account.BillingPostalCode)) {
				account.BillingPostalCode = participation.Postal_Code__c;
			}
			if(isAddressFieldUpdatable(participation.Phone__c, account.Phone)) {
				account.Phone = participation.Phone__c;
			}
			if(isAddressFieldUpdatable(participation.Fax__c, account.Fax)) {
				account.Fax = participation.Fax__c;
			}
			if(isAddressFieldUpdatable(participation.Country__c, account.BillingCountry)) {
				if(participation.Country__c == 'US') {
					account.BillingCountry = 'United States';
				} else {
					account.BillingCountry = participation.Country__c;
				}
				if(isAddressFieldUpdatable(participation.State__c, account.BillingState)) {
					account.BillingState = participation.State__c;
				}
			}
		}

		return accountList;
	}


	@TestVisible
	private static Boolean isAddressFieldUpdatable(String participationString, String accountString) {
		return (String.isNotBlank(participationString) && String.isBlank(accountString));
	}

	public static void updateCD(List<Account> accounts) {

		if(!System.isBatch()){

			// The call to UpdateCDHandler returns a list because UpdateCDHandler is used by a batch process which
			// requires a returned list. In the Trigger context, the list isnt used.

			List<Account> updateAccountsNotUsed = UpdateCDHandler.updateCDHandlerMain(accounts);
		}

	}

}