/*
 * Created by Eitan Alfiya
 * on 5/14/2018
 * Mil Corporation
 */
@isTest
public class StaffingAssignmentsSelectorTest {
    //Test Staffing Assignment Selector, include Related Organizations
    @testSetup static void dataSetup(){
        //Create custom settings data
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
		Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        Related_Organization__c relatedOrg = TestUtils.createRelatedOrg(petition, true);
    }
    
    private static Related_Organization__c relatedOrg{
        get{
            if(relatedOrg == null){
                relatedOrg = [Select Id From Related_Organization__c Limit 1];
            }
            return relatedOrg;
        }
        set;
    }
    
    private static Petition__c petition{
        get{
            if(petition == null){
                petition = [Select Id From Petition__c Limit 1];
            }
            return petition;
        }
        set;
    }
    
    @isTest static void testStaffingAssignments(){
        Test.startTest();
        StaffingAssignmentsSelector.setParentIdsToStaffLists(petition.Id, 'Petition__c');
        Test.stopTest();
        StaffingAssignmentsSelector SAS = new StaffingAssignmentsSelector();
        //Related organization has 2 staffing assignments, Petition has 15 staffing assignments
        List<Staffing_Assignment__c> saList = SAS.getStaffingAssignments(petition.Id);
        for(Staffing_Assignment__c SA: saList){
            if(SA.Petition__c != null){
             	System.assertEquals(petition.Id, SA.Petition__c);   
            }
            else if(SA.Related_Organization__c != null){
                System.assertEquals(relatedOrg.Id, SA.Related_Organization__c);
            }
        }
    }
}