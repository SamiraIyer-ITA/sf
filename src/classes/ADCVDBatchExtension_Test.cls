/**
*
*    Created by Sean Babalola
*    on August 20 2020
*    MIL Corporation
*
**/

@isTest
public class ADCVDBatchExtension_Test{
    
    static List<ADCVD_Case__c> caseList {
        get {
            if (caseList == null) {
                caseList = [SELECT Id FROM ADCVD_Case__c];
            }
            return caseList;
        } set;
    }
    
    @testSetup static void dataSetup() {
        
        
        //create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('ADCVDStandardCaseFieldsBatch', true, true);
        //create test data
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
        
       
    }
    
    @isTest static void unittest1() {
    
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(caseList[0]);
        ADCVDBatchExtension objClsBatch = new ADCVDBatchExtension(sc);
        
        PageReference pageRef = Page.ADCVDCaseBatch;
        pageRef.getParameters().put('id', String.valueOf(caseList[0].Id));
        Test.setCurrentPage(pageRef);
    
        
        objClsBatch.callBatch();
        
        System.assertEquals(!caseList.isEmpty(),true);
        
        Test.stopTest();
    }


    
    
}