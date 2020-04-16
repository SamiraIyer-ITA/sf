@isTest
public class ADCVD_TollingDayMapperTest {

    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionsList {get; set;}
    private static List<Investigation__c> investigationList {get; set;}
    private static List<Segment__c> segmentList {get; set;}
    private static List<Tolling_Day__c> tdList {get; set;}
    private static Id standardRecordTypeId = Utils.getRecordTypeIdMap('Tolling_Day__c').get('Standard_Tolling');
    private static Id specificRecordTypeId = Utils.getRecordTypeIdMap('Tolling_Day__c').get('Toll_By_Specific_Record');

    @isTest static void testADCVD_TollingDayMapper_PetitionParent(){

        dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_TollingDaySelector mockADCVD_TollingDaySelector = (ADCVD_TollingDaySelector) mocks.mock(ADCVD_TollingDaySelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_TollingDaySelector.sObjectType()).thenReturn(Tolling_Day__c.SObjectType);
        mocks.when(mockADCVD_TollingDaySelector.selectAllToLimit()).thenReturn(tdList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_TollingDaySelector);

        Test.startTest();
        ADCVD_TollingDayMapper tdMapper = new ADCVD_TollingDayMapper(true);
        Map<Id, SObject> standardTollingDayMap = tdMapper.getMap();
        Map<Id, SObject> specificTollingDayMap = tdMapper.getMap(petitionsList[0].Id);

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(tdList[0].Id, standardTollingDayMap.get(tdList[0].Id).Id);
        System.assertEquals(tdList[1].Id, specificTollingDayMap.get(tdList[1].Id).Id);
    }

    @isTest static void testADCVD_TollingDayMapper_InvestigationParent(){

        dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_TollingDaySelector mockADCVD_TollingDaySelector = (ADCVD_TollingDaySelector) mocks.mock(ADCVD_TollingDaySelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_TollingDaySelector.sObjectType()).thenReturn(Tolling_Day__c.SObjectType);
        mocks.when(mockADCVD_TollingDaySelector.selectAllToLimit()).thenReturn(tdList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_TollingDaySelector);

        Test.startTest();
        ADCVD_TollingDayMapper tdMapper = new ADCVD_TollingDayMapper(true);
        Map<Id, SObject> standardTollingDayMap = tdMapper.getMap();
        Map<Id, SObject> specificTollingDayMap = tdMapper.getMap(investigationList[0].Id);

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(tdList[0].Id, standardTollingDayMap.get(tdList[0].Id).Id);
        System.assertEquals(tdList[2].Id, specificTollingDayMap.get(tdList[2].Id).Id);
    }

    @isTest static void testADCVD_TollingDayMapper_SegmentParent(){

        dataSetup();
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_TollingDaySelector mockADCVD_TollingDaySelector = (ADCVD_TollingDaySelector) mocks.mock(ADCVD_TollingDaySelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_TollingDaySelector.sObjectType()).thenReturn(Tolling_Day__c.SObjectType);
        mocks.when(mockADCVD_TollingDaySelector.selectAllToLimit()).thenReturn(tdList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_TollingDaySelector);

        Test.startTest();
        ADCVD_TollingDayMapper tdMapper = new ADCVD_TollingDayMapper(true);
        Map<Id, SObject> standardTollingDayMap = tdMapper.getMap();
        Map<Id, SObject> specificTollingDayMap = tdMapper.getMap(segmentList[0].Id);

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(tdList[0].Id, standardTollingDayMap.get(tdList[0].Id).Id);
        System.assertEquals(tdList[3].Id, specificTollingDayMap.get(tdList[3].Id).Id);
    }

    @IsTest static void testBehavior()
    {
        ADCVD_TollingDayMapper tollingMapper = new ADCVD_TollingDayMapper().getInstance();
        ADCVD_TollingDayMapper tollingMapper2 = new ADCVD_TollingDayMapper().getInstance();
        ADCVD_TollingDayMapper.getNewInstance();
        tollingMapper.getMap(true);
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
        //Create Investigation records
        investigationList = new List<Investigation__c>();
        investigationList.add(
                new Investigation__c(
                        Id = fflib_IDGenerator.generate(Investigation__c.SObjectType),
                        Locked__c = false
                )
        );
        //Create relationship between ADCVD_Cases and Petitions
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Investigation__c.ADCVD_Case__c,
                new List<List<Investigation__c>>{
                        new List<Investigation__c> {investigationList.get(0)}
                }
        );
        //Create Segment records
        segmentList = new List<Segment__c>();
        segmentList.add(
                new Segment__c(
                        Id = fflib_IDGenerator.generate(Segment__c.SObjectType),
                        Locked__c = false
                )
        );
        //Create relationship between ADCVD_Cases and Petitions
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Segment__c.ADCVD_Case__c,
                new List<List<Segment__c>>{
                        new List<Segment__c> {segmentList.get(0)}
                }
        );
        //Create Tolling Day records, one standard and one specific to Petition
        tdList = new List<Tolling_Day__c>();
        tdList.add(
                new Tolling_Day__c(
                    Id = fflib_IDGenerator.generate(Tolling_Day__c.SObjectType),
                    RecordTypeId = standardRecordTypeId
                )
        );
        tdList.add(
                new Tolling_Day__c(
                        Id = fflib_IDGenerator.generate(Tolling_Day__c.SObjectType),
                        RecordTypeId = specificRecordTypeId,
                    	Petition__c = petitionsList[0].Id
                )
        );
        tdList.add(
                new Tolling_Day__c(
                        Id = fflib_IDGenerator.generate(Tolling_Day__c.SObjectType),
                        RecordTypeId = specificRecordTypeId,
                        Investigation__c = investigationList[0].Id
                )
        );
        tdList.add(
                new Tolling_Day__c(
                        Id = fflib_IDGenerator.generate(Tolling_Day__c.SObjectType),
                        RecordTypeId = specificRecordTypeId,
                        Segment__c = segmentList[0].Id
                )
        );
        //Create relationship between Petition and Tolling Days
        petitionsList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Petition__c>.class,
                petitionsList,
                Tolling_Day__c.Petition__c,
                new List<List<Tolling_Day__c>>{
                        new List<Tolling_Day__c> {tdList.get(1)}
                }
        );
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Investigation__c>.class,
                investigationList,
                Tolling_Day__c.Investigation__c,
                new List<List<Tolling_Day__c>>{
                        new List<Tolling_Day__c> {tdList.get(2)}
                }
        );
        segmentList = (List<Segment__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Segment__c>.class,
                segmentList,
                Tolling_Day__c.Segment__c,
                new List<List<Tolling_Day__c>>{
                        new List<Tolling_Day__c> {tdList.get(3)}
                }
        );
    }
}