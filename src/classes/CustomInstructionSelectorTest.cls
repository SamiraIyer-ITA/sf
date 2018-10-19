/*
 * Create by Joshua Moody
 * on 8/29/2018
 * Mil Corporation
 */
@isTest
public class CustomInstructionSelectorTest {

	private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionsList {get; set;}
    private static List<Custom_Instruction__c> cstInstList {get; set;}

    @isTest static void testCustomInstructionSelector(){

		dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
        mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id> {adcvdCaseList.get(0).Id})).thenReturn(adcvdCaseList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);

        CustomInstructionSelector mockCustomInstructionSelector = (CustomInstructionSelector) mocks.mock(CustomInstructionSelector.class);

        mocks.startStubbing();
        mocks.when(mockCustomInstructionSelector.sObjectType()).thenReturn(Custom_Instruction__c.SObjectType);
        mocks.when(mockCustomInstructionSelector.selectById(new Set<Id> {cstInstList.get(0).Id, cstInstList.get(1).Id})).thenReturn(cstInstList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockCustomInstructionSelector);

        Test.startTest();
        List<Custom_Instruction__c> cstInstTestList = CustomInstructionSelector.newInstance().selectById(new Set<Id> {cstInstList.get(0).Id, cstInstList.get(1).Id});
        Test.stopTest();

        //Assert adcvd case records
        if (!cstInstTestList.get(0).Locked__c) {
        	System.assertEquals(cstInstList[0].Id, cstInstTestList.get(0).Id);
        	System.assertEquals(cstInstList[1].Id, cstInstTestList.get(1).Id);
        } else {
        	System.assertEquals(cstInstList[1].Id, cstInstTestList.get(0).Id);
        	System.assertEquals(cstInstList[0].Id, cstInstTestList.get(1).Id);
        }
    }

    private static void dataSetup(){
        // Create ADCVD_Case records, one locked and one unlocked
        adcvdCaseList = new List<ADCVD_Case__c>();
        adcvdCaseList.add(
            new ADCVD_Case__c(
                Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
                Locked__c = false
            )
        );

        //Create Petition records, one locked and one unlocked
        petitionsList = new List<Petition__c>();
        petitionsList.add(
            new Petition__c(
                Id = fflib_IDGenerator.generate(Petition__c.SObjectType),
                Locked__c = false
            )
        );
        //Create relationship between ADCVD_Cases and Petitions
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Petition__c.ADCVD_Case__c,
            new List<List<Petition__c>>{
                new List<Petition__c> {petitionsList.get(0)}
            }
        );
        //Create Custom Instruction records, one locked and one unlocked
        cstInstList = new List<Custom_Instruction__c>();
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false
                )
        );
        cstInstList.add(
                new Custom_Instruction__c(
                        Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                        Locked__c = true
                )
        );
        //Create relationship between ADCVD Case and Custom Instructions
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Custom_Instruction__c.ADCVD_Case__c,
                new List<List<Custom_Instruction__c>>{
                        new List<Custom_Instruction__c> {cstInstList.get(0)},
                        new List<Custom_Instruction__c> {cstInstList.get(1)}
                }
        );
        //Create relationship between Petition and Custom Instructions
        petitionsList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Petition__c>.class,
                petitionsList,
                Custom_Instruction__c.Petition__c,
                new List<List<Custom_Instruction__c>>{
                        new List<Custom_Instruction__c> {cstInstList.get(0)},
                        new List<Custom_Instruction__c> {cstInstList.get(1)}
                }
        );
    }
}