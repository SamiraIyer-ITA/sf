/**
*
*    Created by Sean Babalola
*    on June 22 2020
*    MIL Corporation
*
**/

@IsTest
public class StaffingAssignment_Test {

    static Petition__c p {
        get {
            if (p == null) {
                p = [SELECT Id,ADCVD_Case__c FROM Petition__c LIMIT 1];
            }
            return p;
        }
        set;
    }

    @TestSetup static void dataSetup() {
        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);

        System.runAs(testUser) {
            Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
            AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
            //create test data

            ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser,true);

            Petition__c testADPetition = TestUtils.createPetition(testADCase, System.today().addDays(-280), true);

            Recusal__c testRecusal = TestUtils.createRecusal(testUser.Id, System.today(), System.today().addDays(3), true);
        }
    }

    @IsTest static void unittest() {

        Test.startTest();

        StaffingAssignment.getStaffingAssignmentByParentId(p.Id);
        Boolean deleteCheck = StaffingAssignment.doesRunningUserHavePermission();
        StaffingAssignment.getRecusalLinkMap(p.ADCVD_Case__c);
        Staffing_Assignment__c testNewSA = StaffingAssignmentExtension.createNewStaffingAssignment(p.Id, 'Office Director');
        StaffingAssignment.deleteRecord(testNewSA.Id);

        List<Staffing_Assignment__c> checkSAList = [SELECT Id FROM Staffing_Assignment__c WHERE Id = :testNewSA.Id];

        System.assertEquals(checkSAList.isEmpty(), true);

        Test.stopTest();
    }
}