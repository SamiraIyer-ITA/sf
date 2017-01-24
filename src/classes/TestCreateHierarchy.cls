@isTest
private class TestCreateHierarchy {
    
    @isTest (seealldata = true)
    static void TestCreateHierarchyTrigger() {
        Department_Taxonomy__c DT = new Department_Taxonomy__c();
        DT.Level_0__c = 'LV0';
        DT.All__c = 'LV0';
        DT.DAS__c = 'LV0';
        DT.Region_2__c = 'LV0';
        DT.Region_1__c = 'LV0';
        DT.Country__c = 'LV0';
        DT.Old_Office_Name__c = 'OLDOFF';
        Insert DT;
        User Usr = new User();
        Usr.Alias = 'asdfas';
        Usr.Email = 'email@test.com';
        Usr.EmailEncodingKey = 'UTF-8';
        Usr.LanguageLocaleKey = 'en_US';
        Usr.LocaleSidKey = 'en_US';
        Usr.ProfileId = [Select id from profile where name = 'Read Only'].id;
        Usr.username = 'Username@esawtds.com';
        Usr.ITA_Office__c = 'OLDOFF';
        Usr.Lastname = 'sadfasdf';
        Usr.TimeZoneSidKey = 'America/New_York';
        insert Usr;
        }
    }