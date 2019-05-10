@IsTest
public class ProductSelector_Test{

	/*
	Test class for the ProductSelector class
	*/

	public static testMethod void createOrder() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c p = TestUtils.createProgram('Program Name', true);
		ProductSelector ps = new ProductSelector();
		Order o = ps.createOrder(acct.Id, app.Id, p.Id);
		System.assertNotEquals(o, null);
	}

	public static testMethod void addPriceBookEntryToOrder() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c program = TestUtils.createProgram('Program Name', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Order o = TestUtils.createOrder(acct.Id, app.Id, program.Id, pricebook.Id);

		Product2 productEU = TestUtils.createProduct('EU-US', true);
		Product2 productSW = TestUtils.createProduct('SW-US', true);
		Framework__c frameworkEU = new Framework__c(Name = 'EU-US', Product__c = productEU.Id, Program__c = program.Id, isActive__c = true);
		Framework__c frameworkSW = new Framework__c(Name = 'SW-US', Product__c = productSW.Id, Program__c = program.Id, isActive__c = true);
		insert(new Framework__c[]{frameworkEU, frameworkSW});
		List<Product2> products = new Product2[]{productEU, productSW};
		List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});

		ProductSelector ps = new ProductSelector();
		OrderItem oi = ps.addPriceBookEntryToOrder(o.Id, [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :pricebook.Id LIMIT 1].Id);
		System.assertNotEquals(oi, null);
	}

	public static testMethod void addProductToOrder() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c program = TestUtils.createProgram('Program Name', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Order o = TestUtils.createOrder(acct.Id, app.Id, program.Id, pricebook.Id);

		Product2 productEU = TestUtils.createProduct('EU-US', true);
		Product2 productSW = TestUtils.createProduct('SW-US', true);
		Framework__c frameworkEU = new Framework__c(Name = 'EU-US', Product__c = productEU.Id, Program__c = program.Id, isActive__c = true);
		Framework__c frameworkSW = new Framework__c(Name = 'SW-US', Product__c = productSW.Id, Program__c = program.Id, isActive__c = true);
		insert(new Framework__c[]{frameworkEU, frameworkSW});
		List<Product2> products = new Product2[]{productEU, productSW};
		List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});

		ProductSelector ps = new ProductSelector();
		OrderItem oi = ps.addProductToOrder(o.Id, productEU.Id, pricebook.Id);
		System.assertNotEquals(oi, null);
		OrderItem oi2 = ps.addProductToOrder(o.Id, productSW.Id, pricebook.Id);
		System.assertNotEquals(oi2, null);
	}

	public static testMethod void deleteProductFromOrder() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c program = TestUtils.createProgram('Program Name', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Order o = TestUtils.createOrder(acct.Id, app.Id, program.Id, pricebook.Id);
		Product2 prod = TestUtils.createProduct(true);
		ProductSelector ps = new ProductSelector();
		Boolean deleted = ps.deleteProductFromOrder(o.Id, prod.Id);
		System.assertEquals(deleted, true);
	}

	public static testMethod void getAllOrderProducts() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c program = TestUtils.createProgram('Program Name', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Order o = TestUtils.createOrder(acct.Id, app.Id, program.Id, pricebook.Id);

		Product2 productEU = TestUtils.createProduct('EU-US', true);
		Product2 productSW = TestUtils.createProduct('SW-US', true);
		Framework__c frameworkEU = new Framework__c(Name = 'EU-US', Product__c = productEU.Id, Program__c = program.Id, isActive__c = true);
		Framework__c frameworkSW = new Framework__c(Name = 'SW-US', Product__c = productSW.Id, Program__c = program.Id, isActive__c = true);
		insert(new Framework__c[]{frameworkEU, frameworkSW});
		List<Product2> products = new Product2[]{productEU, productSW};
		List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});

		ProductSelector ps = new ProductSelector();
		OrderItem oi = ps.addProductToOrder(o.Id, productEU.Id, pricebook.Id);
		OrderItem oi2 = ps.addProductToOrder(o.Id, productSW.Id, pricebook.Id);

		List<Product2> orderProducts = ps.getAllOrderProducts(o.Id);
		System.assertEquals(orderProducts.size() > 0, true);
	}

	public static testMethod void deleteOrder() {
		Account acct = TestUtils.createAccount(true);
		Participation__c app = TestUtils.createApplication(acct.Id);
		Program__c program = TestUtils.createProgram('Program Name', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Order o = TestUtils.createOrder(acct.Id, app.Id, program.Id, pricebook.Id);
		ProductSelector ps = new ProductSelector();
		Boolean deleted = ps.deleteOrder(o.Id);
		System.assertEquals(deleted, true);
	}

	public static testMethod void coverExceptions() {
		ProductSelector ps = new ProductSelector();
		Account acct = TestUtils.createAccount(true);

		Id fakeId = Test.getStandardPricebookId();  //Any valid ID can be used
		Order o = ps.createOrder(fakeId, fakeId, fakeId);
		System.assertEquals(o, null);
		OrderItem oi = ps.addPriceBookEntryToOrder(fakeId, fakeId);
		System.assertEquals(oi, null);
		oi = ps.addProductToOrder(fakeId, fakeId, fakeId);
		System.assertEquals(oi, null);
		List<Product2> products = ps.getAllOrderProducts(fakeId);
		System.assertEquals(products.size(), 0);
	}

}