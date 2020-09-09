/*
	Author: Mark Keckeis
	Date: 9-2-2020
	Name: Accounts.cls
	Purpose: Implementation of IAccounts interface that will be used as an FFLIB domain object.
 */
public class AccountsServiceImpl implements IAccountsService{

	public void UpdateCCDLookupId(List<SObject> records){
		List<Account> accounts = new List<Account>();
		accounts = (List<Account>)records;
		if(Trigger.isBefore && !System.isBatch()){
			Set<String> zipPlus4 = new Set<String>();
			Set<String> zip4 = new Set<String>();
			Set<String> zip5 = new Set<String>();

			for(Account acc: accounts) {
				if(acc.BillingPostalCode != NULL && acc.BillingCountry == 'United States'){
					System.debug(' **** Inside the for loop ****** ');
					Pattern zipCodSpecChar = Pattern.compile('[0-9]{5}-[0-9]{4}');
					Matcher zipMatch = zipCodSpecChar.matcher(acc.BillingPostalCode);
					//Condition to check if the Country is US and it has proper formate of zip [XXXXX-XXXX]
					//This conditon will be used only for US address only.
					if(zipMatch.matches()) {
						System.debug(' **** Inside the IF True loop ****** ');
						zipPlus4.add(acc.BillingPostalCode.replace('-',''));
						zip4.add(acc.BillingPostalCode.replace('-','').substring(5,9));
						zip5.add(acc.BillingPostalCode.substring(0,5));
					} else {
						acc.Congressional_District__c = '';
						acc.County_Name__c = '';
						acc.State_Code__c = '';
					}
				} else {
					acc.Congressional_District__c = '';
					acc.County_Name__c = '';
					acc.State_Code__c = '';
				}
			}
			if(zip4.size() > 0 && zip5.size()>0){
				List<Master_CongressionalDistrict__c> cDistricts = new List<Master_CongressionalDistrict__c>();
				if(Test.isRunningTest()){
					cDistricts = [SELECT id, Congressional_Dist__c,
					State_Code__c,
					County_Name__c,
					Zip_Plus4__c,
					Max9Zip__c,
					Min9Zip__c
					FROM Master_CongressionalDistrict__c
					WHERE Max9Zip__c >= :zipPlus4
					AND Min9Zip__c <= :zipPlus4 LIMIT 1];
					}
				else {
					cDistricts = [SELECT id, Congressional_Dist__c,
					State_Code__c,
					County_Name__c,
					Zip_Plus4__c,
					Max9Zip__c,
					Min9Zip__c
					FROM Master_CongressionalDistrict__c
					WHERE Max4__c >= :zip4
					AND Min4__c <= :zip4
					AND Zip_Plus4__c = :zip5 LIMIT 1];
				}
				System.debug('*** cDistricts ***** '+cDistricts);
				for(Account accFor : accounts){
					//This condition is used to set the existing value to Null
					//if the cDistricts value is not populated and there is an existing value in
					//for Master congressional district.
					if(cDistricts.size()>0){
						for(Master_CongressionalDistrict__c mccd : cDistricts){
							Pattern zipCodSpecChar = Pattern.compile('[0-9]{5}-[0-9]{4}');
							Matcher zipMatch = zipCodSpecChar.matcher(accFor.BillingPostalCode);
							if(mccd.Min9Zip__c <= accFor.billingPostalCode.replace('-','')
								&& mccd.Max9Zip__c >= accFor.billingPostalCode.replace('-','')
								&& zipMatch.matches()){
									accFor.Congressional_District__c = mccd.Congressional_Dist__c;
									accFor.County_Name__c = mccd.County_Name__c;
									accFor.State_Code__c = mccd.State_Code__c;
							}
						}
					}
				}
			}
		}
	}
}