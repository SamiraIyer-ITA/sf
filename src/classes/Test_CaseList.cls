@isTest
public class Test_CaseList {
    /*
    This class handles all of the unit tests related to the caselist controller.
    */  
    static testMethod void assistancePageTest(){
        //SETUP TEST DATA
        Account comAccount = new Account(name='Community Account');
        insert comAccount;
        Contact comContact = new contact(LastName = 'comContact', AccountId = comAccount.Id); //create a contact
            insert comContact;
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        User u1 = new User( email='user@test.com',
                UserName='user@test.com', 
                Alias = 'nuser',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = comContact.Id,
                LastName = 'TestUser',
                ProfileId = p.id,
                CommunityNickname = 'nickname');
        insert(u1);
        case__c[] caserecordtypes = new case__c[]{};
        Case__c rt = new Case__c();
            rt.name = 'Participation';
            //rt.Record_Type_Key__c = String.valueOf([select id from recordtype where sobjecttype ='Case' and name = 'Consultation' limit 1].id).substring(0, 15);
            rt.SiteDomain__c = URL.getSalesforceBaseUrl().getHost();
            rt.icon__c = 'test';
            rt.Sort_Order__c = 1;
            caserecordtypes.add(rt);
        Case__c rt1 = new Case__c();
            rt1.name = 'Business_Service_Providers';
            rt1.Display_Name__c = '11';
            rt1.SiteDomain__c = URL.getSalesforceBaseUrl().getHost();
            rt1.icon__c = 'test';
            rt1.Sort_Order__c = 2;
            caserecordtypes.add(rt1);
        Case__c rt2 = new Case__c();
            rt2.name = 'Documentation';
            //rt2.Record_Type_Key__c = '22';
            rt2.SiteDomain__c = URL.getSalesforceBaseUrl().getHost();
            rt2.icon__c = 'test';
            rt2.Sort_Order__c = 1;
            caserecordtypes.add(rt2);
        Case__c rt3 = new Case__c();
            rt3.name = 'Leads';
            //rt3.Record_Type_Key__c = '33';
            rt3.SiteDomain__c = URL.getSalesforceBaseUrl().getHost();
            rt3.icon__c = 'test';
            rt3.Sort_Order__c = 1;
            caserecordtypes.add(rt3);
        Case__c rt4 = new Case__c();
            rt4.name = 'Technical_Support';
            //rt4.Record_Type_Key__c = '44';
            rt4.SiteDomain__c = URL.getSalesforceBaseUrl().getHost();
            rt4.icon__c = 'test';
            rt4.Sort_Order__c = 1;
            caserecordtypes.add(rt4);
        insert caserecordtypes;
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        //END SETUP TEST DATA
        Test.startTest();
            System.runAs(u1){
                PageReference pageRef = Page.assistance;
                Test.setCurrentPage(pageRef);
                CaseList controller = new CaseList();
                
                RecordType[] types = controller.getRecordTypes();
                map<integer, RecordType[]> types2 = controller.getRecordTypes2();
                
                system.assertEquals(controller.recordtype, null);
                system.assertEquals(controller.casediv, null);
                system.assertEquals(controller.RecordTypeName, '');
                
                controller.save();
                controller.errorValidations();

                ApexPages.currentPage().getParameters().put('recordtypeid', types[0].id);
                ApexPages.currentPage().getParameters().put('casediv', types[0].developername);
                ApexPages.currentPage().getParameters().put('RecordTypeName', types[0].name);
                controller.setRecordTypeId();
                system.assertNotEquals(controller.recordtype, null);
                system.assertNotEquals(controller.casediv, null);
                system.assertNotEquals(controller.RecordTypeName, null);
                controller.cancel();
                System.assertEquals(controller.cancel().getUrl(), '/apex/assistance');
                
                controller.c.contactid=comContact.id;
                controller.c.accountid=comAccount.id;
               
                controller.c.subject = 'Case';
                controller.c.type = 'Case';
                controller.c.description = 'Case';
                
                controller.save();
                System.assertNotEquals(controller.c.id, null); 

                //comment body is present attachment body is null
                controller.comment.IsPublished = true;
                controller.comment.CommentBody = 'Whiskey Tango Foxtrot';
                                
                controller.upload();
                
                system.assertNotEquals(controller.comment.id, null);
                system.assertEquals(controller.comment.CommentBody, 'Whiskey Tango Foxtrot');
                                
                system.assertEquals(controller.attachment.id, null);
            }
        Test.stopTest();
    }
    static testMethod void dashboardPageTest(){
        //SETUP TEST DATA
        Account comAccount = new Account(name='Community Account'); //create account
        insert comAccount;
        Contact comContact = new contact(LastName = 'comContact', AccountId = comAccount.Id); //create contact
            insert comContact;
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        User u1 = new User( email='user@test.com', //create user
                UserName='user@test.com', 
                Alias = 'nuser',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = comContact.Id,
                LastName = 'TestUser',
                ProfileId = p.id,
                CommunityNickname = 'nickname');
        insert(u1);
        Recordtype crt = [select id from recordtype where sobjecttype ='Case' and name = 'Participation' ];
        
        List<Case> casesToCreate = new List<Case>(); //create 15 cases
            for(Integer n=1; n<= 15; n++){
                Case caseToAdd = new Case(Status = 'Action Required', recordtypeid = crt.id, ownerid= u1.id,
                                          contactid=comContact.id, accountid=comAccount.id,
                                          subject = 'Case'+n); 
                casesToCreate.add(caseToAdd);
            } insert casesToCreate;
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = false, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        //END SETUP TEST DATA
        Test.startTest();
            System.runAs(u1){
                PageReference pageRef = Page.dashboard;
                Test.setCurrentPage(pageRef);
                CaseList controller = new CaseList();
           
                controller.changeFilter();
                controller.getTotal_size();
                controller.getPageNumber();
                controller.getTotalPages();
                
                System.assertEquals(controller.getTotal_size(),15);
                System.assertEquals(controller.getPageNumber(),1);             
                System.assertEquals(controller.getTotalPages(),2);
                
                controller.filterid = 'My Company Cases';
                controller.processRequests();
                System.assertEquals(controller.filterid, 'My Company Cases');
                System.assertEquals(controller.getTotal_size(), 15);
                System.assertEquals(controller.results.size(), 10);
                                
                controller.filterid = 'Action Required';
                controller.processRequests();
                System.assertEquals(controller.getTotal_size(), 15);
                System.assertEquals(controller.results.size(), 10);

                controller.filterid = 'My Open Cases';
                controller.processRequests();
                System.assertEquals(controller.getTotal_size(), 15);
                System.assertEquals(controller.results.size(), 10);
                
                controller.filterid = '';
                controller.processRequests();
                System.assertEquals(controller.getTotal_size(), 15);
                System.assertEquals(controller.results.size(), 10);
                
                controller.filterid = 'My Closed Cases';
                controller.processRequests();
                System.assertEquals(controller.getTotal_size(), 15);
                System.assertEquals(controller.results.size(), 0);

                controller.SortField = 'CaseNumber';
                System.assertEquals(controller.SortField, 'CaseNumber');
                controller.SortDirection = 'desc';
                System.assertEquals(controller.SortDirection, 'desc');
                controller.SortToggle();
                System.assertEquals(controller.SortDirection, 'asc');
                
                controller.getDisablePrevious();
                controller.getDisableNext();
            
                System.assertEquals(True,controller.getDisablePrevious());
                System.assertEquals(False,controller.getDisableNext());
                
                controller.Beginning();
                System.assertEquals(controller.getPageNumber(),1);
                controller.Next();
                System.assertEquals(controller.getPageNumber(),2);
                controller.Previous();
                System.assertEquals(controller.getPageNumber(),1);
                controller.End();
                System.assertEquals(controller.getPageNumber(),2);
                
                controller.Total_size = 0;
                System.assertEquals(controller.getTotalPages(), 0);
                
                controller.NewCase();
                System.assertEquals(controller.NewCase().getUrl(), '/apex/assistance');
            }
        Test.stopTest();
    }
    static testMethod void statusPageTest(){
        //SETUP TEST DATA
        Account comAccount = new Account(name='Community Account');
        insert comAccount;
        Contact comContact = new contact(LastName = 'comContact', AccountId = comAccount.Id); //create a contact
            insert comContact;
        Recordtype crt = [SELECT id, name, developername FROM recordtype WHERE sobjecttype ='Case' AND name = 'Participation' ];
        Case c = new Case(); 
        c.status = 'New';
        c.recordtypeid = crt.id;
        c.contactid=comContact.id;
        c.accountid=comAccount.id;
        c.subject = 'Case';
        insert c;
        Profile p = [select id from profile where name = 'Customer Trade Community User'];        
        User u1 = new User( email='user@test.com',
                UserName='user@test.com', 
                Alias = 'nuser',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = comContact.Id,
                LastName = 'TestUser',
                ProfileId = p.id,
                CommunityNickname = 'nickname');
        insert(u1);
        Case__c rt = new Case__c();
            rt.name = 'Participation';
            rt.Display_Name__c = 'Superman';
            rt.SiteDomain__c = 'export.gov';
            rt.icon__c = 'test';
            rt.Sort_Order__c = 1;
        insert(rt);
        
        Site__c sites = new Site__c(name = 'Export.gov', 
                                    title__c = 'Export.gov', 
                                    domain__c = URL.getSalesforceBaseUrl().getHost(), 
                                    UseAsDefault__c = true, 
                                    site_css__c = '/css/sample.css', 
                                    site_logo__c = '/img/sample.png');
        insert sites;
        
        String caseRT = case__c.getAll().get('Participation').display_name__c;
        //END SETUP TEST DATA
        Test.startTest();
            System.runAs(u1){
                PageReference pageRef = Page.status;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id',c.id);
                 
                CaseList controller = new CaseList();
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
               	controller.caseRT = caseRT;
                system.assertEquals(controller.caseRT, 'Superman');
                //No comment or attachment body
                //controller.comment.IsPublished = true;
                //controller.attachment.Name='Unit Test Attachment';
                
                //controller.upload();

                //system.assertEquals(controller.comment.id, null);
                //system.assertEquals(controller.attachment.id, null);
                
                //No comment body
                //controller.attachment.Name='Unit Test Attachment';
                //controller.attachment.body = bodyBlob;
                
                //controller.upload();

                //system.assertEquals(controller.comment.id, null);
                //system.assertEquals(controller.attachment.id, null);

                //Both attachment and comment body are present
                controller.comment.IsPublished = true;
                controller.comment.CommentBody = 'Whiskey Tango Foxtrot';
                controller.attachment.Name='Unit Test Attachment';
                controller.attachment.body = bodyBlob;
                
                controller.upload();
                controller.toggleContent();
                controller.toggleAttachment();
                
                //system.assertNotEquals(controller.comment.id, null);
                //system.assertEquals(controller.comment.CommentBody, 'Whiskey Tango Foxtrot');
                                
                //system.assertNotEquals(controller.attachment.id, null);
                //system.assertEquals(controller.attachment.body, bodyBlob);

            }
        Test.stopTest();
    }
   
}