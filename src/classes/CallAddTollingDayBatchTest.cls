/**
 * Created by Patrick Childers on 6/26/2020.
 */

@IsTest
public with sharing class CallAddTollingDayBatchTest {

    private static Date tollingDateStart = System.today();
    private static Date tollingDateEnd = System.today().addDays(5);
    private static User u {
        get{
            if(u == null){
                u = new User();
                u = [SELECT Id FROM User LIMIT 1];
            }
            return u;
        }
        set;
    }

    private static Petition__c adp {
        get{
            if(adp == null){
                adp = new Petition__c();
                adp = [SELECT Id FROM Petition__c LIMIT 1];
            }
            return adp;
        }
        set;
    }

    @isTest static void tollingDayList(){
        //System.assert(ADCVD_TollingDayUtility.tollingDayList.size() == 1);
    }

    @isTest static void callBatch(){
        Test.startTest();
        CallAddTollingDayBatch.callBatch();
        Test.stopTest();
        System.assertNotEquals(null, CallAddTollingDayBatch.batchProcessId, 'batchProcessId is null and has not been initialized');
    }

    @IsTest static void RequestVariables(){
        new CallAddTollingDayBatch.RequestVariables();
    }

    @isTest static void setLastDateStandardTolling(){
        Test.startTest();
        String maxDateTest = CallAddTollingDayBatch.setLastDate();
        Test.stopTest();
        System.assertEquals(String.valueOf(tollingDateEnd), maxDateTest, 'maxDateTest does not equal tollingDateEnd');
    }

    @isTest static void setLastDateSpecificTolling(){
        Date diffTollingDateEnd = System.today().addDays(10);
        Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, diffTollingDateEnd, u, false);
        td.RecordTypeId = Schema.SObjectType.Tolling_Day__c.getRecordTypeInfosByDeveloperName().get('Toll_By_Specific_Record').getRecordTypeId();
        td.Petition__c = adp.Id;
        insert td;
        Test.startTest();
        String maxDateTest = CallAddTollingDayBatch.setLastDate();
        Test.stopTest();
        System.assertEquals(String.valueOf(diffTollingDateEnd), maxDateTest, 'maxDateTest does not equal diffTollingDateEnd');
    }

    @testSetup static void dataSetup() {
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.comtest', 1 );

        System.runAs(testUser) {

            //create custom setting configuration to activate triggers, workflow rules, and validation rules
            Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
            AppConfig__c ac = TestUtils.createAppConfig('default', true, true);

            //create test data
            Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);

            ADCVD_Case__c testAdCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);

            Petition__c testAdPetition = TestUtils.createPetition(testAdCase, System.today().addDays(-5), true);
        }
    }
}