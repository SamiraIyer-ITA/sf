/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: AssetsTest.cls
	Purpose: Test class for IAssets and Assets.
 */
@IsTest
private class AssetsTest {

	@IsTest
	static void testNewInstanceOfAssetsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Asset> assetList  = new List<Asset>();
		assetList.add(new Asset());
		IAssets iAsset = (IAssets) Assets.newInstance(assetList);
		System.assertNotEquals(iAsset, null, 'Interface returned as null and should not have');
	}

	@isTest
	static void testUpdateContactAndOfficer() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Asset asset = new Asset();
		asset.Name ='Name';
		asset.Organization_Contact__c = 'i@i.com';
		asset.Organization_Corporate_Officer__c = 'i@i.com';
		asset.Participant__c = myApplication.Id;
		asset.AccountId = myAccount.Id;
		insert asset;

		Test.startTest();
		System.assertEquals('i@i.com',asset.Organization_Contact__c);
		System.assertEquals('i@i.com',asset.Organization_Corporate_Officer__c);
		update asset;

		Asset asset2 = [select Name,Organization_Contact__c,Organization_Corporate_Officer__c from Asset where Name = 'Name'];
		Test.stopTest();

		System.assertEquals('officer@success.com',asset2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',asset2.Organization_Contact__c);
	}

	@IsTest
	static void testAssetsTrigger_InsertAssetRecord_TriggerIsCovered() {
		try { insert new Asset(); } catch (Exception e) {}
	}

}