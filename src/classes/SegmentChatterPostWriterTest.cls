/**
 * 
 *    Created by Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

@IsTest
private class SegmentChatterPostWriterTest {

    private static Date petitionDate = Date.newInstance(2019, 3, 5);
    private static Date investigationDate = Date.newInstance(2019, 3, 5);
    private static Date segmentDate = Date.newInstance(2019, 3, 5);

    private static ADCVD_Case__c testADCase;
    private static Petition__c petition;
    private static Petition__c petition2;
    private static Investigation__c newI;
    private static ADCVD_Order__c testADOrder;
    private static Segment__c newS;

    @IsTest
    static void testCheckConditions() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        newS.Initiation_Extension_of_days__c = 9;
        oldS.Initiation_Extension_of_days__c = 9;

        Test.startTest();
        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        scpw = new segmentChatterPostWriter();
        scpw.checkConditions(newS, oldS);
        //Calculated_Preliminary_Signature__c is null
        System.assert(scpw.getMap(false).get(newI.Id) == null);

        Test.stopTest();
    }

    @IsTest
    static void testInitiationExtensionChanged() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        newS.Initiation_Extension_of_days__c = 9;
        newS.Calculated_Initiation_Signature__c = segmentDate;
        oldS.Initiation_Extension_of_days__c = 5;

        Test.startTest();
        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        scpw = new segmentChatterPostWriter();
        scpw.initiationExtensionChanged(newS, oldS);

        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>The Calculated Initiation Signature date is: <b>3/5/2019</b></p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Initiation Extension Number of Days changed from 5 to 9</p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }
    @IsTest
    static void testPrelimExtensionChanged() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        newS.Prelim_Extension__c = 9;
        newS.Calculated_Preliminary_Signature__c = segmentDate;
        oldS.Prelim_Extension__c = 5;

        Test.startTest();
        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        scpw = new segmentChatterPostWriter();
        scpw.prelimExtensionChanged(newS, oldS);

        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>The Calculated Preliminary Signature date is: <b>3/5/2019</b></p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Preliminary Extension Number of Days changed from 5 to 9</p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }

    @IsTest
    static void testFinalExtensionChanged() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        newS.Final_Extension_of_days__c = 9;
        newS.Calculated_Final_Signature__c = segmentDate;
        oldS.Final_Extension_of_days__c = 5;

        Test.startTest();
        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        scpw = new segmentChatterPostWriter();
        scpw.finalExtensionChanged(newS, oldS);

        //Calculated_Initiation_Signature__c and Initiation_Extension_of_days__c has changed so we have a chatter post
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>The Calculated Final Signature date is: <b>3/5/2019</b></p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Final Extension Number of Days changed from 5 to 9</p>'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('<p>Link to record:'));

        Test.stopTest();
    }

    @IsTest
    static void testLitigationNoChange() {

        dataSetup();

        newS.Litigation_YesNo__c = 'Yes';
        newS.Litigation_Resolved__c = 'Yes';

        Segment__c oldS = newS.clone(true, true, true, true);

        Test.startTest();

        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        //old - yes/yes -- new - yes/yes
        scpw.litigationChanged(newS, oldS);
        System.assert(scpw.getMap(false).get(newS.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationNoChange2() {

        dataSetup();

        newS.Litigation_YesNo__c = 'Yes';
        newS.Litigation_Resolved__c = 'Yes';

        Segment__c oldS = newS.clone(true, true, true, true);

        Test.startTest();

        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        //old - yes/yes -- new - no/blank
        newS.Litigation_YesNo__c = 'No';
        newS.Litigation_Resolved__c = '';
        scpw = new SegmentChatterPostWriter();
        scpw.litigationChanged(newS, oldS);
        System.assert(scpw.getMap(false).get(newI.Id) == null);

        Test.stopTest();


    }
    @IsTest
    static void testLitigationLitigated() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        Test.startTest();

        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        //old - no/blank -- new - yes/no
        oldS.Litigation_YesNo__c = 'No';
        oldS.Litigation_Resolved__c = '';
        newS.Litigation_YesNo__c = 'Yes';
        newS.Litigation_Resolved__c = 'No';
        scpw = new SegmentChatterPostWriter();
        scpw.litigationChanged(newS, oldS);
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Litigation Status has changed'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('is being litigated.'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Link to record:'));

        Test.stopTest();

    }
    @IsTest
    static void testLitigationLitigatedNotLitigated() {

        dataSetup();

        Segment__c oldS = newS.clone(true, true, true, true);

        Test.startTest();

        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        //old - yes/no -- new - yes/yes
        oldS.Litigation_YesNo__c = 'Yes';
        oldS.Litigation_Resolved__c = 'No';
        newS.Litigation_YesNo__c = 'Yes';
        newS.Litigation_Resolved__c = 'Yes';
        scpw = new SegmentChatterPostWriter();
        scpw.litigationChanged(newS, oldS);
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Litigation Status has changed'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('is not being litigated.'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Link to record:'));

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

        Segment__c oldS = newS.clone(true, true, true, true);

        Test.startTest();

        SegmentChatterPostWriter scpw = new SegmentChatterPostWriter();
        //old - yes/no -- new - yes/yes
        oldS.Administrative_Review_Aligned_To__c = null;
        newS.Administrative_Review_Aligned_To__c = alignedToInv2.Id;
        scpw = new SegmentChatterPostWriter();
        scpw.alignmentChanged(newS, oldS);

        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Alignment to another record has changed on '));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Alignment has been added'));
        System.assert(scpw.getMap(false).get(newS.Id).get(0).contains('Link to record:'));

        Test.stopTest();
    }

    @testSetup static void dataSetup() {
        // Create ADCVD_Case record
        testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', false);
        testADCase.Id = fflib_IDGenerator.generate(ADCVD_Case__c.SObjectType);

        petition = TestUtils.createPetition(testADCase, petitionDate, false);
        petition.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);

        petition2 = TestUtils.createPetition(testADCase, petitionDate, false);
        petition2.Id = fflib_IDGenerator.generate(Petition__c.SObjectType);

        newI = TestUtils.createInvestigation(petition, false);
        newI.Id = fflib_IDGenerator.generate(Investigation__c.SObjectType);

        testADOrder = TestUtils.createOrder(newI, false);
        testADOrder.Id = fflib_IDGenerator.generate(ADCVD_Order__c.SObjectType);

        newS = TestUtils.createSegment(testADOrder, 'New Shipper Review', false);
        newS.Id = fflib_IDGenerator.generate(Segment__c.SObjectType);
        newS.RecordTypeId = Schema.SObjectType.Segment__c.getRecordTypeInfosByName().get('New Shipper Review').getRecordTypeId();

    }

}