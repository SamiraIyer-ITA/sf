@IsTest
public class Test_ShoppingCart{

	public static testMethod void No_Products_Selected1(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			System.assertEquals(controller.RelatedWebResources.size(), 3);
			System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
		}
	}

	public static testMethod void No_Products_Selected2(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			System.assertEquals(controller.RelatedWebResources.size(), 3);
			System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
			controller.Tier1Selected.add(Issue1.Id);
			controller.refreshPage(); //the action done when an option is selected.
			System.assertEquals(controller.Tier2VisibleSelectOptions.size(), 1);
		}
	}

	public static testMethod void No_Products_Selected3(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			System.assertEquals(controller.RelatedWebResources.size(), 3);
			System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
			controller.Tier1Selected.add(Issue1.Id);
			controller.refreshPage();
			System.assertEquals(controller.Tier2VisibleSelectOptions.size(), 1);
			controller.Tier2Selected.add('Advisory and Legal Support Services');
			controller.refreshPage();
			System.assertEquals(controller.Tier3VisibleSelectOptions.keySet().contains('Advisory and Legal Support Services'), true);
		}
	}

	public static testMethod void No_Products_Selected4(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			System.assertEquals(controller.RelatedWebResources.size(), 3);
			System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
			controller.Tier1Selected.add(Issue1.Id);
			controller.refreshPage();
			System.assertEquals(controller.Tier2VisibleSelectOptions.size(), 1);
			controller.Tier2Selected.add('Advisory and Legal Support Services');
			controller.refreshPage();
			System.assertEquals(controller.Tier3VisibleSelectOptions.keySet().contains('Advisory and Legal Support Services'), true);
			controller.Tier3Selected.get('Advisory and Legal Support Services').add('Public Acceptance');
			controller.refreshPage();
			System.assertEquals(new set<String>(controller.Tier3Selected.get('Advisory and Legal Support Services')).contains('Public Acceptance'), true);
		}
	}

	public static testMethod void No_Products_Selected5(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		List<PricebookEntry> priceBookEntryLists = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		upsert priceBookEntryLists;
		System.debug('****************************************************** \nMethod: No_Products_Selected5; \nVariableName: priceBookEntryLists, \nVariableValue: ' + JSON.serializePretty(priceBookEntryLists));

		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			order.Pricebook2Id = controller.PriceBookId;
			update order;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			System.assertEquals(controller.RelatedWebResources.size(), 3);
			System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
			controller.Tier1Selected.add(Issue1.Id);
			controller.refreshPage();
			System.assertEquals(controller.Tier2VisibleSelectOptions.size(), 1);
			controller.Tier2Selected.add('Advisory and Legal Support Services');
			controller.refreshPage();
			System.assertEquals(controller.Tier3VisibleSelectOptions.keySet().contains('Advisory and Legal Support Services'), true);
			controller.Tier3Selected.get('Advisory and Legal Support Services').add('Public Acceptance');
			controller.Tier4Selected.put('Advisory and Legal Support Services - Public Acceptance', new String[]{});
			controller.Tier4Selected.get('Advisory and Legal Support Services - Public Acceptance').add(product1.Id);
			System.assertEquals(controller.ProductSelector.getAllOrderProducts(controller.OrderId).size(), 0); //there should not be any products yet;
			controller.refreshPage();
			controller.addRemoveProducts();
			System.assertEquals(controller.ProductSelector.getAllOrderProducts(controller.OrderId).size(), 1); // should be 1 product now
		}
	}

	public static testMethod void PricebookVersion(){
		//SETUP DATA
		Account account = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Smith', account.Id , true);
		User u = TestUtils.createCommunityUser('smith@sm.ith', contact.Id);
		TestUtils.createPaymentSettings();
		Program__c program = TestUtils.createProgram('Cool-Aid', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product1 = TestUtils.createProduct('Product 1', true);
		//this product has a Class and a Category
		product1.Class__c = 'Advisory and Legal Support Services';
		product1.Category__c = 'Public Acceptance';
		Product2 product2 = TestUtils.createProduct('Product 2', true);
		product2.Class__c = 'Design, Construction, Operation';
		Product2 product3 = TestUtils.createProduct('Product 3', true);
		product3.Class__c = 'Advisory and Legal Support Services';
		List<Product2> products = new Product2[]{product1, product2, product3};
		update products;

		List<PricebookEntry> priceBookEntryLists = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.Id});
		upsert priceBookEntryLists;
		System.debug('****************************************************** \nMethod: No_Products_Selected5; \nVariableName: priceBookEntryLists, \nVariableValue: ' + JSON.serializePretty(priceBookEntryLists));

		Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Web_Resource' LIMIT 1].Id;
		Content__c Issue1 = new Content__c(Name = 'Issue 1', Display_Title__c = 'Issue 1', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue2 = new Content__c(Name = 'Issue 2', Display_Title__c = 'Issue 2', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		Content__c Issue3 = new Content__c(Name = 'Issue 3', Display_Title__c = 'Issue 3', RecordTypeId = recordType, Type__c = 'Environmental Issue');
		insert( new Content__c[]{Issue1, Issue2, Issue3});

		/*Related_Resource__c RR1 = new Related_Resource__c(Primary_Web_Resource__c = Issue1.Id, Product__c = product1.Id);
		Related_Resource__c RR2 = new Related_Resource__c(Primary_Web_Resource__c = Issue2.Id, Product__c = product2.Id);
		Related_Resource__c RR3 = new Related_Resource__c(Primary_Web_Resource__c = Issue3.Id, Product__c = product3.Id);
		insert(new Related_Resource__c[]{RR1, RR2, RR3});*/

		Application app = new Application();
		System.runAs(u){
			Participation__c application = app.createApplication(program.Id);
			Order order = app.createOrder(application.Id, program.Id);
			ProductSelectorComponent controller = new ProductSelectorComponent();
			controller.OrderId = order.Id;
			controller.PriceBookId = pricebook.Id;
			order.Pricebook2Id = controller.PriceBookId;
			update order;
			controller.WebResourceType = 'Environmental Issue';
			System.assertEquals(controller.getInit(), '');
			System.assertEquals(controller.PriceBookEntries.size(), 3);
			//System.assertEquals(controller.RelatedWebResources.size(), 3);
			//System.assertEquals(controller.Tier1VisibleSelectOptions.size(), 3);
			controller.Tier1Selected.add(Issue1.Id);
			controller.refreshPage();
			//System.assertEquals(controller.Tier2VisibleSelectOptions.size(), 1);
			controller.Tier2Selected.add('Advisory and Legal Support Services');
			controller.refreshPage();
			System.assertEquals(controller.Tier3VisibleSelectOptions.keySet().contains('Advisory and Legal Support Services'), true);
			controller.Tier3Selected.get('Advisory and Legal Support Services').add('Public Acceptance');
			controller.Tier4Selected.put('Advisory and Legal Support Services - Public Acceptance', new String[]{});
			controller.Tier4Selected.get('Advisory and Legal Support Services - Public Acceptance').add(product1.Id);
			System.assertEquals(controller.ProductSelector.getAllOrderProducts(controller.OrderId).size(), 0); //there should not be any products yet;
			controller.refreshPage();
			controller.addRemoveProducts();
			System.assertEquals(controller.ProductSelector.getAllOrderProducts(controller.OrderId).size(), 1); // should be 1 product now
		}
	}
}
