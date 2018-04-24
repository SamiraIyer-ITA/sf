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
        ADCVD_Order__c adcvdOrder = TestUtils.createOrder(investigation, false); 
        adcvdOrder.ADCVD_Case__c = adcvdCase.Id;
        insert adcvdOrder;
        //Attachment to the order
        Attachment anAttachment = TestUtils.createAttachment(adcvdOrder.Id, false);
        anAttachment.Name = 'Scope.txt';
        insert anAttachment;
        //Create two segments, one to be preliminary and one to be final
        Segment__c prelimSegment = TestUtils.createSegment(adcvdOrder, 'Administrative_Review', false);
        prelimSegment.Actual_Preliminary_Signature__c = Date.today().addDays(-7);
        prelimSegment.Calculated_Preliminary_Signature__c = Date.today().addDays(2);
        Segment__c finalSegment = TestUtils.createSegment(adcvdOrder, 'Administrative_Review', false);
        finalSegment.Actual_Final_Signature__c = Date.Today().addDays(1);
        finalSegment.Calculated_Final_Signature__c = Date.Today().addDays(1);
        finalSegment.Segment_Outcome__c = 'Withdrawn';
        insert new List<Segment__c>{prelimSegment, finalSegment};
            
            } 
    
    private static Segment__c finalAdminRevSegment{
        get{
            if(finalAdminRevSegment == null){
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                finalAdminRevSegment = [SELECT Id, ADCVD_Order__c, Next_Announcement_Date__c ,Final_Announcement_Date__c,
                                         Preliminary_Announcement_Date__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c,
                                         Calculated_Final_Signature__c, Segment_Outcome__c FROM Segment__c WHERE RecordTypeId =: recordTypeId 
                                         AND Actual_Preliminary_Signature__c =: Date.today().addDays(-7) LIMIT 1];
            }
            return finalAdminRevSegment;
        }
        set;
    }
    
    private static Segment__c prelimAdminRevSegment{
        get{
            if(prelimAdminRevSegment == null){
                Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
                prelimAdminRevSegment = [SELECT Id, ADCVD_Order__c, Next_Announcement_Date__c ,Final_Announcement_Date__c,
                                         Preliminary_Announcement_Date__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c,
                                         Calculated_Final_Signature__c, Segment_Outcome__c FROM Segment__c WHERE RecordTypeId =: recordTypeId 
                                         AND Segment_Outcome__c = 'Withdrawn' LIMIT 1];
            }
            return prelimAdminRevSegment;
        }
        set;
        
    }
    
    static testMethod void testPreliminarySegment(){
        PageReference pageRef = Page.adcvd;
        Test.setCurrentPage(pageRef);
        ADCVD_Case__c adcvdCase = [Select Id, ADCVD_Case_Number__c From ADCVD_Case__c];
        pageRef.getParameters().put('adcvdcase', adcvdCase.ADCVD_Case_Number__c);
        ADCVD_OrderDetailController adcvdPageController = new ADCVD_OrderDetailController();
        System.assert(adcvdPageController.Segments.size() == 2);
        prelimAdminRevSegment = null;
        finalAdminRevSegment = null;
        System.debug(prelimAdminRevSegment);
        System.debug(finalAdminRevSegment);
        System.assertEquals(prelimAdminRevSegment.Next_Announcement_Date__c, prelimAdminRevSegment.Preliminary_Announcement_Date__c);
        System.assertEquals(finalAdminRevSegment.Next_Announcement_Date__c, finalAdminRevSegment.Final_Announcement_Date__c);
        
    }
    
}