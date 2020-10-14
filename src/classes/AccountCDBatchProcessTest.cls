/**
 * Created by Mark Keckeis
 * MIL Corporation
 * on 10/14/2020
 */

@IsTest
private class AccountCDBatchProcessTest {
	@IsTest
	static void testBatch() {

		Account acct = TestUtils.createAccount(false);
		acct.BillingCountry = 'United States';
		acct.BillingPostalCode = '90280';
		acct.BillingCity = 'Los Angeles';
		acct.BillingStateCode = 'CA';
		insert acct;

		Master_CongressionalDistrict__c mcd = new Master_CongressionalDistrict__c();
		mcd.Congressional_Dist__c = '40';
		mcd.zip_Plus4__c = '90280';
		mcd.State_Code__c = 'CA';
		insert mcd;

		Id batchJobId = Database.executeBatch(new AccountCDBatchProcess(), 50);
		System.assertNotEquals(batchJobId, null);


	}
}