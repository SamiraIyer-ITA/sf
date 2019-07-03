/**
 * 
 *    Created by Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

@IsTest
public class FederalRegisterChatterPostWriterTest {
    private static Date petitionDate = Date.newInstance(2019, 3, 5);
    private static Date publishDate = Date.newInstance(2019, 3, 5);

    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionList {get; set;}
    private static List<Investigation__c> investigationList {get; set;}
    private static List<ADCVD_Order__c> orderList {get; set;}
    private static List<Related_Organization__c> relOrgList {get; set;}
    private static List<Federal_Register__c> federalRegisterList {get; set;}
    private static List<Staffing_Assignment__c> staffList {get; set;}
    private static Map<Id,Staffing_Assignment__c> staffMap {get; set;}

    @IsTest
    static void testAlignmentChanged() {
        dataSetup();
        selectorSetup();
        Test.startTest();

        ADCVD_Case__c c = adcvdCaseList.get(0);
        Petition__c p = petitionList.get(0);
        ADCVD_Order__c o = orderList.get(0);
        Investigation__c i = investigationList.get(0);

        Federal_Register__c newFr = federalRegisterList.get(0);
        FederalRegisterChatterPostWriter fcpw = new FederalRegisterChatterPostWriter();
        fcpw.newOrderFrAdded(newFr, null);

        System.assert(fcpw.getMap(false).isEmpty());

        newFr.ADCVD_Order__c = orderList.get(0).Id;
        newFr.Type__c = 'Order';

        fcpw = new FederalRegisterChatterPostWriter();
        fcpw.newOrderFrAdded(newFr, null);

        System.assert(fcpw.getMap(true).get(i.Id).get(0).contains('<p>Thanks for adding an Order FR to the Order. Please go back to the Investigation and update the Investigation Outcome to \"Order\".</p>'));

        Test.stopTest();
    }

    @testSetup static void dataSetup() {
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
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        Country_Text__c = 'Mexico'
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
        //Create Related Organization record
        relOrgList = new List<Related_Organization__c>();
        relOrgList.add(
                new Related_Organization__c(
                        Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        Investigation__c = investigationList[0].Id
                )
        );
        //Create Federal Register record
        federalRegisterList = new List<Federal_Register__c>();
        federalRegisterList.add(
                new Federal_Register__c(
                        Id = fflib_IDGenerator.generate(Federal_Register__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        ADCVD_Order__c = orderList[0].Id,
                        Type__c = 'Order',
                        Published_Date__c = publishDate,
                        FR_Parent__c = 'ADCVD_Order__c'
                )
        );
        //Create Staffing Assignment records
        staffList = new List<Staffing_Assignment__c>();
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        Petition__c = petitionList[0].Id
                )
        );
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        Investigation__c = investigationList[0].Id
                )
        );
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        ADCVD_Order__c = orderList[0].Id
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
        //Create relationship between ADCVD_Case and Related Organiztion
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Related_Organization__c.ADCVD_Case__c,
                new List<List<Related_Organization__c>>{relOrgList}
        );
        //Create relationship between ADCVD_Case and Federal Register
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Federal_Register__c.ADCVD_Case__c,
                new List<List<Federal_Register__c>>{federalRegisterList}
        );
        //Create relationship between ADCVD Case and Staffing Assignments
        adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Staffing_Assignment__c.ADCVD_Case__c,
                new List<List<Staffing_Assignment__c>>{staffList}
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
        //Create relationship between Investigation and Related Organization
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Investigation__c>.class,
                investigationList,
                Related_Organization__c.Investigation__c,
                new List<List<Related_Organization__c>>{relOrgList}
        );
        //Create relationship between ADCVD Order and Federal Register
        orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Order__c>.class,
                orderList,
                Federal_Register__c.ADCVD_Order__c,
                new List<List<Federal_Register__c>>{federalRegisterList}
        );
        //Create relationship between Petition and Staffing Assignments
        petitionList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Petition__c>.class,
                petitionList,
                Staffing_Assignment__c.Petition__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[0]}
                }
        );
        //Create relationship between Investigation and Staffing Assignments
        investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Investigation__c>.class,
                investigationList,
                Staffing_Assignment__c.Investigation__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[1]}
                }
        );
        //Create relationship between ADCVD Order and Staffing Assignments
        orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Order__c>.class,
                orderList,
                Staffing_Assignment__c.ADCVD_Order__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[2]}
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
        //Mock Federal Register Selector
        IFederalRegisterSelector mockFederalRegisterSelector = (IFederalRegisterSelector) mocks.mock(IFederalRegisterSelector.class);
        mocks.startStubbing();
        mocks.when(mockFederalRegisterSelector.sObjectType()).thenReturn(Federal_Register__c.SObjectType);
        mocks.when(mockFederalRegisterSelector.selectById(new Set<Id> {federalRegisterList[0].Id})).thenReturn(federalRegisterList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockFederalRegisterSelector);
        //Mock Staffing Assignment Selector
        IStaffingAssignmentSelector mockStaffingAssignmentSelector = (IStaffingAssignmentSelector) mocks.mock(IStaffingAssignmentSelector.class);
        mocks.startStubbing();
        mocks.when(mockStaffingAssignmentSelector.sObjectType()).thenReturn(Staffing_Assignment__c.SObjectType);
        mocks.when(mockStaffingAssignmentSelector.selectById(new Set<Id> {
                staffList[0].Id,
                staffList[1].Id,
                staffList[2].Id
                //staffList[3].Id
                //staffList[4].Id
        })).thenReturn(staffList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockStaffingAssignmentSelector);
    }

}