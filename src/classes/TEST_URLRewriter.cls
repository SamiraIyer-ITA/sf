@isTest(seealldata = false)
public class TEST_URLRewriter{
    public static TestMethod void testCase1(){
        //positive test case
        URL__c url = new URL__c();
        url.friendly__c = '/csl-search';
        url.real__c = '/article';
        insert url;
        urlRewriter page = new urlRewriter();        
        String actualResult = page.mapRequestUrl(new PageReference('/csl-search')).getUrl();
        System.assertEquals(actualResult, '/article');
    }
    
    public static TestMethod void testCase2(){
        //negative test case with null url
        urlRewriter page = new urlRewriter();
        System.assertEquals(page.generateUrlFor(null),null);
    }
    
    public static TestMethod void testCase3(){
        //negative test case with unmapped url
        URL__c url = new URL__c();
        url.friendly__c = '/csl-search';
        url.real__c = '/article';
        insert url;
        urlRewriter page = new urlRewriter();        
        PageReference pr = page.mapRequestUrl(new PageReference('/cslsearch'));
        system.assertEquals(pr.getURL(), '/apex/pagenotfound');
        
    }
    
    public static TestMethod void testCase4(){
        //positive test with page__c on the URL__c
        Page__c page = new Page__c();
            page.name = 'New Page';
            insert page;
        Url__c url = new Url__c();
            url.friendly__c = '/csl-search';
            url.real__c = '/article';
            url.page__c = page.id;
            insert url;
        urlRewriter pg = new urlRewriter();
        String result = pg.mapRequestURL(new PageReference('/csl-search')).getURL();
        system.assertEquals(result, '/apex/page?id='+page.id);
    }

    public static TestMethod void testCase5(){
        //positive test with page__c on a Clean_URL__c
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.site__c = site.id;
            insert page;
        Url__c u = new Url__c();
            u.friendly__c = '/csl-search';
            insert u;
        Clean_URL__c clean = new Clean_URL__c();
            clean.url__c = u.id;
            clean.site__c = site.id;
            clean.page__c = page.id;
            insert clean;
        urlRewriter pg = new urlRewriter();
        String result = pg.mapRequestURL(new PageReference('/csl-search')).getURL();
        system.assertEquals(result, '/apex/page?id='+page.id);
    }

    public static TestMethod void testCase6(){
        //positive test with page__c on a Clean_URL__c
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.site__c = site.id;
            insert page;
        Url__c u = new Url__c();
            u.friendly__c = '/csl-search';
            insert u;
        Clean_URL__c clean = new Clean_URL__c();
            clean.url__c = u.id;
            clean.site__c = site.id;
            clean.Non_Page_URL__c = '/article';
            insert clean;
        urlRewriter pg = new urlRewriter();
        String result = pg.mapRequestUrl(new PageReference('/csl-search')).getUrl();
        system.assertEquals(result, '/article');
    }
    
    public static TestMethod void testCase7(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.site__c = site.id;
            insert page;
        Page__c p = [select id, clean_url__c from Page__c where id = :page.id limit 1];
        system.assertEquals(p.clean_url__c, '/New-Page');
    }
    
    public static TestMethod void testCase8(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.clean_url__c = '/New Page 2';
            page.site__c = site.id;
            insert page;
        Page__c p = [select id, clean_url__c from Page__c where id = :page.id limit 1];
        system.assertEquals(p.clean_url__c, '/New-Page-2');
    }

    public static TestMethod void testCase9(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        URL__c u = new URL__c(friendly__c = 'New-Page-2');
            insert u;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.clean_url__c = 'New Page 2';
            page.site__c = site.id;
            insert page;
        Page__c p = [select id, clean_url__c from Page__c where id = :page.id limit 1];
        system.assertEquals(p.clean_url__c, '/New-Page-2');
    }

    public static TestMethod void testCase10(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        URL__c u = new URL__c(friendly__c = '/New-Page-2');
            insert u;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.clean_url__c = 'New Page';
            page.site__c = site.id;
            insert page;
        Page__c p = [select id, clean_url__c from Page__c where id = :page.id limit 1];

        Page__c page2 = new Page__c();
            page2.name = 'New Page';
            page2.clean_url__c = 'New Page';
            page2.site__c = site.id;

        String message = '';
        try{
            insert page2;
        }catch(Exception e){
            message = e.getMessage();
        }
        system.assertEquals([select id from page__c].size(), 1);
    }

    public static TestMethod void testCase11(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        URL__c u = new URL__c(friendly__c = '/New-Page-2');
            insert u;
        Page__c page = new Page__c();
            page.name = 'New Page';
            page.clean_url__c = 'New Page';
            page.site__c = site.id;
            insert page;
        site.Default_Page__c = page.id;
        update site;
        Page__c p = [select id, clean_url__c from Page__c where id = :page.id limit 1];
        Clean_URL__c clean = new Clean_URL__c();
            clean.url__c = u.id;
            clean.site__c = site.id;
            clean.Non_Page_URL__c = '/servlet.FileDownload';
            insert clean;
            
        string message = '';
        urlRewriter pg = new urlRewriter();
        PageReference pr = new PageReference('/'+clean.url__c);
        pg.mapRequestUrl(pr).getUrl();
    }

    public static TestMethod void testCase12(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Url__c u = new Url__c();
            u.friendly__c = '/csl-search';
            insert u;
        Clean_URL__c clean = new Clean_URL__c();
            clean.url__c = u.id;
            clean.site__c = site.id;
            clean.Non_Page_URL__c = '/servlet.FileDownload?test=false';
            insert clean;
        urlRewriter page = new urlRewriter();        
        String actualResult = page.mapRequestUrl(new PageReference(u.friendly__c)).getUrl();
    }
    
    public static TestMethod void testCase13(){
        Site__c site = new Site__c();
            site.name = 'Test Site';
            site.domain__c = URL.getSalesforceBaseUrl().getHost();
            site.Site_CSS__c = '/css/site.cs';
            insert site;
        Url__c u = new Url__c();
            u.friendly__c = '/csl-search';
            u.real__c = '/servlet.FileDownload?test=false';
            insert u;

        urlRewriter page = new urlRewriter();        
        String actualResult = page.mapRequestUrl(new PageReference(u.friendly__c)).getUrl();
    }
}