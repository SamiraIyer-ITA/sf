@IsTest
Public Class Participant_Search_Controller_Test{
    /*
    Test class for the participant_search controller class
    */
    
    Public static testMethod void searchTerm() {
        PageReference pageRef = Page.participant_search;
        Test.setCurrentPage(pageRef);
        
        Account acct = TestUtils.createAccount(true);
        Program__c program = TestUtils.createProgram('Privacy Shield', true);
        Participation__c app = TestUtils.createApplication(acct.id, program.id);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = TestUtils.createFramework('EU-US', productEU.id, program.id, true);
        Framework__c frameworkSW = TestUtils.createFramework('SW-US', productSW.id, program.id, true);
        List<id> frameworkIds = new List<id>();
        frameworkIds.add(frameworkEU.id);
        frameworkIds.add(frameworkSW.id);
        Asset assetEU = TestUtils.createAsset('Active', acct, productEU, true, true, true, frameworkEU, app);
        Asset assetSW = TestUtils.createAsset('Active', acct, productSW, true, true, true, frameworkSW, app);
        List<Third_Party_Master_List__c> tpmls = TestUtils.createTPMLs(frameworkIds);
        Covered_Entity__c ce = TestUtils.createCoveredEntity('CE Name', app.id);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('program', frameworkEU.id);
        ApexPages.currentPage().getParameters().put('searchMethod', 'SearchTerm');
        ApexPages.currentPage().getParameters().put('showDRP', 'true');
        participant_search_controller psc = new participant_search_controller();
                
        psc.searchTerm = 'Na';  //Will find CE Name for Covered Entity
        psc.search();
        System.assertEquals(psc.participants.size() > 0, true);
    }
    
    Public static testMethod void startsWith() {
        PageReference pageRef = Page.participant_search;
        Test.setCurrentPage(pageRef);
        
        Account acct = TestUtils.createAccount(true);
        Program__c program = TestUtils.createProgram('Privacy Shield', true);
        Participation__c app = TestUtils.createApplication(acct.id, program.id);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = TestUtils.createFramework('EU-US', productEU.id, program.id, true);
        Framework__c frameworkSW = TestUtils.createFramework('SW-US', productSW.id, program.id, true);
        List<id> frameworkIds = new List<id>();
        frameworkIds.add(frameworkEU.id);
        frameworkIds.add(frameworkSW.id);
        Asset assetEU = TestUtils.createAsset('Active', acct, productEU, true, true, true, frameworkEU, app);
        Asset assetSW = TestUtils.createAsset('Active', acct, productSW, true, true, true, frameworkSW, app);
        List<Third_Party_Master_List__c> tpmls = TestUtils.createTPMLs(frameworkIds);
        Covered_Entity__c ce = TestUtils.createCoveredEntity('CE Name', app.id);
        
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('program', frameworkEU.id);
        ApexPages.currentPage().getParameters().put('searchMethod', 'StartingLetter');
        ApexPages.currentPage().getParameters().put('showDRP', 'true');
        participant_search_controller psc = new participant_search_controller();
                
        psc.searchTerm = 'A';
        psc.advancedSearch();  //could also do psc.search() here, but advancedSearch() is done for code coverage
        System.assertEquals(psc.participants.size() > 0, true);
    }
    
    Public static testMethod void variousMethods() { 
        Account acct = TestUtils.createAccount(true);
        Program__c program = TestUtils.createProgram('Privacy Shield', true);
        Participation__c app = TestUtils.createApplication(acct.id, program.id);
        Pricebook2 pricebook = TestUtils.createPricebook(program.id);
        Product2 productEU = TestUtils.createProduct('EU-US', true);
        Product2 productSW = TestUtils.createProduct('SW-US', true);
        Framework__c frameworkEU = TestUtils.createFramework('EU-US', productEU.id, program.id, true);
        Framework__c frameworkSW = TestUtils.createFramework('SW-US', productSW.id, program.id, true);
        List<id> frameworkIds = new List<id>();
        frameworkIds.add(frameworkEU.id);
        frameworkIds.add(frameworkSW.id);
        Asset assetEU = TestUtils.createAsset('Active', acct, productEU, true, true, true, frameworkEU, app);
        Asset assetSW = TestUtils.createAsset('Active', acct, productSW, true, true, true, frameworkSW, app);
        
        List<Third_Party_Master_List__c> tpmls = TestUtils.createTPMLs(frameworkIds);
        
        ApexPages.currentPage().getParameters().put('program', frameworkEU.id);
        ApexPages.currentPage().getParameters().put('searchMethod', 'SearchTerm');
        ApexPages.currentPage().getParameters().put('showDRP', 'true');
        participant_search_controller psc = new participant_search_controller();
        psc.searchTerm = 'A';
        SelectOption[] options = psc.getServiceProviders();
        System.assertNotEquals(options[1], null);
        
        psc.tempQuery = '';
        psc.tempString = '';
        psc.tmpQuery = '';
        
        options = psc.getAvailablePrograms();
        System.assertNotEquals(options[0], null);
        
        options = psc.getOffsetOptions();
        System.assertNotEquals(options[0], null);
        
        Integer offset = psc.getSelectedOffsetInteger();
        System.assertEquals(offset>0, true);
        
        string[] letters = psc.getCouldStartWith();
        System.assertEquals(letters[0], 'A');
        
        String progName = psc.getReferencedProgram();
        System.assertEquals(progName, frameworkEU.id);
        
        Integer orgCount = psc.getTotalOrgCount();
        System.debug('Total Org Count: ' + orgCount);
        System.assertEquals(orgCount > 0, true);
        
        Integer offsetLimit = psc.getLimit();
        System.debug('offsetLimit:' + offsetLimit);
        System.assertEquals(offsetLimit, 10);
        
        Boolean showResProviders = psc.getShowResolutionProviders();
        System.assertEquals(showResProviders, true);  
    }
    
}