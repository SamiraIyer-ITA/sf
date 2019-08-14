@isTest 
public class UpdateApplicationContactEmailsTest 
{
	static testMethod void testBatch() 
	{
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;
		
		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;
		
		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);
		
		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;
		
		List<Asset> listAsset= new List<Asset>();
		for(Integer i=0 ;i <200;i++)
		{
			Asset asset = new Asset();
			asset.Name ='Name'+i;
			listAsset.add(asset);
			asset.Organization_Contact__c = 'i@i.com';
			asset.Organization_Corporate_Officer__c = 'i@i.com';
			asset.Participant__c = myApplication.Id;
			asset.AccountId = myAccount.Id;
		}
		
		insert listAsset;
		
		Test.startTest();
			System.assertEquals('i@i.com',listAsset[1].Organization_Contact__c);
			System.assertEquals('i@i.com',listAsset[1].Organization_Corporate_Officer__c);
			UpdateApplicationContactEmailsBatchable obj = new UpdateApplicationContactEmailsBatchable();
			DataBase.executeBatch(obj);
		Test.stopTest();

		Asset asset2 = [select Name,Organization_Contact__c,Organization_Corporate_Officer__c from Asset where Name =: 'Name1'];
		System.assertEquals('officer@success.com',asset2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',asset2.Organization_Contact__c);
	}
	
	static testMethod void testUpdateAsset() 
	{
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

	static testMethod void testUpdateApplicationContact() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='i@i.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='i@i.com',Participant__c=myApplication.Id);

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
		System.assertEquals('i@i.com',asset.Organization_Corporate_Officer__c);
		System.assertEquals('i@i.com',asset.Organization_Contact__c);
		appContact.Email__c = 'officer@success.com';
		appContact2.Email__c = 'contact@success.com';
		update appContacts;

		Asset asset2 = [select Name,Organization_Contact__c,Organization_Corporate_Officer__c from Asset where Name = 'Name'];
		Test.stopTest();

		System.assertEquals('officer@success.com',asset2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',asset2.Organization_Contact__c);
	}
}