@IsTest
Public Class ProductSelector_Test{
    /*
    Test class for the ProductSelector class
    */

    Public static testMethod void createOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c p = TestUtils.createProgram('Program Name', true);
        ProductSelector ps = new ProductSelector();
        Order o = ps.createOrder(acct.id, app.id, p.id);
        System.assertNotEquals(o, null);
    }
    
    Public static testMethod void addPriceBookEntryToOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c program = TestUtils.createProgram('Program Name', true);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Order o = TestUtils.createOrder(acct.id, app.id, program.id, pricebook.id);  
        
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
        Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
        insert(new Framework__c[]{frameworkEU, frameworkSW});
        List<Product2> products = new Product2[]{productEU, productSW};
        List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id}); 
        
        ProductSelector ps = new ProductSelector();
        OrderItem oi = ps.addPriceBookEntryToOrder(o.id, [select id from pricebookentry where pricebook2id = :pricebook.id limit 1].id);
        System.assertNotEquals(oi, null);
    }
    
    Public static testMethod void addProductToOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c program = TestUtils.createProgram('Program Name', true);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Order o = TestUtils.createOrder(acct.id, app.id, program.id, pricebook.id);
        
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
        Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
        insert(new Framework__c[]{frameworkEU, frameworkSW});
        List<Product2> products = new Product2[]{productEU, productSW};
        List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id}); 
        
        ProductSelector ps = new ProductSelector();
        OrderItem oi = ps.addProductToOrder(o.id, productEU.id, pricebook.id);
        System.assertNotEquals(oi, null);
        OrderItem oi2 = ps.addProductToOrder(o.id, productSW.id, pricebook.id);
        System.assertNotEquals(oi2, null);
    }
    
    Public static testMethod void deleteProductFromOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c program = TestUtils.createProgram('Program Name', true);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Order o = TestUtils.createOrder(acct.id, app.id, program.id, pricebook.id);
        Product2 prod = TestUtils.createProduct(true);
        ProductSelector ps = new ProductSelector();
        Boolean deleted = ps.deleteProductFromOrder(o.id, prod.id);
        System.assertEquals(deleted, true);
    }
    
    Public static testMethod void getAllOrderProducts() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c program = TestUtils.createProgram('Program Name', true);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Order o = TestUtils.createOrder(acct.id, app.id, program.id, pricebook.id);
        
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
        Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
        insert(new Framework__c[]{frameworkEU, frameworkSW});
        List<Product2> products = new Product2[]{productEU, productSW};
        List<PricebookEntry> priceBookEntries = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id}); 
        
        ProductSelector ps = new ProductSelector();
        OrderItem oi = ps.addProductToOrder(o.id, productEU.id, pricebook.id);
        OrderItem oi2 = ps.addProductToOrder(o.id, productSW.id, pricebook.id);

        List<Product2> orderProducts = ps.getAllOrderProducts(o.id);
        System.assertEquals(orderProducts.size() > 0, true);
    }
    
    Public static testMethod void deleteOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c program = TestUtils.createProgram('Program Name', true);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Order o = TestUtils.createOrder(acct.id, app.id, program.id, pricebook.id);
        ProductSelector ps = new ProductSelector();
        Boolean deleted = ps.deleteOrder(o.id);
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
    
    /*Public static testMethod void payForOrder() {
        Account acct = TestUtils.createAccount(true);
        Participation__c app = TestUtils.createApplication(acct.id);
        Program__c p = TestUtils.createProgram('Program Name', true);
        Order o = TestUtils.createOrder(acct.id, app.id, p.id);
        ProductSelector ps = new ProductSelector();
        Boolean paid = payForOrder(o.id);
        System.assertEquals(deleted, true);
    }*/

}