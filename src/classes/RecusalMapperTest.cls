/**
 *
 *    Created by Joshua Moody
 *    on 6/29/2019
 *    MIL Corporation
 *
 **/
@isTest
public class RecusalMapperTest {

    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionsList {get; set;}
    private static List<Recusal__c> recList {get; set;}

    @isTest static void testRecusalMapper(){

        dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
        mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id> {adcvdCaseList.get(0).Id})).thenReturn(adcvdCaseList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);

        RecusalSelector mockRecusalSelector = (RecusalSelector) mocks.mock(RecusalSelector.class);

        mocks.startStubbing();
        mocks.when(mockRecusalSelector.sObjectType()).thenReturn(Recusal__c.SObjectType);
        mocks.when(mockRecusalSelector.selectById(new Set<Id> {recList.get(0).Id, recList.get(1).Id})).thenReturn(recList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockRecusalSelector);

        Test.startTest();
        RecusalMapper recMapper = new RecusalMapper(new Set<Id>{recList[0].Id, recList[1].Id});
        Map<Id, SObject> idToUnlockedRecusalMap = recMapper.getMap(false);
        Map<Id, SObject> idToAllRecusalMap = recMapper.getMap(true);
        Map<Id, List<Recusal__c>> userIdToUnlockedRecusalMap = recMapper.getMapByUserIds();

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(recList[0].Id, idToUnlockedRecusalMap.get(recList[0].Id).Id);
        System.assertEquals(null, idToUnlockedRecusalMap.get(recList[1].Id));
        System.assertEquals(recList[0].Id, idToAllRecusalMap.get(recList[0].Id).Id);
        System.assertEquals(recList[1].Id, idToAllRecusalMap.get(recList[1].Id).Id);

    }

    @IsTest static void testBehavior()
    {
        RecusalMapper rm = new RecusalMapper();
        rm.getInstance();
        rm.getInstance(new Set<Id>());
        rm.getNewInstance(new Set<Id>());
    }


    private static void dataSetup(){
        // Create ADCVD_Case record
        adcvdCaseList = new List<ADCVD_Case__c>();
        adcvdCaseList.add(
            new ADCVD_Case__c(
                Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
                Locked__c = false
            )
        );

        //Create Petition records
        petitionsList = new List<Petition__c>();
        petitionsList.add(
            new Petition__c(
                Id = fflib_IDGenerator.generate(Petition__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id
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
        //Create Recusal records, one locked and one unlocked with ADCVD Case and one unlocked without ADCVD Case
        recList = new List<Recusal__c>();
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id
            )
        );
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = false
            )
        );
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = true
            )
        );
        //Create relationship between ADCVD Case and Recusals
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Recusal__c.ADCVD_Case__c,
            new List<List<Recusal__c>>{
                new List<Recusal__c> {recList.get(0)}
            }
        );
    }
}
