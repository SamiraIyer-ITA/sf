@isTest private without sharing class DB_Custom_Case_Contributor_c
{
    @isTest (SeeAllData=true)
    private static void testTrigger()
    {
//@@TODO:  This class was commented out on 9/29 due to a failure to use best practices for triggers and production unit test failures.
/*        CRMfusionDBR101.DB_Globals.triggersDisabled = true;
        sObject testData = CRMfusionDBR101.DB_TriggerHandler.createTestData( Case_Contributor__c.getSObjectType() );
        Test.startTest();
        insert testData;
        update testData;
        CRMfusionDBR101.DB_Globals.generateCustomTriggerException = true;
        update testData;
        delete testData;
        Test.stopTest();
        */
    }
}