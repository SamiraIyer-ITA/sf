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
    private static User testUser {get; set;}

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
        mocks.when(mockRecusalSelector.selectById(new Set<Id> {recList.get(0).Id, recList.get(1).Id, recList.get(2).Id})).thenReturn(recList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockRecusalSelector);

        Test.startTest();
        RecusalMapper recMapper = new RecusalMapper(new Set<Id>{recList[0].Id, recList[1].Id, recList[2].Id});
        List<Recusal__c> unlockedRecusals = new List<Recusal__c> {recList[0], recList[1]};
        Map<Id, SObject> idToUnlockedRecusalMap = recMapper.getMap(false);
        Map<Id, SObject> idToAllRecusalMap = recMapper.getMap(true);
        Map<Id, List<Recusal__c>> userIdToUnlockedRecusalMap = recMapper.getMapByUserIds();

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(recList[0].Id, idToUnlockedRecusalMap.get(recList[0].Id).Id);
        System.assertEquals(null, idToUnlockedRecusalMap.get(recList[2].Id));
        System.assertEquals(recList[0].Id, idToAllRecusalMap.get(recList[0].Id).Id);
        System.assertEquals(recList[1].Id, idToAllRecusalMap.get(recList[1].Id).Id);
        System.assertEquals(unlockedRecusals, userIdToUnlockedRecusalMap.get(testUser.Id));

    }

    @IsTest static void testBehavior()
    {
        RecusalMapper rm = new RecusalMapper();
        RecusalMapper.getInstance();
        rm.getInstance(new Set<Id>());
        RecusalMapper.getNewInstance(new Set<Id>());
    }


    private static void dataSetup(){
        testUser = new User (Id = fflib_IDGenerator.generate(User.SObjectType));
        // Create ADCVD_Case record
        adcvdCaseList = new List<ADCVD_Case__c>();
        adcvdCaseList.add(
            new ADCVD_Case__c(
                Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
                Locked__c = false
            )
        );
        //Create Recusal records, one locked and one unlocked with ADCVD Case and one unlocked without ADCVD Case
        recList = new List<Recusal__c>();
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id,
                User__c = testUser.Id,
                Start_Date__c = System.today(),
                End_Date__c = System.today()
            )
        );
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = false,
                User__c = testUser.Id,
                Start_Date__c = System.today(),
                End_Date__c = System.today()
            )
        );
        recList.add(
            new Recusal__c(
                Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
                Locked__c = true,
                User__c = testUser.Id,
                Start_Date__c = System.today(),
                End_Date__c = System.today()
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
