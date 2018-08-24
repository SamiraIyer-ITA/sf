@isTest(seeAllData = false)
public class TEST_PrivacyShield{

    static testMethod void RedirectToApplication(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        If a User has no Asset, redirect them to the PS_Enhanced Application.
        This happens from /door
    */        
    //SETUP DATA    

    Account account = TestUtils.createAccount(true);
        account.Privacy_Shield_Disabled__c = true;
        update account;
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});    
        
    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        controller.redirectPSEnhanced();
    }
    }
    
    static testMethod void RedirectToError(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        If a User has the Privacy_Shield_Disabled checkbox on their Account checked, redirect them to the Forbidden page.
    */        
    //SETUP DATA    

    Account account = TestUtils.createAccount(true);
        account.Privacy_Shield_Disabled__c = true;
        update account;
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});    
        
    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        controller.RedirectToErrorPage();
    }
    }

    static testMethod void doNothing(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        There is a method called 'DoNothing' which literally does nothing, but is used for some UI validations.
    */        
    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        controller.doNothing();
    }
    }

    static testMethod void FirstTimeLogin_SingleProduct(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        They come to the 'welcome' page initially.
        They have not applied before, so they should not have any existing Application information.
        They select a single product from the list of available items (which has 2 items in it:  EU-US and SW-US)
        They then click the Start button, which takes them from the 'welcome' page to the page 'Step_1'.
        On the back-end, a new Application (Participation__c) and Order should be created with an OrderItem for each selected Product.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        //current step should be welcome
        system.assertEquals(controller.currentStep, 'welcome');
        //new Participation__c should be created for the Account of the User.
        system.assertEquals(controller.participation.id, null);
        //no products should be selected yet.
        system.assertEquals(controller.getSelectedFrameworks().size(), 0);
        system.assertEquals(controller.getAvailableFrameworks().size(), 2);
        //select a product
        controller.selectedFrameworks.add(controller.getAvailableFrameworks()[0].getValue());
        //start the application
        controller.start();
        //there should be an Application started
        system.assertNotEquals(controller.participation.id, null);
        //there should be one order on the application.
        system.assertNotEquals(controller.order.id, null);
        //there should be one item on the order
        system.assertEquals(controller.order.orderItems.size(), 1);
        //there should be one selected program
        system.assertEquals(controller.selectedFrameworks.size(), 1);
        //current step should be step_1    
        system.assertEquals(controller.currentStep, 'Step_1');
    }
    }
    
    static testMethod void FirstTimeLogin_MultipeProducts(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        They come to the 'welcome' page initially.
        They have not applied before, so they should not have any existing Application information.
        They select all products from the list of available items (which has 2 items in it:  EU-US and SW-US)
        They then click the Start button, which takes them from the 'welcome' page to the page 'Step_1'.
        On the back-end, a new Application (Participation__c) and Order should be created with an OrderItem for each selected Product.
        The price for the EU-US product should be 5.00, and the price for the SW-US should be 2.50.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        //current step should be welcome
        system.assertEquals(controller.currentStep, 'welcome');
        //new Participation__c should be created for the Account of the User.
        system.assertEquals(controller.participation.id, null);
        //no products should be selected yet.
        system.assertEquals(controller.selectedFrameworks.size(), 0);
        system.assertEquals(controller.getAvailableFrameworks().size(), 2);
        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //there should be an Application started
        system.assertNotEquals(controller.participation.id, null);
        //there should be one order on the application.
        system.assertNotEquals(controller.order.id, null);
        //there should be two item on the order
        system.assertEquals(controller.order.orderItems.size(), 2);
        //there should be two selected program
        system.assertEquals(controller.selectedFrameworks.size(), 2);
        for(OrderItem oi : controller.order.orderitems){
            if(oi.product2.name.contains('EU')){
                oi.unitPrice = 5;
            }else{
                oi.unitPrice = 2.5;
            }        
        }
        //current step should be step_1    
        system.assertEquals(controller.currentStep, 'Step_1');
    }
    }    
    
    static testMethod void FirstTimeLogin_RemoveProduct(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        After starting the Application, the User decides to remove one of the frameworks from their application.
        The price of the remaining product should be 5.00.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        //current step should be welcome
        system.assertEquals(controller.currentStep, 'welcome');
        //new Participation__c should be created for the Account of the User.
        system.assertEquals(controller.participation.id, null);
        //no products should be selected yet.
        system.assertEquals(controller.selectedFrameworks.size(), 0);
        system.assertEquals(controller.getAvailableFrameworks().size(), 2);
        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        system.assertEquals(controller.currentStep, 'Step_1');
        //The Page sets a parameter for 'back' to point to 'welcome'
        ApexPages.currentPage().getParameters().put('CurrentStep', 'welcome');
        controller.back();
        //The User should be back on the 'welcome' screen.
        system.assertEquals(controller.currentStep, 'welcome');
        system.assertEquals(controller.selectedFrameworks.size(), 2);
        controller.selectedFrameworks = new list<string>();
        controller.selectedFrameworks.add(controller.getAvailableFrameworks()[1].getValue());
        system.assertEquals(controller.selectedFrameworks.size(), 1);
        //Click 'Start' again.
        controller.start();
        //User is back on Step_1
        system.assertEquals(controller.currentStep, 'Step_1');
        //there should only be 1 product on the order now
        system.assertEquals(controller.order.orderItems.size(), 1);
        //and it's price should be 5
        system.assertEquals(controller.order.orderItems[0].unitPrice, 5);
    }
    }    

    static testMethod void FirstTimeLogin_Step1_error(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        A User Completes Step1, but throws an error.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        //current step should be welcome
        system.assertEquals(controller.currentStep, 'welcome');
        //new Participation__c should be created for the Account of the User.
        system.assertEquals(controller.participation.id, null);
        //no products should be selected yet.
        system.assertEquals(controller.selectedFrameworks.size(), 0);
        system.assertEquals(controller.getAvailableFrameworks().size(), 2);
        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 but the system throws an error for the Application.
        controller.participation = null;
        controller.step1();
        //An error should be thrown.
        system.assertEquals(controller.currentStep, 'Step_1');
        system.assertEquals(controller.showErrors, true);
    }
    }    

    static testMethod void FirstTimeLogin_Step1(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        A User Completes Step1 and is then taken to Step_2.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        
        //current step should be welcome
        system.assertEquals(controller.currentStep, 'welcome');
        //new Participation__c should be created for the Account of the User.
        system.assertEquals(controller.participation.id, null);
        //no products should be selected yet.
        system.assertEquals(controller.selectedFrameworks.size(), 0);
        system.assertEquals(controller.getAvailableFrameworks().size(), 2);
        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        //An error should be thrown.
        system.assertEquals(controller.currentStep, 'Step_2');
        system.assertEquals(controller.showErrors, false);
        system.assertEquals(controller.participation.street__c, '110 Binary Way');
    }
    }   
    
    static testMethod void FirstTimeLogin_Step2(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        User initially has 2 contacts created, and the Organization Contact is the currently opened contact.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        system.assertEquals(controller.contacts.size(), 2);
        system.assertEquals(controller.contact.role__c, 'Organization Contact');
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        //There is only 1 of the required contact types, so this should not be able to proceed.
        system.assertEquals(controller.getHasContacts(), false);
    }
    }   

    static testMethod void FirstTimeLogin_Step2_SecondContact(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        User initially has 2 contacts created, and the Organization Contact is the currently opened contact.
        Create a second contact.
        Confirm that the page is ready to move forward because it has both expected contact types.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        system.assertEquals(controller.contacts.size(), 3);
        system.assertEquals(controller.getHasContacts(), true);
    }
    }   
    
    static testMethod void FirstTimeLogin_Step2_CancelEditContact(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Test the Cancel method for Contacts.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        system.assertEquals(controller.contacts.size(), 3);
        system.assertEquals(controller.getHasContacts(), true);
        ApexPages.currentPage().getParameters().put('contactId', controller.contacts[1].id);
        controller.getContactFromList();
        system.assertEquals(controller.contact.id, controller.contacts[1].id);
        controller.hideContactEdit();
        system.assertEquals(controller.contact, null);
    }
    }   

    static testMethod void FirstTimeLogin_Step2_DeleteContact(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Test deleting a contact.
            The Contacts list should have 2 items.
            The page should not have the required contacts to move forward.
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        ApexPages.currentPage().getParameters().put('contactId', controller.contacts[1].id);
        controller.getContactFromList();
        system.assertEquals(controller.contact.id, controller.contacts[1].id);
        controller.deleteContact();
        system.assertEquals(controller.contact.id, null);
        system.assertEquals(controller.contacts.size(), 2);
        system.assertEquals(controller.getHasContacts(), false);    
    }
    }   

    static testMethod void FirstTimeLogin_Step3_Save(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Test Saving_Level_of_Sales on the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        system.assertNotEquals(controller.showErrors, true);
    }
    }   

    static testMethod void FirstTimeLogin_Step3_NewIndustry(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        User adds an Industry to their Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        controller.ShowIndustryEdit();
        controller.industry.Industry__c = 'Education';
        controller.industry.Sector__c = 'Adult Education';
        controller.industry.Sub_Sector__c = 'Executive Education';
        controller.saveIndustry();
        system.assertEquals(controller.getIndustries().size(), 1);    
        }
    }

    static testMethod void FirstTimeLogin_Step4(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        controller.addEntity();
        controller.entity.name = 'My Covered Entity';
        controller.saveEntity();
        system.assertEquals(controller.entities.size(), 1);
    }
    }   

    static testMethod void FirstTimeLogin_Step4_DeleteEntity(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        controller.addEntity();
        controller.entity.name = 'My Covered Entity';
        controller.saveEntity();
        ApexPages.currentPage().getParameters().put('entityId', controller.entities[0].id);
        controller.deleteEntity();
        system.assertNotEquals(controller.showErrors, true);
        system.assertEquals(controller.entities.size(), 0);
    }
    }   

    static testMethod void FirstTimeLogin_Step5(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Validate that the expected data is available
        system.assertEquals(controller.getAvailable_DRPs().size(), 3);
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        system.assertEquals(controller.getResolutionProviders().size(), 1);
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        system.assertEquals(controller.currentStep, 'Step_5A');
        //assert that the current status is 55%
        system.assertEquals(controller.getProgress(), '55');
    }
    }   

    static testMethod void FirstTimeLogin_Step5A(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Validate that the expected data is available
        system.assertEquals(controller.getAvailable_DRPs().size(), 3);
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        system.assertEquals(controller.currentStep, 'Step_6');
        //assert that the current status is now 60%
        system.assertEquals(controller.getProgress(), '60');
    }
    }

    static testMethod void FirstTimeLogin_Step6(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        //validate the expected setup data
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 1);
        //Select a Statutory Body
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].Id);
        controller.setStatutoryBody();
        system.assertEquals(controller.getStatutoryBodyId(), controller.getStatutoryBodyId());
        
        //select 'Outside Compliance Review' for the verification method, and then select a Verification Provider.
        controller.participation.Claiming_Self_Verified__c = 'Outside Compliance Review';
        controller.save();
        
        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierNAme', controller.getAvailable_Verifiers()[0].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[1].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierName', controller.getAvailable_Verifiers()[1].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('entity', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        controller.step6();
        system.assertEquals(controller.currentStep, 'Step_7');
    }
    }

    static testMethod void FirstTimeLogin_JumpAround(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        //validate the expected setup data
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 1);
        //Select a Statutory Body
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].Id);
        controller.setStatutoryBody();
        system.assertEquals(controller.getStatutoryBodyId(), controller.getStatutoryBodyId());
        
        //select 'Outside Compliance Review' for the verification method, and then select a Verification Provider.
        controller.participation.Claiming_Self_Verified__c = 'Outside Compliance Review';
        controller.save();
        
        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierNAme', controller.getAvailable_Verifiers()[0].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[1].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierName', controller.getAvailable_Verifiers()[1].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('entity', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        controller.step6();
        system.assertEquals(controller.currentStep, 'Step_7');
        controller.jumpTo('Step_5');
        system.assertEquals(controller.currentStep, 'Step_5');
        controller.jumpTo('Step_7');
    }
    }

    static testMethod void FirstTimeLogin_Step7(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        //validate the expected setup data
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 1);
        //Select a Statutory Body
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].Id);
        controller.setStatutoryBody();
        system.assertEquals(controller.getStatutoryBodyId(), controller.getStatutoryBodyId());
        
        //select 'Outside Compliance Review' for the verification method, and then select a Verification Provider.
        controller.participation.Claiming_Self_Verified__c = 'Outside Compliance Review';
        controller.save();
        
        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierNAme', controller.getAvailable_Verifiers()[0].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[1].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierName', controller.getAvailable_Verifiers()[1].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('entity', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        controller.step6();
        Artifact__c art = new Artifact__c(Participation_Profile__c = controller.participation.id, name='Artifact', type__c = 'HR and Non-HR', effective_date__c = Date.today(), External_Artifact_URL__c='http://google.com', isCurrent__c = true);
        insert art;
        controller.step7();
        system.assertEquals(controller.currentStep, 'Step_8');
    }
    }

    static testMethod void FirstTimeLogin_Step8(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record
    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        //validate the expected setup data
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 1);
        //Select a Statutory Body
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].Id);
        controller.setStatutoryBody();
        system.assertEquals(controller.getStatutoryBodyId(), controller.getStatutoryBodyId());
        
        //select 'Outside Compliance Review' for the verification method, and then select a Verification Provider.
        controller.participation.Claiming_Self_Verified__c = 'Outside Compliance Review';
        controller.save();
        
        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierNAme', controller.getAvailable_Verifiers()[0].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[1].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierName', controller.getAvailable_Verifiers()[1].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('entity', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        controller.step6();
        Artifact__c art = new Artifact__c(Participation_Profile__c = controller.participation.id, name='Artifact', type__c = 'HR and Non-HR', effective_date__c = Date.today(), External_Artifact_URL__c='http://google.com', isCurrent__c = true);
        insert art;
        controller.step7();
        system.assertEquals(controller.currentStep, 'Step_8');
        //controller.order = [select id, status,  Participant__r.Primary_Contacts__c from order where id = :controller.order.id limit 1];
        //system.assertEquals(controller.order.participant__r.primary_contacts__c, 1);
        controller.order.status = 'Paid';
        update controller.order;
        
        Case c = new Case(contactID = contact.id,
        subject='PrivacyShield Application',
        status = 'New',
        Order__c = controller.order.id,
        Participation_Profile__c = controller.participation.id);
        insert c;
        
        c.status = 'Successfully Closed';
        update c;
    }
    }

    static testMethod void FirstTimeLogin_Step8_Payment(){
    //IMPORTANT:  This test is run as a Community User
    /*
        TEST STORY:
        A Community User has decided to apply for PrivacyShield using the PS_Enhanced page.
        Add a Covered Entity to the Application
    */

    //SETUP DATA    
    Account account = TestUtils.createAccount(true);
    Contact contact = TestUtils.createContact('Smith', account.id , true);
    User u = TestUtils.createCommunityUser('smith@sm.ith', contact.id);

    List<PaymentSettings__c> PaymentSettings = TestUtils.createPaymentSettings();
    
    Program__c program = TestUtils.createProgram('Privacy Shield', true);
    
    Pricebook2 pricebook = TestUtils.createPricebook(program.id);
    
    Product2 productEU = TestUtils.createProduct('EU-US', true);
    Product2 productSW = TestUtils.createProduct('SW-US', true);

    Framework__c frameworkEU = new Framework__c(name = 'EU-US', product__c = productEU.id, program__c = program.id, isActive__c = true);
    Framework__c frameworkSW = new Framework__c(name = 'SW-US', product__c = productSW.id, program__c = program.id, isActive__c = true);
    insert(new Framework__c[]{frameworkEU, frameworkSW});    
    
    TestUtils.createTPMLs(new List<id>{frameworkEU.id, frameworkSW.id});
    
    List<Product2> products = new Product2[]{productEU, productSW};
    List<PricebookEntry> PBEs = TestUtils.createPricebookEntries(products, new Id[]{Test.getStandardPricebookId(), pricebook.id});
    
//Contact does not have an existing Participant__c record
    System.runAs(u){
        ApexPages.currentPage().getParameters().put('program', program.id);
        ps_enhanced_controller controller = new ps_enhanced_controller();        

        //select all products
        for(SelectOption so : controller.getAvailableFrameworks()){
            controller.selectedFrameworks.add(so.getValue());
        }
        //start the application
        controller.start();
        //User attempts to complete Step_1 for the Application.
        controller.participation.street__c = '110 Binary Way'; //update 1 field.
        controller.step1();
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.saveContact();
        
        //create the second contact
        controller.createContact();
        controller.contact.first_name__c ='John';
        controller.contact.last_name__c='Smith';
        controller.contact.email__c='js@no.mail';
        controller.contact.title__c ='Title';
        controller.contact.phone__c = '5555555555';
        controller.contact.role__c = 'Organization Corporate Officer';
        controller.saveContact();
        if(controller.getHasContacts()){
            ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_3');
            controller.back();
        }
        system.assertEquals(controller.currentStep, 'Step_3');
        controller.participation.Level_of_Sales__c = '$0 to $5 million';
        controller.save();
        //the Visualforce page calls the save method twice as the 2 fields are entered.
        controller.participation.Number_of_Employees__c = 'Fewer than 100';
        controller.save();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_4');
        controller.back();
        ApexPages.currentPage().getParameters().put('CurrentStep', 'Step_5');
        controller.back();
        //Set the HR and NonHR fields
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.participation.Purpose__c = 'Some Reason';
        controller.step5();
        //do the exact same steps for 5A (Swiss-US) that you did for EU
        controller.currentItem.Non_HR_Data__c = true;
        controller.currentItem.HR_Data__c = true;
        controller.currentItem.Confirm_HR_Compliance__c = true;
        controller.updateOrderItem();
        ApexPages.currentPage().getParameters().put('SelectedDRP', controller.getAvailable_DRPs()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedDRPName', controller.getAvailable_DRPs()[0].name);
        controller.useSelectedDRP();
        controller.step5();
        //validate the expected setup data
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 1);
        //Select a Statutory Body
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].Id);
        controller.setStatutoryBody();
        system.assertEquals(controller.getStatutoryBodyId(), controller.getStatutoryBodyId());
        
        //select 'Outside Compliance Review' for the verification method, and then select a Verification Provider.
        controller.participation.Claiming_Self_Verified__c = 'Outside Compliance Review';
        controller.save();
        
        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[0].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierNAme', controller.getAvailable_Verifiers()[0].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('SelectedVerifier', controller.getAvailable_Verifiers()[1].id);
        ApexPages.currentPage().getParameters().put('SelectedVerifierName', controller.getAvailable_Verifiers()[1].name);
        controller.useSelectedVerifier();

        ApexPages.currentPage().getParameters().put('entity', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        controller.step6();
        Artifact__c art = new Artifact__c(Participation_Profile__c = controller.participation.id, name='Artifact', type__c = 'HR and Non-HR', effective_date__c = Date.today(), External_Artifact_URL__c='http://google.com', isCurrent__c = true);
        insert art;
        controller.step7();
        system.assertEquals(controller.currentStep, 'Step_8');
        //@@TODO:  Talk with Cary about this...
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSOnlineMockImpl());
        Test.startTest();
        controller.privacyShieldPayment();
        Test.stopTest();
    }
    }    
}