@isTest
public class SuspensionAgreementTriggerHandlerTest {
    private static Date suspDate = System.today();
    private static Date testActual = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
    private static Date testCalculated = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
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
                sa = [SELECT Id, Anniversary_Month__c, Suspension_Date__c, Investigation__c, Office__c, Next_Sunset_Initiation_Date__c, Termination_Date__c FROM Suspension_Agreement__c LIMIT 1];
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
    /*@isTest static void setCaseValuesFromParent() {
        Test.startTest();
        ADCVD_Case__c testCase = TestUtils.createADCVDCase('A-111-123', 'AD ME', true);
        Petition__c testPetition = TestUtils.createPetition(suspDate.addDays(-14),'AD ME', false);
        testPetition.ADCVD_Case__c = testCase.Id;
        insert testPetition;        
        Investigation__c testInvestigation = TestUtils.createInvestigation('AD', testPetition, true);
        Suspension_Agreement__c testSuspAgr = TestUtils.createSuspensionAgreement(testInvestigation, suspDate, true); 
        Test.stopTest();
        Suspension_Agreement__c savedSuspAgrmnt = [SELECT Id, ADCVD_Case__c, ADCVD_Case_Number__c
                                                  FROM Suspension_Agreement__c WHERE ADCVD_Case__c =: testCase.Id];
        System.assertEquals(testCase.Id, savedSuspAgrmnt.ADCVD_Case__c);
        System.assertEquals(testCase.ADCVD_Case_Number__c, savedSuspAgrmnt.ADCVD_Case_Number__c);
        System.assertEquals(testPetition.ADCVD_Case__c, savedSuspAgrmnt.ADCVD_Case__c);
    }    
       

    @isTest static void setNextSunsetInitiationDate() {
        Test.startTest();
        System.assertEquals(null, sa.Next_Sunset_Initiation_Date__c); 
        setFR(sa.Id, 'Suspension Agreement', true); 
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
    */
    @isTest static void setAnniversaryMonth() {
        Test.startTest();
        setFR(sa.Id, 'Suspension Agreement', true);
        String month = utils.getMonthFromDate(suspDate);
        sa = null;
        
        Test.stopTest();
        System.assertEquals(month, sa.Anniversary_Month__c);
    }

/*    @isTest static void validateEffectiveDateOfTermination() {
        Test.startTest();

        //add setup FRs
        List<Federal_Register__c> frList = new List<Federal_Register__c>();
        suspensionAgreementFR =  setFR(sa.Id, 'Suspension Agreement', false);
        termFR = setFR(sa.Id, 'Termination', false);
        frList.add(suspensionAgreementFR);
        frList.add(termFR);
        insert frList;

        //test validation on order FR
        sa.Effective_Date_of_Termination__c = suspDate.addYears(6);
        String validationError = attemptUpsert(sa);
        System.assert(validationError.contains('Suspension Agreement Federal Register Published Date:'));

        //add continuation FR
        continuationFR = setFR(sa.Id, 'Continuation', false);
        continuationFR.Published_Date__c = continuationFR.Published_Date__c.addDays(14);
        insert continuationFR;

        //test validationon continuation FR
        validationError = attemptUpsert(sa);
        System.assert(validationError.contains('most recent Continuation Federal Register Published Date:'));

        //test successful insert
        sa.Effective_Date_of_Termination__c = suspDate.addYears(-2);
        validationError = attemptUpsert(sa);

        Test.stopTest();
        System.assert(validationError.contains('Success'));

    }
*/
    @testSetup static void dataSetup() {
        Test.startTest();
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, suspDate.addDays(-14), true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        Suspension_Agreement__c testADSuspAgreement = TestUtils.createSuspensionAgreement(testADinvestigation, suspDate, true);
        /*List<Segment__c> segsToInsert = new List<Segment__c>();
        System.runAs(testUser) {
            for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
                Segment__c testSeg = TestUtils.createSegment(testSuspAgr, segRecordTypeName, false);
                segsToInsert.add(testSeg);
            }
            insert segsToInsert;
        }*/
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