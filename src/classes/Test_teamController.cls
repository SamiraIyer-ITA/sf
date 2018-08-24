@isTest(seealldata = false)
public class Test_teamController {
    /*
    This class handles all of the unit tests related to the teamController controller.
    */ 
    static testMethod void test1(){//with a recordtype set
        //setup test data
        page__c testpage = new page__c();
            testpage.name = 'testpage';
        insert testpage;
        
        id rt = [select id from recordtype where sobjecttype = 'section__c' and name = 'office'].id;
        id lkpage = [select id from page__c where name = 'testpage'].id;
        section__c[] teams = new section__c[]{};
        section__c sec1 = new section__c();
            sec1.recordtypeid = rt;
            sec1.name = 'team1';
            sec1.page__c = lkpage;
        section__c sec2 = new section__c();
            sec2.recordtypeid = rt;
            sec2.name = 'team2';
            sec2.page__c = lkpage;
        section__c sec3 = new section__c();
            sec3.recordtypeid = rt;
            sec3.name = 'team3';
            sec3.page__c = lkpage;
        section__c sec4 = new section__c();
            sec4.recordtypeid = rt;
            sec4.name = 'team4';
            sec4.page__c = lkpage;
           
            teams.add(sec1);
            teams.add(sec2);
            teams.add(sec3);
            teams.add(sec4);
        insert teams;
        //End data setup
        PageReference pageRef = Page.team;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('type','office');
        system.assertEquals(ApexPages.currentPage().getParameters().get('type'), 'office');
        teamController controller = new teamController(); 
        section__c[] sections = controller.getteamList();
        system.assertEquals(sections.size(), 4);
    }
    static testMethod void test2(){//without a recordtype set
        //setup test data
        page__c testpage = new page__c();
            testpage.name = 'testpage';
        insert testpage;
        
        id rt = [select id from recordtype where sobjecttype = 'section__c' and name = 'office'].id;
        id lkpage = [select id from page__c where name = 'testpage'].id;
        section__c[] teams = new section__c[]{};
        section__c sec1 = new section__c();
            sec1.recordtypeid = rt;
            sec1.name = 'team1';
            sec1.page__c = lkpage;
        section__c sec2 = new section__c();
            sec2.recordtypeid = rt;
            sec2.name = 'team2';
            sec2.page__c = lkpage;
        section__c sec3 = new section__c();
            sec3.recordtypeid = rt;
            sec3.name = 'team3';
            sec3.page__c = lkpage;
        section__c sec4 = new section__c();
            sec4.recordtypeid = rt;
            sec4.name = 'team4';
            sec4.page__c = lkpage;
           
            teams.add(sec1);
            teams.add(sec2);
            teams.add(sec3);
            teams.add(sec4);
        insert teams;
        //End data setup
        PageReference pageRef = Page.team;
        Test.setCurrentPage(pageRef);
        teamController controller = new teamController(); 
        section__c[] sections = controller.getteamList();
        system.assertEquals(sections, null);
    }
}