/**
 * 
 *    Created by Joshua Moody
 *    on 8/29/2018
 *    MIL Corporation
 * 
 **/
@isTest
public class CustomInstructionTriggerHandlerTest {
    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionList {get; set;}
    private static List<Investigation__c> investigationList {get; set;}
    private static List<ADCVD_Order__c> orderList {get; set;}
    private static List<Suspension_Agreement__c> suspAgrmtList {get; set;}
    private static List<Segment__c> segmentList {get; set;}
    private static List<Custom_Instruction__c> cstInstList {get; set;}
    private static Map<Id,Custom_Instruction__c> cstInstMap {get; set;}

    @isTest static void testInitialize(){
        dataSetup();
        selectorSetup();
        CustomInstructionMapper cstInstMapper = new CustomInstructionMapper(new Set<Id> {
        	cstInstList[0].Id, 
        	cstInstList[1].Id, 
        	cstInstList[2].Id, 
        	cstInstList[3].Id, 
        	cstInstList[4].Id
        	}
        );

        Test.startTest();
        CustomInstructionTriggerHandler.initialize(cstInstList, null);
        Test.stopTest();

        //Assert adcvd case records
        System.assertNotEquals(CustomInstructionTriggerHandler.caseMapper, null);
        System.assertEquals(cstInstList[0].CI_Parent__c, 'Petition__c');

    }

    @isTest static void testSetCaseValues(){
        dataSetup();
        selectorSetup();
        CustomInstructionMapper cstInstMapper = new CustomInstructionMapper(new Set<Id> {
        	cstInstList[0].Id, 
        	cstInstList[1].Id, 
        	cstInstList[2].Id, 
        	cstInstList[3].Id, 
        	cstInstList[4].Id
        	}
        );

        Test.startTest();
        CustomInstructionTriggerHandler.mainEntry(cstInstList, null, null, null, true, true, false);
        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(adcvdCaseList[0].Country__c, cstInstList[0].Country_Text__c);
    }

    @isTest static void testAddNewCIsToMapper(){
        dataSetup();
        selectorSetup();
        cstInstMap = new Map<Id, Custom_Instruction__c>();
        for (Custom_Instruction__c ci : cstInstList) {
        	cstInstMap.put(ci.Id, ci);
        }

        Test.startTest();
        CustomInstructionTriggerHandler.mainEntry(cstInstList, cstInstList, cstInstMap, null, true, false, true);
        Test.stopTest();

        //Assert adcvd case records
        for (Custom_Instruction__c ci : cstInstList) {
        	CustomInstructionMapper cim = (CustomInstructionMapper) ADCVD_CaseMapper.mapperMap.get('Custom_Instruction__c');
        	System.assert(cim.getMap().containsKey(ci.Id));
        }
        
    }

    @IsTest
    static void exerciseTrigger()
    {
        insert new Custom_Instruction__c(ADCVD_Case_Number_Text__c = '--This is a test--');
    }

    private static void dataSetup(){
        // Create ADCVD_Case record
        adcvdCaseList = new List<ADCVD_Case__c>();
        adcvdCaseList.add(
            new ADCVD_Case__c(
                Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
                Locked__c = false,
                Country__c = 'Mexico'
            )
        );
        //Create Petition record
        petitionList = new List<Petition__c>();
        petitionList.add(
            new Petition__c(
                Id = fflib_IDGenerator.generate(Petition__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id
            )
        );
        //Create Investigation record
        investigationList = new List<Investigation__c>();
        investigationList.add(
            new Investigation__c(
                Id = fflib_IDGenerator.generate(Investigation__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id,
                Petition__c = petitionList[0].Id
            )
        );
        //Create ADCVD Order record
        orderList = new List<ADCVD_Order__c>();
        orderList.add(
            new ADCVD_Order__c(
                Id = fflib_IDGenerator.generate(ADCVD_Order__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id,
                Investigation__c = investigationList[0].Id
            )
        );
        //Create Suspension Agreement record
        suspAgrmtList = new List<Suspension_Agreement__c>();
        suspAgrmtList.add(
            new Suspension_Agreement__c(
                Id = fflib_IDGenerator.generate(Suspension_Agreement__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id,
                Investigation__c = investigationList[0].Id
            )
        );
        //Create Segment record
        segmentList = new List<Segment__c>();
        segmentList.add(
            new Segment__c(
                Id = fflib_IDGenerator.generate(Segment__c.SObjectType),
                Locked__c = false,
                ADCVD_Case__c = adcvdCaseList[0].Id,
                ADCVD_Order__c = orderList[0].Id
            )
        );
        //Create Custom Instruction records
        cstInstList = new List<Custom_Instruction__c>();
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false,
                    Petition__c = petitionList[0].Id
                )
        );
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false,
                    Investigation__c = investigationList[0].Id
                )
        );
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false,
                    ADCVD_Order__c = orderList[0].Id
                )
        );
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false,
                    Suspension_Agreement__c = suspAgrmtList[0].Id
                )
        );
        cstInstList.add(
                new Custom_Instruction__c(
                    Id = fflib_IDGenerator.generate(Custom_Instruction__c.SObjectType),
                    Locked__c = false,
                    Segment__c = segmentList[0].Id
                )
        );

        //Create relationship between ADCVD_Case and Petition
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Petition__c.ADCVD_Case__c,
            new List<List<Petition__c>>{petitionList}
        );
        //Create relationship between ADCVD_Case and Investigation
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Investigation__c.ADCVD_Case__c,
            new List<List<Investigation__c>>{investigationList}
        );
        //Create relationship between ADCVD_Case and ADCVD Order
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            ADCVD_Order__c.ADCVD_Case__c,
            new List<List<ADCVD_Order__c>>{orderList}
        );
        //Create relationship between ADCVD_Case and Suspension Agreement
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Suspension_Agreement__c.ADCVD_Case__c,
            new List<List<Suspension_Agreement__c>>{suspAgrmtList}
        );
        //Create relationship between ADCVD_Case and Segment
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Case__c>.class,
            adcvdCaseList,
            Segment__c.ADCVD_Case__c,
            new List<List<Segment__c>>{segmentList}
        );
        //Create relationship between ADCVD Case and Custom Instructions
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Custom_Instruction__c.ADCVD_Case__c,
                new List<List<Custom_Instruction__c>>{cstInstList}
        );
        //Create relationship between Petition and Investigation
        petitionList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Petition__c>.class,
            petitionList,
            Investigation__c.Petition__c,
            new List<List<Investigation__c>>{investigationList}
        );
        //Create relationship between Investigation and ADCVD Order
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Investigation__c>.class,
            investigationList,
            ADCVD_Order__c.Investigation__c,
            new List<List<ADCVD_Order__c>>{orderList}
        );
        //Create relationship between Investigation and Suspension Agreement
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Investigation__c>.class,
            investigationList,
            Suspension_Agreement__c.Investigation__c,
            new List<List<Suspension_Agreement__c>>{suspAgrmtList}
        );
        //Create relationship between ADCVD Order and Segment
        orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Order__c>.class,
            orderList,
            Segment__c.ADCVD_Order__c,
            new List<List<Segment__c>>{segmentList}
        );
        //Create relationship between Petition and Custom Instructions
        petitionList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Petition__c>.class,
            petitionList,
            Custom_Instruction__c.Petition__c,
            new List<List<Custom_Instruction__c>>{
                new List<Custom_Instruction__c> {cstInstList[0]}
            }
        );
        //Create relationship between Investigation and Custom Instructions
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Investigation__c>.class,
            investigationList,
            Custom_Instruction__c.Investigation__c,
            new List<List<Custom_Instruction__c>>{
                new List<Custom_Instruction__c> {cstInstList[1]}
            }
        );
        //Create relationship between ADCVD Order and Custom Instructions
        orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
            List<ADCVD_Order__c>.class,
            orderList,
            Custom_Instruction__c.ADCVD_Order__c,
            new List<List<Custom_Instruction__c>>{
                new List<Custom_Instruction__c> {cstInstList[2]}
            }
        );
        //Create relationship between Suspension Agreement and Custom Instructions
        suspAgrmtList = (List<Suspension_Agreement__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Suspension_Agreement__c>.class,
            suspAgrmtList,
            Custom_Instruction__c.Suspension_Agreement__c,
            new List<List<Custom_Instruction__c>>{
                new List<Custom_Instruction__c> {cstInstList[3]}
            }
        );
        //Create relationship between Segment and Custom Instructions
        segmentList = (List<Segment__c>)fflib_ApexMocksUtils.makeRelationship(
            List<Segment__c>.class,
            segmentList,
            Custom_Instruction__c.Segment__c,
            new List<List<Custom_Instruction__c>>{
                new List<Custom_Instruction__c> {cstInstList[4]}
            }
        );
    }

    private static void selectorSetup() {
    	fflib_ApexMocks mocks = new fflib_ApexMocks();
    	//Mock ADCVD Case Selector
        ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);
        mocks.startStubbing();
        mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
        mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id> {adcvdCaseList[0].Id})).thenReturn(adcvdCaseList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);
        //Mock Petition Selector
        IPetitionSelector mockPetitionSelector = (IPetitionSelector) mocks.mock(IPetitionSelector.class);
        mocks.startStubbing();
        mocks.when(mockPetitionSelector.sObjectType()).thenReturn(Petition__c.SObjectType);
        mocks.when(mockPetitionSelector.selectById(new Set<Id> {petitionList[0].Id})).thenReturn(petitionList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockPetitionSelector);
        //Mock Investigation Selector
        IInvestigationSelector mockInvestigationSelector = (IInvestigationSelector) mocks.mock(IInvestigationSelector.class);
        mocks.startStubbing();
        mocks.when(mockInvestigationSelector.sObjectType()).thenReturn(Investigation__c.SObjectType);
        mocks.when(mockInvestigationSelector.selectById(new Set<Id> {investigationList[0].Id})).thenReturn(investigationList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockInvestigationSelector);
        //Mock ADCVD Order Selector
        ADCVD_IOrderSelector mockADCVD_OrderSelector = (ADCVD_IOrderSelector) mocks.mock(ADCVD_IOrderSelector.class);
        mocks.startStubbing();
        mocks.when(mockADCVD_OrderSelector.sObjectType()).thenReturn(ADCVD_Order__c.SObjectType);
        mocks.when(mockADCVD_OrderSelector.selectById(new Set<Id> {orderList[0].Id})).thenReturn(orderList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockADCVD_OrderSelector);
        //Mock Suspension Agreement
        ISuspensionAgreementSelector mockSuspensionAgreementSelector = (ISuspensionAgreementSelector) mocks.mock(ISuspensionAgreementSelector.class);
        mocks.startStubbing();
        mocks.when(mockSuspensionAgreementSelector.sObjectType()).thenReturn(Suspension_Agreement__c.SObjectType);
        mocks.when(mockSuspensionAgreementSelector.selectById(new Set<Id> {suspAgrmtList[0].Id})).thenReturn(suspAgrmtList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockSuspensionAgreementSelector);
        //Mock Segment Selector
        ISegmentSelector mockSegmentSelector = (ISegmentSelector) mocks.mock(ISegmentSelector.class);
        mocks.startStubbing();
        mocks.when(mockSegmentSelector.sObjectType()).thenReturn(Segment__c.SObjectType);
        mocks.when(mockSegmentSelector.selectById(new Set<Id> {segmentList[0].Id})).thenReturn(segmentList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockSegmentSelector);
        //Mock Custom Instruction Selector
        ICustomInstructionSelector mockCustomInstructionSelector = (ICustomInstructionSelector) mocks.mock(ICustomInstructionSelector.class);
        mocks.startStubbing();
        mocks.when(mockCustomInstructionSelector.sObjectType()).thenReturn(Custom_Instruction__c.SObjectType);
        mocks.when(mockCustomInstructionSelector.selectById(new Set<Id> {
        	cstInstList[0].Id, 
        	cstInstList[1].Id, 
        	cstInstList[2].Id, 
        	cstInstList[3].Id, 
        	cstInstList[4].Id
        	})).thenReturn(cstInstList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockCustomInstructionSelector);
    }
}