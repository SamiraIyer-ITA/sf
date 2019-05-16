@IsTest(seeAllData=false)
public class Test_ShoppingCart{

public static testMethod void No_Products_Selected1(){
 //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Cool-Aid', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 product1 = TestUtils.createProduct('Product 1', true);
        //this product has a Class and a Category
        product1.Class__c = 'Advisory and Legal Support Services';
        product1.Category__c = 'Public Acceptance';
    Product2 product2 = TestUtils.createProduct('Product 2', true);
        product2.Class__c = 'Design, Construction, Operation';
    Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
    
    List<Product2> products = new Product2[]{product1, product2, product3};
    update products;
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
    Id recordType = [select id from recordtype where developername = 'Web_Resource' limit 1].id;

    Content__c Issue1 = new Content__c(name = 'Issue 1', display_title__c = 'Issue 1', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue2 = new Content__c(name = 'Issue 2', display_title__c = 'Issue 2', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue3 = new Content__c(name = 'Issue 3', display_title__c = 'Issue 3', recordtypeid = recordType, type__c = 'Environmental Issue');

    insert( new Content__c[]{Issue1, Issue2, Issue3});

    Related_Resource__c RR1 = new Related_Resource__c(Primary_web_resource__c = Issue1.id, Product__c = product1.id);
    Related_Resource__c RR2 = new Related_Resource__c(Primary_web_resource__c = Issue2.id, Product__c = product2.id);
    Related_Resource__c RR3 = new Related_Resource__c(Primary_web_resource__c = Issue3.id, Product__c = product3.id);

    insert(new Related_Resource__c[]{RR1, RR2, RR3});
    Application app = new Application();

    System.runAs(u){
        Participation__c application = app.createApplication(program.id);
        Order order = app.createOrder(application.id, program.id);
        ProductSelectorComponent controller = new ProductSelectorComponent();
        controller.orderId = order.id;
        controller.pricebookid = pricebook.id;
        controller.webresourcetype = 'Environmental Issue';
        system.assertEquals(controller.getInit(), '');
        system.assertEquals(controller.PBE.size(), 3);
        system.assertEquals(controller.WebResources.size(), 3);
        system.assertEquals(controller.options1.size(), 3);
    } 
}

public static testMethod void No_Products_Selected2(){
 //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Cool-Aid', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 product1 = TestUtils.createProduct('Product 1', true);
        //this product has a Class and a Category
        product1.Class__c = 'Advisory and Legal Support Services';
        product1.Category__c = 'Public Acceptance';
    Product2 product2 = TestUtils.createProduct('Product 2', true);
        product2.Class__c = 'Design, Construction, Operation';
    Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
    
    List<Product2> products = new Product2[]{product1, product2, product3};
    update products;
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
    Id recordType = [select id from recordtype where developername = 'Web_Resource' limit 1].id;

    Content__c Issue1 = new Content__c(name = 'Issue 1', display_title__c = 'Issue 1', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue2 = new Content__c(name = 'Issue 2', display_title__c = 'Issue 2', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue3 = new Content__c(name = 'Issue 3', display_title__c = 'Issue 3', recordtypeid = recordType, type__c = 'Environmental Issue');

    insert( new Content__c[]{Issue1, Issue2, Issue3});

    Related_Resource__c RR1 = new Related_Resource__c(Primary_web_resource__c = Issue1.id, Product__c = product1.id);
    Related_Resource__c RR2 = new Related_Resource__c(Primary_web_resource__c = Issue2.id, Product__c = product2.id);
    Related_Resource__c RR3 = new Related_Resource__c(Primary_web_resource__c = Issue3.id, Product__c = product3.id);

    insert(new Related_Resource__c[]{RR1, RR2, RR3});
    Application app = new Application();

    System.runAs(u){
        Participation__c application = app.createApplication(program.id);
        Order order = app.createOrder(application.id, program.id);
        ProductSelectorComponent controller = new ProductSelectorComponent();
        controller.orderId = order.id;
        controller.pricebookid = pricebook.id;
        controller.webresourcetype = 'Environmental Issue';
        system.assertEquals(controller.getInit(), '');
        system.assertEquals(controller.PBE.size(), 3);
        system.assertEquals(controller.WebResources.size(), 3);
        system.assertEquals(controller.Options1.size(), 3);
    
        controller.cat1.add(Issue1.id);
        controller.doNothing(); //the action done when an option is selected.
        system.assertEquals(controller.options2a.size(), 1);
    } 
}

public static testMethod void No_Products_Selected3(){
 //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Cool-Aid', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 product1 = TestUtils.createProduct('Product 1', true);
        //this product has a Class and a Category
        product1.Class__c = 'Advisory and Legal Support Services';
        product1.Category__c = 'Public Acceptance';
    Product2 product2 = TestUtils.createProduct('Product 2', true);
        product2.Class__c = 'Design, Construction, Operation';
    Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
    
    List<Product2> products = new Product2[]{product1, product2, product3};
    update products;
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
    Id recordType = [select id from recordtype where developername = 'Web_Resource' limit 1].id;

    Content__c Issue1 = new Content__c(name = 'Issue 1', display_title__c = 'Issue 1', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue2 = new Content__c(name = 'Issue 2', display_title__c = 'Issue 2', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue3 = new Content__c(name = 'Issue 3', display_title__c = 'Issue 3', recordtypeid = recordType, type__c = 'Environmental Issue');

    insert( new Content__c[]{Issue1, Issue2, Issue3});

    Related_Resource__c RR1 = new Related_Resource__c(Primary_web_resource__c = Issue1.id, Product__c = product1.id);
    Related_Resource__c RR2 = new Related_Resource__c(Primary_web_resource__c = Issue2.id, Product__c = product2.id);
    Related_Resource__c RR3 = new Related_Resource__c(Primary_web_resource__c = Issue3.id, Product__c = product3.id);

    insert(new Related_Resource__c[]{RR1, RR2, RR3});
    Application app = new Application();

    System.runAs(u){
        Participation__c application = app.createApplication(program.id);
        Order order = app.createOrder(application.id, program.id);
        ProductSelectorComponent controller = new ProductSelectorComponent();
        controller.orderId = order.id;
        controller.pricebookid = pricebook.id;
        controller.webresourcetype = 'Environmental Issue';
        system.assertEquals(controller.getInit(), '');
        system.assertEquals(controller.PBE.size(), 3);
        system.assertEquals(controller.WebResources.size(), 3);
        system.assertEquals(controller.Options1.size(), 3);
    
    controller.cat1.add(Issue1.id);
    controller.doNothing();
    system.assertEquals(controller.Options2A.size(), 1);
    controller.cat2a.add('Advisory and Legal Support Services');
    controller.doNothing();
    system.assertEquals(controller.Options3A1.keySet().contains('Advisory and Legal Support Services'), true);
    } 
}

public static testMethod void No_Products_Selected4(){
 //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Cool-Aid', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 product1 = TestUtils.createProduct('Product 1', true);
        //this product has a Class and a Category
        product1.Class__c = 'Advisory and Legal Support Services';
        product1.Category__c = 'Public Acceptance';
    Product2 product2 = TestUtils.createProduct('Product 2', true);
        product2.Class__c = 'Design, Construction, Operation';
    Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
    
    List<Product2> products = new Product2[]{product1, product2, product3};
    update products;
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
    Id recordType = [select id from recordtype where developername = 'Web_Resource' limit 1].id;

    Content__c Issue1 = new Content__c(name = 'Issue 1', display_title__c = 'Issue 1', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue2 = new Content__c(name = 'Issue 2', display_title__c = 'Issue 2', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue3 = new Content__c(name = 'Issue 3', display_title__c = 'Issue 3', recordtypeid = recordType, type__c = 'Environmental Issue');

    insert( new Content__c[]{Issue1, Issue2, Issue3});

    Related_Resource__c RR1 = new Related_Resource__c(Primary_web_resource__c = Issue1.id, Product__c = product1.id);
    Related_Resource__c RR2 = new Related_Resource__c(Primary_web_resource__c = Issue2.id, Product__c = product2.id);
    Related_Resource__c RR3 = new Related_Resource__c(Primary_web_resource__c = Issue3.id, Product__c = product3.id);

    insert(new Related_Resource__c[]{RR1, RR2, RR3});
    Application app = new Application();

    System.runAs(u){
        Participation__c application = app.createApplication(program.id);
        Order order = app.createOrder(application.id, program.id);
        ProductSelectorComponent controller = new ProductSelectorComponent();
        controller.orderId = order.id;
        controller.pricebookid = pricebook.id;
        controller.webresourcetype = 'Environmental Issue';
        system.assertEquals(controller.getInit(), '');
        system.assertEquals(controller.PBE.size(), 3);
        system.assertEquals(controller.WebResources.size(), 3);
        system.assertEquals(controller.Options1.size(), 3);
    
    controller.cat1.add(Issue1.id);
    controller.doNothing();
    system.assertEquals(controller.Options2A.size(), 1);
    controller.cat2a.add('Advisory and Legal Support Services');
    controller.doNothing();
    system.assertEquals(controller.Options3A1.keySet().contains('Advisory and Legal Support Services'), true);
    controller.cat3a1.get('Advisory and Legal Support Services').add('Public Acceptance');
    controller.doNothing();
    system.assertEquals(new set<string>(controller.cat3a1.get('Advisory and Legal Support Services')).contains('Public Acceptance'), true);
//    system.assertEquals(controller.cat4A1.keySet().size(), 1);
//    system.assertEquals(controller.Options4A1.keySet().contains('Advisory and Legal Support Services - Public Acceptance'), true);
//    system.assertEquals(controller.Options4A1.get('Advisory and Legal Support Services - Public Acceptance').size(), 1);
    } 
}

public static testMethod void No_Products_Selected5(){
 //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Cool-Aid', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 product1 = TestUtils.createProduct('Product 1', true);
        //this product has a Class and a Category
        product1.Class__c = 'Advisory and Legal Support Services';
        product1.Category__c = 'Public Acceptance';
    Product2 product2 = TestUtils.createProduct('Product 2', true);
        product2.Class__c = 'Design, Construction, Operation';
    Product2 product3 = TestUtils.createProduct('Product 3', true);  //no class or category
    
    List<Product2> products = new Product2[]{product1, product2, product3};
    update products;
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});

    upsert PBEs;    
    
    Id recordType = [select id from recordtype where developername = 'Web_Resource' limit 1].id;

    Content__c Issue1 = new Content__c(name = 'Issue 1', display_title__c = 'Issue 1', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue2 = new Content__c(name = 'Issue 2', display_title__c = 'Issue 2', recordtypeid = recordType, type__c = 'Environmental Issue');
    Content__c Issue3 = new Content__c(name = 'Issue 3', display_title__c = 'Issue 3', recordtypeid = recordType, type__c = 'Environmental Issue');

    insert( new Content__c[]{Issue1, Issue2, Issue3});

    Related_Resource__c RR1 = new Related_Resource__c(Primary_web_resource__c = Issue1.id, Product__c = product1.id);
    Related_Resource__c RR2 = new Related_Resource__c(Primary_web_resource__c = Issue2.id, Product__c = product2.id);
    Related_Resource__c RR3 = new Related_Resource__c(Primary_web_resource__c = Issue3.id, Product__c = product3.id);

    insert(new Related_Resource__c[]{RR1, RR2, RR3});
    Application app = new Application();

    System.runAs(u){
        Participation__c application = app.createApplication(program.id);
        Order order = app.createOrder(application.id, program.id);
        ProductSelectorComponent controller = new ProductSelectorComponent();
        controller.orderId = order.id;
        controller.pricebookid = pricebook.id;
        controller.webresourcetype = 'Environmental Issue';
        system.assertEquals(controller.getInit(), '');
        system.assertEquals(controller.PBE.size(), 3);
        system.assertEquals(controller.WebResources.size(), 3);
        system.assertEquals(controller.Options1.size(), 3);
    
    controller.cat1.add(Issue1.id);
    controller.doNothing();
    system.assertEquals(controller.Options2A.size(), 1);
    controller.cat2a.add('Advisory and Legal Support Services');
    controller.doNothing();
    system.assertEquals(controller.Options3A1.keySet().contains('Advisory and Legal Support Services'), true);
    controller.cat3a1.get('Advisory and Legal Support Services').add('Public Acceptance');
    controller.cat4a1.put('Advisory and Legal Support Services - Public Acceptance', new String[]{});    
    controller.cat4a1.get('Advisory and Legal Support Services - Public Acceptance').add(product1.id);
    system.assertEquals(controller.ProductSelector.getAllOrderProducts(controller.orderid).size(), 0); //there should not be any products yet;
    controller.doNothing();
    controller.AddRemoveProducts(); 
    } 
}
}