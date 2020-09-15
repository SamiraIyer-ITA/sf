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

	private static Set<String> zip4;

	private static Set<String> zip5;

	private static Set<Id> recordTypeIds;

	private static Map<String, Id> recordTypeMap;

	private static Pattern zipCode5Plus4;

	private static Pattern zipCode5;

	private static List<Master_CongressionalDistrict__c> min4Max4AndZipPlus4MCCD;

	private static List<Master_CongressionalDistrict__c> selectByzip_Plus4;

	@TestVisible
	private static Boolean isAddressFieldUpdatable(String participationString, String accountString) {
		return (String.isNotBlank(participationString) && String.isBlank(accountString));
	}

	public static void updateCCDLookupId(List<Account> accounts) {

		if (!System.isBatch()) {

			updateCCDLookupId_initVars();

			updateCCDLookupId_populateZipSets(accounts);

			updateCCDLookupId_populateMCCDLists();

			updateCCDLookupId_setCongressionalDistrict(accounts);

		}
	}

	private static void updateCCDLookupId_initVars(){
		zip4 = new Set<String>();
		zip5 = new Set<String>();
		// SM-136: Update account triggers by record types
		recordTypeMap = Utils.getRecordTypeMapBySObject(Account.SObjectType);
		recordTypeIds = new Set<Id>{
				recordTypeMap.get('ITA_CRM_Law_Firm'),
				recordTypeMap.get('ITA_User_Account_RT'),
				recordTypeMap.get('Individual'),
				recordTypeMap.get('Partner_Account')
		};

		zipCode5Plus4 = Pattern.compile('[0-9]{5}-[0-9]{4}');
		zipCode5 = Pattern.compile('[0-9]{5}');
	}

	private static void updateCCDLookupId_populateZipSets(List<Account> accounts){
		for (Account acct: accounts) {
			Boolean meetsCriteriaZip5Plus4 = false;
			Boolean meetsCriteriaZip5 = false;
			if(Acct.BillingPostalCode != null
					&& acct.BillingCountry == 'United States'
					&& recordTypeIds.contains(acct.RecordTypeId)){
				if(zipCode5Plus4.matcher(acct.BillingPostalCode).matches()){
					meetsCriteriaZip5Plus4 = true;
				} else if(zipCode5.matcher(acct.BillingPostalCode).matches()){
					meetsCriteriaZip5 = true;
				}
			}
			if (meetsCriteriaZip5Plus4) {
				zip4.add(acct.BillingPostalCode.replace('-','').substring(5,9));
				zip5.add(acct.BillingPostalCode.substring(0,5));
			} else if(meetsCriteriaZip5){
				zip5.add(acct.BillingPostalCode.substring(0,5));
			} else {
				acct.Congressional_District__c = null;
				acct.County_Name__c = null;
				acct.State_Code__c = null;
			}
		}

	}

	private static void updateCCDLookupId_populateMCCDLists(){
		min4Max4AndZipPlus4MCCD = MasterCongressionalDistrictsSelector.newInstance().selectByMin4Max4AndZipPlus4(zip4, zip5);
		selectByzip_Plus4 = MasterCongressionalDistrictsSelector.newInstance().selectByzip_Plus4(zip5);
	}

	private static void updateCCDLookupId_setCongressionalDistrict(List<Account> accounts){
		if (!zip4.isEmpty() && !zip5.isEmpty()) {
			// Accounts that have both Zip5 and Plus4
			for (Master_CongressionalDistrict__c mccd: min4Max4AndZipPlus4MCCD) {
				for (Account acct : accounts) {
					//This condition is used to set the existing value to Null
					//if the cDistricts value is not populated and there is an existing value in
					//for Master congressional district.
					if (mccd.Min9Zip__c <= acct.BillingPostalCode.replace('-','')
							//zipcodespecchar needs to differentiate between Zip5-zip4 and Zip5
							&& mccd.Max9Zip__c >= acct.BillingPostalCode.replace('-','')
							&& zipCode5Plus4.matcher(acct.BillingPostalCode).matches()) {
						acct.Congressional_District__c = mccd.Congressional_Dist__c;
						acct.County_Name__c = mccd.County_Name__c;
						acct.State_Code__c = mccd.State_Code__c;
					}
				}
			}
		} else if(!zip5.isEmpty()) {
			// Assigns Congressional District to Orgs that do not have +4 zip codes
			List<Master_CongressionalDistrict__c> mccd = MasterCongressionalDistrictsSelector.newInstance().selectByzip_Plus4(zip5);
			Map<String, Master_CongressionalDistrict__c> mccdMap = new Map<String, Master_CongressionalDistrict__c>();
			for (Master_CongressionalDistrict__c m : mccd) {
				mccdMap.put(m.zip_Plus4__c, m);
			}
			for (Account acct : accounts) {
				String acctZip5 = acct.BillingPostalCode.substring(0, 5);
				Master_CongressionalDistrict__c m = mccdMap.get(acctZip5);
				acct.Congressional_District__c = m.Congressional_Dist__c;
				acct.County_Name__c = m.County_Name__c;
				acct.State_Code__c = m.State_Code__c;
			}
		}

	}

}