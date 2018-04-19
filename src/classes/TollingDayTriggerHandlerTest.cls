/**
 * 
 *    Created by Joshua Moody
 *    on Feb 10 2017
 *    MIL Corporation
 * 
 *    Updated by Eitan Alfiya
 * 
 **/

@isTest
public class TollingDayTriggerHandlerTest {

    /************************************************
    * This class performs unit tests on the TollingDayTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that records in scope are correct
    * 3. Test to ensure that date calculations are logically correct
    *************************************************/

    private static Date petitionDate {
        get {
            if(petitionDate == null){
                petitionDate = System.today();
                //petitionDate = petitionDate.today();
            }
            return petitionDate;
        }
    }
    private static Date futureTollingDateStart = System.today().addDays(6);
    private static Date futureTollingDateEnd = System.today().addDays(10);

    private static Date pastTollingDateStart = System.today().addDays(-10);
    private static Date pastTollingDateEnd = System.today().addDays(-6);

    private static User u{
        get{
            if(u == null){
                u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
                                Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
                            FROM User WHERE LastName =: 'LastName1' LIMIT 1];
            }
            return u;
        }
    }
    //calls db everytime
    private static List<Petition__c> petitionList {
        get {
            petitionList = [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c];
            return petitionList;
        }
    }
    //calls db everytime
    private static List<Tolling_Day__c> tdList {
        get {
            tdList = [SELECT Id, Start_Date__c, End_Date__c FROM Tolling_Day__c];
            return tdList;
        }
    }

    @isTest static void setFutureDatesInScope(){
        Test.startTest();
        System.assertEquals(TollingDayTriggerHandler.earliestDate, null);//nulls prior to insert
        System.assertEquals(TollingDayTriggerHandler.latestDate, null);
        Tolling_Day__c td = TestUtils.createTollingDay(futureTollingDateStart, futureTollingDateEnd, u, true);
        TollingDayTriggerHandler.setDatesInScope(tdList);

        Test.stopTest();
        System.assertEquals(TollingDayTriggerHandler.earliestDate, futureTollingDateStart);//equal to the tolling day scope
        System.assertEquals(TollingDayTriggerHandler.maxLatestDate, futureTollingDateEnd);
    }
    @isTest static void setPastDatesInScope(){
        Test.startTest();
        System.assertEquals(TollingDayTriggerHandler.earliestDate, null);//nulls prior to insert
        System.assertEquals(TollingDayTriggerHandler.latestDate, null);
        Tolling_Day__c td = TestUtils.createTollingDay(pastTollingDateStart, pastTollingDateEnd, u, true);
        TollingDayTriggerHandler.setDatesInScope(tdList);

        Test.stopTest();
        System.assertEquals(TollingDayTriggerHandler.earliestDate, pastTollingDateStart);//equal to the tolling day scope
        System.assertEquals(TollingDayTriggerHandler.maxLatestDate, pastTollingDateEnd);
    }

//    @isTest static void recalculatePastPetitionTollingDay(){
//        insertAppConfig();
//        Test.startTest();
//        Tolling_Day__c td = TestUtils.createTollingDay(pastTollingDateStart, pastTollingDateEnd, u, true);//add 5 tolling days
//        Test.stopTest();
        //Petition_Filed + 20(standard) + 3 Extension + 5 tollingdays = Petition Calculated_Initiation_Signature__c
//        System.assertEquals(petitionDate.addDays(28), [SELECT Calculated_Initiation_Signature__c 
//                                                              FROM Petition__c 
//                                                            WHERE Petition_Filed__c =: petitionDate
//                                                          LIMIT 1].Calculated_Initiation_Signature__c);
//    }
//    @isTest static void recalculateFuturePetitionTollingDay(){
//        insertAppConfig();
//        Test.startTest();
//        Tolling_Day__c td = TestUtils.createTollingDay(futureTollingDateStart, futureTollingDateEnd, u, true);//add 5 tolling days
//        Test.stopTest();
//        //Petition_Filed + 20(standard) + 3 Extension + 5 tollingdays = Petition Calculated_Initiation_Signature__c
//        System.assertEquals(petitionDate.addDays(28), [SELECT Calculated_Initiation_Signature__c 
//                                                                FROM Petition__c 
//                                                                WHERE Petition_Filed__c =: petitionDate
//                                                                LIMIT 1].Calculated_Initiation_Signature__c);
//    }
    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);//TestUtils creates with a 3 day extension
        System.debug('Petition_Filed__c ' + p.Petition_Filed__c);
    }
    
    public static void insertAppConfig() {
                AppConfig__c app = new AppConfig__c();
                app.Name = 'default';
                app.Primary_Admin__c = 'sandip.menon@trade.gov'; 
                app.ADCVD_Admin__c = 'joshua.moody@trade.gov';
                app.TriggersEnabled__c = true;
                app.AppEnabled__c = true;
                app.Go_Live_Date__c = Date.newInstance(2018, 2, 15);
                app.ChronExp_LitigationSegement__c = ' 0 ' + string.valueOf((system.now().addMinutes(30)).minute()) + ' ' + string.valueOf((system.now().addMinutes(30)).hour()) + ' ' + string.valueOf(system.today().day()) + ' ' + string.valueOf(system.today().Month()) + ' ?';
                system.debug('app.ChronExp_LitigationSegement__c = ' + app.ChronExp_LitigationSegement__c);
                app.ChronExpr_PetitionInvestigation__c = '0 0 1 ' +  string.valueOf((system.today().addDays(1)).day()) + ' ' + string.valueOf(system.today().addDays(1).month()) + ' ?';
                system.debug('ChronExpr_PetitionInvestigation__c = ' + app.ChronExpr_PetitionInvestigation__c); 
                insert app;
    }   
}