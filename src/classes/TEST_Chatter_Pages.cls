@isTest(seealldata = false)
public class TEST_Chatter_Pages{

public static testMethod void GroupsList(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        chatter.add(new CollaborationGroup(name='Chatter Second', collaborationtype = 'Public'));
        chatter.add(new CollaborationGroup(name='Chatter Third', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    Group_Controller controller = new Group_Controller();
}

public static testMethod void Join(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
    System.runAs(u){
        Group_Controller.join(chatter[0].id);
    }
}

public static testMethod void Leave(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
    System.runAs(u){
        Group_Controller.join(chatter[0].id);
        Group_Controller.leave(chatter[0].id);
    }
}

public static testMethod void getFeeds(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
      Group_Controller.getFeeds(chatter[0].id);

}

public static testMethod void saveFeed(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
      Group_Controller.saveFeed(new FeedItem(ParentId = chatter[0].Id, Body= '<p>Test</p>', IsRichText= true));
}

public static testMethod void saveReply(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
      Group_Controller.saveFeed(new FeedItem(ParentId = chatter[0].Id, Body= '<p>Test</p>', IsRichText= true));
      CollaborationGroupFeed[] feeds = Group_Controller.getFeeds(chatter[0].id);
      system.assertEquals(feeds.size(), 1);
      Group_Controller.saveReply(new FeedComment(FeedItemId= feeds[0].id, CommentBody= 'Test Reply', CommentType= 'TextComment'));
}

public static testMethod void addLike(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
      Group_Controller.saveFeed(new FeedItem(ParentId = chatter[0].Id, Body= '<p>Test</p>', IsRichText= true));
      CollaborationGroupFeed[] feeds = Group_Controller.getFeeds(chatter[0].id);
      system.assertEquals(feeds.size(), 1);
      Group_Controller.addLike(feeds[0].id);
}

public static testMethod void existingData(){
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

    collaborationGroup[] chatter = new CollaborationGroup[]{};
        chatter.add(new CollaborationGroup(name='Chatter Test', collaborationtype = 'Public'));
        insert chatter;
        FeedItem fi = new FeedItem(ParentId = chatter[0].Id, Body= '<p>Test</p>', IsRichText= true);
        insert fi;
        FeedComment fc = new FeedComment(FeedItemId= fi.id, CommentBody= 'Test Reply', CommentType= 'TextComment');
        insert fc;
    PageReference pageRef = Page.group;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().put('id', chatter[0].id);
    Group_Controller controller = new Group_Controller();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User u = new User(Alias = 'abc1wq', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='abc12q@testorg.com');
}
}