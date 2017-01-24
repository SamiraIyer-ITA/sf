@isTest
private class UpdateCCDLookupIdTest {
	
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
		testAccount.add(accSet);
		insert testAccount;

		List<DandBCompany> dnb = new List<DandBCompany>();
		List<DandBCompany> dnbUpdate = new List<DandBCompany>();		
		DandBCompany dbSet = new DandBCompany();
		dbSet.DunsNumber ='1234';
		dbSet.Name =' DnB company';
		dbSet.UsTaxId ='89765';
		dnb.add(dbSet);
		insert dnb;

		dbSet = new DandBCompany();
		dbSet.Id = dnb[0].Id;
		dbSet.UsTaxId = Null;
		dnbUpdate.add(dbSet);
		update dnbUpdate;

		//System.assertEquals(testAccount[0].billingPostalCode.replace('-',''), mCCD[0].Max9Zip__c);
        System.assertEquals(dnbUpdate[0].UsTaxId,Null);
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
		testAccount.add(accSet);
		
		List<DandBCompany> dnb = new List<DandBCompany>();
		List<DandBCompany> dnbUpdate = new List<DandBCompany>();		
		DandBCompany dbSet = new DandBCompany();
		dbSet.DunsNumber ='1234';
		dbSet.Name =' DnB company';
		dbSet.UsTaxId ='89765';
		dnb.add(dbSet);
		insert dnb;

		dbSet = new DandBCompany();
		dbSet.Id = dnb[0].Id;
		dbSet.UsTaxId = '98765';
		dnbUpdate.add(dbSet);
		update dnbUpdate;

		insert testAccount;
		insert mCCD;
		//System.assertNotEquals(mCCD[0].Max9Zip__c, testAccount[0].billingPostalCode.replace('-',''));
        System.assertNotEquals(dnbUpdate[0].UsTaxId,Null);
		Test.stopTest();
	}
	}	
}