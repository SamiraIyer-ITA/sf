@isTest(seealldata = false)
public class TEST_Knowledge_Management{
/*
    This class handles all of the unit tests related to knowledge management code.
*/
    public static TestMethod void testCase1(){
        //A link is clicked that navigates the user's browser to /km_atom.
        //This test passes when the following 4 variables are returned to the page from the Knowledge Article Type for the 'id' provided:
        //    Title, Last Published Date, Atom, and Summary
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;

       Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my Reference';
           kav.urlName = 'this-is-my-kav';
           kav.series__c = pub.id;
           kav.language = 'en_US';
           insert kav;
        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        
        article_controller controller = new article_controller();
        system.assertNotEquals(controller.atom, null); //make sure that the atom is not empty
        system.assertEquals(controller.atom, 'This is my KAV Atom'); //make sure that the atom matches what was specified in this test
        system.assertEquals(controller.title, 'This is my KAV Title'); //make sure that the title matches what was specified in the test        
    }

    public static TestMethod void testCase2(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        //A link is somehow clicked to an article that is not published or is no longer available.
        //the data returned should be a generic error message.
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;

       Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           insert kav;
        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        //removing assert since article_controller is being replaced with article2_controller
        //system.assertEquals(controller.atom, 'We\'re sorry, this page does not exist.');    
    }
    
    public static TestMethod void testCase3(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter1: Blammo';
           kav.level_2__c = 'Doing Business In';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter1: Blammo';
           kav2.level_2__c = 'Doing Business In';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase4(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.publication_template__c = pt.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.publication_template__c = pt.id;
        insert cs2;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_2__c = 'Doing Business In';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_2__c = 'Doing Business In';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase5(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }
    
    public static TestMethod void testCase6(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter 1 : Testing Kav';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter 1 : Testing Kav';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase7(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter 1 : Testing Kav';
           kav.level_2__c = 'Section 1';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter 1 : Testing Kav';
           kav2.level_2__c = 'Section 1';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase8(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_2__c = 'Section 1';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_2__c = 'Section 1';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase9(){
        //A link is clicked that navigates the user's browser to /km_atom.
        //This test passes when the following 4 variables are returned to the page from the Knowledge Article Type for the 'id' provided:
        //    Title, Last Published Date, Atom, and Summary
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;

       Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           insert kav;
        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
        system.assertNotEquals(controller.atom, null); //make sure that the atom is not empty
        system.assertEquals(controller.atom, 'This is my KAV Atom'); //make sure that the atom matches what was specified in this test
        system.assertEquals(controller.title, 'This is my KAV Title'); //make sure that the title matches what was specified in the test        
    }

    public static TestMethod void testCase10(){
        //A link is somehow clicked to an article that is not published or is no longer available.
        //the data returned should be a generic error message.
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;

       Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           insert kav;
        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
        system.assertEquals(controller.atom, 'We\'re sorry, this page does not exist.');    
    }
    
    public static TestMethod void testCase11(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial Guide';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter1: Blammo';
           kav.level_2__c = 'Doing Business In';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter1: Blammo';
           kav2.level_2__c = 'Doing Business In';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }

    public static TestMethod void testCase12(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial Guide';
        insert pt;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.publication_template__c = pt.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.publication_template__c = pt.id;
        insert cs2;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_2__c = 'Doing Business In';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_2__c = 'Doing Business In';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }

    public static TestMethod void testCase13(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }
    
    public static TestMethod void testCase14(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter 1 : Testing Kav';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter 1 : Testing Kav';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }

    public static TestMethod void testCase15(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter 1 : Testing Kav';
           kav.level_2__c = 'Section 1';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter 1 : Testing Kav';
           kav2.Level_2__c = 'Section 1';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }

    public static TestMethod void testCase16(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_2__c = 'Section 1';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_2__c = 'Section 1';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('printarticle');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        print_article_controller controller = new print_article_controller();
    }

    public static TestMethod void testCase17(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        //testing series list controller
        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Series__c pub2 = new Series__c();
        pub2.name = 'Rocket and Groot';
        pub2.type__c = 'Country Commercial';
        insert pub2;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Level 1';
           kav.level_2__c = 'Section 1';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub2.id;
           kav.level_1__c = 'Level 1';
           kav2.level_2__c = 'Section 1';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        
        SeriesType_Controller controller = new SeriesType_Controller();
        controller.type =  'Country Commercial';
        KnowledgeMap__c ccg = new KnowledgeMap__c();
            ccg.name = 'Country Commercial';
            ccg.api__c = 'Country_Commercial__kav';
            insert ccg;
        controller.recordID = null;
        system.assertEquals(controller.getRecordType(), 'Country_Commercial__kav');
        system.assertEquals(controller.getTypes().size(), 2);
    }
    public static TestMethod void testCase18(){
            Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 2';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 1';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_1__c = 'Chapter1: Blammo';
           kav.level_2__c = 'Doing Business In';
           insert kav;
        Country_Commercial__kav kav2 = new Country_Commercial__kav();
           kav2.title = 'This is my KAV Title 2';
           kav2.atom__c = 'This is my KAV Atom 2';
           kav2.summary = 'This is my KAV Summary 2';
           kav2.references__c = 'This is my KAV Reference 2';
           kav2.urlName = 'this-is-my-kav2';
           kav2.language = 'en_US';
           kav2.series__c = pub.id;
           kav2.level_1__c = 'Chapter1: Blammo';
           kav2.level_2__c = 'Doing Business In';
           insert kav2;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }

    public static TestMethod void testCase19(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 2';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 1';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Chapter1: Blammo';
           kav.level_2__c = 'Doing Business In';
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
    }
    
    public static TestMethod void testCase20(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 2';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Chapter1: Blammo';
           kav.level_2__c = 'Doing Business In';
           kav.level_3__c = 'Test 4';
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('id', 'this-is-my-kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase21(){
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 3';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Test 2';
           kav.level_2__c = 'Test 3';
           kav.level_3__c = 'Test 4';
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('series', pub.id);
            page.getParameters().put('type', 'Country_Commercial__kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase22(){
        //No N1 links
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        /*Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 3';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;*/

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           /*kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Test 2';
           kav.level_2__c = 'Test 3';
           kav.level_3__c = 'Test 4';*/
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('series', pub.id);
            page.getParameters().put('type', 'Country_Commercial__kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase23(){
        //No N2 links
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 3';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        /*Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;*/

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Test 2';
           /*kav.level_2__c = 'Test 3';
           kav.level_3__c = 'Test 4';*/
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('series', pub.id);
            page.getParameters().put('type', 'Country_Commercial__kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase24(){
        //No N3 links
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Country_Commercial__kav';
            pt.Series_Template_Name__c = 'Country Commercial';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 3';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Country Commercial Guide';
        pub.type__c = 'Country Commercial';
        insert pub;
        Country_Commercial__kav kav = new Country_Commercial__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Test 2';
           kav.level_2__c = 'Test 3';
           /*kav.level_3__c = 'Test 4';*/
           insert kav;

        Country_Commercial__kav inserted = [select KnowledgeArticleId from Country_Commercial__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('series', pub.id);
            page.getParameters().put('type', 'Country_Commercial__kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', type__c = 'Country Commercial', endpoint__c = 'http://google.com');
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase25(){
        //Video
        Site__c site = new Site__c();
            site.name = 'Export';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.title__c = 'Export.gov';
            site.Site_CSS__c = '/css/sample.css' ;
            site.site_logo__c = '/img/sample.png';
            site.UseAsDefault__c = false;
        insert site;
        Publication_Template__c pt = new Publication_Template__c();
            pt.name = 'Market_Intelligence__kav';
            pt.Series_Template_Name__c = 'Market Intelligence';
        insert pt;
        Chapter__c chap = new chapter__c();
            chap.name = 'Blammo';
            chap.sort_order__c = 1.0;
            chap.publication_template__c = pt.id;
        insert chap;
        Chapter__c chap2 = new chapter__c();
            chap2.name = 'Blammo';
            chap2.sort_order__c = 1.0;
            chap2.publication_template__c = pt.id;
        insert chap2;

        Chapter_Section__c cs = new Chapter_Section__c();
            cs.name = 'Doing Business In';
            cs.sort_order__c = 1.0;
            cs.chapter__c = chap.id;
        insert cs;
        Chapter_Section__c cs2 = new Chapter_Section__c();
            cs2.name = 'Doing Business In';
            cs2.sort_order__c = 1.0;
            cs2.chapter__c = chap.id;
        insert cs2;
        Level__c lvl0 = new Level__c();
            lvl0.name = 'Test 1';
            lvl0.series_template__c = pt.id;
            lvl0.Level_Number__c = 'Level 0';
            lvl0.sort_order__c = 1;
            insert lvl0;
        Level__c lvl1 = new Level__c();
            lvl1.name = 'Test 2';
            lvl1.series_template__c = pt.id;
            lvl1.Level_Number__c = 'Level 1';
            lvl1.parent_level__c = lvl0.id;
            lvl1.sort_order__c = 1;
            insert lvl1;
        Level__c lvl2 = new Level__c();
            lvl2.name = 'Test 3';
            lvl2.series_template__c = pt.id;
            lvl2.Level_Number__c = 'Level 2';
            lvl2.parent_level__c = lvl1.id;
            lvl2.sort_order__c = 1;
            insert lvl2;
        Level__c lvl3 = new Level__c();
            lvl3.name = 'Test 4';
            lvl3.series_template__c = pt.id;
            lvl3.Level_Number__c = 'Level 3';
            lvl3.parent_level__c = lvl2.id;
            lvl3.sort_order__c = 1;
            insert lvl3;

        Series__c pub = new Series__c();
        pub.name = 'Blammo Market Intelligence Guide';
        pub.type__c = 'Market Intelligence';
        insert pub;
        Content__c video = new Content__c();
        video.Endpoint__c = 'Endpoint';
        video.Video_Description__c = 'Video Description';
        video.Video_Download__c = 'www.google.com';
        video.Video_File_Size__c = '5';
        insert video;
        
        Market_Intelligence__kav kav = new Market_Intelligence__kav();
           kav.title = 'This is my KAV Title';
           kav.atom__c = 'This is my KAV Atom';
           kav.summary = 'This is my KAV Summary';
           kav.references__c = 'This is my KAV Reference';
           kav.urlName = 'this-is-my-kav';
           kav.language = 'en_US';
           kav.series__c = pub.id;
           kav.video__c = video.id;
           /*kav.level_0__c = 'Test 1';
           kav.level_1__c = 'Test 2';
           kav.level_2__c = 'Test 3';
           kav.level_3__c = 'Test 4';*/
           insert kav;

        Market_Intelligence__kav inserted = [select KnowledgeArticleId from Market_Intelligence__kav where id = :kav.id];
        KbManagement.PublishingService.publishArticle(inserted.KnowledgeArticleId, true);
        PageReference page = new PageReference('article');
            page.getParameters().put('series', pub.id);
            page.getParameters().put('type', 'Market_Intelligence__kav');
        Test.setCurrentPage(page);
        KnowledgeSearch__c ks = new KnowledgeSearch__c(name='abc', 
                                                       type__c = 'Market Intelligence',
                                                       endpoint__c = 'http://google.com',
                                                      site__c = URL.getSalesforceBaseUrl().getHost(),
                                                      KAV_or_Category__c = 'Market Intelligence');
        insert ks;
        DescribeDataCategoryGroupResult[] results = Schema.describeDataCategoryGroups(
            new String[] { 'KnowledgeArticleVersion'}
        ); 
        Market_Intelligence__DataCategorySelection ds = new Market_Intelligence__DataCategorySelection();
            ds.parentid = inserted.id;
            ds.DataCategoryGroupName = 'Trade_Topics';
            ds.DataCategoryName = 'Advertising';
        insert ds;
        article_controller controller = new article_controller();
        controller.isSectionalNav = false;
        controller.isStaticNav = false;
        system.assertEquals(controller.getLoggedIn(), true);
        controller.navigation = new map<string, map<string, map<string, string>>>();
        system.assertNotEquals(controller.navObjects.size(), 0);
        system.assertNotEquals(controller.navObjects[0].empty, null);
    }
    
    public static TestMethod void testCase26() {
        //Errors
        Site__c site = new Site__c();
        site.name = 'Export';
        site.domain__c = URL.getSalesforceBaseUrl().getHost();
        site.title__c = 'Export.gov';
        site.Site_CSS__c = '/css/sample.css' ;
        site.site_logo__c = '/img/sample.png';
        site.UseAsDefault__c = false;
        insert site;
        
        article_controller controller = new article_controller();
        PageReference pg = controller.error();
        system.assertEquals('/apex/pagenotfound', pg.getUrl());
         
        controller.pageError = false;
        controller.publicViewing = false;
        controller.customerViewing = false; 
        pg = controller.error();
        system.assertEquals(pg.getParameters().get('retURL'), '/article');
         
        controller.publicViewing = true;
        pg = controller.error();
        system.assertEquals(null, pg);
     }    
}