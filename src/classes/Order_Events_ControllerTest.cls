@IsTest
public class Order_Events_ControllerTest {

	static Integer recordsToAdd = 10;
	static Id legacyRecordTypeId = Schema.SObjectType.Order
		.getRecordTypeInfosByDeveloperName().get('Legacy').getRecordTypeId();

	@TestSetup
	static void setup() {
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < recordsToAdd; i++) {
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
					RecordTypeId = legacyRecordTypeId,
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
		// Create payments
		List<Payment__c> payments = new List<Payment__c>();
		for (Order order: orders) {
			payments.add(new Payment__c(Order__c = order.Id, Application__c = 'Privacy Shield'));
		}
		insert payments;
	}



	@IsTest
	static void testUpdateAssets_updateExistingAssets() {
		createAssets();
		Test.startTest();
		updatePaymentStatusAndType([SELECT Id FROM Payment__c]);
		Test.stopTest();
	}

	@IsTest
	static void testUpdateAssets_insertNewAssets() {
		Test.startTest();
		updatePaymentStatusAndType([SELECT Id FROM Payment__c]);
		Test.stopTest();
	}

	@IsTest
	static void testUpdateThirdParties() {
		createAssets();
		List<Third_Party__c> thirdParties = new List<Third_Party__c>();
		Framework__c framework = [SELECT Id FROM Framework__c LIMIT 1][0];
		Third_Party_Master_List__c thirdPartyMasterList = new Third_Party_Master_List__c(Framework__c = framework.Id);
		for (OrderItem orderItem: [SELECT Id FROM OrderItem]) {
			thirdParties.add(
				new Third_Party__c(
					Order_Product__c = orderItem.Id,
					Third_Party_Master_List__c = thirdPartyMasterList.Id,
					Website__c = 'www.test.org'
				)
			);
		}
		insert thirdParties;
		Test.startTest();
		updatePaymentStatusAndType([SELECT Id FROM Payment__c]);
		Test.stopTest();
	}

	static void createAssets() {
		List<Order> orders = [SELECT Id, AccountId FROM Order];
		List<Contact> contacts = [SELECT Id FROM Contact];
		Product2 product = [SELECT Id FROM Product2 LIMIT 1][0];
		List<Asset> assets = new List<Asset>();
		for (Integer l = 0; l < orders.size(); l++) {
			assets.add(
				new Asset(
					Name = 'Test Asset ' + l,
					AccountId = orders[l].AccountId,
					Product2Id = product.Id,
					ContactId = contacts[l].Id
				)
			);
		}
		insert assets;
	}

	static void updatePaymentStatusAndType(List<Payment__c> payments) {
		for (Integer i = 0; i < payments.size(); i++) {
			if (Math.mod(i, 2) == 0) {
				payments[i].Transaction_Status__c = 'Success';
				payments[i].Payment_Type__c = 'PLASTIC_CARD';
			} else {
				payments[i].Transaction_Status__c = 'Received';
				payments[i].Payment_Type__c = 'ACH';
			}
		}
		update payments;
	}
}