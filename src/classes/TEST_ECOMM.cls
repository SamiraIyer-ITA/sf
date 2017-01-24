@isTest(seeAllData=false)
public class TEST_ECOMM{

public static testmethod void TEST_1(){
//Test the process through beginning through step 8 with the "happy path"
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    contact c = new Contact();
        c.firstname = 'John';
        c.lastname = 'Smith';
        c.email = 'John.Smith@no.mail';
        c.accountid = acc.id;
        insert c;
    Profile p = [select id from profile where name = 'Customer Trade Community User'];
    User u = new User( email=c.email,
        UserName=c.email, 
        Alias = c.firstname,
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='ISO-8859-1',
        LocaleSidKey='en_US', 
        LanguageLocaleKey='en_US',
        ContactId = c.id,
        LastName = c.lastname,
        ProfileId = p.id,
        CommunityNickname = c.firstname+c.lastname);
        insert u;
    Program__c prog = new program__c();
        prog.name = 'Test Program';
        prog.isActive__c = true;
        insert prog;
    Framework__c f = new Framework__c();
        f.program__c = prog.id;
        f.name = 'Test Framework';
        f.isActive__c = true;
        insert f;
    PaymentSettings__c[] settings = new PaymentSettings__c[]{
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP', value__c = 'ps'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP', value__c = 'es')
    };
    insert settings; 
    insert new CertificationPricePoints__c(name='value tbd', price__c=600.00);
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site', nonhr_data__c = true),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site', nonhr_data__c = true),
        new Third_Party_Master_List__c(name = 'Verifier 1', type__c = 'Verification Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'Verifier 2', type__c = 'Verification Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'Statutory 1', type__c = 'U.S. Statutory Body', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'Statutory 2', type__c = 'U.S. Statutory Body', website__c = 'http://my.site')
    };
    insert TPML;
    PageReference pageRef = Page.ps;
    Test.setCurrentPage(pageRef);
    System.runAs(u){
        ApexPages.currentPage().getParameters().put('framework', f.id);
        ps_controller controller = new ps_controller();
        //test the doNothing method
        controller.doNothing();
        pageReference started = controller.start();
        participation__c[] participations = [select id from participation__c where organization__c = :acc.id];
        system.assertEquals(participations.size(), 1); //assert that there is only the one participation__c record;
        system.assertEquals(controller.participant.id, participations[0].id); //assert that the 'participant' variable is set to the participation record created.
    
        //now on step 2 of 9
        //"Organization Contacts"
        system.assertEquals([select id from participant_contact__c].size(), 2);
        controller.createContact();
            controller.contact.first_name__c = 'John';
            controller.contact.last_name__c = 'Smith';
            controller.contact.email__c = 'john.smith@no.mail';
            controller.contact.phone__c = '8888888888';
            controller.contact.title__c = 'CEO';
            controller.contact.role__c = 'Organization Corporate Officer';
            controller.contact.contact__c = c.id;
        controller.saveContact();
        //page rerenders the contact list
        
        system.assertEquals(controller.contacts.size(), 3);
        ApexPages.currentPage().getParameters().put('contactId', controller.contacts[0].id);
        controller.getContactFromList();
        system.assertEquals(controller.getHasContacts(), true);
        //now on step 3 of 9
        //"Company Demographics"
        //add industry information
        controller.industry.industry__c = 'Energy';
        controller.industry.sector__c = 'Coal';
        controller.industry.sub_sector__c = 'Clean Coal Technology';
        controller.industry.participant__c = controller.participant.id;
        controller.saveIndustry();
        system.assertEquals(controller.getIndustries().size(), 1);
    
        //add industry information
        controller.industry.industry__c = 'Agribusiness';
        controller.industry.sector__c = 'Lawn and Garden Equipment';
        controller.saveIndustry();
        system.assertEquals(controller.getIndustries().size(), 2);
    
        ApexPages.currentPage().getParameters().put('industryId', controller.getIndustries()[1].id);
        controller.selectIndustry();
        ApexPages.currentPage().getParameters().put('entityId', controller.getIndustries()[1].id);
        controller.deleteIndustry();
        system.assertEquals(controller.getIndustries().size(), 1);
        //update the level of sales and number of employees
        controller.participant.level_of_sales__c = 'Under $5 Million';
        controller.participant.number_of_employees__c = 'Fewer than 100';
        controller.save();
        
        //setp 4 of 9
        //"Covered Entities"
        controller.entity.name = 'Covered Entity 1';
        controller.entity.participant__c = controller.participant.id;
        controller.addEntity();
        
        controller.entity.name = 'Covered Entity 2';
        controller.addEntity();
        system.assertEquals(controller.entities.size(), 2);
        ApexPages.currentPage().getParameters().put('entityId', controller.entities[1].id);
        controller.deleteEntity();
        system.assertEquals(controller.entities.size(), 1);
        
        //step 5 of 9
            //Manate the purpose and data types
        controller.participation.purpose__c = 'Some reason for collecting data';
        controller.participation.Non_HR_Data__c = true;
        controller.participation.HR_Data__c = true;   
        controller.participation.Confirm_HR_Compliance__c = true; 
            //add a DRP
        controller.saveParticipation();
        system.assertEquals(controller.getAvailable_DRPs().size(), 2);
        ApexPages.currentPage().getParameters().put('selectedDRP', controller.getAvailable_DRPs()[1].id);
        controller.useSelectedDRP();
        controller.DRP.name = 'Some New DRP';
        controller.DRP.website__c = 'http://no.site';
        controller.saveDRP();
        system.assertEquals(controller.getResolutionProviders().size(), 2);
        controller.deleteDRP();
        
        //Step 6 of 9
        system.assertEquals(controller.getAvailableStatutoryBodies().size(), 2);
        ApexPages.currentPage().getParameters().put('statBodyId', controller.getAvailableStatutoryBodies()[0].id);
        ApexPages.currentPage().getParameters().put('statBodyName', controller.getAvailableStatutoryBodies()[0].name);
        controller.setStatutoryBody();
        system.assertNotEquals(controller.getStatutoryBodyId(), null);
        
        system.assertEquals(controller.getAvailable_Verifiers().size(), 2);
        ApexPages.currentPage().getParameters().put('selectedVerifier', controller.getAvailable_verifiers()[0].id);
        controller.useSelectedVerifier();
        system.assertEquals(controller.getVerifiers().size(), 1);
        controller.useSelectedVerifier();
        ApexPages.currentPage().getParameters().put('entityId', controller.getVerifiers()[1].id);
        controller.deleteVerifier();
        
        //Step 7 of 9
        controller.newArtifact();
        controller.artifact.name = 'Privacy Policy';
        controller.artifact.description__c = 'Description';
        controller.artifact.type__c = 'HR';
        controller.artifact.effective_date__c = date.today();
        controller.saveArtifact();
        system.assertEquals(controller.getArtifacts().size(), 1);
        ApexPages.currentPage().getParameters().put('selectedPolicy', controller.getArtifacts()[0].id);
        controller.getPolicyFromList();
    }
}

public static testmethod void TEST_2(){
//Test the participant_search with no parameters
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
    Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
        insert asset;
    Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
    Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
    };
        insert TPML;

    Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
    Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
        insert participation;
//start the test
    PageReference pg = Page.participant_search;
    Test.setCurrentPage(pg);
    participant_search_controller controller = new participant_search_controller();
    //assert the correct number of values in the search controls
    system.assertEquals(controller.getCouldStartWith().size(), 26);
    system.assertEquals(controller.getAvailablePrograms().size(), 2);
    system.assertEquals(controller.getServiceProviders().size(), 3);

    //assert parameter-controlled features
    system.assertEquals(controller.getShowResolutionProviders(), false);

    controller.search();
    system.assertEquals(controller.searchResults.size(), 1);
}

public static testmethod void TEST_3(){
//Test the participant page
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
    Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
        insert asset;
    Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
    Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
    };
        insert TPML;

    Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
    Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
        insert participation;
//start the test
    PageReference pg = Page.participant;
    Test.setCurrentPage(pg);
    ApexPages.currentPage().getParameters().put('id', participant.id);
    ApexPages.StandardController stdController = new ApexPages.StandardController(participant);
    profile_controller controller = new profile_controller(stdController);
    
    //Added on 09/27/16
    System.assert(controller.getIsContact() == false);
    System.debug(controller.participations);
    Profile_Controller controller2 = new Profile_Controller();    //Try the other constructor
}

public static testmethod void TEST_5(){
    //test the payment refund controller redirect
    PaymentSettings__c[] settings = new PaymentSettings__c[]{
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP', value__c = 'ps'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP', value__c = 'es'),
        new PaymentSettings__c(name='AGENCY_ID', value__c = 'es'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_NAME', value__c = 'Privacy Shield')
    };
    insert settings;
    
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
    Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
        insert asset;
    Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
    Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
    };
        insert TPML;

    Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
    Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
        insert participation;
    Order order = new Order();
        order.accountid = acc.id;
        order.Participation__c = participation.id;
        order.participant__c = participant.id;
        order.program__c = program.id;
        order.effectivedate = Date.today();
        order.status = 'Draft';
    insert order;
    Payment__c payment = new Payment__c();
        payment.order__c = order.id;
        payment.Application__c = 'Privacy Shield';
        payment.Transaction_Status__c = 'Success';
        payment.Payment_Date__c = date.today();
        payment.Transaction_Date__c = datetime.now();
        payment.Transaction_Amount__c = 500.00;
        insert payment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Payment);
        RefundController controller = new RefundController(sc);
        
        PageReference pageRef = Page.PaymentRefund;
        pageRef.getParameters().put('id', String.valueOf(payment.id));
        Test.setCurrentPage(pageRef);
        controller.redirectToPayment();
}

public static testmethod void TEST_6(){
    //test the payment refund controller without tcsappid
    PaymentSettings__c[] settings = new PaymentSettings__c[]{
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_ID', value__c = ''),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP', value__c = 'ps'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP', value__c = 'es'),
        new PaymentSettings__c(name='AGENCY_ID', value__c = 'es'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_NAME', value__c = 'Privacy Shield')
    };
    insert settings;
    
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
    Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
        insert asset;
    Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
    Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
    };
        insert TPML;

    Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
    Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
        insert participation;
    Order order = new Order();
        order.accountid = acc.id;
        order.Participation__c = participation.id;
        order.participant__c = participant.id;
        order.program__c = program.id;
        order.effectivedate = Date.today();
        order.status = 'Draft';
    insert order;
    Payment__c payment = new Payment__c();
        payment.order__c = order.id;
        payment.Application__c = 'Privacy Shield';
        payment.Transaction_Status__c = 'Success';
        payment.Payment_Date__c = date.today();
        payment.Transaction_Date__c = datetime.now();
        payment.Transaction_Amount__c = 500.00;
        insert payment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Payment);
        RefundController controller = new RefundController(sc);
        
        PageReference pageRef = Page.PaymentRefund;
        pageRef.getParameters().put('id', String.valueOf(payment.id));
        Test.setCurrentPage(pageRef);
        controller.issueRefund();
}

public static testmethod void TEST_7(){
    //test the payment refund controller without tcsappid
    PaymentSettings__c[] settings = new PaymentSettings__c[]{
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_ID', value__c = 'TCSITAUSMASSHQA'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP', value__c = 'ps'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP_ID', value__c = 'dummy'),
        new PaymentSettings__c(name='EVENTS_SERVICES_APP', value__c = 'es'),
        new PaymentSettings__c(name='AGENCY_ID', value__c = 'es'),
        new PaymentSettings__c(name='PRIVACY_SHIELD_APP_NAME', value__c = 'Privacy Shield')
    };
    insert settings;
    
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
    Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed');
        insert asset;
    Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
    Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
    Third_Party_Master_List__c[] TPML = new Third_Party_Master_List__c[]{
        new Third_Party_Master_List__c(name = 'DRP 1', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site'),
        new Third_Party_Master_List__c(name = 'DRP 2', type__c = 'Dispute Resolution Provider', website__c = 'http://my.site')
    };
        insert TPML;

    Participation__c participant = new Participation__c(organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
    Participant__c participation = new Participant__c(framework__c = framework.id, participant__c = participant.id, status__c = 'Active');    
        insert participation;
    Order order = new Order();
        order.accountid = acc.id;
        order.Participation__c = participation.id;
        order.participant__c = participant.id;
        order.program__c = program.id;
        order.effectivedate = Date.today();
        order.status = 'Draft';
    insert order;
    Payment__c payment = new Payment__c();
        payment.order__c = order.id;
        payment.Application__c = 'Privacy Shield';
        payment.Transaction_Status__c = 'Success';
        payment.Payment_Date__c = date.today();
        payment.Transaction_Date__c = datetime.now();
        payment.Transaction_Amount__c = 500.00;
        insert payment;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(Payment);
        RefundController controller = new RefundController(sc);
        
        PageReference pageRef = Page.PaymentRefund;
        pageRef.getParameters().put('id', String.valueOf(payment.id));
        Test.setCurrentPage(pageRef);
        Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
        controller.issueRefund();
}

}