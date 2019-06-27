/**
 * 
 *    Created by Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

@IsTest
private class InvestigationChatterPostWriterTest {

    private static Date petitionDate = Date.newInstance(2019, 3, 5);
    private static Date investigationDate = Date.newInstance(2019, 3, 5);

    private static ADCVD_Case__c testADCase;
    private static Petition__c petition;
    private static Petition__c petition2;
    private static Investigation__c newI;

    @IsTest
    static void testCheckConditions() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);
        newI.Prelim_Extension_of_days__c = 1;
        newI.Calculated_Preliminary_Signature__c = null;
        oldI.Prelim_Extension_of_days__c = 2;

        Test.startTest();
        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        icpw = new InvestigationChatterPostWriter();
        icpw.checkConditions(newI, oldI);
        //Calculated_Preliminary_Signature__c is null
        System.assert(icpw.getMap(false).get(newI.Id) == null);

        Test.stopTest();
    }

    @IsTest
    static void testPrelimExtensionChanged() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);
        newI.Prelim_Extension_of_days__c = 1;
        newI.Calculated_Preliminary_Signature__c = investigationDate;
        oldI.Prelim_Extension_of_days__c = 2;

        Test.startTest();
        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        icpw = new InvestigationChatterPostWriter();
        icpw.checkConditions(newI, oldI);
        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>The Calculated Preliminary Signature date is: <b>3/5/2019</b></p>'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>Preliminary Extension Number of Days changed from 2 to 1</p>'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }

    @IsTest
    static void testFinalExtensionChanged() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);
        newI.Final_Extension_of_days__c = 1;
        newI.Calculated_Final_Signature__c = null;
        oldI.Final_Extension_of_days__c = 2;

        Test.startTest();
        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        icpw = new InvestigationChatterPostWriter();
        icpw.finalExtensionChanged(newI, oldI);
        //Calculated_Final_Signature__c is null
        System.assert(icpw.getMap(false).get(newI.Id) == null);

        newI.Final_Extension_of_days__c = 1;
        newI.Calculated_Final_Signature__c = investigationDate;
        oldI.Final_Extension_of_days__c = 2;

        icpw = new InvestigationChatterPostWriter();
        icpw.finalExtensionChanged(newI, oldI);
        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>The Calculated Final Signature date is: <b>3/5/2019</b></p>'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>Final Extension Number of Days changed from 2 to 1</p>'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }

    @IsTest
    static void testLitigationNoChange() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);

        newI.Litigation_YesNo__c = 'Yes';
        newI.Litigation_Resolved__c = 'Yes';

        Test.startTest();

        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        //old - yes/yes -- new - yes/yes
        icpw.litigationChanged(newI, oldI);
        System.assert(icpw.getMap(false).get(newI.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationNoChange2() {
        dataSetup();

        newI.Litigation_YesNo__c = 'Yes';
        newI.Litigation_Resolved__c = 'Yes';
        Investigation__c oldI = newI.clone(true, true, true, true);

        Test.startTest();

        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        //old - yes/yes -- new - no/blank
        newI.Litigation_YesNo__c = 'No';
        newI.Litigation_Resolved__c = '';
        icpw = new InvestigationChatterPostWriter();
        icpw.litigationChanged(newI, oldI);
        System.assert(icpw.getMap(false).get(newI.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationLitigated() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);

        Test.startTest();

        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        //old - no/blank -- new - yes/no
        oldI.Litigation_YesNo__c = 'No';
        oldI.Litigation_Resolved__c = '';
        newI.Litigation_YesNo__c = 'Yes';
        newI.Litigation_Resolved__c = 'No';
        icpw = new InvestigationChatterPostWriter();
        icpw.litigationChanged(newI, oldI);
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('Litigation Status has changed'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('is being litigated.'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('Link to record:'));

        Test.stopTest();

    }
    @IsTest
    static void testLitigationLitigatedNotLitigated() {
        dataSetup();

        Investigation__c oldI = newI.clone(true, true, true, true);

        Test.startTest();

        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        //old - yes/no -- new - yes/yes
        oldI.Litigation_YesNo__c = 'Yes';
        oldI.Litigation_Resolved__c = 'No';
        newI.Litigation_YesNo__c = 'Yes';
        newI.Litigation_Resolved__c = 'Yes';
        icpw = new InvestigationChatterPostWriter();
        icpw.litigationChanged(newI, oldI);
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('Litigation Status has changed'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('is not being litigated.'));
        System.assert(icpw.getMap(false).get(newI.Id).get(0).contains('Link to record:'));

        Test.stopTest();
    }
    @IsTest
    static void testAlignmentChanged() {

        dataSetup();

        //create aligned to investigations
        Investigation__c alignedToInv1 = TestUtils.createInvestigation(petition, false);
        alignedToInv1.Id = fflib_IDGenerator.generate(Investigation__c.SObjectType);
        Investigation__c alignedToInv2 = TestUtils.createInvestigation(petition2, false);
        alignedToInv2.Id = fflib_IDGenerator.generate(Investigation__c.SObjectType);


        Investigation__c oldI = newI.clone(true, true, true, true);

        Test.startTest();

        InvestigationChatterPostWriter icpw = new InvestigationChatterPostWriter();
        //old - yes/no -- new - yes/yes
        oldI.AD_Investigation_Aligned_To__c = null;
        newI.AD_Investigation_Aligned_To__c = alignedToInv2.Id;
        icpw = new InvestigationChatterPostWriter();
        icpw.alignmentChanged(newI, oldI);

        System.assert(icpw.getMap(false).get(newI.Id ).get(0).contains('Alignment to another record has changed on '));
        System.assert(icpw.getMap(false).get(newI.Id ).get(0).contains('Alignment has been added'));
        System.assert(icpw.getMap(false).get(newI.Id ).get(0).contains('Link to record:'));

        Test.stopTest();
    }
    @testSetup static void dataSetup() {
        // Create ADCVD_Case record
        testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', false);
        testADCase.Id = fflib_IDGenerator.generate(ADCVD_Case__c.SObjectType);

        petition = TestUtils.createPetition(testADCase, petitionDate, false);
        petition.Calculated_Initiation_Signature__c = petitionDate;
        petition.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);

        petition2 = TestUtils.createPetition(testADCase, petitionDate, false);
        petition2.Calculated_Initiation_Signature__c = petitionDate;
        petition2.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);

        newI = TestUtils.createInvestigation(petition, false);
        newI.Id = fflib_IDGenerator.generate(Investigation__c.SObjectType);
    }

}