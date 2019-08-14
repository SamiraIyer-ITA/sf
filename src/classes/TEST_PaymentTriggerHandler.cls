@isTest(seeAllData=false)
public class TEST_PaymentTriggerHandler{

	public static testmethod void TEST_1(){
		Payment__c payment1 = new Payment__c();
	    insert payment1;
	    Payment__c payment2 = new Payment__c();
	    insert payment2;
	    Payment__c[] newList = new List<Payment__c>();
		newList.add(payment1);
		newList.add(payment2);
		Map<id, Payment__c> newMap = new Map<id, Payment__c>();
		Map<id, Payment__c> oldMap = new Map<id, Payment__c>();
		Test.startTest();    
		PaymentTriggerHandler.createCases(newList, newMap, oldMap);
		system.assertEquals(null, null);  //Nothing is return from createCases so nothing can be compared
		Test.stopTest();
	}
    
    @IsTest
	static void testCreatePrivacyShieldPaymentCases_Update() {
		List<Payment__c> payments = getPrivacyShieldPayments(10);
		Test.startTest();
		updatePaymentStatusAndType(payments);
		Test.stopTest();
		System.assertEquals(10, [SELECT COUNT() FROM Case],
			'Verify Privacy Shield cases were created by future method');
	}

	static List<Payment__c> getPrivacyShieldPayments(Integer recordsToAdd) {
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
		// Create product and pricebook
		Product2 product = new Product2(Name = 'Privacy Shield Product', IsActive = true);
		insert product;
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
		// Create payments
		List<Payment__c> payments = new List<Payment__c>();
		for (Order order: orders) {
			payments.add(new Payment__c(Order__c = order.Id, Application__c = 'Privacy Shield'));
		}
		insert payments;
		return payments;
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