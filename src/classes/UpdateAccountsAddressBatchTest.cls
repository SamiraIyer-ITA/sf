@IsTest
private class UpdateAccountsAddressBatchTest {

	@TestSetup
	static void setup(){
		Account a1 = new Account(Name = 'Globex');
		Account a2 = new Account(Name = 'Soylent');
		Account a3 = new Account(Name = 'Acme');
		List<Account> accountList = new List<Account>();
		accountList.add(a1);
		accountList.add(a2);
		accountList.add(a3);
		insert accountList;

		List<Participation__c> participationList = new List<Participation__c>();
		participationList.add(new Participation__c(
			Organization__c = a1.Id,
			Street__c = '123 Main St.',
			State__c = 'Ohio',
			Postal_Code__c = '12345'
			// Phone is empty on purpose because all records are supposed to have an empty Phone in the assert
		));
		participationList.add(new Participation__c(
			Organization__c = a2.Id,
			Street__c = 'Apple',
			State__c = 'California',
			Postal_Code__c = '54321',
			Phone__c = '1234567890'
		));
		participationList.add(new Participation__c(
			Organization__c = a3.Id,
			Street__c = 'Orange',
			State__c = 'Florida',
			Postal_Code__c = '99999',
			Phone__c = '1234567890'
		));
		insert participationList;

		/*
		* Deliberately add these participation records after the others. These new records should trump the
		* records created above and update the values set on these Participation__c records only.
		* NOTE: The above have a2 and a3 have a Phone filled out but since the latest Participation__c
		* records do not then we are not filling it in. If the old records are updated ever in the context of the
		* trigger then the phone will be copied over (if it is empty) but for this batch it
		* is out of scope to update from multiple records.
		*/
		participationList = new List<Participation__c>();
		participationList.add(new Participation__c(
			Organization__c = a2.Id,
			Street__c = '123 Main St.',
			State__c = 'Ohio',
			Postal_Code__c = '12345'
		));
		participationList.add(new Participation__c(
			Organization__c = a3.Id,
			Street__c = '123 Main St.',
			State__c = 'Ohio',
			Postal_Code__c = '12345'
		));
		insert participationList;

		/*
		* Artificially remove data from accounts because they were updated in the participation trigger.
		* We're trying to mimic a system with Accounts and related Participations before the trigger
		* logic was set up.
		*/
		for(Account a : accountList){
			a.BillingStreet = '';
			a.BillingState = '';
			a.BillingPostalCode = '';
			a.Phone = '';
		}
		update accountList;
	}

	@IsTest
	static void testBatch_AccountsNeedToBeUpdated_AccountsAreUpdatedWithTheCorrectValues() {
		Test.startTest();
		UpdateAccountsAddressBatch uaab = new UpdateAccountsAddressBatch();
		Id batchId = Database.executeBatch(uaab);
		Test.stopTest();

		List<Account> accountList = [SELECT Id, BillingStreet, BillingState, BillingPostalCode, Phone FROM Account LIMIT 3];
		for(Account a : accountList){
			System.assertEquals('123 Main St.', a.BillingStreet);
			System.assertEquals('Ohio', a.BillingState);
			System.assertEquals('12345', a.BillingPostalCode);
			System.assertEquals(null, a.Phone);
		}
	}

}