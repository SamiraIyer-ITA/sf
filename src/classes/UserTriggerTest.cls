@isTest
public class UserTriggerTest {
    @isTest
    private static void testUserTrigger() {
        User Usr = new User();
        Usr.Alias = 'asdfas';
        Usr.AD_User_Id__c = 'email@test.com';
        Usr.EmailEncodingKey = 'UTF-8';
        Usr.LanguageLocaleKey = 'en_US';
        Usr.LocaleSidKey = 'en_US';
        Usr.ProfileId = [Select id from profile where name = 'ITA User Read Only'].id;
        Usr.username = 'Username@esawtds.com';
        Usr.ITA_Office__c = 'OLDOFF';
        Usr.Lastname = 'sadfasdf';
        Usr.TimeZoneSidKey = 'America/New_York';
        insert Usr;
        Usr.ProfileId = [Select id from profile where name = 'System Administrator'].id;
        usr.Updated_by_Last_AD_Run__c = true;
        usr.isActive = false;
        update Usr;
		Usr.ProfileId = [Select id from profile where name = 'ITA User Read Only'].id;
        update Usr;
        Usr = [Select FederationIdentifier, Email from User where id =: usr.id];
        system.assertEquals(Usr.FederationIdentifier, 'email@test.com');
        system.assertEquals(Usr.Email, 'email@test.com');
    }
}