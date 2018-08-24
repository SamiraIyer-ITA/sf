@isTest
private class TEST_ToolkitSearchService
{
    /*public static Id getWebResourceRecordType(){
        return [select id from RecordType where DeveloperName = 'Web_Resource' limit 1].id;
    }*/
    
    static Program__c prog;
    static Account acc;
    static Participation__c application;
    static Product2 product;
    static Product2 product1;
    static Product2 product2;
    static Asset asset;
    static Asset asset1;
    static Asset asset2;
    static Content__c atom;
    static Content__c atoma;
    static Web_Resource_Link__c wr;
    static Web_Resource_Link__c wr2;
    static Related_Resource__c rr;
    static Content__c atom1;
    static Content__c atom1a;
    static Web_Resource_Link__c wr3;
    static Web_Resource_Link__c wr4;
    static Related_Resource__c rr1;
    static Content__c atom2;
    static Content__c atom2a;
    static Related_Resource__c rr2;
    static Language__c lang;
    static Translation__c trans;
    static String webResourceRecordTypeId;

    static void init() {
        prog = TestUtils.createProgram('U.S. Environmental Solutions', true);
        acc = TestUtils.createAccount(true);
        application = TestUtils.createApplication(acc.id, prog.id);

        product = TestUtils.createProduct('Framework Participation', true);
        product.Class__c = 'Consulting';
        product.Category__c = '';
        product.ProductOffering__c = 'Product';
        update product;
        
        product1 = TestUtils.createProduct('Framework Participation 2', true);
        product1.Class__c = 'Fuels';
        product1.Category__c = 'Mining';
        product1.ProductOffering__c = 'Product';
        update product1;
        
        product2 = TestUtils.createProduct('Chinese Product', true);
        product2.Class__c = 'Components';
        product2.Category__c = 'Nuclear Island';
        product2.ProductOffering__c = 'Product';
        update product2;
        
        asset = TestUtils.createAsset('Active', acc, product, true, true, true, null, application);
        asset.name = product.name;
        asset.Program__c = prog.id;
        update asset;
        
        asset1 = TestUtils.createAsset('Active', acc, product1, true, true, true, null, application);
        asset1.name = product1.name;
        asset1.Program__c = prog.id;
        update asset1;
        
        asset2 = TestUtils.createAsset('Active', acc, product2, true, true, true, null, application);
        asset2.name = product2.name;
        asset2.Program__c = prog.id;
        update asset2;
        
        webResourceRecordTypeId = [select id from RecordType where DeveloperName = 'Web_Resource' limit 1].id;
        
        atom = TestUtils.createContent('Name', 'Display', 'Use Case', webResourceRecordTypeId);
        atoma = TestUtils.createContent('Namea', 'Displaya', 'Project Phase', webResourceRecordTypeId);
        
        wr = TestUtils.createWebResourceLink('wrl1', 'cnn.com', 'Published', atom.id);
        wr2 = TestUtils.createWebResourceLink('wrl2', 'cnn.com', 'Published', atoma.id);
        
        rr = TestUtils.createRelatedResource(atom.id, atoma.id, product.id);
        
        atom1 = TestUtils.createContent('Name1', 'Display1', 'Environmental Issue', webResourceRecordTypeId); 
        atom1a = TestUtils.createContent('Name1a', 'Display1a', 'Environmental Issue', webResourceRecordTypeId);
                   
        wr3 = TestUtils.createWebResourceLink('wrl3', 'cnn.com', 'Published', atom1.id);
        wr4 = TestUtils.createWebResourceLink('wrl4', 'cnn.com', 'Published', atom1a.id);
        
        rr1 = TestUtils.createRelatedResource(atom1.id, atom1a.id, product1.id);
        
        atom2 = TestUtils.createContent('Name2', 'Display2', 'Environmental Issue', webResourceRecordTypeId);
        atom2a = TestUtils.createContent('Name2a', 'Display2a', 'Environmental Issue', webResourceRecordTypeId);
        
        rr2 = TestUtils.createRelatedResource(atom2.id, atom2a.id, product2.id);
        
        lang = TestUtils.createLanguage('Chinese', 'rtl', 'zh');
        
        trans = TestUtils.createTranslation('Chinese Test', product2.id, lang.id);
    }
    
    static testMethod void mainTest()
    {
        init();
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new TEST_ToolkitSearchServiceImpl());
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ToolkitSearch/';
        String languageIso = 'zh';
        req.addParameter('programId', prog.id);
        req.addParameter('languageIso', languageIso);
        req.httpMethod = 'POST'; 
        RestContext.request = req;
        RestContext.response = res;
        ToolkitSearchService.doPost(prog.id, languageIso);
        
        /*
        System.debug('REQUEST:  ' + req);
        System.debug('RESPONSE:  ' + res);
        
        ToolkitSearchService.JsonOutput jsonResponse = (ToolkitSearchService.JsonOutput)JSON.deserialize(res.responseBody.toString(), ToolkitSearchService.JsonOutput.class);
        
        System.assertEquals(prog.name, jsonResponse.program.name);
        System.assertEquals(7, jsonResponse.filterGroups.size());
        System.assertEquals(3, jsonResponse.filterGroups[0].filterItems.size());
        System.assertEquals('Chinese', jsonResponse.currentLanguage.name);
		*/
        
        Test.stopTest();        
    }
    
}