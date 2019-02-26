@isTest
public with sharing class ADCVDCaseTriggerHandlerTest {

    private static Map<Id, ADCVD_Case__c> casesMap{
        get{
            if(casesMap == null){
                casesMap = new Map<Id, ADCVD_Case__c>([SELECT Id, ADCVD_Case_Type__c, Commodity__c, Country__c, Product_Short_Name__c, Product__c, LastModifiedDate FROM ADCVD_Case__c]);
            }
            return casesMap;
        }
        set;
    }

    private static ADCVD_Case__c adCase{
        get{
            if(adCase == null){
                adCase = [SELECT Id, Name, ADCVD_Case_Number__c, Case_Concat_Text_Values__c FROM ADCVD_Case__c WHERE ADCVD_Case_Type__c = 'AD ME'];
            }
            return adCase;
        }
        set;
    }

    private static ADCVD_Case__c cvdCase{
        get{
            if(cvdCase == null){
                cvdCase = [SELECT Id, Name, ADCVD_Case_Number__c, Case_Concat_Text_Values__c FROM ADCVD_Case__c WHERE ADCVD_Case_Type__c = 'CVD'];
            }
            return cvdCase;
        }
        set;
    }

    @isTest static void testStandardizedFieldChange(){
        //This test method tests the functionality of the checkStandardizedFieldChanges() method in the ADCVDCaseTriggerHandler
        casesMap = null;
        List<ADCVD_Case__c> newList = new List<ADCVD_Case__c>();
        for(ADCVD_Case__c adcvdCase: casesMap.values()){
            //Clone with preserving id equals to true
            ADCVD_Case__c newCase = adcvdCase.clone(true);
            newCase.Country__c = 'United States';
            newCase.Product__c = 'New Name';
            newList.add(newCase);
        }
        List<ADCVD_Case__c> changedCasesList = ADCVDCaseTriggerHandler.getChangedCases(newList, casesMap);
        System.assertEquals(newList.size(), changedCasesList.size());
    }

    @isTest static void testFieldUpdateOnInsert(){
        adCase = null;
        cvdCase = null;
        //Concatenated case fields have the following format: "Commodity__c; Country__c; ADCVD_Case_Type_Text__c"
        String adCaseConcatenatedField = 'Foodstuffs; Argentina; AD ME';
        String cvdCaseConcatenatedField = 'Foodstuffs; Argentina; CVD';
        //Assert that custom text field have been populated correctly
        //ADCVD Case Number is used in the parent value service class to populate child records with the case number.
        System.assertEquals(adCase.ADCVD_Case_Number__c, adCase.Name);
        System.assertEquals(adCase.Case_Concat_Text_Values__c, adCaseConcatenatedField);
        System.assertEquals(cvdCase.ADCVD_Case_Number__c, cvdCase.Name);
        System.assertEquals(cvdCase.Case_Concat_Text_Values__c, cvdCaseConcatenatedField);
    }

    @isTest static void testFieldUpdateOnUpdate(){
        Test.startTest();
        adCase = null;
        cvdCase = null;

        adCase.Country__c = 'China';
        cvdCase.Commodity__c = 'Minerals';
        List<ADCVD_Case__c> casesToUpdate = new List<ADCVD_Case__c>{adCase, cvdCase};
        System.debug(casesToUpdate);
        update casesToUpdate;
        Test.stopTest();
        adCase = null;
        cvdCase = null;

        //Concatenated case fields have the following format: "Commodity__c; Country__c; ADCVD_Case_Type_Text__c"
        String adCaseConcatenatedField = 'Foodstuffs; China; AD ME';
        String cvdCaseConcatenatedField = 'Minerals; Argentina; CVD';

        System.assertEquals(adCaseConcatenatedField, adCase.Case_Concat_Text_Values__c);
        System.assertEquals(cvdCaseConcatenatedField, cvdCase.Case_Concat_Text_Values__c);


    }

    @isTest static void testBatchJobInPipeline(){
        //This test method tests the functionality of the getRecentlyModifiedCases() method in ADCVDCaseTriggerHandler
        //Pass one case to the getRecentlyModifiedCases, and confirm it will return two cases. Since two cases were created in this test class (past 24 hrs)
        adCase = null;
        List<ADCVD_Case__c> casesList = new List<ADCVD_Case__c>{adCase};
        casesList = ADCVDCaseTriggerHandler.getRecentlyModifiedCases(casesList);
        System.assert(casesList.size() == 2);

    }

    @testSetup static void dataSetup(){
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('ADCVDStandardCaseFieldBatch', true, true);
        //create test data
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-534-124', 'AD ME', false);
        ADCVD_Case__c testCVDCase = TestUtils.createADCVDCase('C-352-523', 'CVD', false);
        List<ADCVD_Case__c> casesToInsert = new List<ADCVD_Case__c>{testADCase, testCVDCase};
        insert casesToInsert;
    }
}