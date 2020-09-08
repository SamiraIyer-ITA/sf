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

	public static void updateCCDLookupId(List<Account> accounts) {
		system.debug('MGK Inside updateCCDLookupId');
		if (!System.isBatch()) {
			Set<String> zip4 = new Set<String>();
			Set<String> zip5 = new Set<String>();
			// SM-136: Update account triggers by record types
			Map<String, Id> recordTypeMap = Utils.getRecordTypeMapBySObject(Account.SObjectType);
			Set<Id> recordTypeIds = new Set<Id>{
				recordTypeMap.get('ITA_CRM_Law_Firm'),
				recordTypeMap.get('ITA_User_Account_RT'),
				recordTypeMap.get('Individual'),
				recordTypeMap.get('Partner_Account')
			};
			Pattern zipCodSpecChar = Pattern.compile('[0-9]{5}-[0-9]{4}');
			for (Account acct: accounts) {
				Boolean meetsCriteria = (
					acct.BillingPostalCode != null
						&& acct.BillingCountry == 'United States'
						&& recordTypeIds.contains(acct.RecordTypeId)
						&& zipCodSpecChar.matcher(acct.BillingPostalCode).matches()
				);
				if (meetsCriteria) {
					system.debug('MGK Zipcode meets criteria');
					system.debug('MGK 5digit zip is ==> ' + acct.BillingPostalCode.substring(0,5));
					zip4.add(acct.BillingPostalCode.replace('-','').substring(5,9));
					zip5.add(acct.BillingPostalCode.substring(0,5));
				} else {
					acct.Congressional_District__c = null;
					acct.County_Name__c = null;
					acct.State_Code__c = null;
				}
			}
			if (!zip4.isEmpty() && !zip5.isEmpty()) {
				for (Master_CongressionalDistrict__c mccd:
					MasterCongressionalDistrictsSelector.newInstance().selectByMin4Max4AndZipPlus4(zip4, zip5)
				) {
					for (Account acct : accounts) {
						//This condition is used to set the existing value to Null
						//if the cDistricts value is not populated and there is an existing value in
						//for Master congressional district.
						if (mccd.Min9Zip__c <= acct.BillingPostalCode.replace('-','')
								&& mccd.Max9Zip__c >= acct.BillingPostalCode.replace('-','')
								&& zipCodSpecChar.matcher(acct.BillingPostalCode).matches()) {
							system.debug('MGK before acct.Congressional_District__c = mccd.Congressional_Dist__c');
							acct.Congressional_District__c = mccd.Congressional_Dist__c;
							system.debug('MGK after acct.Congressional_District__c = mccd.Congressional_Dist__c');
							acct.County_Name__c = mccd.County_Name__c;
							acct.State_Code__c = mccd.State_Code__c;
						}
					}
				}
			}
		}
	}
}