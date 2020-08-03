/**
* 
*    Created by Eitan Alfiya
*    on April 23 2018
*    MIL Corporation
* 
**/
@isTest
public class ADCVD_OrderDetailControllerTest {

    @testSetup static void createData() {
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        User pleaseAssignUser = TestUtils.createAdminUser(false, 'myemail2@email.com.testita', 2);
        pleaseAssignUser.LastName = 'Test1 Assign';
        pleaseAssignUser.Staffing_Role__c = 'Program Manager';
        insert pleaseAssignUser;
        
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-111-222', 'AD ME', true); //Matching case name to adcvd order case name
        adcvdCase.Program_Manager__c = pleaseAssignUser.Id;
        update adcvdCase ;
        
        Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        //Investigations are now combined on the page, inside the same wrapper class, and are part of the assertions
        Investigation__c investigationAD1 = TestUtils.createInvestigation(petition, false);
        investigationAD1.RecordTypeId = utils.getRecordTypeIdMap('Investigation__c').get('AD');
        insert investigationAD1;
        

    }
    //TODO: use a selector here instead of a query
    private static Segment__c segment {
        get {
            if (segment == null) {
                segment = [
                        Select Id, Name, Country_Text__c, ADCVD_Case_Number_Text__c, Actual_Final_Signature__c, Segment_Outcome__c, RecordType.Name,
                                Product_Short_Name_Text__c, Next_Announcement_Date__c
                        From Segment__c
                        Limit 1
                ];
            }
            return segment;
        }
        set;
    }
    //TODO: use a selector here instead of a query
    private static Investigation__c investigation {
        get {
            if (investigation == null) {
                investigation = [
                        Select Id, Name, Actual_Preliminary_Signature__c, Country_Text__c, ADCVD_Case_Number_Text__c, Product_Short_Name_Text__c,
                                RecordType.Name, Next_Announcement_Date__c, Announcement_Type__c
                        From Investigation__c
                        Limit 1
                ];
            }
            return investigation;
        }
        set;
    }
    //TODO: use a selector here instead of a query
    private static ADCVD_Case__c adcvdCase {
        get {
            if (adcvdCase == null) {
                adcvdCase = [Select Id,Locked__c, ADCVD_Case_Number__c From ADCVD_Case__c];
            }
            return adcvdCase;
        }
        set;
    }

    private static Map<Id, Harmonized_Tariff_Schedule__c> harmonizedTariffScheduleMap {
        get {
            if (harmonizedTariffScheduleMap == null) {
                harmonizedTariffScheduleMap = new Map<Id, Harmonized_Tariff_Schedule__c>([Select Id, HTS_Number__c, HTS_Number_Formatted__c From Harmonized_Tariff_Schedule__c]);
            }
            return harmonizedTariffScheduleMap;
        }
        set;
    }

    @isTest static void testPreliminarySegment() {
        ADCVD_Order__c adcvdOrder = TestUtils.createOrder(investigation, true);
        List<Harmonized_Tariff_Schedule__c> htsList = TestUtils.createHTS(adcvdOrder, 3, true);
        Attachment anAttachment = TestUtils.createAttachment(adcvdOrder.Id, false);
        anAttachment.Name = 'Scope.txt';
        anAttachment.Body = Blob.valueOf('Some text in the body');
        insert anAttachment;
        //Create a segment to be used in testing, for preliminary announcement type
        Segment__c segmentAR1 = TestUtils.createSegment(adcvdOrder, 'Administrative_Review', false);
        //Set the date in the segment to test for Preliminary announcement type
        segmentAR1.Actual_Final_Signature__c = Date.today().addDays(1);
        segmentAR1.Segment_Outcome__c = 'Completed';
        insert segmentAR1;


        PageReference pageRef = Page.adcvd;
        
        pageRef.getParameters().put('adcvdcase', 'A-111-222');

        //Set the date in the investigation to test for Final announcement type
        investigation.Actual_Preliminary_Signature__c = Date.today().addDays(-7);
        update investigation;

                
        //Requery the records
        segment = null;
        investigation = null;
        Test.startTest();
        Test.setCurrentPage(pageRef);
        ADCVD_OrderDetailController adcvdPageController = new ADCVD_OrderDetailController();
        //Assert VF page data is correct
        System.debug(adcvdPageController.segInvList);
        for (ADCVD_OrderDetailController.SegmentInvestigationObj segmentInvestigationObj : adcvdPageController.segInvList) {
            if (segmentInvestigationObj.announcementType == 'Final') {
                System.assertEquals(segmentInvestigationObj.name, investigation.Name);
                System.assertEquals(segmentInvestigationObj.recordType, investigation.RecordType.Name);
                System.assertEquals(segmentInvestigationObj.productShortName, investigation.Product_Short_Name_Text__c);
                System.assertEquals(segmentInvestigationObj.country, investigation.Country_Text__c);
                System.assertEquals(segmentInvestigationObj.caseNumber, investigation.ADCVD_Case_Number_Text__c);
                System.assertEquals(segmentInvestigationObj.announcementDate, investigation.Next_Announcement_Date__c.format());
            } else if (segmentInvestigationObj.announcementType == 'Preliminary') {
                System.assertEquals(segmentInvestigationObj.name, segment.Name);
                System.assertEquals(segmentInvestigationObj.recordType, segment.RecordType.Name);
                System.assertEquals(segmentInvestigationObj.productShortName, segment.Product_Short_Name_Text__c);
                System.assertEquals(segmentInvestigationObj.country, segment.Country_Text__c);
                System.assertEquals(segmentInvestigationObj.caseNumber, segment.ADCVD_Case_Number_Text__c);
                System.assertEquals(segmentInvestigationObj.announcementDate, segment.Next_Announcement_Date__c.format());
            }
        }
        harmonizedTariffScheduleMap = null;
        //Assert List of HTS Numbers is correct
        for (Harmonized_Tariff_Schedule__c hts : adcvdPageController.caseObj.Harmonized_Tariff_Schedules__r) {
            System.assertEquals(hts.HTS_Number_Formatted__c, harmonizedTariffScheduleMap.get(hts.Id).HTS_Number_Formatted__c);
        }
        //Assert text body of attachment
        System.assertEquals(adcvdPageController.attachmentBody, 'Some text in the body');
    }
    @isTest static void testFinalInvestigation() {
        PageReference pageRef = Page.adcvd;
        
        pageRef.getParameters().put('adcvdcase', 'A-111-222');

        //Set the date in the investigation to test for Final announcement type
        investigation.Actual_Preliminary_Signature__c = Date.today().addDays(-7);
        update investigation;
        
        //Requery the records
        investigation = null;
        Test.startTest();
        Test.setCurrentPage(pageRef);
        ADCVD_OrderDetailController adcvdPageController = new ADCVD_OrderDetailController();
        //Assert VF page data is correct
        System.debug(adcvdPageController.caseObj);
        for (ADCVD_OrderDetailController.SegmentInvestigationObj segmentInvestigationObj : adcvdPageController.segInvList) {
            if (segmentInvestigationObj.announcementType == 'Final') {
                System.assertEquals(segmentInvestigationObj.name, investigation.Name);
                System.assertEquals(segmentInvestigationObj.recordType, investigation.RecordType.Name+' Investigation');
                System.assertEquals(segmentInvestigationObj.productShortName, investigation.Product_Short_Name_Text__c);
                System.assertEquals(segmentInvestigationObj.country, investigation.Country_Text__c);
                System.assertEquals(segmentInvestigationObj.caseNumber, investigation.ADCVD_Case_Number_Text__c);
                System.assertEquals(segmentInvestigationObj.announcementDate, investigation.Next_Announcement_Date__c.format());
            } else if (segmentInvestigationObj.announcementType == 'Preliminary') {
                System.assertEquals(segmentInvestigationObj.name, segment.Name);
                System.assertEquals(segmentInvestigationObj.recordType, segment.RecordType.Name+' Investigation');
                System.assertEquals(segmentInvestigationObj.productShortName, segment.Product_Short_Name_Text__c);
                System.assertEquals(segmentInvestigationObj.country, segment.Country_Text__c);
                System.assertEquals(segmentInvestigationObj.caseNumber, segment.ADCVD_Case_Number_Text__c);
                System.assertEquals(segmentInvestigationObj.announcementDate, segment.Next_Announcement_Date__c.format());
            }
        }
    }
}