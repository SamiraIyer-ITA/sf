/**
 * 
 *    Created by Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

@IsTest
private class PetitionChatterPostWriterTest {

    private static ADCVD_Case__c c;
    private static Date petitionDate = Date.newInstance(2019, 3, 5);

    private static ADCVD_Case__c testADCase;
    private static Petition__c newP;

    @IsTest
    static void testCheckConditions() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Initiation_Extension_of_days__c = 5;

        Petition__c oldP = newP.clone(true, true, true, true);//TestUtils.createPetition(testADCase, petitionDate, false);
        oldP.Initiation_Extension_of_days__c = 6;

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();
        newP.Calculated_Initiation_Signature__c = null;
        pcpw = new PetitionChatterPostWriter();
        pcpw.checkConditions(newP, oldP);

        //since Calculated_Initiation_Signature__c is null, no chatter post
        System.assert(pcpw.getMap(false).get(newP.Id) == null);

        newP.Calculated_Initiation_Signature__c = petitionDate;
        pcpw.checkConditions(newP, oldP);

        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>The Calculated Initiation Signature date is: <b>3/5/2019</b></p>'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>Initiation Extension Number of Days changed from 6 to 5</p>'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }
    @IsTest
    static void testInitiationExtensionChanged() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Initiation_Extension_of_days__c = 5;

        Petition__c oldP = newP.clone(true, true, true, true);//TestUtils.createPetition(testADCase, petitionDate, false);
        oldP.Initiation_Extension_of_days__c = 6;

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();
        newP.Calculated_Initiation_Signature__c = null;
        pcpw = new PetitionChatterPostWriter();
        pcpw.checkConditions(newP, oldP);

        //since Calculated_Initiation_Signature__c is null, no chatter post
        System.assert(pcpw.getMap(false).get(newP.Id) == null);

        newP.Calculated_Initiation_Signature__c = petitionDate;
        pcpw.checkConditions(newP, oldP);

        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>The Calculated Initiation Signature date is: <b>3/5/2019</b></p>'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>Initiation Extension Number of Days changed from 6 to 5</p>'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }

    @IsTest
    static void testLitigationNoChange() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';

        Petition__c oldP = newP.clone(true, true, true, true);

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();

        //old - yes/yes -- new - yes/yes
        pcpw.litigationChanged(newP, oldP);
        System.assert(pcpw.getMap(false).get(newP.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationNoChange2() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';

        Petition__c oldP = newP.clone(true, true, true, true);

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();

        //old - yes/yes -- new - no/blank
        newP.Litigation_YesNo__c = 'No';
        newP.Litigation_Resolved__c = '';
        pcpw = new PetitionChatterPostWriter();
        pcpw.litigationChanged(newP, oldP);
        System.assert(pcpw.getMap(false).get(newP.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationLitigated() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';

        Petition__c oldP = newP.clone(true, true, true, true);

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();

        //old - no/blank -- new - yes/no
        oldP.Litigation_YesNo__c = 'No';
        oldP.Litigation_Resolved__c = '';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'No';
        pcpw = new PetitionChatterPostWriter();
        pcpw.litigationChanged(newP, oldP);
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('Litigation Status has changed'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('is being litigated.'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('Link to record:'));

        Test.stopTest();

    }
    @IsTest
    static void testLitigationLitigatedNotLitigated() {
        dataSetup();
        newP.Product_Short_Name_Text__c = 'Test Short Name';
        newP.Country_Text__c = 'Belarus';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';

        Petition__c oldP = newP.clone(true, true, true, true);

        Test.startTest();

        PetitionChatterPostWriter pcpw = new PetitionChatterPostWriter();

        //old - yes/no -- new - yes/yes
        oldP.Litigation_YesNo__c = 'Yes';
        oldP.Litigation_Resolved__c = 'No';
        newP.Litigation_YesNo__c = 'Yes';
        newP.Litigation_Resolved__c = 'Yes';
        pcpw = new PetitionChatterPostWriter();
        pcpw.litigationChanged(newP, oldP);
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('Litigation Status has changed'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('is not being litigated.'));
        System.assert(pcpw.getMap(false).get(newP.Id).get(0).contains('Link to record:'));
    }

    @testSetup static void dataSetup() {
        // Create ADCVD_Case record
        testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', false);
        Id newCaseId = fflib_IDGenerator.generate(ADCVD_Case__c.SObjectType);
        testADCase.Id = newCaseId;

        newP = TestUtils.createPetition(testADCase, petitionDate, false);
        newP.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);
    }
}