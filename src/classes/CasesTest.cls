/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: CasesTest.cls
	Purpose: Test class for ICases and Cases.
 */
@IsTest
private class CasesTest {

	@IsTest
	static void testNewInstanceOfCasesDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Case> caseList  = new List<Case>();
		caseList.add(new Case());
		ICases iCase = (ICases) Cases.newInstance(caseList);
		System.assertNotEquals(iCase, null, 'Interface returned as null and should not have');
	}

	@isTest
	static void testUpdateContactAndOfficer_Insert() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case();
		//myCase.Name ='Name';
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		myCase.Participation_Profile__c = myApplication.Id;
		myCase.AccountId = myAccount.Id;
		//try insert
		insert myCase;

		Test.startTest();
		//test successful insert trigger
		Case myCase2 = [select Organization_Contact__c,Organization_Corporate_Officer__c from Case where Id =: myCase.Id];
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}

	@isTest
	static void testUpdateContactAndOfficer_Update() {
		Account myAccount = new Account(Name='MyAccount');
		insert myAccount;

		Participation__c myApplication = new Participation__c(Name='test',Postal_Code__c='22222');
		insert myApplication;

		Participant_Contact__c appContact = new Participant_Contact__c(Role__c='Organization Corporate Officer',Email__c='officer@success.com',Participant__c=myApplication.Id);
		Participant_Contact__c appContact2 = new Participant_Contact__c(Role__c='Organization Contact',Email__c='contact@success.com',Participant__c=myApplication.Id);

		List<Participant_Contact__c> appContacts = new List<Participant_Contact__c>{appContact,appContact2};
		insert appContacts;

		Case myCase = new Case();
		//myCase.Name ='Name';
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		myCase.Participation_Profile__c = myApplication.Id;
		myCase.AccountId = myAccount.Id;
		//try insert
		insert myCase;

		Test.startTest();
		myCase.Organization_Contact__c = 'i@i.com';
		myCase.Organization_Corporate_Officer__c = 'i@i.com';
		//try update
		update myCase;

		Case myCase2 = [select Organization_Contact__c,Organization_Corporate_Officer__c from Case where Id =: myCase.Id];

		//test successful update trigger
		System.assertEquals('officer@success.com',myCase2.Organization_Corporate_Officer__c);
		System.assertEquals('contact@success.com',myCase2.Organization_Contact__c);
		Test.stopTest();
	}
    
    @IsTest
    static void testUpdateAssests_Update_SuccessfullyClosed() {
        Test.startTest();
        updateAssetCasesByStatus('Successfully Closed');
        Test.stopTest();
    }
    
    @IsTest
    static void testUpdateAssests_Update_AdministrativelyClosed() {
        Test.startTest();
        updateAssetCasesByStatus('Administratively Closed');
        Test.stopTest();
    }
    
    @IsTest
    static void testUpdateAssests_Update_Denied() {
        Test.startTest();
        updateAssetCasesByStatus('Denied');
        Test.stopTest();
    }
    
    static void updateAssetCasesByStatus(String status) {
        List<Case> cases = getUpdateAssetCases(10);
        for (Case c: cases) {
            c.Status = status;
        }
		update cases;     
    }
    
    static List<Case> getUpdateAssetCases(Integer casesToAdd) {
        List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < casesToAdd; i++) {
			Account acct = new Account(Name = 'TestAccount' + i, Website = 'www.test' + i + '.com');
			accounts.add(acct);
		}
		insert accounts;
		// Create related contacts
		List<Contact> contacts = new List<Contact>();
		for (Integer j = 0; j < accounts.size(); j++) {
			Contact con = new Contact(
				FirstName = 'Test ' + j,
				LastName = 'Test ' + j,
				AccountId = accounts[j].Id,
				Email = 'test' + j + '@test.org.com'
			);
			contacts.add(con);
		}
		insert contacts;
		// Create applications
		List<Participation__c> applications = new List<Participation__c>();
		for (Account account: accounts) {
			applications.add(
				new Participation__c(
					Organization__c = account.Id,
					Postal_Code__c = '55555'
				)
			);
		}
		insert applications;
		List<Participant_Contact__c> applicationContacts = new List<Participant_Contact__c>();
		for (Integer k = 0; k < applications.size(); k++) {
			applicationContacts.add(
				new Participant_Contact__c(
					Participant__c = applications[k].Id,
					Role__c = 'Primary Contact',
					Contact__c = contacts[k].Id
				)
			);
		}
		insert applicationContacts;
		// Create product, framework, and pricebook
		Product2 product = new Product2(Name = 'Privacy Shield Product', IsActive = true);
		insert product;
		Program__c program = new Program__c(isActive__c = true);
		insert program;
		Framework__c framework = new Framework__c(Product__c = product.Id, Program__c = program.Id, isActive__c = true);
		insert framework;
		Id pricebookId = Test.getStandardPricebookId();
		PricebookEntry standardPricebookEntry = new PricebookEntry(
			Pricebook2Id = pricebookId,
			Product2Id = product.Id,
			UnitPrice = 1000,
			IsActive = true
		);
		insert standardPricebookEntry;
		Pricebook2 pricebook = TestUtils.createPricebook('Privacy Shield', true, true);
		PricebookEntry pricebookEntry = new PricebookEntry(
			IsActive = true,
			UnitPrice = 1000,
			Pricebook2Id = pricebook.Id,
			Product2Id = product.Id
		);
		insert pricebookEntry;
		// Create orders
		List<Order> orders = new List<Order>();
		for (Participation__c application: applications) {
			orders.add(
				new Order(
					Participant__c = application.Id,
					AccountId = application.Organization__c,
					Status = 'In Progress',
					Description = 'Privacy Shield',
					EffectiveDate = Date.today(),
					Pricebook2Id = pricebook.Id
				)
			);
		}
		insert orders;
		// Create order items
		List<OrderItem> orderItems = new List<OrderItem>();
		for (Order order: orders) {
			orderItems.add(
				new OrderItem(
					OrderId = order.Id,
					Quantity = 1,
					PricebookEntryId = pricebookEntry.Id,
					UnitPrice = pricebookEntry.UnitPrice
				)
			);
		}
		insert orderItems;
        List<Asset> assets = new List<Asset>();
        List<Case> cases = new List<Case>();
		for (Integer l = 0; l < orders.size(); l++) {
			assets.add(
				new Asset(
					Name = 'Test Asset ' + l,
					AccountId = orders[l].AccountId,
					Product2Id = product.Id,
					ContactId = contacts[l].Id
				)
			);
            cases.add(
                new Case(
                    AccountId = orders[l].AccountId,
                    ContactId = contacts[l].Id,
                    Order__c = orders[l].Id
                )
            );
		}
		insert assets;
        insert cases;
        return cases;
    }

	@IsTest
	static void testCasesTrigger_InsertCaseRecord_TriggerIsCovered() {
		try { insert new Case(); } catch (Exception e) {}
	}

}