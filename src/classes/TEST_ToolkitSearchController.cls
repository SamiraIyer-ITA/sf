//////////////////////////////////////////////
// TEST_ToolkitSearchController
//    Created by: Jeff Weyhrauch
//    Created on: 6-13-2017
//    Updated by: 
//////////////////////////////////////////////

@isTest(seealldata = false)
public class TEST_ToolkitSearchController {

    public static Id getWebResourceRecordType(){
        return [select id from RecordType where DeveloperName = 'Web_Resource' limit 1].id;
    }
         
    static testMethod void testToolkitSearchConstructor(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;           
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;         
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef);
        //-- ADD DATA TO PAGE --//
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            product.isActive = true;
            insert product;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active');
            asset.Program__c = program.id;
            insert asset;    
        ApexPages.currentPage().getParameters().put('program',program.id);
        //-- ** --//
        system.assertEquals(ApexPages.currentPage().getParameters().get('program'), program.id);
        ToolkitSearchController controller = new ToolkitSearchController();
        system.assertEquals(controller.toolkitName, 'Initiative Name');
    }
    static testMethod void testToolkitSearchConstructorBlankProgramId(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;            
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;         
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef);
        //-- ** --//        
        system.assertEquals(ApexPages.currentPage().getParameters().get('program'), null);
        ToolkitSearchController controller = new ToolkitSearchController();
    }
    static testMethod void testRefreshChoices(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;           
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;         
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef);  
        //-- ADD DATA TO PAGE --//
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            product.isActive = true;
            insert product;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active');
            asset.Program__c = program.id;
            insert asset;    
        ApexPages.currentPage().getParameters().put('program',program.id);
        //-- ** --//
        ToolkitSearchController controller = new ToolkitSearchController();
        controller.refreshChoices();
        system.assert(controller.filterGroups.size() == 1);
    }    
    static testMethod void testDeselectFilterItem(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;            
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;       
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef); 
        //-- ADD DATA TO PAGE --//
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        Participation__c participation = new Participation__c(name='Globex Nuclear', Program__c = program.id, Organization__c = acc.id, Public_Display_Name__c = 'Globex Corporation', Postal_Code__c = '90000');    
            insert participation;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            product.Class__c = 'Consulting';
            product.Category__c = '';
            product.Shore__c = 'OnShore';
            product.Block__c = '0';
            product.ProductOffering__c = 'Product';
            product.isActive = true;
            insert product;
        Product2 product1 = new product2(name='Framework Participation 2', isActive = true);
            product1.Class__c = 'Fuels';
            product1.Category__c = 'Mining';
            product1.Shore__c = 'OnShore';
            product1.Block__c = '1';
            product1.ProductOffering__c = 'Product';
            product1.isActive = true;
            insert product1;
        Product2 product2 = new product2(name='Globex Island', isActive = true);
            product2.Class__c = 'Components';
            product2.Category__c = 'Nuclear Island';
            product2.Shore__c = 'OffShore';
            product2.Block__c = '2';
            product2.ProductOffering__c = 'Product';
            product2.isActive = true;
            insert product2;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active');
            asset.Program__c = program.id;
            asset.Participant__c = participation.id;
            insert asset;
        Asset asset1 = new Asset(name=product1.name, AccountId = acc.id, product2id = product1.id, status='Active');
            asset1.Program__c = program.id;
            asset1.Participant__c = participation.id;
            insert asset1;
        Asset asset2 = new Asset(name=product2.name, AccountId = acc.id, product2id = product2.id, status='Active');
            asset2.Program__c = program.id;
            asset2.Participant__c = participation.id;
            insert asset2;            
        Content__c atom = new Content__c(name='Name', display_title__c = 'Display');        
            atom.Display_Title__c = '';
            atom.Type__c = 'Use Case';
            atom.recordtypeid = getWebResourceRecordType();
            insert atom;
        Content__c atoma = new Content__c(name='Namea', display_title__c = 'Displaya');
            atoma.Type__c = 'Project Phase';
            atoma.recordtypeid = getWebResourceRecordType();
            insert atoma;
        Web_Resource_Link__c wr = new Web_Resource_Link__c(DisplayName__c = 'JEFF',URL__c = 'jeff.com',Status__c = 'Published',Web_Resource__c=atom.id);
            insert wr;
        Web_Resource_Link__c wr2 = new Web_Resource_Link__c(DisplayName__c = 'JEFF2',URL__c = 'jeff2.com',Status__c = 'Published',Web_Resource__c=atom.id);
            insert wr2;
        Related_Resource__c rr = new Related_Resource__c();
            rr.Primary_Web_Resource__c = atom.id;
            rr.Related_Web_Resource__c = atoma.id;
            rr.Product__c = product.id;
            insert rr;            
        Content__c atom1 = new Content__c(name='Name1', display_title__c = 'Display1');
            atom1.Type__c = 'Environmental Issue';
            atom1.recordtypeid = getWebResourceRecordType();
            insert atom1;
        Content__c atom1a = new Content__c(name='Name1a', display_title__c = 'Display1a');
            atom1a.Display_Title__c = '';
            atom1a.Type__c = 'Environmental Issue';
            atom1a.recordtypeid = getWebResourceRecordType();
            insert atom1a;       
        Related_Resource__c rr1 = new Related_Resource__c();
            rr1.Primary_Web_Resource__c = atom1.id;
            rr1.Related_Web_Resource__c = atom1a.id;
            rr1.Product__c = product1.id;
            insert rr1;            
        Content__c atom2 = new Content__c(name='Name2', display_title__c = 'Display2');
            atom2.Type__c = 'Environmental Issue';
            atom2.recordtypeid = getWebResourceRecordType();
            insert atom2;
        Content__c atom2a = new Content__c(name='Name2a', display_title__c = 'Display2a');
            atom2a.Type__c = 'Environmental Issue';
            atom2a.recordtypeid = getWebResourceRecordType();
            insert atom2a;           
        Related_Resource__c rr2 = new Related_Resource__c();
            rr2.Primary_Web_Resource__c = atom2.id;
            rr2.Related_Web_Resource__c = atom2a.id;
            rr2.Product__c = product2.id;
            insert rr2;                                                  
        ApexPages.currentPage().getParameters().put('program',program.id);          
        //-- ** --//
        ToolkitSearchController controller = new ToolkitSearchController();
        controller.searchString = 'nuclear';
        ToolkitSearchController.FilterGroup myFilterGroup = new ToolkitSearchController.FilterGroup();
            myFilterGroup.selectedOptions.add('Fuel');
            myFilterGroup.selectedOptions.add('Legal');
            myFilterGroup.selectedOptions.add('0');
            myFilterGroup.selectedOptions.add('1');
            myFilterGroup.selectedOptions.add('2');
            myFilterGroup.selectedOptions.add('OnShore');
            myFilterGroup.selectedOptions.add('Environmental Issue');
            ToolkitSearchController.FilterItem myFilterItem = new ToolkitSearchController.FilterItem();
                myFilterItem.id = atom1.id;
                myFilterItem.name = atom1.name;
            myFilterGroup.filterItems.add(myFilterItem);
        ToolkitSearchController.FilterGroup myFilterGroup2 = new ToolkitSearchController.FilterGroup();
            myFilterGroup2.selectedOptions.add('Fuel');    
        controller.filterGroups.add(myFilterGroup);
        controller.filterGroups.add(myFilterGroup2);
        controller.deselectFilterItem();
        //system.assertEquals(controller.displayResults, true);       
    }
    static testMethod void miscCoverage(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;           
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;         
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef);
        //-- ADD DATA TO PAGE --//
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            product.isActive = true;
            insert product; 
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active');
            asset.Program__c = program.id;
            insert asset;    
        ApexPages.currentPage().getParameters().put('program',program.id);
        //-- ** --//
        system.assertEquals(ApexPages.currentPage().getParameters().get('program'), program.id);
        ToolkitSearchController controller = new ToolkitSearchController();
        String myTemp = controller.temp;
        Integer myTempInt = controller.tempInt;
        //product mynewproducts = controller.products;
        ToolkitSearchController.AtomLink myAtomLink = new ToolkitSearchController.Atomlink();
            myAtomLink.name = 'Jeff';
            myAtomLink.url = 'jeff.com';
        ToolkitSearchController.FilterItem myFilterItem = new ToolkitSearchController.FilterItem();
            myFilterItem.name = 'jeff';
        ToolkitSearchController.translation newtranslation = new ToolkitSearchController.translation();
            newtranslation.Name = 'jeffese';
            newtranslation.Language = 'jeffcool';
            newtranslation.LanguageDirection = 'ltr';
            newtranslation.LanguageISO = 'jf';
            newtranslation.Translation = 'jeff is the coolest and also the most humble';    
        Integer myHashCode = myFilterItem.hashCode();
        system.assertEquals(myFilterItem.equals(myAtomLink), false);
    }
    static testMethod void testChangeLanguage(){
        //-- SET UP TEST TOOLKIT SEARCH PAGE --//
        page__c testpage = new page__c(name='testpage');
            insert testpage;            
        Program__c program = new Program__c(name='Initiative Name', isActive__c = true);
            insert program;         
        PageReference pageRef = Page.toolkitSearch;
        Test.setCurrentPage(pageRef);
        //-- ADD DATA TO PAGE --//
        Account acc = new Account(name='Acme', billingstreet = '101 binary way', billingcity = 'New York', billingstatecode='NY', billingpostalcode='10101');
            insert acc;
        Participation__c participation = new Participation__c(name='Globex Nuclear', Program__c = program.id, Organization__c = acc.id, Public_Display_Name__c = 'Globex Corporation', Postal_Code__c = '90000');    
            insert participation;
        Product2 product = new product2(name='Framework Participation', isActive = true);
            product.Class__c = 'Consulting';
            product.Category__c = '';
            product.Shore__c = 'OnShore';
            product.Block__c = '0';
            product.ProductOffering__c = 'Product';
            product.isActive = true;
            insert product;
        Product2 product1 = new product2(name='Framework Participation 2', isActive = true);
            product1.Class__c = 'Fuels';
            product1.Category__c = 'Mining';
            product1.Shore__c = 'OnShore';
            product1.Block__c = '1';
            product1.ProductOffering__c = 'Product';
            product1.isActive = true;
            insert product1;
        Product2 product2 = new product2(name='Globex Island', isActive = true);
            product2.Class__c = 'Components';
            product2.Category__c = 'Nuclear Island';
            product2.Shore__c = 'OffShore';
            product2.Block__c = '2';
            product2.ProductOffering__c = 'Product';
            product2.isActive = true;
            insert product2;
        Asset asset = new Asset(name=product.name, AccountId = acc.id, product2id = product.id, status='Active');
            asset.Program__c = program.id;
            asset.Participant__c = participation.id;
            insert asset;
        Asset asset1 = new Asset(name=product1.name, AccountId = acc.id, product2id = product1.id, status='Active');
            asset1.Program__c = program.id;
            asset1.Participant__c = participation.id;
            insert asset1;
        Asset asset2 = new Asset(name=product2.name, AccountId = acc.id, product2id = product2.id, status='Active');
            asset2.Program__c = program.id;
            asset2.Participant__c = participation.id;
            insert asset2;            
        Content__c atom = new Content__c(name='Name', display_title__c = 'Display');        
            //atom.Display_Title__c = '';
            atom.Type__c = 'Use Case';
            atom.recordtypeid = getWebResourceRecordType();
            insert atom;
        Content__c atoma = new Content__c(name='Namea', display_title__c = 'Displaya');
            atoma.Type__c = 'Project Phase';
            atoma.recordtypeid = getWebResourceRecordType();
            insert atoma;
        Web_Resource_Link__c wr = new Web_Resource_Link__c(DisplayName__c = 'JEFF',URL__c = 'jeff.com',Status__c = 'Published',Web_Resource__c=atom.id);
            insert wr;
        Web_Resource_Link__c wr2 = new Web_Resource_Link__c(DisplayName__c = 'JEFF2',URL__c = 'jeff2.com',Status__c = 'Published',Web_Resource__c=atom.id);
            insert wr2;
        Related_Resource__c rr = new Related_Resource__c();
            rr.Primary_Web_Resource__c = atom.id;
            rr.Related_Web_Resource__c = atoma.id;
            rr.Product__c = product.id;
            insert rr;            
        Content__c atom1 = new Content__c(name='Name1', display_title__c = 'Display1');
            atom1.Type__c = 'Environmental Issue';
            atom1.recordtypeid = getWebResourceRecordType();
            insert atom1;
        Content__c atom1a = new Content__c(name='Name1a', display_title__c = 'Display1a');
            atom1a.Display_Title__c = '';
            atom1a.Type__c = 'Environmental Issue';
            atom1a.recordtypeid = getWebResourceRecordType();
            insert atom1a;       
        Related_Resource__c rr1 = new Related_Resource__c();
            rr1.Primary_Web_Resource__c = atom1.id;
            rr1.Related_Web_Resource__c = atom1a.id;
            rr1.Product__c = product1.id;
            insert rr1;            
        Content__c atom2 = new Content__c(name='Name2', display_title__c = 'Display2');
            atom2.Type__c = 'Environmental Issue';
            atom2.recordtypeid = getWebResourceRecordType();
            insert atom2;
        Content__c atom2a = new Content__c(name='Name2a', display_title__c = 'Display2a');
            atom2a.Type__c = 'Environmental Issue';
            atom2a.recordtypeid = getWebResourceRecordType();
            insert atom2a;           
        Related_Resource__c rr2 = new Related_Resource__c();
            rr2.Primary_Web_Resource__c = atom2.id;
            rr2.Related_Web_Resource__c = atom2a.id;
            rr2.Product__c = product2.id;
            insert rr2;
        Language__c chineselanguage = new Language__c(Name='Chinese',Direction__c='ltr',ISO_639_1__c = 'cn');
            insert chineselanguage;
        Translation__c chinese = new Translation__c(Name='Chinese', Product__c=product.id, Atom__c=atom.id, Web_Resource_Link__c=wr.id, 
                                                    Translation__c='fushujin wuqi', Language__c=chineselanguage.id);   
            insert chinese;                                               
        ApexPages.currentPage().getParameters().put('program',program.id);          
        //-- ** --//
        system.assertEquals(ApexPages.currentPage().getParameters().get('program'), program.id);
        ToolkitSearchController controller = new ToolkitSearchController();
        controller.changeLanguage();
        controller.selectedLanguage = 'cn';
        controller.changeLanguage();
    }        
}