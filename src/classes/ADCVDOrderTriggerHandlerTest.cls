/**
 * 
 *    Created by Joshua Moody
 *    on May 10 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class ADCVDOrderTriggerHandlerTest {

    /************************************************
    * This class performs unit tests on the ADCVDOrderTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that date calculations are logically correct
    * 3. Test to ensure that status calculations are logically correct
    *************************************************/

    private static Date orderDate = System.today();
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
    private static ADCVD_Order__c o{
        get{
            if (o == null) {
                o = [SELECT Id, ADCVD_Case__c, Anniversary_Month__c, Investigation__c, Office__c, Segment_Status__c, Status__c, Next_Sunset_Initiation_Date__c FROM ADCVD_Order__c LIMIT 1];
            }
            return o;
        }
    }
    private static Federal_Register__c orderFR{
        get{
            if (orderFR == null) {
                orderFR = [SELECT Id, ADCVD_Case__c, ADCVD_Order__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Order' LIMIT 1];
            }
            return orderFR;
        }
    }
    private static Federal_Register__c continuationFR{
        get{
            if (continuationFR == null) {
                continuationFR = [SELECT Id, ADCVD_Order__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Continuation' LIMIT 1];
            }
            return continuationFR;
        }
    }
    private static Federal_Register__c revoFR{
        get{
            if (revoFR == null) {
                revoFR = [SELECT Id, ADCVD_Order__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Revocation' LIMIT 1];
            }
            return revoFR;
        }
    }
    private static Segment__c adminSeg{
        get{
            if (adminSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                adminSeg = [SELECT Id, RecordTypeId, Status__c, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c,
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c 
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return adminSeg;
        }
    }
    private static Segment__c nsSeg{
        get{
            if (nsSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('New_Shipper_Review');
                nsSeg = [SELECT Id, RecordTypeId, Status__c, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Calculated_Initiation_Signature__c,
                                Actual_Initiation_Signature__c, Calculated_Final_Signature__c, Actual_Preliminary_Signature__c, Actual_Final_Signature__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return nsSeg;
        }
    }
    private static Segment__c siSeg{
        get{
            if (siSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Scope_Inquiry');
                siSeg = [SELECT Id, Status__c, Deadline_for_Decision_on_How_to_Proceed__c, Initiation_Extension_of_days__c, RecordTypeId, Request_Filed__c, 
                                Prelim_Extension__c, Calculated_Preliminary_Signature__c, Actual_Date_of_Decision_on_HoP__c, Calculated_Final_Signature__c 
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return siSeg;
        }
    }
    private static Segment__c expedSeg{
        get{
            if (expedSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Expedited_Review');
                expedSeg = [SELECT Id, RecordTypeId, Status__c, Prelim_Extension__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return expedSeg;
        }
    }
    private static Segment__c acSeg{
        get{
            if (acSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Anti_Circumvention_Review');
                acSeg = [SELECT Id, RecordTypeId, Status__c, Prelim_Extension__c, Initiation_Extension_of_days__c, Calculated_Preliminary_Signature__c,
                                    Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    Application_Accepted__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return acSeg;
        }
    }
    private static Segment__c ccSeg{
        get{
            if (ccSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Changed_Circumstances_Review');
                ccSeg = [SELECT Id, RecordTypeId, Status__c, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Is_This_Review_Expedited__c,
                                    Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    All_parties_in_agreement_to_the_outcome__c, Request_Filed__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ccSeg;
        }
    }
    private static Segment__c ssSeg{
        get{
            if (ssSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Sunset_Review');
                ssSeg = [SELECT Id, Status__c, Calculated_Final_Signature__c, Update_ACE_Customs_Module__c, Adequacy_of_Respondents_Submission__c, 
                            Actual_Final_Signature__c, Actual_Revocation_or_Continuation_FR__c, Calculated_Revocation_or_Continuation_FR__c, 
                            Issue_Liquidation_Revocation_Instruction__c, Rebuttal_Comments_Due__c, Adequacy_Determination_Letter__c, 
                            Comments_on_Adequacy_Determination_Filed__c, Memorandum_on_Adequacy_Determination__c, 
                            Notify_ITC_of_No_Domestic_Interest__c, Inadequate_Domestic_Response_note_to_ITC__c, Notice_of_Intent_to_Participate__c, 
                            Notify_Cluster_Coordinator_No_Interest__c, Substantive_Response_Due_For_All_Parties__c, Inform_Cluster_Coordinator_if_No_Respons__c, 
                            Notice_of_intent_to_participate_Ips__c, Domestic_Party_File_Substan_Response__c, Review_to_address_zeroing_in_Segments__c, 
                            Respondent_File_Substantive_Response__c, Prelim_Extension__c, Initiation_Extension_of_days__c, Final_Extension_of_days__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ssSeg;
        }
    }

    @isTest static void initialize(){
        Test.startTest();
        List<ADCVD_Order__c> aList = new List<ADCVD_Order__c>();
        aList.add(o);
        ADCVDOrderTriggerHandler.initialize(aList, null);

        Test.stopTest();
        System.assertNotEquals(ADCVDOrderTriggerHandler.orderIdToSegmentMap, null);
    }

    @isTest static void setNextSunsetInitiationDate_Order() {
        Test.startTest();
        System.assertEquals(null, o.Next_Sunset_Initiation_Date__c);
        Federal_Register__c orderFR = setFR(o.Id, 'Order', true);
        o = null;
        testCalculated = orderDate.toStartOfMonth().addYears(4).addMonths(11);

        Test.stopTest();
        System.assertEquals(testCalculated, o.Next_Sunset_Initiation_Date__c);
    }
    @isTest static void setNextSunsetInitiationDate_Continuation() {
        Test.startTest();
        orderDate = orderDate.addMonths(1);
        List<Federal_Register__c> frList = new List<Federal_Register__c>();
        Federal_Register__c orderFR = setFR(o.Id, 'Order', false);
        frList.add(orderFR);
        Federal_Register__c continuationFR = setFR(o.Id, 'Continuation', false);
        frList.add(continuationFR);
        insert frList;
        o = null;
        testCalculated = orderDate.toStartOfMonth().addYears(4).addMonths(11);

        Test.stopTest();
        System.assertEquals(testCalculated, o.Next_Sunset_Initiation_Date__c);
    }
    @isTest static void setNextSunsetInitiationDate_Revocation() {
        Test.startTest();
        orderDate = orderDate.addMonths(2);
        List<Federal_Register__c> frList = new List<Federal_Register__c>();
        Federal_Register__c orderFR = setFR(o.Id, 'Order', false);
        frList.add(orderFR);
        Federal_Register__c continuationFR = setFR(o.Id, 'Continuation', false);
        frList.add(continuationFR);
        Federal_Register__c revoFR = setFR(o.Id, 'Revocation', false);
        frList.add(revoFR);
        insert frList;
        o = null;

        Test.stopTest();
        System.assertEquals(null, o.Next_Sunset_Initiation_Date__c);
    }

    @isTest static void setSegmentStatus1() {
        Test.startTest();
        //System.assertEquals('Active', o.Segment_Status__c);
        List<Segment__c> deleteList = new List<Segment__c>();
        deleteList.add(adminSeg);
        deleteList.add(acSeg);
        deleteList.add(ccSeg);
        deleteList.add(expedSeg);
        deleteList.add(nsSeg);
        deleteList.add(siSeg);
        deleteList.add(ssSeg);
        delete deleteList;
        o = null;

        Test.stopTest();
        System.assertEquals('Inactive', o.Segment_Status__c);
    }
    @isTest static void setSegmentStatus2() {
        Test.startTest();
        //System.assertEquals('Active', o.Segment_Status__c);
        List<Segment__c> deleteList = new List<Segment__c>();
        deleteList.add(acSeg);
        deleteList.add(ccSeg);
        deleteList.add(expedSeg);
        deleteList.add(nsSeg);
        deleteList.add(siSeg);
        deleteList.add(ssSeg);
        delete deleteList;
        adminSeg.Segment_Outcome__c = 'Withdrawn';
        update adminSeg;
        update o;
        o = null;

        Test.stopTest();
        //System.assertEquals('Active', o.Segment_Status__c);
    }

    @isTest static void setStatus1() {
        Test.startTest();
        System.assertEquals('Order FR Needed', o.Status__c);//default on Insert
        Federal_Register__c orderFR = setFR(o.Id, 'Order', true);
        o = null;

        Test.stopTest();
        //System.assertEquals('Current-Active', o.Status__c);//updated when any Segment is active
    }

    @isTest static void setStatus2() {
        Test.startTest();
        System.assertEquals('Order FR Needed', o.Status__c);//default on Insert
        List<Federal_Register__c> frList = new List<Federal_Register__c>();
        Federal_Register__c orderFR = setFR(o.Id, 'Order', false);
        frList.add(orderFR);
        Federal_Register__c revoFR = setFR(o.Id, 'Revocation', false);
        frList.add(revoFR);
        insert frList;
        o = null;
        System.assertEquals('Revoked-Incomplete', o.Status__c);//updated when Revocation FR is inserted
        o.Status__c = 'Revoked-Complete';//manually set to Revoked-Complete
        update o;
        delete revoFR;
        o = null;

        Test.stopTest();
        System.assertEquals('Revoked-Complete', o.Status__c);//does not overwrite when other changes happen
    }

    @isTest static void setAnniversaryMonth() {
        Test.startTest();
        setFR(o.Id, 'Order', true);
        String month = utils.getMonthFromDate(orderDate);
        o = null;
        
        Test.stopTest();
        System.assertEquals(month, o.Anniversary_Month__c);
    }

    @isTest static void validateEffectiveDateOfRevocation() {
        Test.startTest();

        //add setup FRs
        List<Federal_Register__c> frList = new List<Federal_Register__c>();
        orderFR =  setFR(o.Id, 'Order', false);
        revoFR = setFR(o.Id, 'Revocation', false);
        frList.add(orderFR);
        frList.add(revoFR);
        insert frList;
        //test validation on order FR
        o.Effective_Date_of_Revocation__c = orderDate.addYears(6);
        String validationError = attemptUpsert(o);
        System.assert(validationError.contains('Order Federal Register Published Date:'));
		Test.stopTest();
        //add continuation FR
        continuationFR = setFR(o.Id, 'Continuation', false);
        continuationFR.Published_Date__c = continuationFR.Published_Date__c.addDays(14);
        insert continuationFR;
        

        //test validationon continuation FR
        validationError = attemptUpsert(o);
        System.assert(validationError.contains('most recent Continuation Federal Register Published Date:'));

        //test successful insert
        o.Effective_Date_of_Revocation__c = orderDate.addYears(-2);
        validationError = attemptUpsert(o);

        
        System.assert(validationError.contains('Success'));

    }

    @testSetup static void dataSetup() {
        Test.startTest();

        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);

        System.runAs(testUser) {
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);

        //create test data
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, true);

        Petition__c testADPetition = TestUtils.createPetition(testADCase, orderDate.addDays(-280), true);

        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);

        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);

        List<Segment__c> segsToInsert = new List<Segment__c>();

            for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
                Segment__c testSeg = TestUtils.createSegment(testADOrder, segRecordTypeName, false);
                segsToInsert.add(testSeg);
            }
            insert segsToInsert;
        }
    }

    private static Federal_Register__c setFR(Id parentId, String frType, Boolean doInsert) {
        Federal_Register__c testFR = TestUtils.createFR(parentId, 'ADCVD_Order__c', orderDate, frType, doInsert);
        return testFR;
    }

    private static void getNewSegs() {
        adminSeg = null;
        nsSeg = null;
        siSeg = null;
        expedSeg = null;
        acSeg = null;
        ccSeg = null;
        ssSeg = null;
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