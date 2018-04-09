/**
 * 
 *    Created by Joshua Moody
 *    on Feb 23 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class SegmentTriggerHandlerTest {

    /************************************************
    * This class performs unit tests on the SegmentTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that date calculations are logically correct
    * 3. Test to ensure that status calculations are logically correct
    *************************************************/

    private static Date segmentDate = System.today();
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
                o = [SELECT Id, Anniversary_Month__c FROM ADCVD_Order__c LIMIT 1];
            }
            return o;
        }
    }
    private static Federal_Register__c prelimFR{
        get{
            if (prelimFR == null) {
                prelimFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Preliminary' LIMIT 1];
            }
            return prelimFR;
        }
    }
    private static Federal_Register__c initFR{
        get{
            if (initFR == null) {
                initFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Initiation' LIMIT 1];
            }
            return initFR;
        }
    }
    private static Federal_Register__c finalFR{
        get{
            if (finalFR == null) {
                finalFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Final' LIMIT 1];
            }
            return finalFR;
        }
    }
    private static Federal_Register__c itcFinalFR{
        get{
            if (itcFinalFR == null) {
                itcFinalFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'ITC Final' LIMIT 1];
            }
            return itcFinalFR;
        }
    }
    private static Federal_Register__c revoFR{
        get{
            if (revoFR == null) {
                revoFR = [SELECT Id, ADCVD_Order__c, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Revocation' LIMIT 1];
            }
            return revoFR;
        }
    }
    private static Federal_Register__c rescFR{
        get{
            if (rescFR == null) {
                rescFR = [SELECT Id, ADCVD_Order__c, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Rescission' LIMIT 1];
            }
            return rescFR;
        }
    }
    private static Segment__c adminSeg{
        get{
            if (adminSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                adminSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c,
                            		Segment__c.ADCVD_Order__c, Segment__c.Suspension_Agreement__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return adminSeg;
        }
    }
    private static Segment__c nsSeg{
        get{
            if (nsSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('New_Shipper_Review');
                nsSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Calculated_Initiation_Signature__c, Final_Team_Meeting_Deadline__c, 
                                Actual_Initiation_Signature__c, Calculated_Final_Signature__c, Actual_Preliminary_Signature__c, Actual_Final_Signature__c, 
                                Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                                Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, Prelim_Team_Meeting_Deadline__c, 
                                Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c,
                         		Segment__c.ADCVD_Order__c, Segment__c.Suspension_Agreement__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return nsSeg;
        }
    }
    private static Segment__c siSeg{
        get{
            if (siSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Scope_Inquiry');
                siSeg = [SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c, Initiation_Extension_of_days__c, RecordTypeId, Request_Filed__c, 
                                Prelim_Extension__c, Calculated_Preliminary_Signature__c, Actual_Date_of_Decision_on_HoP__c, Calculated_Final_Signature__c, 
                                Decision_on_HOP_Issues_Due_to_DAS__c, Decision_on_HOP_Concurrence_Due_to_DAS__c, Prelim_Issues_Due_to_DAS__c, 
                                Prelim_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Prelim_Team_Meeting_Deadline__c, 
                                Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Final_Team_Meeting_Deadline__c, 
                                Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Segment__c.ADCVD_Order__c,
                         		Segment__c.Suspension_Agreement__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return siSeg;
        }
    }
    private static Segment__c expedSeg{
        get{
            if (expedSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Expedited_Review');
                expedSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
                                    Calculated_Final_Signature__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, Calculated_Amended_Final_Signature__c,
                            		Segment__c.ADCVD_Order__c, Segment__c.Suspension_Agreement__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return expedSeg;
        }
    }
    private static Segment__c acSeg{
        get{
            if (acSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Anti_Circumvention_Review');
                acSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Initiation_Extension_of_days__c, Calculated_Preliminary_Signature__c, 
                                    Calculated_Final_Signature__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    Application_Accepted__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Segment__c.ADCVD_Order__c,
                         			Segment__c.Suspension_Agreement__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return acSeg;
        }
    }
    private static Segment__c ccSeg{
        get{
            if (ccSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Changed_Circumstances_Review');
                ccSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Is_This_Review_Expedited__c,
                                    Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
                                    All_parties_in_agreement_to_the_outcome__c, Request_Filed__c, Initiation_Issues_Due_to_DAS__c, Initiation_Concurrence_Due_to_DAS__c, 
                                    Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Prelim_Team_Meeting_Deadline__c, 
                                    Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
                                    Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                                    Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Segment__c.ADCVD_Order__c,
                         			Segment__c.Suspension_Agreement__c
                                FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ccSeg;
        }
    }
    private static Segment__c ssSeg{
        get{
            if (ssSeg == null) {
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Sunset_Review');
                ssSeg = [SELECT Id, RecordTypeId, Calculated_Preliminary_Signature__c, Calculated_Final_Signature__c, Update_ACE_Customs_Module__c, Adequacy_of_Respondents_Submission__c, 
                            Actual_Final_Signature__c, Actual_Revocation_or_Continuation_FR__c, Calculated_Revocation_or_Continuation_FR__c, 
                            Issue_Liquidation_Revocation_Instruction__c, Rebuttal_Comments_Due__c, Adequacy_Determination_Letter_to_ITC__c, 
                            Comments_on_Adequacy_Determination_Filed__c, Memorandum_on_Adequacy_Determination__c, Prelim_Team_Meeting_Deadline__c, 
                            Notify_ITC_of_No_Domestic_Interest__c, Inadequate_Domestic_Response_note_to_ITC__c, Notice_of_Intent_to_Participate__c, 
                            Notify_Cluster_Coordinator_No_Interest__c, Substantive_Response_Due_For_All_Parties__c, Inform_Cluster_Coordinator_if_No_Respons__c, 
                            Notice_of_intent_to_participate_Ips__c, Domestic_Party_File_Substan_Response__c, Review_to_address_zeroing_in_Segments__c, 
                            Respondent_File_Substantive_Response__c, Prelim_Extension__c, Initiation_Extension_of_days__c, 
                            Final_Extension_of_days__c, Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, 
                            Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Final_Team_Meeting_Deadline__c, 
                            Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
                            Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Segment__c.ADCVD_Order__c,
                         	Segment__c.Suspension_Agreement__c
                            FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
            }
            return ssSeg;
        }
    }

    @isTest static void initialize(){
        Test.startTest();
        List<Segment__c> sList = new List<Segment__c>();
        sList.add(adminSeg);
        sList.add(acSeg);
        sList.add(ccSeg);
        sList.add(expedSeg);
        sList.add(nsSeg);
        sList.add(siSeg);
        sList.add(ssSeg);

        SegmentTriggerHandler.initialize(sList, null);
        Test.stopTest();
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(adminSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(acSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(ccSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(expedSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(adminSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(siSeg.RecordTypeId),null);
        System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(ssSeg.RecordTypeId),null);
        
    }

    //setDeadlineForDecisionForHoP
    @isTest static void setDeadlineForDecisionForHoP(){
        Test.startTest();
        //Setup start dates
        setStartDates();
        setExtensions();
        //Scope Inquiry
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Request_Filed__c.addDays(45).addDays(7));
        
        Test.stopTest();
        //compare Request_Filed__c + Initiation_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Deadline_for_Decision_on_How_to_Proceed__c);
    }

    //setCalculatedInitationSignature
    @isTest static void setCalculatedInitationSignatureACR() {
        Test.startTest();
        //Setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        //Anti-Circumvention Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Application_Accepted__c.addDays(45));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);
    }

        //setCalculatedInitationSignature
    @isTest static void setCalculatedInitationSignatureCCR() {
        Test.startTest();
        //Setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        //Changed-Circumstances Reivew
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Request_Filed__c.addDays(45).addDays(7));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureAdministrativeReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Administrative Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Final_Date_of_Anniversary_Month__c.addDays(245).addDays(7));

        Test.stopTest();
        //compare Final_Date_of_Anniversary_Month__c + Prelim_Extension__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureNewShipperReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //New Shipper Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));
        //compare Calculated_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        //Based on Actual
        nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update nsSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Initiation_Signature__c.addDays(180).addDays(7));

        Test.stopTest();
        //compare Actual_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureSI(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Scope Inquiry
        //Based on Formal
        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c.addDays(-14);
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        getNewSegs();//trigger new query in class variables
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(75).addDays(7));
        //compare Actual_Date_of_Decision_on_HoP__c + Prelim_Extension__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureExpeditedReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Expedited Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureACR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Anti-Circumvention Review
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        update acSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Initiation_Signature__c.addDays(120));
        //compare Calculated_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        //Based on Actual
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update acSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Actual_Initiation_Signature__c.addDays(120));

        Test.stopTest();
        //compare Actual_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setCalculatedPreliminarySignature
    @isTest static void setCalculatedPreliminarySignatureCCR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Changed-Circumstances Review
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Preliminary_Determination__c = 'Yes';
        update ccSeg;
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));
        //compare Calculated_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        //Based on Actual
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update ccSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(180).addDays(7));
        
        Test.stopTest();
        //compare Actual_Initiation_Signature__c + Prelim_Extension__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineAdministrativeReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Preliminary_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineNewShipperReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //New Shipper
        //compare Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Preliminary_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineSI(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Scope Inquiry
        //Based on Formal
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        getNewSegs();
        //compare Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Calculated_Preliminary_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: siSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineExpeditedReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Expedited Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Preliminary_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineACR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Anti-Circumvention Review
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        update acSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Preliminary_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: acSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setPrelimTeamMeetingDeadline
    @isTest static void setPrelimTeamMeetingDeadlineCCR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Changed-Circumstances Review
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Preliminary_Determination__c = 'Yes';
        update ccSeg;
        getNewSegs();
        System.debug('ccSeg >> '+ccSeg);
        System.debug('testCalculated >> '+testCalculated);
        System.debug('date:  '+ccSeg.Calculated_Preliminary_Signature__c);
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Preliminary_Signature__c.addDays(-21));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
    }

    //setCalculatedFinalSignature for the Administrative Review
    @isTest static void setCalculatedFinalSignatureAdminReview(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        
        //Administrative Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Preliminary_Signature__c.addDays(120).addDays(7));
        //compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on FR Preliminary Published Date
        setFR(adminSeg.Id, 'Preliminary');
        update adminSeg;
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(prelimFR.Published_Date__c.addDays(120).addDays(7));
        //compare prelimFR.Published_Date__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the New Shipper Review
    @isTest static void setCalculatedFinalSignatureNewShipperReview(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //New Shipper Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Preliminary_Signature__c.addDays(90).addDays(7));
        //compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on Actual
        nsSeg.Actual_Preliminary_Signature__c = nsSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        update nsSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Preliminary_Signature__c.addDays(90).addDays(7));
        //compare Actual_Preliminary_Signature__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the New Shipper Review
    @isTest static void setCalculatedFinalSignatureNewShipperReviewSynced(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        nsSeg.Administrative_Review_Aligned_To__c = adminSeg.Id;
        update nsSeg;
        getNewSegs();

        //New Shipper Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Preliminary_Signature__c);
        //compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c);
        //compare Actual_Preliminary_Signature__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the Scope Inquiry
    @isTest static void setCalculatedFinalSignatureScopeInquiry(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Scope Inquiry
        //Based on Formal
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(120).addDays(7));
        //compare Actual_Date_of_Decision_on_HoP__c + Final_Extension_of_days__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on Not Formal
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(120).addDays(7));

        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the Expedited Review
    @isTest static void setCalculatedFinalSignatureExpeditedReview(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Expedited Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Preliminary_Signature__c.addDays(90).addDays(7));
        //compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on Actual
        expedSeg.Actual_Preliminary_Signature__c = expedSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        update expedSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Actual_Preliminary_Signature__c.addDays(90).addDays(7));
        //compare Actual_Preliminary_Signature__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the Anti Circumvention Review
    @isTest static void setCalculatedFinalSignatureAntiCircumventionReview(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Anti_circumvention Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Initiation_Signature__c.addDays(300));
        //compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on Actual
        acSeg.Type_of_Circumvention_Inquiry__c = 'Minor Alterations of Merchandise';
        acSeg.Preliminary_Determination__c = 'No';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update acSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Actual_Initiation_Signature__c.addDays(300));
        //compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the Changed-Circumstances Review
    @isTest static void setCalculatedFinalSignatureChangedCircumstancesReview(){
        Test.startTest();
       
       //setup start dates        
       setStartDates();
       setExtensions();
       getNewSegs();

       ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
       ccSeg.Preliminary_Determination__c = 'No';
       update ccSeg;

        //Changed-Circumstances Review
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(45).addDays(7));
        //compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //Based on Actual
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update ccSeg;
        getNewSegs();
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(45).addDays(7));
        //compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c); 

        //ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
        ccSeg.Actual_Initiation_Signature__c = null;
        update ccSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(45).addDays(7));
        //compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c); 

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        update ccSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(270).addDays(7));
        //compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c); 

        //Based On Actual
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
        update ccSeg;
        getNewSegs();
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(270).addDays(7));
        //compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c); 

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
        update ccSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(45).addDays(7));
        //compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setCalculatedFinalSignature for the Sunset Review
    @isTest static void setCalculatedFinalSignatureSunsetReview(){
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        
        //Sunset Review
        testCalculated = ssSeg.Calculated_Final_Signature__c;
        System.assertEquals(null, testCalculated);//initially null without days set
        setFR(ssSeg.Id, 'Initiation');//create FR needed for calculations

        //90 Days
        ss90();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(90));
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //120 Days
        ss120();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(120));
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);

        //240 Days
        ss240();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(240));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineAdministrativeReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineNewShipperReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //New Shipper
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Final_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineSI(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Scope Inquiry
        //Based on Formal
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Calculated_Final_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: siSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineExpeditedReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Expedited Review
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Final_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineACR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Anti-Circumvention Review
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Final_Signature__c.addDays(-21));

        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: acSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setFinalTeamMeetingDeadline
    @isTest static void setFinalTeamMeetingDeadlineCCR(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();

        //Changed-Circumstances Review
        //compare Calculated_Final_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Final_Signature__c.addDays(-21));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
    }

    //setCalculatedAmendedFinalSignature
    @isTest static void setCalculatedAmendedFinalSignatureAdministrativeReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Administrative Review
        //Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c.addDays(37));
        //compare Calculated_Final_Signature__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
        //Actual
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-14);
        update adminSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Actual_Final_Signature__c.addDays(37));

        Test.stopTest();
        //compare Actual_Final_Signature__c +37 days
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
    }

    //setCalculatedAmendedFinalSignature
    @isTest static void setCalculatedAmendedFinalSignatureNewShipperReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //New Shipper Review
        //Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Final_Signature__c.addDays(37));
        //compare Calculated_Final_Signature__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
        //Actual
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-14);
        update nsSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Final_Signature__c.addDays(37));

        Test.stopTest();
        //compare Actual_Final_Signature__c +37 days
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
    }

    //setCalculatedAmendedFinalSignature
    @isTest static void setCalculatedAmendedFinalSignatureExpeditedReview(){
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        //Expedited Review
        //Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Final_Signature__c.addDays(37));
        //compare Calculated_Final_Signature__c
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
        //Actual
        expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-14);
        update expedSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Actual_Final_Signature__c.addDays(37));
        //compare Actual_Final_Signature__c +37 days
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
    }

    @isTest static void setNotifyItcIfAffirmPrelimIsDetermine(){
        Test.startTest();

        //setup start dates
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        setStartDates();
        getNewSegs();
        //Anti-Circumvention Review
        //based on Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Preliminary_Signature__c.addDays(7));
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_ITC_If_Affirmative_Prelim_Determ__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Notify_ITC_If_Affirmative_Prelim_Determ__c);
        
        //based on Preliminary FR
        setFR(acSeg.Id, 'Preliminary');
        update acSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(prelimFR.Published_Date__c.addDays(2));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_ITC_If_Affirmative_Prelim_Determ__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Notify_ITC_If_Affirmative_Prelim_Determ__c);
    }
    
    //Sunset Review Fields
    //setCalculatedRevocationOrContinuationFR
    @isTest static void setCalculatedRevocationOrContinuationFR(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'ITC Final');
        getNewSegs();

        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(itcFinalFR.Published_Date__c.addDays(7));
        //compare Calculated_Revocation_or_Continuation_FR__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Calculated_Revocation_or_Continuation_FR__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Revocation_or_Continuation_FR__c);
    }

    //sets Update_ACE_Customs_Module__c for 90 day Sunset Reviews
    @isTest static void setUpdateAceCustomsModule90(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //90 Day Calculations
        ss90();
        getNewSegs();
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Final_Signature__c.addDays(6));
        //compare Calculated_Final_Signature__c
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

        //Based on Actual
        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Final_Signature__c.addDays(6));
        //compare Actual_Final_Signature__c
        System.assertEquals(testActual,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

        //Based on FR
        setFR(ssSeg.Id, 'Final');
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(-1));
        //compare Published_Date__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
    }

    //sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Calculated_Revocation_or_Continuation_FR__c
    @isTest static void setUpdateAceCustomsModuleCalc(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');

        //120 Day Calculations for Calculated_Revocation_or_Continuation_FR__c
        setFR(ssSeg.Id, 'ITC Final');
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(6));
        //compare Calculated_Revocation_or_Continuation_FR__c
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

        //240 Calculations for Calculated_Revocation_or_Continuation_FR__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(6));
        //compare Calculated_Revocation_or_Continuation_FR__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
    }

    //sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Actual_Revocation_or_Continuation_FR__c
    @isTest static void setUpdateAceCustomsModuleActual(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');

        //120 Day Calculations for Actual_Revocation_or_Continuation_FR__c
        setFR(ssSeg.Id, 'ITC Final');
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        ss120();
        getNewSegs();
        ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(6));
        //compare Actual_Revocation_or_Continuation_FR__c
        System.assertEquals(testActual,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

        //240 Calculations for Actual_Revocation_or_Continuation_FR__c
        ss240();
        getNewSegs();
        ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(6));
        //compare Actual_Revocation_or_Continuation_FR__c
        
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
    }

    //sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Published_Date__c
    @isTest static void setUpdateAceCustomsModulePublishedDate(){
        Test.startTest();

        //120 Day Calculations for Published_Date__c
        setFR(o.Id, 'Revocation');
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(-1));
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

        //240 Day Calculations for Published_Date__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(-1));
        //compare Published_Date__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
    }

    //sets Issue_Liquidation_Revocation_Instruction__c for 90 day Sunset Reviews
    @isTest static void setIssueLiquidationRevocationInstruction90(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //90 Day Calculations
        ss90();
        getNewSegs();
        //Based on Calculated
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Final_Signature__c.addDays(22));
        //compare Calculated_Final_Signature__c
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

        //Based on Actual
        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Final_Signature__c.addDays(22));
        //compare Actual_Final_Signature__c
        System.assertEquals(testActual,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

        //Based on FR
        setFR(ssSeg.Id, 'Final');
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(15));
        //compare Published_Date__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
    }

    //sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Calculated_Revocation_or_Continuation_FR__c
    @isTest static void setIssueLiquidationRevocationInstructionCalc(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');

        //120 Day Calculations for Calculated_Revocation_or_Continuation_FR__c
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        setFR(ssSeg.Id, 'ITC Final');
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(22));
        //compare Calculated_Revocation_or_Continuation_FR__c
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

        //240 Calculations for Calculated_Revocation_or_Continuation_FR__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(22));
        //compare Calculated_Revocation_or_Continuation_FR__c
                
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
    }

    //sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Actual_Revocation_or_Continuation_FR__c
    @isTest static void setIssueLiquidationRevocationInstructionActual(){
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');

        //120 Day Calculations for Actual_Revocation_or_Continuation_FR__c
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        setFR(ssSeg.Id, 'ITC Final');
        ss120();
        getNewSegs();
        
        ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(22));
        //compare Actual_Revocation_or_Continuation_FR__c
        System.assertEquals(testActual,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

        //240 Calculations for Actual_Revocation_or_Continuation_FR__c
        ss240();
        getNewSegs();
        ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
        update ssSeg;
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(22));
        //compare Actual_Revocation_or_Continuation_FR__c
                
        Test.stopTest();
        System.assertEquals(testActual,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
    }

    //sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Published_Date__c
    @isTest static void setIssueLiquidationRevocationInstructionPublished(){
        Test.startTest();

        //120 Day Calculations for Published_Date__c
        ssSeg.Continuation_or_Revocation__c = 'Revocation';
        setFR(o.Id, 'Revocation');
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(15));
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

        //240 Day Calculations for Published_Date__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(15));
        //compare Published_Date__c
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
    }

    //sets Rebuttal_Comments_Due__c
    @isTest static void setRebuttalCommentsDue(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //120 Day Calculations for Published_Date__c
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(35));
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);

        //240 Day Calculations for Published_Date__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(35));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);
    }

    //sets Adequacy_Determination_Letter_to_ITC__c
    @isTest static void setAdequacyDeterminationandLetterToITC(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Adequacy_Determination_Letter_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_to_ITC__c);
        System.assertEquals(null,
            [SELECT Id, Adequacy_Determination_Letter_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_to_ITC__c);
        
        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //120 Day Calculations for Published_Date__c
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(50));
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Adequacy_Determination_Letter_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_to_ITC__c);

        //240 Day Calculations for Published_Date__c
        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(50));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Adequacy_Determination_Letter_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_to_ITC__c);
    }

    //sets Comments_on_Adequacy_Determination_Filed__c
    @isTest static void setCommentsOnAdequacyDeterminationFiled(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Comments_on_Adequacy_Determination_Filed__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Comments_on_Adequacy_Determination_Filed__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //120 Day Calculations for Published_Date__c
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(70));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Comments_on_Adequacy_Determination_Filed__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Comments_on_Adequacy_Determination_Filed__c);
    }

    //sets Memorandum_on_Adequacy_Determination__c
    @isTest static void setMemorandumOnAdequacyDetermination(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Memorandum_on_Adequacy_Determination__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Memorandum_on_Adequacy_Determination__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //120 Day Calculations for Published_Date__c
        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(110));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Memorandum_on_Adequacy_Determination__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Memorandum_on_Adequacy_Determination__c);
    }

    //sets Notify_ITC_of_No_Domestic_Interest__c
    @isTest static void setNotifyItcOfNoDomesticInterest(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Notify_ITC_of_No_Domestic_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_ITC_of_No_Domestic_Interest__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //90 Day Calculations for Published_Date__c
        ss90();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(20));

        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_ITC_of_No_Domestic_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_ITC_of_No_Domestic_Interest__c);
    }

    //sets Inadequate_Domestic_Response_note_to_ITC__c
    @isTest static void setInadequateDomesticResponseNoteToITC(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Inadequate_Domestic_Response_note_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inadequate_Domestic_Response_note_to_ITC__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //90 Day Calculations for Published_Date__c
        ss90();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(40));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Inadequate_Domestic_Response_note_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inadequate_Domestic_Response_note_to_ITC__c);
    }

    //sets Notice_of_Intent_to_Participate__c
    @isTest static void setNoticeOfIntentToParticipate(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Notice_of_Intent_to_Participate__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notice_of_Intent_to_Participate__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(15));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Notice_of_Intent_to_Participate__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notice_of_Intent_to_Participate__c);
    }

    //sets Notify_Cluster_Coordinator_No_Interest__c
    @isTest static void setNotifyClusterCoordinatorNoInterest(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Notify_Cluster_Coordinator_No_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_Cluster_Coordinator_No_Interest__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Notice_of_Intent_to_Participate__c.addDays(1));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_Cluster_Coordinator_No_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_Cluster_Coordinator_No_Interest__c);
    }

    //sets Substantive_Response_Due_For_All_Parties__c
    @isTest static void setSubstantiveResponseDueForAllParties(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Substantive_Response_Due_For_All_Parties__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Substantive_Response_Due_For_All_Parties__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(30));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Substantive_Response_Due_For_All_Parties__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Substantive_Response_Due_For_All_Parties__c);
    }

    //sets Inform_Cluster_Coordinator_if_No_Respons__c
    @isTest static void setInformClusterCoordinatorIfNoRespons(){
        Test.startTest();

        //date should not be set unless there is an Initial FR published date
        System.assertEquals(null,
            [SELECT Id, Inform_Cluster_Coordinator_if_No_Respons__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inform_Cluster_Coordinator_if_No_Respons__c);

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        //Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Substantive_Response_Due_For_All_Parties__c.addDays(1));
        
        Test.stopTest();
        //compare Published_Date__c
        System.assertEquals(testCalculated,
            [SELECT Id, Inform_Cluster_Coordinator_if_No_Respons__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inform_Cluster_Coordinator_if_No_Respons__c);
    }

    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateAdminReview() {
        Test.startTest();

        //setup start dates
        setFR(adminSeg.Id, 'Final');
        setFR(adminSeg.Id, 'Rescission');
        adminSeg.Segment_Outcome__c = 'Full Rescission';
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Full Rescission
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(rescFR.Published_Date__c.addDays(30));
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

        adminSeg.Segment_Outcome__c = 'Completed';
        adminSeg.Actual_Final_Signature__c = segmentDate;
        update adminSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateExpeditedReview() {
        Test.startTest();

        //setup start dates
        setFR(expedSeg.Id, 'Final');
        setFR(expedSeg.Id, 'Rescission');
        expedSeg.Segment_Outcome__c = 'Full Rescission';
        setStartDates();
        getNewSegs();

        //Expedited Review
        //compare Full Rescission
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(rescFR.Published_Date__c.addDays(30));
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

        expedSeg.Segment_Outcome__c = 'Completed';
        expedSeg.Actual_Final_Signature__c = segmentDate;
        update expedSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateNewShipperReview() {
        Test.startTest();

        //setup start dates
        setFR(nsSeg.Id, 'Final');
        setFR(nsSeg.Id, 'Rescission');
        nsSeg.Segment_Outcome__c = 'Full Rescission';
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Full Rescission
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(rescFR.Published_Date__c.addDays(30));
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

        nsSeg.Segment_Outcome__c = 'Completed';
        nsSeg.Actual_Final_Signature__c = segmentDate;
        update nsSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateAntiCircReview() {
        Test.startTest();

        //setup start dates
        setFR(acSeg.Id, 'Final');
        setFR(acSeg.Id, 'Rescission');
        acSeg.Segment_Outcome__c = 'Full Rescission';
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Full Rescission
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(rescFR.Published_Date__c.addDays(30));
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

        acSeg.Segment_Outcome__c = 'Completed';
        acSeg.Actual_Final_Signature__c = segmentDate;
        update acSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateChangedCircReview() {
        Test.startTest();

        //setup start dates
        setFR(ccSeg.Id, 'Final');
        setFR(ccSeg.Id, 'Rescission');
        ccSeg.Segment_Outcome__c = 'Full Rescission';
        setStartDates();
        getNewSegs();

        //Admin Review
        //compare Full Rescission
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(rescFR.Published_Date__c.addDays(30));
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

        ccSeg.Segment_Outcome__c = 'Completed';
        ccSeg.Actual_Final_Signature__c = segmentDate;
        update ccSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateScopeInquiry() {
        Test.startTest();

        //setup start dates
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Segment_Outcome__c = 'Completed';
        siSeg.Actual_Final_Signature__c = segmentDate.addDays(45);
        setStartDates();
        getNewSegs();

        //Scope Inquiry
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Final_Signature__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setLitigationHoldExpirationDate
    @isTest static void setLitigationHoldExpirationDateSunsetReview() {
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        setFR(ssSeg.Id, 'Final');
        ssSeg.Segment_Outcome__c = 'Completed';
        ssSeg.Actual_Final_Signature__c = segmentDate;
        ss90();
        setStartDates();
        getNewSegs();

        //Sunset Review
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(30));

        Test.stopTest();
        System.assertEquals(testCalculated, [SELECT Litigation_Hold_Expiration_Date__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateAdministrativeReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(adminSeg.Calculated_Preliminary_Signature__c, adminSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, adminSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateExpeditedReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(expedSeg.Calculated_Preliminary_Signature__c, expedSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, expedSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateNewShipperReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(nsSeg.Calculated_Preliminary_Signature__c, nsSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, nsSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateScopeInquiry() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(siSeg.Calculated_Preliminary_Signature__c, siSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, siSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateAntiCircumventionReview() {
        Test.startTest();

        //setup start dates
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(acSeg.Calculated_Preliminary_Signature__c, acSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, acSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateChangedCircumstancesReview() {
        Test.startTest();

        //setup start dates
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Preliminary_Determination__c = 'Yes';
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ccSeg.Calculated_Preliminary_Signature__c, ccSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, ccSeg.Preliminary_Announcement_Date__c);
    }
    //setPreliminaryAnnouncementDate
    @isTest static void setPreliminaryAnnouncementDateSunsetReview() {
        Test.startTest();

        //setup start dates
        ss240();
        setFR(ssSeg.Id, 'Initiation');
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ssSeg.Calculated_Preliminary_Signature__c, ssSeg.Calculated_Preliminary_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, ssSeg.Preliminary_Announcement_Date__c);
    }

    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateAdministrativeReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(adminSeg.Calculated_Final_Signature__c, adminSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, adminSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateExpeditedReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(expedSeg.Calculated_Final_Signature__c, expedSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, expedSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateNewShipperReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(nsSeg.Calculated_Final_Signature__c, nsSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, nsSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateScopeInquiry() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(siSeg.Calculated_Final_Signature__c, siSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, siSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateAntiCircumventionReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(acSeg.Calculated_Final_Signature__c, acSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, acSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateChangedCircumstancesReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ccSeg.Calculated_Final_Signature__c, ccSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, ccSeg.Final_Announcement_Date__c);
    }
    //setFinalAnnouncementDate
    @isTest static void setFinalAnnouncementDateSunsetReview() {
        Test.startTest();

        //setup start dates
        ss90();
        setFR(ssSeg.Id, 'Initiation');
        setStartDates();
        setExtensions();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ssSeg.Calculated_Final_Signature__c, ssSeg.Calculated_Final_Signature__c.addDays(1), true);
        System.assertEquals(testCalculated, ssSeg.Final_Announcement_Date__c);

        ss120();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ssSeg.Calculated_Final_Signature__c, ssSeg.Calculated_Final_Signature__c.addDays(1), true);
        System.assertEquals(testCalculated, ssSeg.Final_Announcement_Date__c);

        ss240();
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(ssSeg.Calculated_Final_Signature__c, ssSeg.Calculated_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, ssSeg.Final_Announcement_Date__c);
    }

    //setAmendedFinalAnnouncementDate
    @isTest static void setAmendedFinalAnnouncementDateAdministrativeReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(adminSeg.Calculated_Amended_Final_Signature__c, adminSeg.Calculated_Amended_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, adminSeg.Amended_Final_Announcement_Date__c);
    }
    //setAmendedFinalAnnouncementDate
    @isTest static void setAmendedFinalAnnouncementDateExpeditedReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(expedSeg.Calculated_Amended_Final_Signature__c, expedSeg.Calculated_Amended_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, expedSeg.Amended_Final_Announcement_Date__c);
    }
    //setAmendedFinalAnnouncementDate
    @isTest static void setAmendedFinalAnnouncementDateNewShipperReview() {
        Test.startTest();
        
        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        testCalculated = ADCVD_TollingDayUtility.getCalculatedDate(nsSeg.Calculated_Amended_Final_Signature__c, nsSeg.Calculated_Amended_Final_Signature__c.addDays(1), true);

        Test.stopTest();
        System.assertEquals(testCalculated, nsSeg.Amended_Final_Announcement_Date__c);
    }

    /**************************
    * Next Deadlines
    **************************/

    //Next Major Deadline
    @isTest static void setNextMajorDeadlineAdminReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(adminSeg.Calculated_Preliminary_Signature__c, adminSeg.Next_Major_Deadline__c);

        adminSeg.Actual_Preliminary_Signature__c = adminSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Final_Signature__c, adminSeg.Next_Major_Deadline__c);

        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Amended_Final_Signature__c, adminSeg.Next_Major_Deadline__c);

        adminSeg.Actual_Amended_Final_Signature__c = adminSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update adminSeg;
        adminSeg = null;

        Test.stopTest();
        System.assertEquals(null, adminSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineExpeditedReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(expedSeg.Calculated_Preliminary_Signature__c, expedSeg.Next_Major_Deadline__c);

        expedSeg.Actual_Preliminary_Signature__c = expedSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Final_Signature__c, expedSeg.Next_Major_Deadline__c);

        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Amended_Final_Signature__c, expedSeg.Next_Major_Deadline__c);

        expedSeg.Actual_Amended_Final_Signature__c = expedSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update expedSeg;
        expedSeg = null;

        Test.stopTest();
        System.assertEquals(null, expedSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineNewShipperReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(nsSeg.Calculated_Preliminary_Signature__c, nsSeg.Next_Major_Deadline__c);

        nsSeg.Actual_Preliminary_Signature__c = nsSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Final_Signature__c, nsSeg.Next_Major_Deadline__c);

        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Amended_Final_Signature__c, nsSeg.Next_Major_Deadline__c);

        nsSeg.Actual_Amended_Final_Signature__c = nsSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update nsSeg;
        nsSeg = null;

        Test.stopTest();
        System.assertEquals(null, nsSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineAntiCircReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(acSeg.Calculated_Initiation_Signature__c, acSeg.Next_Major_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Preliminary_Signature__c, acSeg.Next_Major_Deadline__c);

        acSeg.Actual_Preliminary_Signature__c = acSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Final_Signature__c, acSeg.Next_Major_Deadline__c);

        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineChangedCircReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(ccSeg.Calculated_Initiation_Signature__c, ccSeg.Next_Major_Deadline__c);

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-7);
        ccSeg.Preliminary_Determination__c = 'Yes';
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Preliminary_Signature__c, ccSeg.Next_Major_Deadline__c);

        ccSeg.Actual_Preliminary_Signature__c = ccSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Final_Signature__c, ccSeg.Next_Major_Deadline__c);

        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineScopeInquiry() {
        Test.startTest();

        //setup
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        clearFormal();
        getNewSegs();
        System.assertEquals(siSeg.Deadline_for_Decision_on_How_to_Proceed__c, siSeg.Next_Major_Deadline__c);

        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c.addDays(-7);
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Preliminary_Signature__c, siSeg.Next_Major_Deadline__c);

        siSeg.Actual_Preliminary_Signature__c = siSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Final_Signature__c, siSeg.Next_Major_Deadline__c);

        siSeg.Actual_Final_Signature__c = siSeg.Calculated_Final_Signature__c.addDays(-7);
        update siSeg;
        siSeg = null;

        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Major_Deadline__c);
    }
    //Next Major Deadline
    @isTest static void setNextMajorDeadlineSunsetReview() {
        Test.startTest();

        //setup
        setFR(ssSeg.Id, 'Initiation');
        ss240();
        getNewSegs();
        System.assertEquals(ssSeg.Calculated_Preliminary_Signature__c, ssSeg.Next_Major_Deadline__c);

        ssSeg.Actual_Preliminary_Signature__c = ssSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Final_Signature__c, ssSeg.Next_Major_Deadline__c);

        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Major_Deadline__c);
    }

    //Next Announcement Date
    @isTest static void setNextAnnouncementDateAdministrativeReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        System.assertEquals(adminSeg.Preliminary_Announcement_Date__c, adminSeg.Next_Announcement_Date__c);

        adminSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update adminSeg;
        getNewSegs();
        System.assertEquals(adminSeg.Final_Announcement_Date__c, adminSeg.Next_Announcement_Date__c);

        
        adminSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update adminSeg;
        getNewSegs();
        System.assertEquals(adminSeg.Amended_Final_Announcement_Date__c, adminSeg.Next_Announcement_Date__c);

        adminSeg.Actual_Amended_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update adminSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, adminSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateExpeditedReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        System.assertEquals(expedSeg.Preliminary_Announcement_Date__c, expedSeg.Next_Announcement_Date__c);

        expedSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update expedSeg;
        getNewSegs();
        System.assertEquals(expedSeg.Final_Announcement_Date__c, expedSeg.Next_Announcement_Date__c);

        
        expedSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update expedSeg;
        getNewSegs();
        System.assertEquals(expedSeg.Amended_Final_Announcement_Date__c, expedSeg.Next_Announcement_Date__c);

        expedSeg.Actual_Amended_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update expedSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, expedSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateNewShipperReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();

        System.assertEquals(nsSeg.Preliminary_Announcement_Date__c, nsSeg.Next_Announcement_Date__c);

        nsSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update nsSeg;
        getNewSegs();
        System.assertEquals(nsSeg.Final_Announcement_Date__c, nsSeg.Next_Announcement_Date__c);

        
        nsSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update nsSeg;
        getNewSegs();
        System.assertEquals(nsSeg.Amended_Final_Announcement_Date__c, nsSeg.Next_Announcement_Date__c);

        nsSeg.Actual_Amended_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update nsSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, nsSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateAntiCircReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(null, acSeg.Next_Announcement_Date__c);

        acSeg.Actual_Initiation_Signature__c = System.today().toStartOfWeek().addDays(-4);
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        update acSeg;
        System.assertEquals(acSeg.Preliminary_Announcement_Date__c, acSeg.Next_Announcement_Date__c);

        acSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update acSeg;
        getNewSegs();
        System.assertEquals(acSeg.Final_Announcement_Date__c, acSeg.Next_Announcement_Date__c);

        
        acSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update acSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateChangedCircReview() {
        Test.startTest();

        //setup start dates
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(null, ccSeg.Next_Announcement_Date__c);

        ccSeg.Actual_Initiation_Signature__c = System.today().toStartOfWeek().addDays(-4);
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        update ccSeg;
        System.assertEquals(ccSeg.Preliminary_Announcement_Date__c, ccSeg.Next_Announcement_Date__c);

        ccSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update ccSeg;
        getNewSegs();
        System.assertEquals(ccSeg.Final_Announcement_Date__c, ccSeg.Next_Announcement_Date__c);

        
        ccSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update ccSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateScopeInquiry() {
        Test.startTest();

        //setup start dates
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        siSeg.Decision_on_How_to_Proceed__c = '';
        update siSeg;
        getNewSegs();

        System.assertEquals(null, siSeg.Next_Announcement_Date__c);

        siSeg.Actual_Date_of_Decision_on_HoP__c = System.today().toStartOfWeek().addDays(-4);
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        getNewSegs();
        System.assertEquals(siSeg.Preliminary_Announcement_Date__c, siSeg.Next_Announcement_Date__c);

        siSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update siSeg;
        getNewSegs();
        System.assertEquals(siSeg.Final_Announcement_Date__c, siSeg.Next_Announcement_Date__c);

        
        siSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update siSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Announcement_Date__c);
    }
    //Next Announcement Date
    @isTest static void setNextAnnouncementDateSunsetReview() {
        Test.startTest();

        //setup start dates
        setFR(ssSeg.Id, 'Initiation');
        ss240();
        setStartDates();
        setExtensions();
        getNewSegs();

        System.assertEquals(ssSeg.Preliminary_Announcement_Date__c, ssSeg.Next_Announcement_Date__c);

        ssSeg.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update ssSeg;
        getNewSegs();
        System.assertEquals(ssSeg.Final_Announcement_Date__c, ssSeg.Next_Announcement_Date__c);

        
        ssSeg.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
        update ssSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Announcement_Date__c);
    }

    //Next Due to DAS
    @isTest static void setNextDueToDasAdminReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(adminSeg.Prelim_Issues_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Prelim_Concurrence_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Preliminary_Signature__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Preliminary_Signature__c = adminSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Final_Issues_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Final_Concurrence_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Final_Signature__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Amend_Final_Issues_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Amend_Final_Issues_to_DAS__c = adminSeg.Amend_Final_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Amend_Final_Concurrence_Due_to_DAS__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Amend_Final_Concurrence_to_DAS__c = adminSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Amended_Final_Signature__c, adminSeg.Next_Due_to_DAS_Deadline__c);

        adminSeg.Actual_Amended_Final_Signature__c = adminSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update adminSeg;
        adminSeg = null;

        Test.stopTest();
        System.assertEquals(null, adminSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasExpeditedReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(expedSeg.Prelim_Issues_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Prelim_Issues_to_DAS__c = expedSeg.Prelim_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Prelim_Concurrence_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Prelim_Concurrence_to_DAS__c = expedSeg.Prelim_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Preliminary_Signature__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Preliminary_Signature__c = expedSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Final_Issues_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        expedSeg.Actual_Final_Issues_to_DAS__c = expedSeg.Final_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Final_Concurrence_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Final_Concurrence_to_DAS__c = expedSeg.Final_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Final_Signature__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Amend_Final_Issues_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Amend_Final_Issues_to_DAS__c = expedSeg.Amend_Final_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Amend_Final_Concurrence_Due_to_DAS__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Amend_Final_Concurrence_to_DAS__c = expedSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Amended_Final_Signature__c, expedSeg.Next_Due_to_DAS_Deadline__c);

        expedSeg.Actual_Amended_Final_Signature__c = expedSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update expedSeg;
        expedSeg = null;

        Test.stopTest();
        System.assertEquals(null, expedSeg.Next_Due_to_DAS_Deadline__c);
    }
//Next Due to DAS
    @isTest static void setNextDueToDasNewShipperReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(nsSeg.Initiation_Issues_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Initiation_Concurrence_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Initiation_Signature__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Prelim_Issues_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Prelim_Concurrence_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Preliminary_Signature__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Preliminary_Signature__c = nsSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Final_Issues_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Final_Concurrence_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Final_Signature__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Amend_Final_Issues_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Amend_Final_Issues_to_DAS__c = nsSeg.Amend_Final_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Amend_Final_Concurrence_Due_to_DAS__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Amend_Final_Concurrence_to_DAS__c = nsSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Amended_Final_Signature__c, nsSeg.Next_Due_to_DAS_Deadline__c);

        nsSeg.Actual_Amended_Final_Signature__c = nsSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update nsSeg;
        nsSeg = null;

        Test.stopTest();
        System.assertEquals(null, nsSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasAntiCircReviewWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(acSeg.Initiation_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Initiation_Issues_to_DAS__c = acSeg.Initiation_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Initiation_Concurrence_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Initiation_Concurrence_to_DAS__c = acSeg.Initiation_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Initiation_Signature__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Minor Alterations of Merchandise';
        acSeg.Preliminary_Determination__c = 'Yes';
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Prelim_Issues_to_DAS__c = acSeg.Prelim_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Concurrence_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Prelim_Concurrence_to_DAS__c = acSeg.Prelim_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Preliminary_Signature__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Preliminary_Signature__c = acSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Issues_to_DAS__c = acSeg.Final_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Concurrence_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Concurrence_to_DAS__c = acSeg.Final_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Final_Signature__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasAntiCircReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(acSeg.Initiation_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Initiation_Issues_to_DAS__c = acSeg.Initiation_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Initiation_Concurrence_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Initiation_Concurrence_to_DAS__c = acSeg.Initiation_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Initiation_Signature__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Minor Alterations of Merchandise';
        acSeg.Preliminary_Determination__c = 'No';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Issues_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Issues_to_DAS__c = acSeg.Final_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Concurrence_Due_to_DAS__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Concurrence_to_DAS__c = acSeg.Final_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Final_Signature__c, acSeg.Next_Due_to_DAS_Deadline__c);

        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasChangedCircReviewWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(ccSeg.Initiation_Issues_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Initiation_Issues_to_DAS__c = ccSeg.Initiation_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Initiation_Concurrence_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Initiation_Concurrence_to_DAS__c = ccSeg.Initiation_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Initiation_Signature__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c;
        ccSeg.Preliminary_Determination__c = 'Yes';
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Prelim_Issues_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Prelim_Issues_to_DAS__c = ccSeg.Prelim_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Prelim_Concurrence_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Prelim_Concurrence_to_DAS__c = ccSeg.Prelim_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Preliminary_Signature__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Preliminary_Signature__c = ccSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Issues_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Issues_to_DAS__c = ccSeg.Final_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Concurrence_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Concurrence_to_DAS__c = ccSeg.Final_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Final_Signature__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasChangedCircReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(ccSeg.Initiation_Issues_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Initiation_Issues_to_DAS__c = ccSeg.Initiation_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Initiation_Concurrence_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Initiation_Concurrence_to_DAS__c = ccSeg.Initiation_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Initiation_Signature__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Issues_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Issues_to_DAS__c = ccSeg.Final_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Concurrence_Due_to_DAS__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Concurrence_to_DAS__c = ccSeg.Final_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Final_Signature__c, ccSeg.Next_Due_to_DAS_Deadline__c);

        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasScopeInquiryWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        siSeg.Decision_on_How_to_Proceed__c = '';
        update siSeg;
        getNewSegs();
        System.assertEquals(siSeg.Decision_on_HOP_Issues_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Issues_to_DAS__c = siSeg.Decision_on_HOP_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Concurrence_toDAS__c = siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Deadline_for_Decision_on_How_to_Proceed__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Preliminary_Determination__c = 'Yes';
        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Prelim_Issues_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Prelim_Issues_to_DAS__c = siSeg.Prelim_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Prelim_Concurrence_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Prelim_Concurrence_to_DAS__c = siSeg.Prelim_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Preliminary_Signature__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Preliminary_Signature__c = siSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Final_Issues_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Final_Issues_to_DAS__c = siSeg.Final_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Final_Concurrence_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Final_Concurrence_to_DAS__c = siSeg.Final_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Final_Signature__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Final_Signature__c = siSeg.Calculated_Final_Signature__c.addDays(-7);
        update siSeg;
        siSeg = null;

        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasScopeInquiryWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        clearFormal();
        getNewSegs();
        System.assertEquals(siSeg.Decision_on_HOP_Issues_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Issues_to_DAS__c = siSeg.Decision_on_HOP_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Concurrence_toDAS__c = siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Deadline_for_Decision_on_How_to_Proceed__c, siSeg.Next_Due_to_DAS_Deadline__c);

        siSeg.Decision_on_How_to_Proceed__c = 'Informal';
        siSeg.Type_of_Scope_Ruling__c = 'K (1)';
        siSeg.Segment_Outcome__c = 'Completed';
        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c;
        update siSeg;
        siSeg = null;
        
        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasSunsetReviewWithPrelim() {
        Test.startTest();

        //setup
        setFR(ssSeg.Id, 'Initiation');
        ss240();
        getNewSegs();
        System.assertEquals(ssSeg.Prelim_Issues_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Prelim_Issues_to_DAS__c = ssSeg.Prelim_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Prelim_Concurrence_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Prelim_Concurrence_to_DAS__c = ssSeg.Prelim_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Preliminary_Signature__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Preliminary_Signature__c = ssSeg.Calculated_Preliminary_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Issues_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Issues_to_DAS__c = ssSeg.Final_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Concurrence_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Concurrence_to_DAS__c = ssSeg.Final_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Final_Signature__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Due_to_DAS_Deadline__c);
    }
    //Next Due to DAS
    @isTest static void setNextDueToDasSunsetReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setFR(ssSeg.Id, 'Initiation');
        ss90();
        getNewSegs();
        System.assertEquals(ssSeg.Final_Issues_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Issues_to_DAS__c = ssSeg.Final_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Concurrence_Due_to_DAS__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Concurrence_to_DAS__c = ssSeg.Final_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Final_Signature__c, ssSeg.Next_Due_to_DAS_Deadline__c);

        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Due_to_DAS_Deadline__c);
    }

    //Next Office Deadline, method is split up to have one update call in each method. 
    @isTest static void setNextOfficeARPrelimIssuesDueToDAS() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(adminSeg.Prelim_Team_Meeting_Deadline__c, adminSeg.Next_Office_Deadline__c);

        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Prelim_Issues_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
		
        Test.stopTest();
    }
    @isTest static void setNextOfficeARPrelimConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        
        System.assertEquals(adminSeg.Prelim_Concurrence_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    
    @isTest static void setNextOfficeARCalculatedPreliminarySignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        
        System.assertEquals(adminSeg.Calculated_Preliminary_Signature__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARFinalTeamMeetingDeadline(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update adminSeg;
        adminSeg = null;
        
        System.assertEquals(adminSeg.Final_Team_Meeting_Deadline__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARFinalIssuesDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        update prelimFR;
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update adminSeg;
        adminSeg = null;
        
        System.assertEquals(adminSeg.Final_Issues_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARFinalConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        update prelimFR;
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        
        
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        update adminSeg;
        adminSeg = null;
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        
        System.assertEquals(adminSeg.Final_Concurrence_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARCalculatedFinalSignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        update prelimFR;
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        update adminSeg;
        adminSeg = null;
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        
        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Final_Signature__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARAmendFinalIssuesDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        
        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Amend_Final_Issues_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARAmendFinalConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        
        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        adminSeg.Actual_Amend_Final_Issues_to_DAS__c = adminSeg.Amend_Final_Issues_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Amend_Final_Concurrence_Due_to_DAS__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARCalculatedAmendedFinalSignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        
        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        adminSeg.Actual_Amend_Final_Issues_to_DAS__c = adminSeg.Amend_Final_Issues_Due_to_DAS__c;
        adminSeg.Actual_Amend_Final_Concurrence_to_DAS__c = adminSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update adminSeg;
        adminSeg = null;
        System.assertEquals(adminSeg.Calculated_Amended_Final_Signature__c, adminSeg.Next_Office_Deadline__c);
        Test.stopTest();

    }
    @isTest static void setNextOfficeARNullNextOfficeDeadline(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        
        adminSeg.Final_Date_of_Anniversary_Month__c = System.today().addDays(-245);
        adminSeg.Actual_Prelim_Issues_to_DAS__c = adminSeg.Prelim_Issues_Due_to_DAS__c;        
        adminSeg.Actual_Prelim_Concurrence_to_DAS__c = adminSeg.Prelim_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        setFR(adminSeg.Id, 'Preliminary');
        prelimFR.Published_Date__c = System.today().addDays(-120);
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Actual_Final_Issues_to_DAS__c = adminSeg.Final_Issues_Due_to_DAS__c;
        
        adminSeg.Actual_Final_Concurrence_to_DAS__c = adminSeg.Final_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-7);
        adminSeg.Actual_Amend_Final_Issues_to_DAS__c = adminSeg.Amend_Final_Issues_Due_to_DAS__c;
        adminSeg.Actual_Amend_Final_Concurrence_to_DAS__c = adminSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        adminSeg.Actual_Amended_Final_Signature__c = adminSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update adminSeg;
        adminSeg = null;
        Test.stopTest();
        System.assertEquals(null, adminSeg.Next_Office_Deadline__c);

    }

    
    //Next Office Deadline
    @isTest static void setNextOfficeExpeditedReview() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(expedSeg.Prelim_Team_Meeting_Deadline__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Prelim_Issues_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Prelim_Issues_to_DAS__c = expedSeg.Prelim_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Prelim_Concurrence_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Prelim_Concurrence_to_DAS__c = expedSeg.Prelim_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Preliminary_Signature__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Final_Team_Meeting_Deadline__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Final_Issues_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        expedSeg.Actual_Final_Issues_to_DAS__c = expedSeg.Final_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Final_Concurrence_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Final_Concurrence_to_DAS__c = expedSeg.Final_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Final_Signature__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-7);
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Amend_Final_Issues_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Amend_Final_Issues_to_DAS__c = expedSeg.Amend_Final_Issues_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Amend_Final_Concurrence_Due_to_DAS__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Amend_Final_Concurrence_to_DAS__c = expedSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update expedSeg;
        expedSeg = null;
        System.assertEquals(expedSeg.Calculated_Amended_Final_Signature__c, expedSeg.Next_Office_Deadline__c);

        expedSeg.Actual_Amended_Final_Signature__c = expedSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update expedSeg;
        expedSeg = null;

        Test.stopTest();
        System.assertEquals(null, expedSeg.Next_Office_Deadline__c);
    }
//Next Office Deadline
    @isTest static void setNextOfficeNewSRInitiationConcurrenceDueToDAS() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(nsSeg.Initiation_Issues_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Initiation_Concurrence_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
		
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRCalculatedInitiationSignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Initiation_Signature__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRPrelimTeamMeetingDeadline(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Prelim_Team_Meeting_Deadline__c, nsSeg.Next_Office_Deadline__c);        
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRPrelimIssuesDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Prelim_Issues_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRPrelimConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Prelim_Concurrence_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRCalculatedPreliminarySignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Preliminary_Signature__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRFinalTeamMeetingDeadline(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Final_Team_Meeting_Deadline__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRFinalIssuesDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Final_Issues_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRFinalConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Final_Concurrence_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRCalculatedFinalSignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Final_Signature__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRAmendFinalIssuesDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Amend_Final_Issues_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRAmendFinalConcurrenceDueToDAS(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
		nsSeg.Actual_Amend_Final_Issues_to_DAS__c = nsSeg.Amend_Final_Issues_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Amend_Final_Concurrence_Due_to_DAS__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRCalculatedAmendFinalSignature(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
		nsSeg.Actual_Amend_Final_Issues_to_DAS__c = nsSeg.Amend_Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Amend_Final_Concurrence_to_DAS__c = nsSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        update nsSeg;
        nsSeg = null;
        System.assertEquals(nsSeg.Calculated_Amended_Final_Signature__c, nsSeg.Next_Office_Deadline__c);
        Test.stopTest();
    }
    @isTest static void setNextOfficeNewSRNullNextOfficeDeadline(){
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();

        nsSeg.Actual_Initiation_Issues_to_DAS__c = nsSeg.Initiation_Issues_Due_to_DAS__c;
        nsSeg.Actual_Initiation_Concurrence_to_DAS__c = nsSeg.Initiation_Concurrence_Due_to_DAS__c;
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c;
        nsSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        nsSeg.Actual_Prelim_Issues_to_DAS__c = nsSeg.Prelim_Issues_Due_to_DAS__c;
        nsSeg.Actual_Prelim_Concurrence_to_DAS__c = nsSeg.Prelim_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        nsSeg.Actual_Preliminary_Signature__c = System.today().addDays(-90);
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Actual_Final_Issues_to_DAS__c = nsSeg.Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Final_Concurrence_to_DAS__c = nsSeg.Final_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-7);
		nsSeg.Actual_Amend_Final_Issues_to_DAS__c = nsSeg.Amend_Final_Issues_Due_to_DAS__c;
        nsSeg.Actual_Amend_Final_Concurrence_to_DAS__c = nsSeg.Amend_Final_Concurrence_Due_to_DAS__c;
        nsSeg.Actual_Amended_Final_Signature__c = nsSeg.Calculated_Amended_Final_Signature__c.addDays(7);
        update nsSeg;
        nsSeg = null;
		
        Test.stopTest();
        System.assertEquals(null, nsSeg.Next_Office_Deadline__c);
    }
    
    //Next Office Deadline
    @isTest static void setNextOfficeAntiCircReviewWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(acSeg.Initiation_Issues_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Issues_to_DAS__c = acSeg.Initiation_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Initiation_Concurrence_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Concurrence_to_DAS__c = acSeg.Initiation_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Initiation_Signature__c, acSeg.Next_Office_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Team_Meeting_Deadline__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Signature__c = System.today().addDays(-120);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Issues_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Prelim_Issues_to_DAS__c = acSeg.Prelim_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Prelim_Concurrence_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Prelim_Concurrence_to_DAS__c = acSeg.Prelim_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Preliminary_Signature__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Team_Meeting_Deadline__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Signature__c = System.today().addDays(-300);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Issues_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Issues_to_DAS__c = acSeg.Final_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Concurrence_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Concurrence_to_DAS__c = acSeg.Final_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Final_Signature__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeAntiCircReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(acSeg.Initiation_Issues_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Issues_to_DAS__c = acSeg.Initiation_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Initiation_Concurrence_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Concurrence_to_DAS__c = acSeg.Initiation_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Initiation_Signature__c, acSeg.Next_Office_Deadline__c);

        acSeg.Type_of_Circumvention_Inquiry__c = 'Minor Alterations of Merchandise';
        acSeg.Preliminary_Determination__c = 'No';
        acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Team_Meeting_Deadline__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Initiation_Signature__c = System.today().addDays(-300);
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Issues_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Issues_to_DAS__c = acSeg.Final_Issues_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Final_Concurrence_Due_to_DAS__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Concurrence_to_DAS__c = acSeg.Final_Concurrence_Due_to_DAS__c;
        update acSeg;
        acSeg = null;
        System.assertEquals(acSeg.Calculated_Final_Signature__c, acSeg.Next_Office_Deadline__c);

        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-7);
        update acSeg;
        acSeg = null;

        Test.stopTest();
        System.assertEquals(null, acSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeChangedCircReviewWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(ccSeg.Initiation_Issues_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Issues_to_DAS__c = ccSeg.Initiation_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Initiation_Concurrence_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Concurrence_to_DAS__c = ccSeg.Initiation_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Initiation_Signature__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Actual_Initiation_Signature__c = System.today().addDays(-7);
        ccSeg.Preliminary_Determination__c = 'Yes';
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Prelim_Team_Meeting_Deadline__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Signature__c = System.today().addDays(-180);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Prelim_Issues_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Prelim_Issues_to_DAS__c = ccSeg.Prelim_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Prelim_Concurrence_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Prelim_Concurrence_to_DAS__c = ccSeg.Prelim_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Preliminary_Signature__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Team_Meeting_Deadline__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Signature__c = System.today().addDays(-270);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Issues_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Issues_to_DAS__c = ccSeg.Final_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Concurrence_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Concurrence_to_DAS__c = ccSeg.Final_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Final_Signature__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeChangedCircReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        setExtensions();
        getNewSegs();
        System.assertEquals(ccSeg.Initiation_Issues_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Issues_to_DAS__c = ccSeg.Initiation_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Initiation_Concurrence_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Concurrence_to_DAS__c = ccSeg.Initiation_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Initiation_Signature__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
        ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Team_Meeting_Deadline__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Initiation_Signature__c = System.today().addDays(-270);
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Issues_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Issues_to_DAS__c = ccSeg.Final_Issues_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Final_Concurrence_Due_to_DAS__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Concurrence_to_DAS__c = ccSeg.Final_Concurrence_Due_to_DAS__c;
        update ccSeg;
        ccSeg = null;
        System.assertEquals(ccSeg.Calculated_Final_Signature__c, ccSeg.Next_Office_Deadline__c);

        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(-7);
        update ccSeg;
        ccSeg = null;

        Test.stopTest();
        System.assertEquals(null, ccSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeScopeInquiryWithPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        siSeg.Decision_on_How_to_Proceed__c = '';
        update siSeg;
        getNewSegs();
        System.assertEquals(siSeg.Decision_on_HOP_Issues_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Issues_to_DAS__c = siSeg.Decision_on_HOP_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Concurrence_toDAS__c = siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Deadline_for_Decision_on_How_to_Proceed__c, siSeg.Next_Office_Deadline__c);

        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Preliminary_Determination__c = 'Yes';
        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Prelim_Team_Meeting_Deadline__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Date_of_Decision_on_HoP__c = System.today().addDays(-75);
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Prelim_Issues_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Prelim_Issues_to_DAS__c = siSeg.Prelim_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Prelim_Concurrence_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Prelim_Concurrence_to_DAS__c = siSeg.Prelim_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Preliminary_Signature__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Final_Team_Meeting_Deadline__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Preliminary_Signature__c = System.today().addDays(-52);
        siSeg.Actual_Date_of_Decision_on_HoP__c = System.today().addDays(-120);
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Final_Issues_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Final_Issues_to_DAS__c = siSeg.Final_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Final_Concurrence_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Final_Concurrence_to_DAS__c = siSeg.Final_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Calculated_Final_Signature__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Final_Signature__c = siSeg.Calculated_Final_Signature__c.addDays(-7);
        update siSeg;
        siSeg = null;

        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeScopeInquiryWithoutPrelim() {
        Test.startTest();

        //setup
        setStartDates();
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        siSeg.Decision_on_How_to_Proceed__c = '';
        update siSeg;
        getNewSegs();
        System.assertEquals(siSeg.Decision_on_HOP_Issues_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Issues_to_DAS__c = siSeg.Decision_on_HOP_Issues_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c, siSeg.Next_Office_Deadline__c);

        siSeg.Actual_Decision_on_HOP_Concurrence_toDAS__c = siSeg.Decision_on_HOP_Concurrence_Due_to_DAS__c;
        update siSeg;
        siSeg = null;
        System.assertEquals(siSeg.Deadline_for_Decision_on_How_to_Proceed__c, siSeg.Next_Office_Deadline__c);

        siSeg.Decision_on_How_to_Proceed__c = 'Informal';
        siSeg.Segment_Outcome__c ='Completed';
        siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c;
        update siSeg;
        siSeg = null;
        
        Test.stopTest();
        System.assertEquals(null, siSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeSunsetReviewWithPrelim() {
        Test.startTest();

        //setup
        setFR(ssSeg.Id, 'Initiation');
        ss240();
        getNewSegs();
        System.assertEquals(ssSeg.Prelim_Team_Meeting_Deadline__c, ssSeg.Next_Office_Deadline__c);

        initFR.Published_Date__c = System.today().addDays(-110);
        update initFR;
        ssSeg = null;
        System.assertEquals(ssSeg.Prelim_Issues_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Prelim_Issues_to_DAS__c = ssSeg.Prelim_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Prelim_Concurrence_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Prelim_Concurrence_to_DAS__c = ssSeg.Prelim_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Preliminary_Signature__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Preliminary_Signature__c = System.today().addDays(-7);
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Team_Meeting_Deadline__c, ssSeg.Next_Office_Deadline__c);

        initFR.Published_Date__c = System.today().addDays(-240);
        update initFR;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Issues_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Issues_to_DAS__c = ssSeg.Final_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Concurrence_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Concurrence_to_DAS__c = ssSeg.Final_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Final_Signature__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Office_Deadline__c);
    }
    //Next Office Deadline
    @isTest static void setNextOfficeSunsetReviewWithoutPrelim() {
        Test.startTest();

        //setup
        setFR(ssSeg.Id, 'Initiation');
        ss90();
        getNewSegs();
        System.assertEquals(ssSeg.Final_Team_Meeting_Deadline__c, ssSeg.Next_Office_Deadline__c);

        initFR.Published_Date__c = System.today().addDays(-90);
        update initFR;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Issues_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Issues_to_DAS__c = ssSeg.Final_Issues_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Final_Concurrence_Due_to_DAS__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Concurrence_to_DAS__c = ssSeg.Final_Concurrence_Due_to_DAS__c;
        update ssSeg;
        ssSeg = null;
        System.assertEquals(ssSeg.Calculated_Final_Signature__c, ssSeg.Next_Office_Deadline__c);

        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-7);
        update ssSeg;
        ssSeg = null;

        Test.stopTest();
        System.assertEquals(null, ssSeg.Next_Office_Deadline__c);
    }

    /**************************
    * Validation Methods
    **************************/

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsAdministrativeReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        adminSeg.Segment_Outcome__c = 'Full Rescission';
        String insufficientDataError = attemptUpsert(adminSeg);
        Test.stopTest();
        System.assert(insufficientDataError.contains('You must enter a Rescission Federal Register'));
        
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // adminSeg.Segment_Outcome__c = 'Completed';
        // insufficientDataError = attemptUpsert(adminSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));     
    }

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsExpeditedReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        expedSeg.Segment_Outcome__c = 'Full Rescission';
        String insufficientDataError = attemptUpsert(expedSeg);
        System.assert(insufficientDataError.contains('You must enter a Rescission Federal Register'));
        
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // expedSeg.Segment_Outcome__c = 'Completed';
        // insufficientDataError = attemptUpsert(expedSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));
    }

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsNewShipperReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        nsSeg.Segment_Outcome__c = 'Full Rescission';
        String insufficientDataError = attemptUpsert(nsSeg);
        System.assert(insufficientDataError.contains('You must enter a Rescission Federal Register'));
        
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // nsSeg.Segment_Outcome__c = 'Completed';
        // insufficientDataError = attemptUpsert(nsSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));
    }

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsAntiCircReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        acSeg.Segment_Outcome__c = 'Full Rescission';
        String insufficientDataError = attemptUpsert(acSeg);
        System.assert(insufficientDataError.contains('You must enter a Rescission Federal Register'));
        
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // acSeg.Segment_Outcome__c = 'Completed';
        // insufficientDataError = attemptUpsert(acSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));
    }

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsChangedCircReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        ccSeg.Segment_Outcome__c = 'Full Rescission';
        String insufficientDataError = attemptUpsert(ccSeg);
        System.assert(insufficientDataError.contains('You must enter a Rescission Federal Register'));
        
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // ccSeg.Segment_Outcome__c = 'Completed';
        // insufficientDataError = attemptUpsert(ccSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));
    }

    //setLitigationHoldExpirationDate
    @isTest static void runValidationsSunsetReview() {
        Test.startTest();

        //Negative Tests for error on Outcome without FR
        // Following 4 lines were commented as method validateCompletedOutcome in SegmentTriggerHandler has been removed - story AD-2197
        // ssSeg.Segment_Outcome__c = 'Completed';
        // String insufficientDataError = attemptUpsert(ssSeg);

        // Test.stopTest();
        // System.assert(insufficientDataError.contains('You must enter a Final Federal Register'));
    }


    /******************
    * Status
    ******************/

    @isTest static void setStatusAdministrativeReview() {
        Test.startTest();

        //Segment- Preliminary Status
        System.assertEquals('Prelim', [SELECT Id, Segment_Outcome__c, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Final Status
        adminSeg.Actual_Preliminary_Signature__c = adminSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        setFR(adminSeg.Id, 'Preliminary');
        update adminSeg;
        getNewSegs();
        System.assertEquals('Final' ,[SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Amend Final Status
        adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-14);
        setFR(adminSeg.Id, 'Final');
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        adminSeg.Segment_Outcome__c = 'Completed';
        update adminSeg;
        getNewSegs();
        System.assertEquals('Amend Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        adminSeg.Segment_Outcome__c ='Completed';
        adminSeg.Actual_Amended_Final_Signature__c = adminSeg.Actual_Final_Signature__c.addDays(14);
        update adminSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        adminSeg.Litigation_YesNo__c = 'Yes';
        adminSeg.Litigation_Resolved__c = 'No';
        update adminSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        adminSeg.Litigation_Resolved__c = 'Yes';
        update adminSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        adminSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update adminSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Status__c);    
    }

    @isTest static void setStatusExpeditedReview() {
        Test.startTest();

        //Segment- Preliminary Status
        System.assertEquals('Prelim', [SELECT Id, Segment_Outcome__c, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Final Status
        setStartDates();
        update expedSeg;
        getNewSegs();
        expedSeg.Actual_Preliminary_Signature__c = expedSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        setFR(expedSeg.Id, 'Preliminary');
        update expedSeg;
        getNewSegs();
        System.assertEquals('Final' ,[SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Amend Final Status
        expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-14);
        setFR(expedSeg.Id, 'Final');
        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        expedSeg.Segment_Outcome__c = 'Completed';
        update expedSeg;
        getNewSegs();
        System.assertEquals('Amend Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        expedSeg.Segment_Outcome__c ='Completed';
        expedSeg.Actual_Amended_Final_Signature__c = expedSeg.Actual_Final_Signature__c.addDays(14);
        update expedSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        expedSeg.Litigation_YesNo__c = 'Yes';
        expedSeg.Litigation_Resolved__c = 'No';
        update expedSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        expedSeg.Litigation_Resolved__c = 'Yes';
        update expedSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        expedSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update expedSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusNewShipperReview() {
        Test.startTest();

        //Segment- Preliminary Status
        System.assertEquals('Prelim', [SELECT Id, Segment_Outcome__c, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Final Status
        setStartDates();
        update nsSeg;
        getNewSegs();
        nsSeg.Actual_Preliminary_Signature__c = nsSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        setFR(nsSeg.Id, 'Preliminary');
        update nsSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Amend Final Status
        nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-14);
        setFR(nsSeg.Id, 'Final');
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        nsSeg.Segment_Outcome__c = 'Completed';
        update nsSeg;
        getNewSegs();
        System.assertEquals('Amend Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        nsSeg.Segment_Outcome__c ='Completed';
        nsSeg.Actual_Amended_Final_Signature__c = nsSeg.Actual_Final_Signature__c.addDays(14);
        update nsSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        nsSeg.Litigation_YesNo__c = 'Yes';
        nsSeg.Litigation_Resolved__c = 'No';
        update nsSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        nsSeg.Litigation_Resolved__c = 'Yes';
        update nsSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        nsSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update nsSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusChangedCircumstancesReview() {
        Test.startTest();

        //Segment - Initiation Status
        System.assertEquals('Initiation', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment - Preliminary Status
        setFR(ccSeg.Id, 'Initiation');
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        ccSeg.Preliminary_Determination__c = 'Yes';
        ccSeg.Actual_Initiation_Signature__c = segmentDate;
        setStartDates();
        getNewSegs();
        System.assertEquals('Prelim', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment - Final Statss
        setFR(ccSeg.Id, 'Preliminary');
        ccSeg.Actual_Preliminary_Signature__c = ccSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        update ccSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        setFR(ccSeg.Id, 'Final');
        ccSeg.Segment_Outcome__c ='Completed';
        ccSeg.Actual_Final_Signature__c = ccSeg.Calculated_Final_Signature__c.addDays(14);
        update ccSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        ccSeg.Litigation_YesNo__c = 'Yes';
        ccSeg.Litigation_Resolved__c = 'No';
        update ccSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment Customs Status
        ccSeg.Litigation_Resolved__c = 'Yes';
        ccSeg.Have_Custom_Instruction_been_sent__c = 'No';
        update ccSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        ccSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update ccSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusAntiCircumventionReview() {
        Test.startTest();

        setStartDates();
        //Segment - Initiation Status
        System.assertEquals('Initiation', [SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Prelim Status
        setFR(acSeg.Id, 'Initiation');
        acSeg.Actual_Initiation_Signature__c = segmentDate;
        acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
        update acSeg;
        getNewSegs();
        System.assertEquals('Prelim', [SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Final Status
        setFR(acSeg.Id, 'Preliminary');
        acSeg.Actual_Preliminary_Signature__c = acSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        update acSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM  Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        setFR(acSeg.Id, 'Final');
        acSeg.Segment_Outcome__c ='Completed';
        acSeg.Actual_Final_Signature__c = acSeg.Calculated_Final_Signature__c.addDays(-14);
        update acSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        acSeg.Litigation_YesNo__c = 'Yes';
        acSeg.Litigation_Resolved__c = 'No';
        update acSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Customs Status
        acSeg.Litigation_Resolved__c = 'Yes';
        acSeg.Have_Custom_Instruction_been_sent__c = 'No';
        update acSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        acSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update acSeg;
        getNewSegs();

        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusScopeInquiry() {
        Test.startTest();

        //Segment- How To Proceed Status
        System.assertEquals('How To Proceed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        siSeg.Decision_on_How_to_Proceed__c = 'Informal';
        siSeg.Type_of_Scope_Ruling__c = 'K (1)';
        siSeg.Segment_Outcome__c = 'Completed';
        update siSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment -Prelim Status
        setStartDates();
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Preliminary_Determination__c = 'Yes';
        update siSeg;
        getNewSegs();
        System.assertEquals('Prelim', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment- Final Status
        siSeg.Actual_Preliminary_Signature__c = siSeg.Calculated_Preliminary_Signature__c.addDays(-14);
        update siSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment Hold Status
        setFR(siSeg.Id, 'Final');
        siSeg.Segment_Outcome__c ='Completed';
        siSeg.Actual_Final_Signature__c = siSeg.Calculated_Final_Signature__c.addDays(-14);
        update siSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        siSeg.Litigation_YesNo__c = 'Yes';
        siSeg.Litigation_Resolved__c = 'No';
        update siSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        siSeg.Litigation_Resolved__c = 'Yes';
        update siSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        siSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update siSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusSunsetReview90() {
        Test.startTest();

        //Segment - Initiation Status
        System.assertEquals('Initiation', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Final Status
        ss90();
        setFR(ssSeg.Id, 'Initiation');
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Hold Status
        setFR(ssSeg.Id, 'Final');
        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c;
        ssSeg.Segment_Outcome__c = 'Completed';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        ssSeg.Litigation_YesNo__c = 'Yes';
        ssSeg.Litigation_Resolved__c = 'No';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        ssSeg.Litigation_Resolved__c = 'Yes';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        ssSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update ssSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusSunsetReview120() {
        Test.startTest();

        //Segment - Initiation Status
        System.assertEquals('Initiation', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Final Status
        ss120();
        setFR(ssSeg.Id, 'Initiation');
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Hold Status
        setFR(ssSeg.Id, 'Final');
        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c;
        ssSeg.Segment_Outcome__c = 'Completed';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        ssSeg.Litigation_YesNo__c = 'Yes';
        ssSeg.Litigation_Resolved__c = 'No';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        ssSeg.Litigation_Resolved__c = 'Yes';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        ssSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update ssSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);
    }

    @isTest static void setStatusSunsetReview240() {
        Test.startTest();

        //Segment - Initiation Status
        System.assertEquals('Initiation', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Prelim Status
        ss240();
        setFR(ssSeg.Id, 'Initiation');
        getNewSegs();
        System.assertEquals('Prelim', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Final Status
        setFR(ssSeg.Id, 'Preliminary');
        ssSeg.Actual_Preliminary_Signature__c = ssSeg.Calculated_Preliminary_Signature__c;
        update ssSeg;
        getNewSegs();
        System.assertEquals('Final', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment - Hold Status
        setFR(ssSeg.Id, 'Final');
        ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c;
        ssSeg.Segment_Outcome__c = 'Completed';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Hold', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Litigation Status
        ssSeg.Litigation_YesNo__c = 'Yes';
        ssSeg.Litigation_Resolved__c = 'No';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Litigation',[SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Customs Segment
        ssSeg.Litigation_Resolved__c = 'Yes';
        update ssSeg;
        getNewSegs();
        System.assertEquals('Customs', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);

        //Segment Closed Status
        ssSeg.Have_Custom_Instruction_been_sent__c = 'Yes';
        update ssSeg;
        getNewSegs();
        
        Test.stopTest();
        System.assertEquals('Closed', [SELECT Id, Status__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Status__c);
    }


    @testSetup static void dataSetup() {
        Test.startTest();
        User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
        Petition__c testPet = TestUtils.createPetition(segmentDate.addDays(-350), 'AD ME', true);
        Investigation__c testInvAd = TestUtils.createInvestigation('AD', testPet, true);
        ADCVD_Order__c testOrder = TestUtils.createOrder(testInvAd, true);
        List<Segment__c> segsToInsert = new List<Segment__c>();
        System.runAs(testUser) {
            for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
                Segment__c testSeg = TestUtils.createSegment(testOrder, segRecordTypeName, false);
                segsToInsert.add(testSeg);
            }
            insert segsToInsert;
        }
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

    private static void setStartDates() {
        List<Segment__c> segsToUpdate = new List<Segment__c>();
        //ACR
        acSeg.Application_Accepted__c = segmentDate;
        segsToUpdate.add(acSeg);
        //Administrative Review
        adminSeg.Final_Date_of_Anniversary_Month__c = segmentDate;
        adminSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(adminSeg);
        //CCR
        ccSeg.Request_Filed__c = segmentDate;
        segsToUpdate.add(ccSeg);
        //Expedited Review
        expedSeg.Calculated_Initiation_Signature__c = segmentDate;
        expedSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(expedSeg);
        //New Shipper Review
        nsSeg.Calculated_Initiation_Signature__c = segmentDate;
        nsSeg.Will_you_Amend_the_Final__c = 'Yes';
        segsToUpdate.add(nsSeg);
        //SI
        siSeg.Request_Filed__c = segmentDate;
        siSeg.Actual_Date_of_Decision_on_HoP__c = segmentDate.addDays(21);
        siSeg.Decision_on_How_to_Proceed__c = 'Formal';
        siSeg.Type_of_Scope_Ruling__c = 'K (1)';
        segsToUpdate.add(siSeg);

        update segsToUpdate;
    }

    private static void setExtensions() {
        List<Segment__c> segsToUpdate = new List<Segment__c>();
        //ACR
        acSeg.Initiation_Extension_of_days__c = (acSeg.Type_of_Circumvention_Inquiry__c == 'Later-Developed Merchandise' || acSeg.Preliminary_Determination__c == 'Yes') ? 7 : null;
        acSeg.Prelim_Extension__c = (acSeg.Type_of_Circumvention_Inquiry__c == 'Later-Developed Merchandise' || acSeg.Preliminary_Determination__c == 'Yes') ? 7 : null;
        acSeg.Final_Extension_of_days__c = (acSeg.Type_of_Circumvention_Inquiry__c == 'Later-Developed Merchandise' || acSeg.Preliminary_Determination__c == 'Yes') ? 7 : null;
        segsToUpdate.add(acSeg);
        //Administrative Review
        adminSeg.Prelim_Extension__c = adminSeg.Prelim_Extension__c == null ? 7 : 7;
        adminSeg.Final_Extension_of_days__c = adminSeg.Final_Extension_of_days__c == null ? 7 : 7;
        segsToUpdate.add(adminSeg);
        //CCR
        ccSeg.Initiation_Extension_of_days__c = ccSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
        ccSeg.Prelim_Extension__c = ccSeg.Preliminary_Determination__c != 'Yes' ? 7 : null;
        ccSeg.Final_Extension_of_days__c = ccSeg.Final_Extension_of_days__c == null ? 7 : 7;
        segsToUpdate.add(ccSeg);
        //Expedited Review
        expedSeg.Prelim_Extension__c = expedSeg.Prelim_Extension__c == null ? 7 : 7;
        expedSeg.Final_Extension_of_days__c = expedSeg.Final_Extension_of_days__c == null ? 7 : 7;
        segsToUpdate.add(expedSeg);
        //New Shipper Review
        nsSeg.Prelim_Extension__c = nsSeg.Prelim_Extension__c == null ? 7 : 7;
        nsSeg.Final_Extension_of_days__c = nsSeg.Final_Extension_of_days__c == null ? 7 : 7;
        segsToUpdate.add(nsSeg);
        //SI
        siSeg.Prelim_Extension__c = siSeg.Decision_on_How_to_Proceed__c == 'Formal' ? 7 : null;
        siSeg.Final_Extension_of_days__c = siSeg.Decision_on_How_to_Proceed__c == 'Formal' ? 7 : null;
        siSeg.Initiation_Extension_of_days__c = siSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
        segsToUpdate.add(siSeg);
        //SSR
        //ssSeg.Prelim_Extension__c = ssSeg.Prelim_Extension__c == null ? 7 : 7;
        //ssSeg.Final_Extension_of_days__c = ssSeg.Final_Extension_of_days__c == null ? 7 : 7;
        //ssSeg.Initiation_Extension_of_days__c = ssSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
        //segsToUpdate.add(ssSeg);

        update segsToUpdate;
    }

    private static void clearFormal() {
        siSeg.Decision_on_How_to_Proceed__c = '';
        siSeg.Actual_Date_of_Decision_on_HoP__c = null;
        siSeg.Prelim_Extension__c = siSeg.Prelim_Extension__c = null;
        siSeg.Final_Extension_of_days__c = siSeg.Final_Extension_of_days__c = null;
        siSeg.Initiation_Extension_of_days__c = siSeg.Initiation_Extension_of_days__c = null;
        update siSeg;
    }

    private static void setFR(Id parentId, String frType) {
        String parentName = 'Segment__c';
        if (frType == 'Revocation') {
            parentName = 'ADCVD_Order__c';
        }
        Federal_Register__c testFR = TestUtils.createFR(parentId, parentName, segmentDate.addDays(120), frType, true);
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

    private static void ss90() {
        ssSeg.Notice_of_intent_to_participate_Ips__c = 'No';
        ssSeg.Domestic_Party_File_Substan_Response__c = 'No';
        ssSeg.Review_to_address_zeroing_in_Segments__c = '';
        ssSeg.Respondent_File_Substantive_Response__c = '';
        ssSeg.Adequacy_of_Respondents_Submission__c = '';
        update ssSeg;
    }

    private static void ss120() {
        ssSeg.Notice_of_intent_to_participate_Ips__c = 'Yes';
        ssSeg.Domestic_Party_File_Substan_Response__c = 'Yes';
        ssSeg.Review_to_address_zeroing_in_Segments__c = 'No';
        ssSeg.Respondent_File_Substantive_Response__c = 'No';
        ssSeg.Adequacy_of_Respondents_Submission__c = 'Inadequate or Non-Substantive';
        update ssSeg;
    }

    private static void ss240() {
        ssSeg.Notice_of_intent_to_participate_Ips__c = 'Yes';
        ssSeg.Domestic_Party_File_Substan_Response__c = 'Yes';
        ssSeg.Review_to_address_zeroing_in_Segments__c = 'Yes';
        ssSeg.Respondent_File_Substantive_Response__c = 'Yes';
        ssSeg.Adequacy_of_Respondents_Submission__c = 'Adequate or Substantive';
        update ssSeg;
    }

}