@isTest
public class TEST_activitytrigger {
    static testMethod void afterinsert(){
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
                CommunityNickname = 'nickname', 
                RH_Lev_6_Office__c = 'opm-ita', 
                RH_Lev_7_Individual__c = 'opm-ita',
                RH_Lev_4_Region_1__c = 'opm-ita',
                RH_Lev_3_Region_2__c = 'opm-ita',
                RH_Lev_2_DAS_Level__c = 'opm-ita',
                RH_Lev_1_Top_Level__c = 'opm-ita',
                RH_Lev_5_Country__c = 'opm-ita');
        insert(u1);
        task[] myT = new task[]{};
        task t = new Task(Status = 'Not Started', ownerid= u1.id,
                                  priority = 'Normal', 
                                  subject = 'subject'); 
        myT.add(t);
		insert myT;
        Test.startTest();
        	activityTriggerHandler controller = new activityTriggerHandler();
        	controller.afterInsert(myT);
        	//System.assertEquals(myT[0].RH_Lev_6_Office__c, 'opm-ita');
        Test.stopTest();
    }
    static testMethod void afterupdate(){
        Account a = new Account(name='Community Account');
        insert a;
        Contact c = new contact(LastName = 'comContact', AccountId = a.Id); //create a contact
            insert c;
        Contact cc = new contact(LastName = 'comContact', AccountId = a.Id); //create a contact
            insert cc;
        Profile p = [select id from profile where name = 'Customer Trade Community User'];
        User u1 = new User( email='user@test.com',
                UserName='user@test.com', 
                Alias = 'nuser',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = c.Id,
                LastName = 'TestUser',
                ProfileId = p.id,
                CommunityNickname = 'nickname', 
                RH_Lev_6_Office__c = 'opm-ita2', 
                RH_Lev_7_Individual__c = 'opm-ita2',
                RH_Lev_4_Region_1__c = 'opm-ita2',
                RH_Lev_3_Region_2__c = 'opm-ita2',
                RH_Lev_2_DAS_Level__c = 'opm-ita2',
                RH_Lev_1_Top_Level__c = 'opm-ita2',
                RH_Lev_5_Country__c = 'opm-ita2');
        insert(u1);
        User u2 = new User( email='user2@test.com',
                UserName='user2@test.com', 
                Alias = 'nuser',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = cc.Id,
                LastName = 'TestUser',
                ProfileId = p.id,
                CommunityNickname = 'nickname2', 
                RH_Lev_6_Office__c = 'opm-ita', 
                RH_Lev_7_Individual__c = 'opm-ita',
                RH_Lev_4_Region_1__c = 'opm-ita',
                RH_Lev_3_Region_2__c = 'opm-ita',
                RH_Lev_2_DAS_Level__c = 'opm-ita',
                RH_Lev_1_Top_Level__c = 'opm-ita',
                RH_Lev_5_Country__c = 'opm-ita');
        insert(u2);
        task t = new Task(Status = 'Not Started', ownerid= u1.id,
                                  priority = 'Normal', 
                                  subject = 'subject'); 
		insert t;
        Test.startTest();
        	activityTriggerHandler controller = new activityTriggerHandler();
        	task myTask = new task();
        	myTask.id = t.id;
        	myTask.OwnerId = u2.id;
        	update(myTask);
        	//System.assertEquals(t.Original_Office__c, 'opm-ita');
        Test.stopTest();
    }
}