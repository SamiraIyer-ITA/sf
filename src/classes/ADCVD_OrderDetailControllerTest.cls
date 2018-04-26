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
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-111-222', 'AD ME', true); //Matching case name to adcvd order case name
        Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        Investigation__c investigation = TestUtils.createInvestigation(petition, true);
        ADCVD_Order__c adcvdOrder = TestUtils.createOrder(investigation, true); 
        
        Attachment anAttachment = TestUtils.createAttachment(adcvdOrder.Id, false);
        anAttachment.Name = 'Scope.txt';
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
                segmentList = [SELECT Id,Name, ADCVD_Order__c, Next_Announcement_Date__c ,Final_Announcement_Date__c,Preliminary_Extension_Remaining__c,
                              Preliminary_Announcement_Date__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c,
                              Calculated_Final_Signature__c, Segment_Outcome__c FROM Segment__c WHERE RecordTypeId =: recordTypeId];
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
    
    static testMethod void testSegments(){
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
        update prelimARSegment;
        
        ADCVD_OrderDetailController adcvdPageController = new ADCVD_OrderDetailController();
        //Assert VF page data is correct 
        System.debug(finalARSegment.Name+'-----'+ prelimARSegment.Name);
        for(ADCVD_OrderDetailController.Segment segment: adcvdPageController.Segments){
            System.debug(segment.name);
            if(segment.announcementType == 'Final'){
                System.assertEquals(segment.name, finalARSegment.Name); 
            }else if(segment.announcementType == 'Preliminary'){
                System.assertEquals(segment.name, prelimARSegment.Name);  
            }
        }
    }
}