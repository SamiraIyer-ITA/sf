@IsTest
public class TEST_WebToLead{
    public static testmethod void Test1(){
        Campaign c = new Campaign(name='Test');
        insert c;
        PageReference pr = Page.CN_MarketingPage;
        Test.setCurrentPage(pr);
        string strurl = ApexPages.currentPage().getUrl();
        if(strurl.contains('apex/')){
            strurl = strurl.split('apex/')[1];
        }

        WebToLead__c w2l = new WebToLead__c(name=strurl, campaignId__c = c.id, return_url__c = '/welcome');
        insert w2l;
        WebToLead controller = new WebToLead();

        controller.lead.firstname = 'Yuge';
        controller.lead.lastname = 'Covfefe';
        controller.lead.company = 'InternetMemes';
        controller.lead.email = 'cats@inter.net';

        pr = controller.Submit();
        system.assertEquals(pr.getURL().contains('welcome'), true);
    }
}