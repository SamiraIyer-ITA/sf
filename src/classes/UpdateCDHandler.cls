/**
 * Created by Mark Keckeis - Mil Corporation
 * 	9/17/2020
 */

public class UpdateCDHandler {

	private static Set<Id> recordTypeIds;

	private static Map<String, Id> recordTypeMap;

	private static Pattern patternZipCode5Plus4;

	private static Pattern patternZipCode5;

	private static Set<String> zip4;

	private static Set<String> zip5;

	private static Boolean meetsCriteriaZip5Plus4;

	private static Boolean meetsCriteriaZip5;

	private static List<Account> AccountsZip5Plus4;

	private static List<Account> AccountsZip5;

	private static List<Account> updatedAccounts;

	private static List<Master_CongressionalDistrict__c> min4Max4AndZipPlus4MCCD;

	private static List<Master_CongressionalDistrict__c> selectByzip_Plus4;

	public static List<Account> updateCDHandlerMain(List<Account> accounts) {
		system.debug('MGK: in updateCDHandlerMain');
		updatedAccounts = new List<Account>();
		updateCD_initVars(accounts);
		updateCD(AccountsZip5Plus4);

		AccountsZip5Plus4.clear();
		meetsCriteriaZip5Plus4 = false;
		updatedAccounts.addAll(AccountsZip5Plus4);

		updateCD(AccountsZip5);
		updatedAccounts.addAll(AccountsZip5);
		return updatedAccounts;

	}

	public static void updateCD(List<Account> updateCDAccounts) {
		system.debug('MGK: in updateCD');

		updateCD_populateZipSets(updateCDAccounts);

		updateCD_populateCDLists();

		updateCD_setCongressionalDistrict(updateCDAccounts);

	}

	private static void updateCD_initVars(List<Account> accounts){
		system.debug('MGK: in updateCD_initVars');
		AccountsZip5Plus4 = new List<account>();
		AccountsZip5 		= new List<account>();

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

		patternZipCode5Plus4 = Pattern.compile('[0-9]{5}-[0-9]{4}');
		patternZipCode5 = Pattern.compile('[0-9]{5}');

		for (Account acct: accounts) {
			if (Acct.BillingPostalCode != null
					&& acct.BillingCountry == 'United States'
					&& recordTypeIds.contains(acct.RecordTypeId)) {
				if (patternZipCode5Plus4.matcher(acct.BillingPostalCode).matches()) {
					accountszip5Plus4.add(acct);
				} else if (patternZipCode5.matcher(acct.BillingPostalCode).matches()) {
					accountszip5.add(acct);
				}
			}
		}
	}

	private static void updateCD_populateZipSets(List<Account> accounts){
		system.debug('MGK: in updateCD_populateZipSets');
		for (Account acct: accounts) {
			Boolean meetsCriteriaZip5Plus4 = false;
			Boolean meetsCriteriaZip5 = false;
			if (Acct.BillingPostalCode != null
					&& acct.BillingCountry == 'United States'
					&& recordTypeIds.contains(acct.RecordTypeId)) {
				if (patternZipCode5Plus4.matcher(acct.BillingPostalCode).matches()) {
					meetsCriteriaZip5Plus4 = true;
				} else if (patternZipCode5.matcher(acct.BillingPostalCode).matches()) {
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

	private static void updateCD_populateCDLists() {
		system.debug('MGK: in updateCD_populateCDLists');
		if (!zip4.isEmpty() && !zip5.isEmpty()) {
			min4Max4AndZipPlus4MCCD = MasterCongressionalDistrictsSelector.newInstance().selectByMin4Max4AndZipPlus4(zip4, zip5);
		} else if (!zip5.isEmpty()) {
			selectByzip_Plus4 = MasterCongressionalDistrictsSelector.newInstance().selectByzip_Plus4(zip5);
		}
	}

	private static void updateCD_setCongressionalDistrict(List<Account> accounts){
		system.debug('MGK: in updateCD_setCongressionalDistrict');
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
							&& patternZipCode5Plus4.matcher(acct.BillingPostalCode).matches()) {
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