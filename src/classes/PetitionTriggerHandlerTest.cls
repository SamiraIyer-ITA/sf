/**
 * 
 *    Created by Joshua Moody
 *    on Feb 12 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class PetitionTriggerHandlerTest {

    /************************************************
    * This class performs unit tests on the PetitionTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that date calculations are logically correct
    * 3. Test to ensure that status calculations are logically correct
    *************************************************/

    private static Date petitionDate = Date.newInstance(2018, 10, 7);
    private static User u{
        get{
            if(u == null){
                u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName,
                        Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username
                FROM User WHERE LastName =: 'LastName1' LIMIT 1];
            }
            System.debug('User u: '+u);
            return u;
        }
    }

    //Petition Filed - Scenarios 1, 2, 5
    @isTest static void petitionFiledDateIsValid(){
        Test.startTest();
        String error = '';
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Sat'){
            petitionDate = petitionDate.toStartOfWeek().addDays(-8);//roll back to Saturday
        }
        Holiday h = new Holiday(ActivityDate = petitionDate.addDays(-1), Name = 'Every day is a holiday');//Set previous Friday to holiday
        insert h;
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser){//change context because of holiday insert
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            error = attemptInsert(p);//failed weekend insert
            System.assert(error.contains(''));//needs a portion of Petition Filed on Weekend VR error message
            p.Petition_Filed__c.addDays(-1);
            error = attemptInsert(p);//failed holiday insert
            System.assert(error.contains(''));//needs a portion of Petition Filed on Holiday VR error message
            p.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Petition_Filed__c);//successful insert
            error = attemptInsert(p);
            System.assertNotEquals(p.Id, null);
        }
        Test.stopTest();
    }

    //Initiation Extension - Scenarios 1 and 2
    @isTest static void petitionExtensionBound(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            Master_Automation__c ma = new Master_Automation__c(ValidationRulesEnabled__c = true, WorkflowRulesEnabled__c = true);
            insert ma;
            if (ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri') {//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on a weekday
                petitionDate = petitionDate.toStartOfWeek().addDays(5);
            }
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 21;//out of bounds
            String error = attemptInsert(p);
            System.debug(loggingLevel.Error, '*** error: ' + error);
            System.assert(error.contains('extension cannot exceed more than 20 days'));
            p.Initiation_Extension_of_days__c = 20;//in bounds
            error = attemptInsert(p);
            System.assertEquals(20, [SELECT Id, Initiation_Extension_of_days__c FROM Petition__c WHERE Id = :p.Id].Initiation_Extension_of_days__c);
            Test.stopTest();
        }
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 1
    @isTest static void businessDayCalcWithoutTolling(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            if (ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Mon') {//Set to Monday
                petitionDate = petitionDate.toStartOfWeek().addDays(1);
            }
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day of the week as Petition Filed
            System.debug(p.Petition_Filed__c);
            System.debug(p.Petition_Filed__c.addDays(20));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c).addDays(0));
            insert p;
            System.assertNotEquals(p.Id, null);
            //Petition Filed Date in memory + 20(standard) + 1(extension) + 0(adjustment from trigger) == Calculated Initiation in database
            System.assertEquals(petitionDate.addDays(20).addDays((Integer) (p.Initiation_Extension_of_days__c)),
                    [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Calculated_Initiation_Signature__c);
            Test.stopTest();
        }
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 2
    @isTest static void weekendDayCalcWithoutTolling(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            if (ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri') {//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
                petitionDate = petitionDate.toStartOfWeek().addDays(5);
            }
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
            System.debug(p.Petition_Filed__c);
            System.debug(p.Petition_Filed__c.addDays(20));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c).addDays(2));
            insert p;
            System.assertNotEquals(p.Id, null);
            //Petition Filed Date in memory + 20(standard) + 2(extension) + 2(Saturday and Sunday adjustment from trigger) == Calculated Initiation in database
            System.assertEquals(petitionDate.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c).addDays(2),
                    [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Calculated_Initiation_Signature__c);
            Test.stopTest();
        }
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 3
    @isTest static void weekendDayFollowedByHolidayCalcWithoutTolling(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
            petitionDate = petitionDate.toStartOfWeek().addDays(5);
        }
        Holiday h = new Holiday(ActivityDate = petitionDate.addDays(24), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
        insert h;
        System.runAs(testUser){//change context because of holiday insert
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
            System.debug(p.Petition_Filed__c);
            System.debug(p.Petition_Filed__c.addDays(20));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c).addDays(3));
            insert p;
            System.assertNotEquals(p.Id, null);
            //Petition Filed Date in memory + 20(standard) + 2(extension) + 3(Saturday, Sunday, and holiday Monday adjustment from trigger) == Calculated Initiation in database
            System.assertEquals(petitionDate.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c).addDays(3),
                    [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
        }
        Test.stopTest();
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 4
    @isTest static void holidayCalcWithoutTolling(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Mon'){//If not a Monday, roll forward to the next Monday
            petitionDate = petitionDate.toStartOfWeek().addDays(1);
        }
        Holiday h = new Holiday(ActivityDate = petitionDate.addDays(21), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
        insert h;
        System.runAs(testUser){
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day as Petition Filed
            System.debug(p.Petition_Filed__c);
            System.debug(p.Petition_Filed__c.addDays(20));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c).addDays(1));
            insert p;
            System.assertNotEquals(p.Id, null);
            //Petition Filed Date in memory + 20(standard) + 1(extension) + 1(Holiday adjustment from trigger) == Calculated Initiation in database
            System.assertEquals(petitionDate.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c).addDays(1),
                    [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
        }
        Test.stopTest();
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 5
    @isTest static void businessDay40CalcWithoutTolling(){
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Tuesday
            petitionDate = petitionDate.toStartOfWeek().addDays(5);
        }
        System.runAs(testUser) {
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, false);
            p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
            System.debug(p.Petition_Filed__c);
            System.debug(p.Petition_Filed__c.addDays(20));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c));
            System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer) p.Initiation_Extension_of_days__c).addDays(0));
            insert p;
            System.assertNotEquals(p.Id, null);
            //Petition Filed Date in memory + 20(standard) + 20(extension) + 0(adjustment from trigger) == Calculated Initiation in database
            System.assertEquals(petitionDate.addDays(20).addDays((Integer) (p.Initiation_Extension_of_days__c)),
                    [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Calculated_Initiation_Signature__c);
            Test.stopTest();
        }
    }

    //Business Day Calculation without Tolling Day Consideration - Scenario 6 (not valid, since initiation cannot be more than 20)
    //Business Day Calculation without Tolling Day Consideration - Scenario 7
    /*@isTest static void weekendDayRollbackCalcWithoutTolling(){
        Test.startTest();
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Tue'){//if today is not Monday, move the petition filed date ahead to the next Monday, which puts Calculated Initiation on Monday before rollback
            petitionDate = petitionDate.toStartOfWeek().addDays(2);
        }
        Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
        p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
        System.debug(p.Petition_Filed__c);
        System.debug(p.Petition_Filed__c.addDays(20));
        System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c));
        System.debug(p.Petition_Filed__c.addDays(20).addDays((Integer)p.Initiation_Extension_of_days__c).addDays(-2));
        insert p;
        System.assertNotEquals(p.Id, null);
        //Petition Filed Date in memory + 20(standard) + 20(extension) - 2(Sat and Sun adjustment from trigger) == Calculated Initiation in database
        System.assertEquals(petitionDate.addDays(20).addDays((Integer)(p.Initiation_Extension_of_days__c)).addDays(-2),
            [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
        Test.stopTest();
    }*/

/*    @isTest static void setStatusFromPetition() {
        Test.startTest();
        if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){
            petitionDate = petitionDate.toStartOfWeek().addDays(5);
        }
        Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', true);

        //From Petition
        //Initial Status
        System.assertEquals('In Progress', [SELECT Id, Petition_Outcome__c, Status__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Status__c);//default on Insert

        //Litigation Status - Inactive
        p.Litigation_YesNo__c = 'Yes';
        p.Litigation_Resolved__c = 'No';
        p.Actual_Initiation_Signature__c = petitionDate.addDays(14);
        p.Petition_Outcome__c = 'Initiated from Petition';
        update p;
        System.assertEquals('Litigation', [SELECT Id, Petition_Outcome__c, Status__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Status__c);

        //Closed Status - Withdrawn
        p.Actual_Initiation_Signature__c = null;
        p.Petition_Outcome__c = 'Petition Withdrawn/Did Not Initiate';
        update p;
        System.assertEquals('Litigation', [SELECT Id, Petition_Outcome__c, Status__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Status__c);

        //Closed Status - Rejected
        p.Litigation_YesNo__c = 'No';
        p.Litigation_Resolved__c = '';
        p.Petition_Outcome__c = 'Deficient Petition/Did Not Initiate';
        update p;
        System.assertEquals('Closed', [SELECT Id, Petition_Outcome__c, Status__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Status__c);

        //Self-Initiated
        p.Actual_Initiation_Signature__c = petitionDate.addDays(14);
        p.Petition_Outcome__c = 'Self-Initiated';
        update p;

        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Petition_Outcome__c, Status__c FROM Petition__c WHERE Id =: p.Id LIMIT 1].Status__c);
    }*/

    @isTest static void setNextMajorDeadline() {
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            petitionDate = petitionDate.toStartOfWeek().addDays(-9);//need date in past for Actual to be set in past
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);
            System.assertEquals(p.Calculated_Initiation_Signature__c, p.Next_Major_Deadline__c);

            p.Petition_Outcome__c = 'Initiated from Petition';
            p.Actual_Initiation_Signature__c = Date.newInstance(2018, 10, 7).toStartofWeek().addDays(-5);
            update p;

            Test.stopTest();
            System.assertEquals(null, [SELECT Id, Next_Major_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Major_Deadline__c);
        }
    }

    @isTest static void setNextAnnouncementDate() {
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            petitionDate = petitionDate.toStartOfWeek().addDays(-9);//need date in past for Actual to be set in past
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);
            System.assertEquals(p.Initiation_Announcement_Date__c, p.Next_Announcement_Date__c);

            p.Petition_Outcome__c = 'Initiated from Petition';
            p.Actual_Initiation_Signature__c = petitionDate.addDays(4);
            update p;

            Test.stopTest();
            System.assertEquals(null, [SELECT Id, Next_Announcement_Date__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Announcement_Date__c);
        }
    }

    @isTest static void setNextDueToDasDeadline() {
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            petitionDate = petitionDate.toStartOfWeek().addDays(-9);//need date in past for Actual to be set in past
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);
            System.assertEquals([SELECT Id, Initiation_Issues_Due_to_DAS__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Initiation_Issues_Due_to_DAS__c,
                    [SELECT Id, Next_Due_to_DAS_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Due_to_DAS_Deadline__c);

            p.Actual_Initiation_Issues_to_DAS__c = petitionDate.addDays(4);
            update p;
            System.assertEquals([SELECT Initiation_Concurrence_Due_to_DAS__c FROM Petition__c WHERE Id = :p.Id].Initiation_Concurrence_Due_to_DAS__c,
                    [SELECT Id, Next_Due_to_DAS_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Due_to_DAS_Deadline__c);

            p.Actual_Initiation_Concurrence_to_DAS__c = petitionDate.addDays(7);
            update p;
            System.assertEquals([SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Calculated_Initiation_Signature__c,
                    [SELECT Id, Next_Due_to_DAS_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Due_to_DAS_Deadline__c);

            p.Petition_Outcome__c = 'Initiated from Petition';
            p.Actual_Initiation_Signature__c = Date.newInstance(2018, 10, 7).toStartofWeek().addDays(-5);
            update p;

            Test.stopTest();
            System.assertEquals(null, [SELECT Id, Next_Due_to_DAS_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Due_to_DAS_Deadline__c);
        }
    }

    @isTest static void setNextOfficeDeadline() {
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            petitionDate = petitionDate.toStartOfWeek().addDays(-9);//need date in past for Actual to be set in past
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);
            System.assertEquals([SELECT Id, Initiation_Issues_Due_to_DAS__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Initiation_Issues_Due_to_DAS__c,
                    [SELECT Id, Next_Office_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Office_Deadline__c);

            p.Actual_Initiation_Issues_to_DAS__c = petitionDate.addDays(4);
            update p;
            System.assertEquals([SELECT Initiation_Concurrence_Due_to_DAS__c FROM Petition__c WHERE Id = :p.Id].Initiation_Concurrence_Due_to_DAS__c,
                    [SELECT Id, Next_Office_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Office_Deadline__c);

            p.Actual_Initiation_Concurrence_to_DAS__c = petitionDate.addDays(7);
            update p;
            System.assertEquals([SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Calculated_Initiation_Signature__c,
                    [SELECT Id, Next_Office_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Office_Deadline__c);

            p.Petition_Outcome__c = 'Initiated from Petition';
            p.Actual_Initiation_Signature__c = System.today().toStartofWeek().addDays(-5);
            update p;

            Test.stopTest();
            System.assertEquals(null, [SELECT Id, Next_Office_Deadline__c FROM Petition__c WHERE Id = :p.Id LIMIT 1].Next_Office_Deadline__c);
        }
    }

    @isTest static void setCaseValuesFromParent() {
        Test.startTest();
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);
            Petition__c p = TestUtils.createPetition(testADCase, petitionDate, true);
            Test.stopTest();
            Petition__c savedPetition = [
                    SELECT Id, ADCVD_Case_Number_Text__c, ADCVD_Case_Type_Text__c, CBP_Case_Number_Text__c, Commodity_Text__c,
                            Country_Text__c, Product_Text__c, Product_Short_Name_Text__c
                    FROM Petition__c
                    WHERE ADCVD_Case__c = :testADCase.Id
            ];
            System.assertEquals(testADCase.ADCVD_Case_Number__c, savedPetition.ADCVD_Case_Number_Text__c);
            System.assertEquals(testADCase.ADCVD_Case_Type__c, savedPetition.ADCVD_Case_Type_Text__c);
            System.assertEquals(testADCase.CBP_Case_Number__c, savedPetition.CBP_Case_Number_Text__c);
            System.assertEquals(testADCase.Commodity__c, savedPetition.Commodity_Text__c);
            System.assertEquals(testADCase.Country__c, savedPetition.Country_Text__c);
            System.assertEquals(testADCase.Product__c, savedPetition.Product_Text__c);
            System.assertEquals(testADCase.Product_Short_Name__c, savedPetition.Product_Short_Name_Text__c);
        }
    }

    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User pleaseAssignUser = TestUtils.createAdminUser(false, 'myemail2@email.com.testita', 2);
        pleaseAssignUser.LastName = 'Please Assign';
        pleaseAssignUser.Staffing_Role__c = 'Program Manager';
        insert pleaseAssignUser;
    }

    private static String attemptInsert(SObject o){
        String error = '';
        try{
            insert o;
            error = 'Success';
        } catch (DmlException e) {
            error = e.getMessage();
        }
        return error;
    }
}