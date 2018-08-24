@IsTest(SeeAllData=false)
Public Class TEST_FormsEngine{

    public static testMethod void  TEST1(){
        //form page layout VFP override
        Form__c form = new Form__c(name='Test Form', Object_API__c='Participation__c');
        insert form;

        ApexPages.StandardController record = new ApexPages.StandardController(form);

        FormController controller = new FormController(record);  
        system.assertNotEquals(controller.supportedObjectsList.size(), 0);      
    }

    public static testMethod void  TEST2(){
        //form-section page layout VFP override
        Form__c form = new Form__c(name='Test Form', Object_API__c='Participation__c');
        insert form;
        Form_Section__c formSection = new Form_Section__c(form__c=form.id);
        insert formSection;

        ApexPages.StandardController record = new ApexPages.StandardController(formSection);

        SectionController controller = new SectionController(record);  
        system.assertNotEquals(controller.supportedObjectsList.size(), 0);      
    }

    public static testMethod void  TEST3(){
        //field page layout VFP override
        Form__c form = new Form__c(name='Test Form', Object_API__c='Participation__c');
        insert form;
        Form_Section__c formSection = new Form_Section__c(form__c=form.id);
        insert formSection;

        Field__c field = new Field__c(section__c = formSection.id, Field_Header__c = 'Field Header');
        insert field;
        ApexPages.StandardController record = new ApexPages.StandardController(field);      

        FieldController controller = new FieldController(record);  

    }

    public static testMethod void  TEST4(){
        //field page layout VFP override - with Section Object_Api_Name__c
        Form__c form = new Form__c(name='Test Form', Object_API__c='Participation__c');
        insert form;
        Form_Section__c formSection = new Form_Section__c(form__c=form.id, object_api_name__c = 'Note');
        insert formSection;

        Field__c field = new Field__c(section__c = formSection.id, Field_Header__c = 'Field Header');
        insert field;
        ApexPages.StandardController record = new ApexPages.StandardController(field);      

        FieldController controller = new FieldController(record);  

    }


    public static testMethod void test5(){
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
    
    Form__c form = new Form__c(name='Test Form', Object_API__c='Participation__c', record_type__c = [select developername from recordtype where sobjecttype = 'Participation__c' limit 1][0].developername);
    insert form;


    System.runAs(u){
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_start_controller controller = new form_start_controller();
        controller.doNothing();
        controller.redirect();
        controller.start();
        system.assertEquals([select id from participation__c where organization__c = :account.id limit 1].size(), 1);
    } 
}

public static testMethod void test6(){
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
    
    Form__c form = new Form__c(name='Test Form', program__c = program.id, Object_API__c='Participation__c', record_type__c = [select developername from recordtype where sobjecttype = 'Participation__c' limit 1][0].developername);
    insert form;


    System.runAs(u){
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_start_controller start = new form_start_controller();
        start.redirect();
        start.start();
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_controller controller = new form_controller();
        //controller redirect should be null because we already have a record for this program
        system.assertEquals(controller.redirect(), null);
    } 
}


public static testMethod void test7(){
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
    
    Form__c form = new Form__c(name='Test Form', program__c = program.id, Object_API__c='Participation__c', record_type__c = [select developername from recordtype where sobjecttype = 'Participation__c' limit 1][0].developername);
    insert form;

    Form_Section__c details = new Form_Section__c(form__c = form.id, Header__c = 'Details');
    Form_Section__c contacts = new Form_Section__c(form__c = form.id, Header__c = 'Contacts', create__c = true, update__c = true, delete__c = true, object_api_name__c = 'Participant_Contact__c');
    insert new Form_Section__c[]{details, contacts};
 
    Field__c[] fields = new Field__c[]{
        new Field__c(section__c = contacts.id, api__c = 'Role__c', validation_Type__c = 'PICKLIST', field_header__c = 'Role'),
        new Field__c(section__c = contacts.id, api__c = 'Language__c', Reference__c = 'Language__c', validation_Type__c = 'PICKLIST', field_header__c = 'Language'),
        new Field__c(section__c = details.id, api__c = 'TermsandConditionsAcknowledgement__c', validation_Type__c = 'BOOLEAN', field_header__c = 'Agree!')
    };
    insert fields;

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_start_controller start = new form_start_controller();
        start.redirect();
        start.start();
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_controller controller = new form_controller();
        //controller redirect should be null because we already have a record for this program
        system.assertEquals(controller.redirect(), null);
    } 
}

public static testMethod void test8(){
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
    
    Form__c form = new Form__c(name='Test Form', program__c = program.id, Object_API__c='Participation__c', record_type__c = [select developername from recordtype where sobjecttype = 'Participation__c' limit 1][0].developername);
    insert form;

    Form_Section__c details = new Form_Section__c(form__c = form.id, Header__c = 'Details');
    Form_Section__c contacts = new Form_Section__c(form__c = form.id, Header__c = 'Contacts', Record_Type__c = 'Toolkit_Application_Contact', create__c = true, update__c = true, delete__c = true, object_api_name__c = 'Participant_Contact__c');
    insert new Form_Section__c[]{details, contacts};
 
    Field__c[] fields = new Field__c[]{
        new Field__c(section__c = contacts.id, api__c = 'Role__c', validation_Type__c = 'PICKLIST', field_header__c = 'Role'),
        new Field__c(section__c = contacts.id, api__c = 'Language__c', Reference__c = 'Language__c', validation_Type__c = 'PICKLIST', field_header__c = 'Language'),
        new Field__c(section__c = details.id, api__c = 'TermsandConditionsAcknowledgement__c', validation_Type__c = 'BOOLEAN', field_header__c = 'Agree!')
    };
    insert fields;

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_start_controller start = new form_start_controller();
        start.redirect();
        start.start();
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_controller controller = new form_controller();

        //edit the first section
        controller.newRecordObjectType = 'Participant_Contact__c';
        controller.AddRecordToSection();
        controller.SaveRecord();
    } 
}


public static testMethod void test9(){
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
    
    Form__c form = new Form__c(name='Test Form', program__c = program.id, Object_API__c='Participation__c', record_type__c = [select developername from recordtype where sobjecttype = 'Participation__c' limit 1][0].developername);
    insert form;

    System.runAs(u){
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_start_controller start = new form_start_controller();
        start.redirect();
        start.start();
        system.assertEquals([select id from participation__c where organization__c = :account.id limit 1].size(), 1);
        ApexPages.currentPage().getParameters().put('id', form.id);
        form_controller controller = new form_controller();
        controller.redirect();
        system.assertNotEquals(controller.getCurrentOrder(), null);
        } 
}

}