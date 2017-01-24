@isTest(seealldata = false)
public class TEST_CMS{
    /*
    IMPORTANT!
    This class is only use to test the CMS portion of the application, not the additional tools used with the app.
    The application consists of the Site Template and Page (and page components)
    */
    public static testMethod void SingleSiteDomain(){
        //The Site_Template_Controller used on Page should pull in the Site__c that has the domain associated to the current domain.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
            system.assertNotEquals(site.id, null);
            system.assertNotEquals(controller.main, null);
    }
    
    public static testMethod void MultipleDomain_CurrentDomain(){
        //The Site_Template_Controller used on Page should pull in the Site__c that has the domain associated to the current domain, even though there is another Site__c with 'UseAsDefault' set.
        Site__c[] sites = new Site__c[]{};
            sites.add(new Site__c(name = 'Export', title__c = 'Export.gov', domain__c = 'test.url', UseAsDefault__c = true, site_css__c = '/css/sample.css', site_logo__c = '/img/sample.png'));
            sites.add(new Site__c(name = 'SUSA', title__c = 'Select USA', domain__c = URL.getSalesforceBaseUrl().getHost(), UseAsDefault__c = false, site_css__c = '/css/sample.css', site_logo__c = '/img/sample.png'));
        insert sites;
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
            system.assertEquals(controller.main.id, sites[1].id);        
    }
    
    public static testMethod void NoCurrentDomain(){
        //The Site_Template_Controller used on Page should pull in the Site__c that has the attribute 'UseAsDefault' set if the current domain does not match any existing record.
        Site__c[] sites = new Site__c[]{};
            sites.add(new Site__c(name = 'Export', title__c = 'Export.gov', domain__c = 'test.url', UseAsDefault__c = true, site_css__c = '/css/sample.css', site_logo__c = '/img/sample.png'));
            sites.add(new Site__c(name = 'SUSA', title__c = 'Select USA', domain__c = 'selectusa.gov', UseAsDefault__c = false, site_css__c = '/css/sample.css', site_logo__c = '/img/sample.png'));
        insert sites;
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
            system.assertEquals(controller.main.id, sites[0].id);        
    }
    
    public static testMethod void SingleGroup_SingleSite_NoLinks(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        //this test only uses one navigation group as it is only testing the following:
        //1) that the navigation group is put into the list of fields for the navigation
        //2) that the url for the group link is '#'
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();

        system.assertNotEquals(controller.NavigationGroups, null);
        system.assertEquals(controller.NavigationGroups.size(), 1);
        //system.assertEquals(controller.NavigationGroups[0].url, '#');
    }

    public static testMethod void SingleGroup_SingleSite_NoLinks_ChatterGroupRedirect(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        CollaborationGroup chatter = new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public');
        insert chatter;
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test', chatter_group__c = 'Chatter Test'));
        insert groups;
        //this test only uses one navigation group as it is only testing the following:
        //1) that the navigation group is put into the list of fields for the navigation
        //2) that the url for the group link is '/apex/group?id=[chatter.id]'
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();

        system.assertNotEquals(controller.NavigationGroups, null);
        system.assertEquals(controller.NavigationGroups.size(), 1);
        //system.assertEquals(controller.NavigationGroups[0].url, '/apex/group?id='+chatter.id);
    }

    public static testMethod void SingleGroup_SingleSite_SingleLink_NoContent(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test', url__c = 'salesforce.com'));
        insert groups;
        Page__c pg = new Page__c(name = 'Test Page');
        insert pg;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        //this test only uses one navigation group as it is only testing the following:
        //1) that the navigation group is put into the list of fields for the navigation
        //2) that the url for the group link is '#'
        //3) that the group contains a link
        PageReference pageRef = Page.page;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();

        system.assertNotEquals(controller.NavigationGroups, null);
        system.assertEquals(controller.NavigationGroups.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].url, 'http://salesforce.com');
        system.assertEquals(controller.NavigationGroups[0].links.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].links[0].page__c, pg.id);
    }

    public static testMethod void SingleGroup_SingleSite_SingleLink_SinglePageContent_WithSection(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        Page__c home = new Page__c(name = 'Test Home Page');
        insert home;
        Section__c section = new Section__c(name='section 1', page__c = home.id);
        insert section;
        Page__c pg = new Page__c(name = 'Test Page', section__c = section.id);
        insert pg;
        Content__c content = new Content__c(content__c = '<h1>Hello World!</h1>');
        insert content;
        Page_Content__c pc = new Page_Content__c(page__c = pg.id, content__c = content.id);
        insert pc;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        PageReference pageRef = Page.page;
            pageRef.getParameters().put('id', pg.id);
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
        ApexPages.StandardController stdPg = new ApexPages.StandardController(pg);
        Page_Section_Controller PSC = new Page_Section_Controller(stdPg);

        system.assertNotEquals(controller.NavigationGroups, null);
        system.assertEquals(controller.NavigationGroups.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].url, '#');
        system.assertEquals(controller.NavigationGroups[0].links.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].links[0].page__c, pg.id);
        system.assertEquals(PSC.section.id, section.id); 
        system.assertEquals(PSC.page.id, pg.id);              
    }

    public static testMethod void SingleGroup_SingleSite_SingleLink_SinglePageContent_Carousel(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        Page__c home = new Page__c(name = 'Test Home Page');
        insert home;
        Section__c section = new Section__c(name='section 1', page__c = home.id);
        insert section;
        Content__c content = new Content__c( name='Carousel Test', RecordTypeId = [select id from RecordType where SObjectType = 'Content__c' and name='Carousel' limit 1].id);
        insert content;
        Image__c img = new Image__c(Name = 'Image 1', alt__c = 'test alt', location__c = '/img/image.jpg');
        insert img;
        Carousel_Item__c item = new Carousel_Item__c(image__c = img.id, content__c = content.id);
        insert item;
        CollaborationGroup chatter = new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public');
        insert chatter;        
        Page__c pg = new Page__c(name = 'Test Page', section__c = section.id, carousel__c = content.id, collaboration_group__c = 'Chatter Test');
        insert pg;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        PageReference pageRef = Page.page;
            pageRef.getParameters().put('id', pg.id);
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
        ApexPages.StandardController stdPg = new ApexPages.StandardController(pg);
        Page_Section_Controller PSC = new Page_Section_Controller(stdPg);

        system.assertNotEquals(controller.NavigationGroups, null);
        system.assertEquals(controller.NavigationGroups.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].url, '#');
        system.assertEquals(controller.NavigationGroups[0].links.size(), 1);
        system.assertEquals(controller.NavigationGroups[0].links[0].page__c, pg.id);
        system.assertEquals(PSC.section.id, section.id); 
        system.assertEquals(PSC.page.id, pg.id);          
    }
    
    public static testMethod void Landing(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        Page__c home = new Page__c(name = 'Test Home Page');
        insert home;
        Section__c section = new Section__c(name='section 1', page__c = home.id);
        insert section;
        Page__c pg = new Page__c(name = 'Test Page', section__c = section.id);
        insert pg;
        Content__c content = new Content__c(content__c = '<h1>Hello World!</h1>');
        insert content;
        Page_Content__c pc = new Page_Content__c(page__c = pg.id, content__c = content.id);
        insert pc;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        PageReference pageRef = Page.landing;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
        Landing_Controller landing = new Landing_Controller(); 
        landing.redirect();
    }    

    public static testMethod void Landing_withPage(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Page__c pg = new Page__c(name = 'Test Page');
        insert pg;
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
            site.default_page__c = pg.id;
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        Page__c home = new Page__c(name = 'Test Home Page');
        insert home;
        Section__c section = new Section__c(name='section 1', page__c = home.id);
        insert section;
        Content__c content = new Content__c(content__c = '<h1>Hello World!</h1>');
        insert content;
        Page_Content__c pc = new Page_Content__c(page__c = pg.id, content__c = content.id);
        insert pc;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        PageReference pageRef = Page.landing;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
        Landing_Controller landing = new Landing_Controller(); 
        landing.redirect();
    }    

    public static testMethod void Landing_withRedirect(){
        //NOTE:  This test assumes that the previous tests pass, and so uses the setup data that was also used in SingleSiteDomain() test method.
        //The navigation in this test sets up a single page but does not create content as it is only testing the navigation links.
        Page__c pg = new Page__c(name = 'Test Page');
        insert pg;
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
            site.VisualForce_Redirect__c = 'apex/market_intelligence_latest';
        insert site;        
        Navigation_Group__c[] groups = new Navigation_Group__c[]{};
            groups.add(new Navigation_Group__c(Site__c = site.id, name = 'Test'));
        insert groups;
        Page__c home = new Page__c(name = 'Test Home Page');
        insert home;
        Section__c section = new Section__c(name='section 1', page__c = home.id);
        insert section;
        Content__c content = new Content__c(content__c = '<h1>Hello World!</h1>');
        insert content;
        Page_Content__c pc = new Page_Content__c(page__c = pg.id, content__c = content.id);
        insert pc;
        Navigation_Link__c link = new Navigation_Link__c(Navigation_Group__c = groups[0].id, Page__c=pg.id);
        insert link;
        PageReference pageRef = Page.landing;
        Test.setCurrentPage(pageRef);
        Site_Template_Controller controller = new Site_Template_Controller();
        Landing_Controller landing = new Landing_Controller(); 
        landing.redirect();
    }
    
    public static testMethod void ImageManager(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.upload();
    }

    public static testMethod void ImageManager_no_Body(){
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.upload();   
    }

    public static testMethod void CarouselManager_Search(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.image.body = b;
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 0);
        
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 0); 
    }
    
    public static testMethod void CarouselManager_AddSlide(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.type = 'Carousel Image';
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.type = 'Carousel Image';
        controller.image.body = b;
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 2);
        system.assertEquals(cont.getCItems().size(), 0);
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 1); 
        ApexPages.currentPage().getParameters().put('img', cont.getImages()[0].id);
        cont.doNothing();
        cont.saveSlide();
        system.assertEquals(cont.getCItems().size(), 1);
    }

    public static testMethod void CarouselManager_AddSlide_Error(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.image.body = b;
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 0);
        system.assertEquals(cont.getCItems().size(), 0);
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 0); 
        cont.saveSlide();
        system.assertEquals(cont.getCItems().size(), 0);
    }

    public static testMethod void CarouselManager_Cancel(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.type = 'Carousel Image';
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.type = 'Carousel Image';
        controller.image.body = b;
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 2);
        system.assertEquals(cont.getCItems().size(), 0);
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 1); 
        ApexPages.currentPage().getParameters().put('img', cont.getImages()[0].id);
        cont.doNothing();
        cont.Cancel();
        system.assertEquals(cont.getCItems().size(), 0);
    }

    public static testMethod void CarouselManager_DeleteSlide(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.type = 'Carousel Image';
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.image.body = b;
        controller.type = 'Carousel Image';
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 2);
        system.assertEquals(cont.getCItems().size(), 0);
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 1); 
        ApexPages.currentPage().getParameters().put('img', cont.getImages()[0].id);
        cont.doNothing();
        cont.saveSlide();
        system.assertEquals(cont.getCItems().size(), 1);
        system.assertNotEquals(cont.getCItems()[0].id, null);
        ApexPages.currentPage().getParameters().put('ci', cont.getCItems()[0].id);
        //ApexPages.currentPage().getParameters().put('img', null);
        cont.doNothing();
        system.assertNotEquals(cont.cItem, null);
        system.assertNotEquals(cont.cItem.id, null);
        cont.deleteSlide();
    }

    public static testMethod void CarouselManager_DeleteSlide_Error(){
        Blob b = Blob.valueOf('Test Data');  
        PageReference pageRef = page.imageManager;
        test.setCurrentPage(pageRef);
        imageManager_Controller controller = new imageManager_Controller();
        controller.name = 'Image Upload';
        controller.filename = 'testImage.jpg';
        controller.description = 'Test Description of an Image';
        controller.image.body = b;
        controller.upload();

        controller.name = 'Upload 2';
        controller.filename = 'testImage2.jpg';
        controller.description = 'Test Description of the Second Image'; 
        controller.image.body = b;
        controller.upload();   

        Content__c c = new Content__c();
        c.recordtypeid = [select id from recordtype where sobjecttype = 'content__c' and name = 'Carousel' limit 1].id;
        insert c;
        
        ApexPages.StandardController stdPg = new ApexPages.StandardController(c);
        pageRef = page.carouselManager;
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', c.id);
        CarouselController cont = new CarouselController(stdPg);
        
        Image__c[] images = cont.getImages();
        system.assertEquals(images.size(), 0);
        system.assertEquals(cont.getCItems().size(), 0);
        cont.search = '2';
        cont.search();
        system.assertEquals(cont.getImages().size(), 0); 

        cont.deleteSlide();
    }
    
    public static testMethod void TestSiteMap(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Site__c site2 = new Site__c();
            site2.name = 'Second Site';
            site2.domain__c = 'google.com';
            site2.title__c = 'Google!';
            site2.Site_CSS__c = '/css/sample.css' ;
            site2.site_logo__c = '/img/sample.png';
            site2.UseAsDefault__c = false;
        insert site2;
        
        Page__c[] pages = new Page__c[]{
            new Page__c(name='page1', site__c = site2.id),
            new Page__c(name='page2', site__c = site.id),
            new Page__c(name='page3', site__c = site2.id),
            new Page__c(name='page4', site__c = site.id)
        };
        insert pages;
        
        PageReference pageRef = Page.SiteMap;
        Test.setCurrentPage(pageRef);
        SiteMap_Controller controller = new SiteMap_Controller();
        system.assertEquals([select id from page__c].size(), 4);
        system.assertEquals(controller.getPages().size(), 2);
        system.assertEquals(controller.getXML(), '<?xml version="1.0" encoding="UTF-8"?>');
    }
}