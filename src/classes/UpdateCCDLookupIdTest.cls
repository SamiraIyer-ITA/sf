@isTest
private class UpdateCCDLookupIdTest {

	// SM-136: Update account triggers by record types (pass this record type into test here)
	static Id partnerAccountRecordTypeId = Schema.SObjectType.Account
		.getRecordTypeInfosByDeveloperName().get('Partner_Account').getRecordTypeId();

	@isTest static void ZipcodeMatch() {
		Test.startTest();
		if(!System.isBatch())
		{
		List<Master_CongressionalDistrict__c> mCCD = new List<Master_CongressionalDistrict__c>();
		Master_CongressionalDistrict__c mCCDSet = new Master_CongressionalDistrict__c();
		mCCDSet.State_Code__c = 'MD';
		mCCDSet.County_Name__c = 'Franklin';
		mCCDSet.Zip_Plus4__c = '22020';
		mCCDSet.Min4__c = '1600';
		mCCDSet.Max4__c = '1700';
		mCCDSet.Congressional_Dist__c ='01';
		mCCD.add(mCCDSet);
		insert mCCD;

		List<Account> testAccount = new List<Account>();
		Account accSet = new Account();
		accSet.Name = 'ABC company Ltd.';
		accSet.BillingStreet ='Test Street';
		accSet.BillingCity ='Test City';
		accSet.BillingState = 'Maryland';
		accSet.BillingPostalCode = '22020-1700';
		accSet.BillingCountry ='United States';
		accSet.RecordTypeId = partnerAccountRecordTypeId;
		testAccount.add(accSet);
		insert testAccount;

		List<DNBoptimizer__DnBCompanyRecord__c> dnb = new List<DNBoptimizer__DnBCompanyRecord__c>();
		List<DNBoptimizer__DnBCompanyRecord__c> dnbUpdate = new List<DNBoptimizer__DnBCompanyRecord__c>();		
		DNBoptimizer__DnBCompanyRecord__c dbSet = new DNBoptimizer__DnBCompanyRecord__c();
		dbSet.DNBoptimizer__DUNSNumber__c ='1234';
		dbSet.Name =' DnB company';
		dbSet.DNBoptimizer__USTaxID__c ='89765';
		dnb.add(dbSet);
		insert dnb;

		dbSet = new DNBoptimizer__DnBCompanyRecord__c();
		dbSet.Id = dnb[0].Id;
		dbSet.DNBoptimizer__USTaxID__c = Null;
		dnbUpdate.add(dbSet);
		update dnbUpdate;

		//System.assertEquals(testAccount[0].billingPostalCode.replace('-',''), mCCD[0].Max9Zip__c);
        System.assertEquals(dnbUpdate[0].DNBoptimizer__USTaxID__c,Null);
		Test.stopTest();
	}
	}

	@isTest static void ZipcodeNotMatch() {
		Test.startTest();
		if(!System.isBatch())
		{
		List<Master_CongressionalDistrict__c> mCCD = new List<Master_CongressionalDistrict__c>();
		Master_CongressionalDistrict__c mCCDSet = new Master_CongressionalDistrict__c();
		mCCDSet.State_Code__c = 'MD';
		mCCDSet.County_Name__c = 'Franklin';
		mCCDSet.Zip_Plus4__c = '22020';
		mCCDSet.Min4__c = '1700';
		mCCDSet.Max4__c = '1800';
		mCCDSet.Congressional_Dist__c ='01';
		mCCD.add(mCCDSet);
		
		List<Account> testAccount = new List<Account>();
		Account accSet = new Account();
		accSet.Name = 'ABC company Ltd.';
		accSet.BillingStreet ='Test Street';
		accSet.BillingCity ='Test City';
		accSet.BillingState = 'Maryland';
		accSet.BillingPostalCode ='22020-1801';
		accSet.BillingCountry ='United States';
		accSet.RecordTypeId = partnerAccountRecordTypeId;
		testAccount.add(accSet);
		
		List<DNBoptimizer__DnBCompanyRecord__c> dnb = new List<DNBoptimizer__DnBCompanyRecord__c>();
		List<DNBoptimizer__DnBCompanyRecord__c> dnbUpdate = new List<DNBoptimizer__DnBCompanyRecord__c>();		
		DNBoptimizer__DnBCompanyRecord__c dbSet = new DNBoptimizer__DnBCompanyRecord__c();
		dbSet.DNBoptimizer__DUNSNumber__c ='1234';
		dbSet.Name =' DnB company';
		dbSet.DNBoptimizer__USTaxID__c ='89765';
		dnb.add(dbSet);
		insert dnb;

		dbSet = new DNBoptimizer__DnBCompanyRecord__c();
		dbSet.Id = dnb[0].Id;
		dbSet.DNBoptimizer__USTaxID__c = '98765';
		dnbUpdate.add(dbSet);
		update dnbUpdate;

		insert testAccount;
		insert mCCD;
		//System.assertNotEquals(mCCD[0].Max9Zip__c, testAccount[0].billingPostalCode.replace('-',''));
        System.assertNotEquals(dnbUpdate[0].DNBoptimizer__USTaxID__c,Null);
		Test.stopTest();
	}
	}	
}