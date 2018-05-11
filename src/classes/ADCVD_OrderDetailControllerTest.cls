/**
* 
*    Created by Eitan Alfiya
*    on April 23 2018
*    MIL Corporation
* 
**/
@isTest
public class ADCVD_OrderDetailControllerTest {
    
    @testSetup static void createData(){
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-111-222', 'AD ME', true); //Matching case name to adcvd order case name
        Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        Investigation__c investigation = TestUtils.createInvestigation(petition, true);
        ADCVD_Order__c adcvdOrder = TestUtils.createOrder(investigation, true); 
        List<Harmonized_Tariff_Schedule__c> htsList = TestUtils.createHTS(adcvdOrder, 3, true);
        Attachment anAttachment = TestUtils.createAttachment(adcvdOrder.Id, false);
        anAttachment.Name = 'Scope.txt';
        anAttachment.Body = Blob.valueOf('Some text in the body');
        insert anAttachment;
        
        //Create two segments, one to be used for preliminary announcement testing and one to be used for final announcement testing
        Segment__c segmentAR1 = TestUtils.createSegment(adcvdOrder, 'Administrative_Review', false);
        Segment__c segmentAR2 = TestUtils.createSegment(adcvdOrder, 'Administrative_Review', false);
        insert new List<Segment__c>{segmentAR1, segmentAR2};
        
    } 
    
    private static List<Segment__c> segmentList{
        get{
            if(segmentList == null){
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                segmentList = [SELECT Id,Name, ADCVD_Order__c,Country__c, Next_Announcement_Date__c ,Final_Announcement_Date__c,Preliminary_Extension_Remaining__c,
                              Preliminary_Announcement_Date__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c,ADCVD_Case_Number__c,
                              Calculated_Final_Signature__c,Product_Short_Name__c, Segment_Outcome__c, RecordType.Name FROM Segment__c WHERE RecordTypeId =: recordTypeId];
            }
            return segmentList;
        }
        set;
    }
    
    private static ADCVD_Case__c adcvdCase{
        get{
            if(adcvdCase == null){
                adcvdCase = [Select Id, ADCVD_Case_Number__c From ADCVD_Case__c];
            }
            return adcvdCase;
        }
        set;
    }
    
    private static Map<Id,Harmonized_Tariff_Schedule__c> harmonizedTariffScheduleMap{
        get{
            if(harmonizedTariffScheduleMap == null){
                harmonizedTariffScheduleMap = new Map<Id,Harmonized_Tariff_Schedule__c>([Select Id, HTS_Number__c, HTS_Number_Formatted__c From Harmonized_Tariff_Schedule__c]); 
            }
            return harmonizedTariffScheduleMap;
        }
        set;
    }
    
    static testMethod void testPreliminarySegment(){
        PageReference pageRef = Page.adcvd;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('adcvdcase', adcvdCase.ADCVD_Case_Number__c);
        
        //Set the dates in the segment to test for Final annoucement type
        Segment__c finalARSegment = segmentList[0];        
        finalARSegment.Actual_Preliminary_Signature__c = Date.today().addDays(-7);
        update finalARSegment;
        
        //Set the dates in the segment to test for Preliminary announcement type
        Segment__c prelimARSegment = segmentList[1];
        prelimARSegment.Actual_Final_Signature__c = Date.today().addDays(1);
        prelimARSegment.Segment_Outcome__c = 'Completed';
        update prelimARSegment;
        
        //Requery the records
        segmentList = null;
        finalARSegment = segmentList[0];
        prelimARSegment = segmentList[1];
        ADCVD_OrderDetailController adcvdPageController = new ADCVD_OrderDetailController();
        //Assert VF page data is correct 
        for(ADCVD_OrderDetailController.Segment segment: adcvdPageController.Segments){
            if(segment.announcementType == 'Final'){
                System.assertEquals(segment.name, finalARSegment.Name); 
                System.assertEquals(segment.recordType, finalARSegment.RecordType.Name);
                System.assertEquals(segment.productShortName, finalARSegment.Product_Short_Name__c);
                System.assertEquals(segment.country, finalARSegment.Country__c);
                System.assertEquals(segment.caseNumber, finalARSegment.ADCVD_Case_Number__c);
                System.assertEquals(segment.announcementDate, finalARSegment.Next_Announcement_Date__c.format());
            }else if(segment.announcementType == 'Preliminary'){
                System.assertEquals(segment.name, prelimARSegment.Name); 
                System.assertEquals(segment.recordType, prelimARSegment.RecordType.Name);
                System.assertEquals(segment.productShortName, prelimARSegment.Product_Short_Name__c);
                System.assertEquals(segment.country, prelimARSegment.Country__c);
                System.assertEquals(segment.caseNumber, prelimARSegment.ADCVD_Case_Number__c);
                System.assertEquals(segment.announcementDate, prelimARSegment.Next_Announcement_Date__c.format());
            }
        }
        harmonizedTariffScheduleMap = null;
        //Assert List of HTS Numbers is correct
        for(Harmonized_Tariff_Schedule__c hts: adcvdPageController.order.Harmonized_Tariff_Schedules__r){
        	System.assertEquals(hts.HTS_Number_Formatted__c, harmonizedTariffScheduleMap.get(hts.Id).HTS_Number_Formatted__c);    
        }
        //Assert text body of attachment
        System.assertEquals(adcvdPageController.attachmentBody, 'Some text in the body');
    }
}