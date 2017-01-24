@isTest(seeAllData=false)
public class Test_REST_Content { 
    // Unit Test Class for REST_CONTENT controller.
    static testMethod void NullSince(){
        //set test data
        RecordType rt = [Select id 
                        from RecordType
                        Where sobjecttype = 'content__c'
                        and name = 'generic content'
                        limit 1];
        RecordType pcRT = [Select id 
                        from RecordType
                        Where sobjecttype = 'Page_Content__c'
                        and name = 'generic content'
                        limit 1];
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        Page__c pg = new Page__c(name = 'Test Page',
                                site__c = sites.id,
                                clean_url__c = 'test.com');
        insert pg;
        Row__c r = new Row__c(name= 'Test Row',
                             page__c = pg.id);
        insert r;
        Content__c c = new Content__c(RecordTypeid = rt.Id,
                                       name = 'Test Content',
                                      Content__c = 'testing');
                                      //status__c = 'Draft');
        insert c;
        Page_Content__c pc1 = new Page_Content__c(RecordTypeid = pcRT.Id,
                                                  page__c = pg.id,
                                                Row__c = r.id,
                                                Content__c= c.id,
                                                 SortOrder__c=1,
                                                 display_Content_Name__c = true);
        insert pc1;
        //end test data 
        Test.startTest();
            RestRequest req = new RestRequest();  
            RestResponse res = new RestResponse();  
        
            //Long dt = Long.valueOf(RestContext.request.params.get('since'));
            DateTime dtime = pg.LastModifiedDate;
        
            req.requestURI = sites.Domain__c+'/services/apexrest/content';
            req.addParameter('site', sites.domain__c);
            req.addParameter('since', null);
            req.httpMethod = 'GET';
        
            REST_CONTENT.content results = new REST_CONTENT.content();
            results.title = 'Test';
            results.url= 'test';
            results.description = 'test';
            results.content = 'test';
            
            RestContext.request = req; 
            RestContext.response = res; 
            
            
            String Domain = RestContext.request.params.get('site');
            DateTime since;
            
            System.assertEquals(Domain, sites.domain__c);
            System.assertEquals(since, null);
            REST_CONTENT.get(); 
            System.assertEquals(res.statusCode, 400);
        Test.stopTest();
    }
    static testMethod void nullSite(){
        //set test data
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        //end test data
        Test.startTest();
            RestRequest req = new RestRequest();  
            RestResponse res = new RestResponse();  

            Long dtime = DateTime.now().getTime();
            //Long dt = dtime.formatLong();
            String sString = String.valueOf(dtime);
        
            req.requestURI = sites.Domain__c+'/services/apexrest/content';
            //req.addParameter('site', sites.domain__c);
            req.addParameter('since', sString);
            req.httpMethod = 'GET';
        
            REST_CONTENT.content results = new REST_CONTENT.content();
            results.title = 'Test';
            results.url= 'test';
            results.description = 'test';
            results.content = 'test';
            
            RestContext.request = req; 
            RestContext.response = res; 
            
            String domain = null;
            Long timestamp = Long.valueOf(RestContext.request.params.get('since'));
                DateTime dt = DateTime.newInstance(timestamp);
            DateTime since = dt;
        
            REST_CONTENT.get(); 
        
            System.assertNotEquals(Domain, sites.domain__c);
            System.assertEquals(since, DateTime.newInstance(dtime));
            System.assertEquals(res.statusCode, 400);
        Test.stopTest();
    }
    static testMethod void validParam(){
        //set test data
        RecordType rt = [Select id 
                        from RecordType
                        Where sobjecttype = 'content__c'
                        and name = 'generic content'
                        limit 1];
        RecordType pcRT = [Select id 
                        from RecordType
                        Where sobjecttype = 'Page_Content__c'
                        and name = 'generic content'
                        limit 1];
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        Page__c pg = new Page__c(name = 'Test Page',
                                site__c = sites.id);
        insert pg;
        Row__c r = new Row__c(name= 'Test Row',
                             page__c = pg.id);
        insert r;
        Content__c c = new Content__c(RecordTypeid = rt.Id,
                                       name = 'Test Content',
                                      Content__c = 'testing');
                                      //status__c = 'Draft');
        insert c;
        Page_Content__c pc1 = new Page_Content__c(RecordTypeid = pcRT.Id,
                                                  page__c = pg.id,
                                                  Row__c = r.id,
                                                  Content__c= c.id,
                                                  SortOrder__c=1,
                                                  display_Content_Name__c = true);
        insert pc1;
        //end test data
        Test.startTest();
            RestRequest req = new RestRequest();  
            RestResponse res = new RestResponse();  

            Long dtime = DateTime.now().getTime();
            String sString = String.valueOf(dtime);
        
            req.requestURI = sites.Domain__c+'/services/apexrest/content';
            req.addParameter('site', sites.domain__c);
            req.addParameter('since', sString);
            req.httpMethod = 'GET';
        
            REST_CONTENT.content results = new REST_CONTENT.content();
            results.title = 'Test';
            results.url= 'test';
            results.description = 'test';
            results.content = 'test';
            
            RestContext.request = req; 
            RestContext.response = res; 
            
            String Domain = RestContext.request.params.get('site');
            Long timestamp = Long.valueOf(RestContext.request.params.get('since'));
                DateTime dt = DateTime.newInstance(timestamp);
            DateTime since = dt;
        
            System.assertEquals(Domain, sites.domain__c);
            System.assertEquals(since, DateTime.newInstance(dtime));
            REST_CONTENT.get(); 
            System.assertEquals(res.statusCode, 200);
        Test.stopTest();
    }
    static testMethod void sinceExceptions(){
        //set test data
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        //end test data
        Test.startTest();
            RestRequest req = new RestRequest();  
            RestResponse res = new RestResponse();  

            String sString = 'Invalid dateTime';
        
            req.requestURI = sites.Domain__c+'/services/apexrest/content';
            req.addParameter('site', sites.domain__c);
            req.addParameter('since', sString);
            req.httpMethod = 'GET';
            
            RestContext.request = req; 
            RestContext.response = res; 
        
            REST_CONTENT.get(); 

        Test.stopTest();
    }
    static testMethod void unexpectedException(){
        //set test data
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        //end test data
        Test.startTest();
            RestRequest req = new RestRequest();  
            RestResponse res = new RestResponse();  

            String sString = 'Invalid dateTime';
            String d = '123456';
        
            req.requestURI = sites.Domain__c+'/services/apexrest/content';
            req.addParameter('site', d);
            req.addParameter('since', sString);
            req.httpMethod = 'GET';
            
            RestContext.request = req; 
            RestContext.response = res; 
        
            REST_CONTENT.get(); 

        Test.stopTest();
    }
}