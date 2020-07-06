/**
*
*    Created by Sean Babalola
*    on June 22 2020
*    MIL Corporation
*
**/

@isTest
public class StaffingAssignment_Test{
    
    static Petition__c p {
        get {
            if (p == null) {
                p = [SELECT Id,ADCVD_Case__c FROM Petition__c LIMIT 1];
            }
            return p;
        } set;
    }
    
    @testSetup static void dataSetup() {
        
        
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
        User testUser = TestUtils.createAdminUser(false, 'myemail@email.com.testita', 1);
        testUser.Staffing_Role__c = 'Program Manager';
        insert testUser;
        
        User pleaseAssignUser = TestUtils.createAdminUser(false, 'myemail2@email.com.testita', 2);
        pleaseAssignUser.LastName = 'Test1 Assign';
        pleaseAssignUser.Staffing_Role__c = 'Program Manager';
        insert pleaseAssignUser;
        
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        testADCase.Program_Manager__c = pleaseAssignUser.Id;
        update testADCase;
        
        Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);
        Recusal__c testRecusal = TestUtils.createRecusal(pleaseAssignUser.Id, System.today(), System.today().addDays(3), true);
        
       
    }
    
    @isTest static void unittest() {
    
        Test.startTest();
        
        StaffingAssignment.getStaffingAssignmentByParentId(p.Id);
        StaffingAssignment.getRecusalLinkMap(p.ADCVD_Case__c);
        Staffing_Assignment__c testNewSA = StaffingAssignmentExtension.createNewStaffingAssignment(p.Id, 'Office Director');
        StaffingAssignment.deleteRecord(testNewSA.Id);
        
        List<Staffing_Assignment__c> checkSAList = [SELECT Id FROM Staffing_Assignment__c WHERE Id =: testNewSA.Id];
        
        System.assertEquals(checkSAList.isEmpty(),true);
        
        Test.stopTest();
    }


    
    
}