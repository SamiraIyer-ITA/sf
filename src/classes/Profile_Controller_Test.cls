@isTest
private class Profile_Controller_Test {

    static testMethod void UserIsNotContact(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
        Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed', framework__c = framework.id, HR_Data__c = true, Non_HR_Data__c = true);
        insert asset;


        ApexPages.currentPage().getParameters().put('id', participant.id);
        Profile_Controller controller = new Profile_Controller();
        system.assertEquals(controller.getIsContact(), false);
    }

    static testMethod void UserIsContact(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
        Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active', framework__c = framework.id, HR_Data__c = true, Non_HR_Data__c = true, Participant__c = participant.id);
        insert asset;


        Contact c = new Contact(firstname='John', lastname='Smith', email='js@no.mail', accountid = acc.id);
        insert c;
        Profile p = [select id from profile where name = 'Customer Trade Community User'];

        // Setup test data
        // This code runs as the system user
        User u = new User( email=c.email,
            UserName=c.email,
            Alias = c.firstname,
            TimeZoneSidKey='America/New_York',
            EmailEncodingKey='ISO-8859-1',
            LocaleSidKey='en_US',
            LanguageLocaleKey='en_US',
            postalcode = '10101',
            ContactId = c.id,
            LastName = c.lastname,
            ProfileId = p.id,
            CommunityNickname = c.firstname+c.lastname);
        insert u;

        System.runAs(u) {

            ApexPages.currentPage().getParameters().put('id', participant.id);
            ApexPages.currentPage().getParameters().put('contact', c.id);
            Profile_Controller controller = new Profile_Controller();
            system.assertEquals(controller.getIsContact(), true);
        }
    }

    static testMethod void IncorrectActiveStatus(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
        Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Inactive', framework__c = framework.id, HR_Data__c = true, Non_HR_Data__c = true, Participant__c = participant.id);
        insert asset;

        ApexPages.currentPage().getParameters().put('id', participant.id);
        ApexPages.currentPage().getParameters().put('status', 'Active');
        Profile_Controller controller = new Profile_Controller();
        system.assertEquals(controller.fatalError, null);
    }

    static testMethod void IncorrectInactiveStatus(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
        Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active', framework__c = framework.id, HR_Data__c = true, Non_HR_Data__c = true, Participant__c = participant.id);
        insert asset;

        ApexPages.currentPage().getParameters().put('id', participant.id);
        ApexPages.currentPage().getParameters().put('status', 'Inactive');
        Profile_Controller controller = new Profile_Controller();
        system.assertEquals(controller.fatalError, null);
    }

    static testMethod void fatalError(){
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
        insert product;
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
        insert program;
        Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
        insert framework;
        Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
        insert participant;


        ApexPages.currentPage().getParameters().put('id', participant.id);
        ApexPages.currentPage().getParameters().put('status', 'Active');
        Profile_Controller controller = new Profile_Controller();
        system.assertNotEquals(controller.fatalError, null);
    }
}
/*static testMethod void HrData(){
     Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
     insert acc;
     Product2 product = new product2(name='Framework Participation', isActive = true);
     insert product;
     Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
     insert program;
     Framework__c framework = new Framework__c(name = 'Framework', product__c = product.id, program__c = program.id, isActive__c = true);
     insert framework;
     Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Installed', framework__c = framework.id, HR_Data__c = true);
     insert asset;
     Participation__c participant = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
     insert participant;

     ApexPages.currentPage().getParameters().put('id', participant.id);
     Profile_Controller controller = new Profile_Controller();
 }

 @isTest
 static void test1() {
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

 }*/