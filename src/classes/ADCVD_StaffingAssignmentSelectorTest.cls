@isTest
public class ADCVD_StaffingAssignmentSelectorTest
{

    @testSetup static void dataSetup()
    {
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        ADCVD_Case__c adcvdCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c petition = TestUtils.createPetition(adcvdCase, Date.today(), true);
        Related_Organization__c relatedOrg = TestUtils.createRelatedOrg(petition, true);
    }

    private static Related_Organization__c relatedOrg
    {
        get {
            if (relatedOrg == null) {
                relatedOrg = [Select Id From Related_Organization__c Limit 1];
            }
            return relatedOrg;
        }
        set;
    }

    private static Petition__c petition
    {
        get {
            if (petition == null) {
                petition = [Select Id From Petition__c Limit 1];
            }
            return petition;
        }
        set;
    }

    @isTest static void testStaffingAssignments()
    {
        Test.startTest();
        Map<Id, List<Staffing_Assignment__c>> staffingAssignmentMap = ADCVD_StaffingAssignmentSelector.newInstance().selectByParentId(new Set<Id> {petition.Id}, new Set<Id> {relatedOrg.Id});
        Test.stopTest();
        List<Staffing_Assignment__c> saList = staffingAssignmentMap.get(petition.Id);
        for (Staffing_Assignment__c SA : saList) {
            if (SA.Petition__c != null) {
                System.assertEquals(petition.Id, SA.Petition__c);
            } else if (SA.Related_Organization__c != null) {
                System.assertEquals(relatedOrg.Id, SA.Related_Organization__c);
            }
        }
    }
}