/**
 * Created by skip on 2/4/19.
 */

@isTest
public class LitigationMapperTest {

    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionsList {get; set;}
    private static List<Litigation__c> litList {get; set;}

    @isTest static void testLitigationMapper(){

        dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
        mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id> {adcvdCaseList.get(0).Id})).thenReturn(adcvdCaseList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);

        ILitigationSelector mockLitigationSelector = (ILitigationSelector) mocks.mock(ILitigationSelector.class);

        mocks.startStubbing();
        mocks.when(mockLitigationSelector.sObjectType()).thenReturn(Litigation__c.SObjectType);
        mocks.when(mockLitigationSelector.selectById(new Set<Id> {litList.get(0).Id, litList.get(1).Id})).thenReturn(litList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockLitigationSelector);

        Test.startTest();
        LitigationMapper litMapper = new LitigationMapper(new Set<Id>{litList[0].Id, litList[1].Id});
        Map<Id, SObject> idToUnlockedLitMap = litMapper.getMap(false);
        Map<Id, SObject> idToAllLitMap = litMapper.getMap(true);

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(litList[0].Id, idToUnlockedLitMap.get(litList[0].Id).Id);
        System.assertEquals(null, idToUnlockedLitMap.get(litList[1].Id));
        System.assertEquals(litList[0].Id, idToAllLitMap.get(litList[0].Id).Id);
        System.assertEquals(litList[1].Id, idToAllLitMap.get(litList[1].Id).Id);

    }

    @IsTest static void testBehavior()
    {
        LitigationMapper.getInstance();
        LitigationMapper.getNewInstance();
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
        //Create Litigation records, one locked and one unlocked
        litList = new List<Litigation__c>();
        litList.add(
            new Litigation__c(
                Id = fflib_IDGenerator.generate(Litigation__c.SObjectType),
                Locked__c = false,
                Litigation_Parent__c = 'Petition__c'
            )
        );
        litList.add(
            new Litigation__c(
                Id = fflib_IDGenerator.generate(Litigation__c.SObjectType),
                Locked__c = true,
                Litigation_Parent__c = 'Petition__c'
            )
        );
        //Create relationship between ADCVD Case and Litigations
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Litigation__c.ADCVD_Case__c,
            new List<List<Litigation__c>>{
                new List<Litigation__c> {litList.get(0)},
                new List<Litigation__c> {litList.get(1)}
            }
        );
        //Create relationship between Petition and Litigations
        petitionsList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Petition__c>.class,
            petitionsList,
            Litigation__c.Petition__c,
            new List<List<Litigation__c>>{
                new List<Litigation__c> {litList.get(0)},
                new List<Litigation__c> {litList.get(1)}
            }
        );
    }
}