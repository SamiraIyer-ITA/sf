@isTest(seeAllData=false)
public class TEST_ToolkitProvider{

public static testMethod void InitialLoad_withActiveAssets(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    system.assertEquals(controller.assets.size(), 1); //assert that the asset created for this test is available.

    system.assertEquals(controller.redirectForInactive(), null); //redirect for inactive should return null, not a new PageReference.
}

public static testMethod void InitialLoad_withActiveAssets_But_Inactive_Program(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = false);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    system.assertEquals(controller.assets.size(), 1); //assert that the asset created for this test is available.

    system.assertNotEquals(controller.redirectForInactive(), null); //redirect for inactive should return pagenotfound page, not null.
}

public static testMethod void InitialLoad_withActiveAssets_But_Inactive_Program_Missing_Atom_Content(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Content__c inactiveContent = new Content__c(name='InactiveContent');
        insert inactiveContent;
    Program__c program = new Program__c(name='Toolkit', isActive__c = false, Incorrect_or_Inactive_Provider_Message__c = inactiveContent.id);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    system.assertEquals(controller.assets.size(), 1); //assert that the asset created for this test is available.

    system.assertNotEquals(controller.redirectForInactive(), null); //redirect for inactive should return pagenotfound page, not null.
}

public static testMethod void InitialLoad_withActiveAssets_With_Inactive_Program_With_Atom_Content(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Content__c inactiveContent = new Content__c(name='InactiveContent', content__c = '<p>Inactive or Missing</p>');
        insert inactiveContent;
    Program__c program = new Program__c(name='Toolkit', isActive__c = false, Incorrect_or_Inactive_Provider_Message__c = inactiveContent.id);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    system.assertEquals(controller.assets.size(), 1); //assert that the asset created for this test is available.
    controller.redirectForInactive();
    system.assertEquals(controller.NotFoundDisplayMessage, '<p>Inactive or Missing</p>'); 
}

public static testMethod void InitialLoad_withActiveAssets_and_Translastions(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; 
    insert app;

    language__c language = new language__c(name='Spanish', ISO_639_1__c = 'SP');
    insert language;

    Translation__c translation = new Translation__c(Participation__c = app.id, language__c = language.id, name='Nombre de Acme', translation__c = '<pre>test</pre>');
        translation.translation__c = '<pre>Test</pre>';
        insert translation;
    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    system.assertEquals(controller.assets.size(), 1); //assert that the asset created for this test is available.

    //set the translated language
    system.assertEquals(controller.getAvailableLanguages().size(), 2); //English is always there, and the Spanish translation should be available, too.
    controller.SelectedLanguage=language.id;
    controller.translate();
    system.assertEquals(controller.getTranslation().Name, 'Nombre de Acme');
}


public static testMethod void CaseSubmission_Positive(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Participant_Contact__c contact = new Participant_Contact__c(first_name__c = 'Bob', last_name__c = 'Dyllon', email__c = 'a@b.cd', participant__c = app.id);
        insert contact;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    controller.firstname = 'John';
    controller.lastname = 'Smith';
    controller.c.suppliedEmail = 'john.smith@acme.com';
    controller.c.subject = 'CEO';
    controller.c.SuppliedCompany = 'Acme';
    controller.c.suppliedPhone = '8886424448';
    controller.c.SuppliedCountry__c = 'United Kingdom';
    controller.c.ImportCountry__c = 'United Kingdom';
    controller.c.Description = 'Blah blah #MSGA';
    //simulate positive captcha
    ApexPages.currentPage().getParameters().put('g-recaptcha-response', 'simulated');
    system.assertNotEquals(controller.verify(), false);

    controller.submitCase();
    system.assertEquals(controller.caseSubmitted, true);
}

public static testMethod void CaseSubmission_Failure(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Participant_Contact__c contact = new Participant_Contact__c(first_name__c = 'Bob', last_name__c = 'Dyllon', email__c = 'a@b.cd', participant__c = app.id);
        insert contact;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
    Asset[] asset = new Asset[]{new Asset(name=products[0].name, AccountId = acc.id, product2id = products[0].id, status='Active', participant__c = app.id), new Asset(name=products[1].name, AccountId = acc.id, product2id = products[1].id, status='Inctive', participant__c = app.id)};
        insert asset;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    controller.c.suppliedPhone = 'abc';
    controller.submitCase();
    //system.assertNotEquals(ApexPages.getMessages().size(), 0); //there should be error messages displayed
}

public static testMethod void InitialLoad_withoutActiveAssets_But_Active_Program(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;
        
    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.

    system.assertNotEquals(controller.redirectForInactive(), null); //redirect for inactive should return pagenotfound page, not null.
}

public static testMethod void InitialLoad_withoutActiveAssets_But_Active_Program_Missing_Atom_Content(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Content__c inactiveContent = new Content__c(name='InactiveContent');
        insert inactiveContent;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true, Incorrect_or_Inactive_Provider_Message__c = inactiveContent.id);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.

    system.assertNotEquals(controller.redirectForInactive(), null); //redirect for inactive should return pagenotfound page, not null.
}

public static testMethod void InitialLoad_withoutActiveAssets_With_Active_Program_With_Atom_Content(){
    Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
        insert acc;
    Content__c inactiveContent = new Content__c(name='InactiveContent', content__c = '<p>Inactive or Missing</p>');
        insert inactiveContent;
    Program__c program = new Program__c(name='Toolkit', isActive__c = true, Incorrect_or_Inactive_Provider_Message__c = inactiveContent.id);
    insert program;
    Participation__c app = new Participation__c(program__c = program.id, organization__c = acc.id, name=acc.name, postal_code__c = acc.billingpostalcode);
    app.company_description__c = '<pre>test</pre>'; insert app;

    Product2[] products = new product2[]{new product2(name='Framework Participation', isActive = true), new product2(name='Toolkit Participation', isActive = true)};
        insert products;

    CaptchaSettings__c[] settings = new CaptchaSettings__c[]{new CaptchaSettings__c(name='SECRET_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='SITE_KEY', value__c = 'Test123'), new CaptchaSettings__c(name='BASE_URL', value__c = 'Test123')}; 
        insert settings;    
    ApexPages.currentPage().getParameters().put('id', app.id);
    Provider controller = new Provider();
    system.assertEquals(controller.getTranslation().Name, acc.name); //assert that the 'Name' attribute has not been translated.
    controller.redirectForInactive();
    system.assertEquals(controller.NotFoundDisplayMessage, '<p>Inactive or Missing</p>'); 
}

}