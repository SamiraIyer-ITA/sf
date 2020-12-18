/**
 * 
 *    Created by Joshua Moody
 *    on May 16 2017
 *    MIL Corporation
 * 
 **/
 @isTest
public class SuspensionAgreementTriggerHandlerTest {
    /************************************************
    * This class performs unit tests on the SuspensionAgreementTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that date calculations are logically correct
    *************************************************/
    
    private static Date baseDate = Date.newInstance(2018, 10, 7);

    private static Date suspDate = baseDate;
    private static Date testActual = baseDate;//reusable date variable for each test to add roll forward logic allowing data normalization
    private static Date testCalculated = baseDate;//reusable date variable for each test to add roll forward logic allowing data normalization
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
    private static Suspension_Agreement__c sa{
        get{
            if (sa == null) {
                sa = [SELECT Id, ADCVD_Case__c, Anniversary_Month__c, Suspension_Date__c, Investigation__c, Office__c, Next_Sunset_Initiation_Date__c, Termination_Date__c FROM Suspension_Agreement__c LIMIT 1];
            }
            return sa;
        }
    }
    private static Federal_Register__c suspensionAgreementFR{
        get{
            if (suspensionAgreementFR == null) {
                suspensionAgreementFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Suspension Agreement' LIMIT 1];
            }
            return suspensionAgreementFR;
        }
    }
    private static Federal_Register__c continuationFR{
        get{
            if (continuationFR == null) {
                continuationFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Continuation' LIMIT 1];
            }
            return continuationFR;
        }
    }
    private static Federal_Register__c termFR{
        get{
            if (termFR == null) {
                termFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Termination' LIMIT 1];
            }
            return termFR;
        }
    }

    @isTest static void initialize(){
        Test.startTest();
        List<Suspension_Agreement__c> aList = new List<Suspension_Agreement__c>();
        aList.add(sa);
        SuspensionAgreementTriggerHandler.initialize(aList, null);

        Test.stopTest();
        System.assert(SuspensionAgreementTriggerHandler.frUtilMap.isEmpty());
    }

    //Test to check if Suspension Agreement is auto-populated with ADCVD Case number
    @isTest static void setCaseValuesFromParent() {
    
        Test.startTest();
        User testUser = [SELECT Id FROM User WHERE EMAIL=:'myemail@email.com.testita1' LIMIT 1];
        
        ADCVD_Case__c testCase = TestUtils.createADCVDCase('A-123-125', 'AD ME', testUser,true);
        Petition__c testPetition = TestUtils.createPetition(testCase,suspDate.addDays(-14), true);
        //insert testPetition;
        Investigation__c testInvestigation = TestUtils.createInvestigation(testPetition, true);
        Suspension_Agreement__c testSuspAgr = TestUtils.createSuspensionAgreement(testInvestigation, suspDate, true); 
        Test.stopTest();
        Suspension_Agreement__c savedSuspAgrmnt = [SELECT Id, ADCVD_Case__c, ADCVD_Case_Number_Text__c
                                                  FROM Suspension_Agreement__c WHERE ADCVD_Case__c =: testCase.Id];
        System.assertEquals(testCase.Id, savedSuspAgrmnt.ADCVD_Case__c);
        System.assertEquals(testCase.ADCVD_Case_Number__c, savedSuspAgrmnt.ADCVD_Case_Number_Text__c);
        System.assertEquals(testPetition.ADCVD_Case__c, savedSuspAgrmnt.ADCVD_Case__c);
    }
       

    @isTest static void setNextSunsetInitiationDate() {
        Test.startTest();
        System.assertEquals(null, sa.Next_Sunset_Initiation_Date__c);
        //Create a JSON string from the Federal Register object to be able to modify the CreatedDate
        String frJSON = JSON.serialize(new Federal_Register__c());
        Map<String, Object> frJSONMap = (Map<String, Object>)JSON.deserializeUntyped(frJSON);
        frJSONMap.put('CreatedDate', baseDate.addDays(-1));
        frJSONMap.put('Type__c','Suspension Agreement');
        frJSONMap.put('Cite_Number__c','3rfef');
        frJSONMap.put('Published_Date__c', baseDate.addDays(5));
        frJSONMap.put('Suspension_Agreement__c', sa.Id);
        String frJSON2 = JSON.serialize(frJSONMap);
        //Deserialize string back to FR object and commit to database
        Federal_Register__c suspensionAgreementFR = (Federal_Register__c)JSON.deserializeStrict(frJSON2, Federal_Register__c.class);
        insert suspensionAgreementFR;
        sa = null;
        testCalculated = suspDate.toStartOfMonth().addYears(4).addMonths(11);
        System.assertEquals(testCalculated, sa.Next_Sunset_Initiation_Date__c);
        suspDate = suspDate.addMonths(1);
        setFR(sa.Id, 'Continuation', true);
        sa = null;
        testCalculated = suspDate.toStartOfMonth().addYears(4).addMonths(11);
        System.assertEquals(testCalculated, sa.Next_Sunset_Initiation_Date__c);
        suspDate = suspDate.addMonths(1);
        setFR(sa.Id, 'Termination', true);
        sa = null;
        Test.stopTest();
        System.assertEquals(null, sa.Next_Sunset_Initiation_Date__c);

    }

    @isTest static void setAnniversaryMonth() {
        Test.startTest();
        setFR(sa.Id, 'Suspension Agreement', true);
        String month = utils.getMonthFromDate(suspDate);
        sa = null;
        
        Test.stopTest();
        System.assertEquals(month, sa.Anniversary_Month__c);
    }

    @testSetup static void dataSetup() {
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        //create test data
        Test.startTest();
        User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
            AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
            
            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);
            Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
            Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
            Suspension_Agreement__c testADSuspAgreement = TestUtils.createSuspensionAgreement(testADinvestigation, suspDate, true);
        
        }
        
    }

    private static Federal_Register__c setFR(Id parentId, String frType, Boolean doInsert) {
        Federal_Register__c testFR = TestUtils.createFR(parentId, 'Suspension_Agreement__c', suspDate, frType, doInsert);
        return testFR;
    }

    private static String attemptUpsert(SObject o){
        String error = '';
        try{
            upsert o;
            error = 'Success';
        } catch (DmlException e) {
            error = e.getMessage();
        }
        return error;
    }
}