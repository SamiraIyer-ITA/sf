/**
 * Created by skip on 1/18/19.
 */

@isTest
public class StaffingAssignmentTriggerHandlerTest {
    private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
    private static List<Petition__c> petitionList {get; set;}
    private static List<Investigation__c> investigationList {get; set;}
    private static List<ADCVD_Order__c> orderList {get; set;}
    private static List<Related_Organization__c> relOrgList {get; set;}
    private static List<Segment__c> segmentList {get; set;}
    private static List<Staffing_Assignment__c> staffList {get; set;}
    private static Map<Id,Staffing_Assignment__c> staffMap {get; set;}

    @isTest static void testInitialize(){
        dataSetup();
        selectorSetup();

        Test.startTest();
        StaffingAssignmentTriggerHandler.initialize(staffList, null);
        Test.stopTest();

        //Assert adcvd case records
        System.assertNotEquals(StaffingAssignmentTriggerHandler.caseMapper, null);
        System.assertEquals(staffList[0].Staff_Parent__c, 'Petition__c');

    }

    @isTest static void testSetCaseValues(){
        dataSetup();
        selectorSetup();

        Test.startTest();
        StaffingAssignmentTriggerHandler.mainEntry(staffList, null, null, null, true, false, false, false, true, false);
        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(adcvdCaseList[0].Country__c, staffList[0].Country_Text__c);
    }

    @isTest static void testAddNewStaffToMapper(){
        dataSetup();
        selectorSetup();
        staffMap = new Map<Id, Staffing_Assignment__c>();
        for (Staffing_Assignment__c staff : staffList) {
            if(staff.Petition__c != null) {
                staff.Staff_Parent__c = 'Petition__c';
            } else if(staff.Investigation__c != null) {
                staff.Staff_Parent__c = 'Investigation__c';
            } else if(staff.Segment__c != null) {
                staff.Staff_Parent__c = 'Segment__c';
            } else if(staff.ADCVD_Order__c != null) {
                staff.Staff_Parent__c = 'ADCVD_Order__c';
            } else if(staff.Related_Organization__c != null) {
                staff.Staff_Parent__c = 'Related_Organization__c';
            }
            staffMap.put(staff.Id, staff);
        }

        Test.startTest();
        StaffingAssignmentTriggerHandler.mainEntry(staffList, staffList, staffMap, null, true, false, false, false, false, true);
        Test.stopTest();

        //Assert adcvd case records
        for (Staffing_Assignment__c staff : staffList) {
            StaffingAssignmentMapper staffMapper = (StaffingAssignmentMapper) ADCVD_CaseMapper.mapperMap.get('Staffing_Assignment__c');
            System.assert(staffMapper.getMap().containsKey(staff.Id));
        }

    }

    @IsTest
    static void exerciseTrigger()
    {
        //insert new Staffing_Assignment__c(ADCVD_Case_Number_Text__c = '--This is a test--');
    }

    private static void dataSetup() {

        User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);
        System.runAs(testUser) {
            // Create ADCVD_Case record
            adcvdCaseList = new List<ADCVD_Case__c>();
            adcvdCaseList.add(
                    new ADCVD_Case__c(
                            Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
                            Locked__c = false,
                            Program_Manager__c = testUser.Id,
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
                            Petition__c = petitionList[0].Id,
                            Country_Text__c = 'Mexico'
                    )
            );
            //Create ADCVD Order record
            orderList = new List<ADCVD_Order__c>();
            orderList.add(
                    new ADCVD_Order__c(
                            Id = fflib_IDGenerator.generate(ADCVD_Order__c.SObjectType),
                            Locked__c = false,
                            ADCVD_Case__c = adcvdCaseList[0].Id,
                            Investigation__c = investigationList[0].Id,
                            Country_Text__c = 'Mexico'
                    )
            );
            //Create Related Organization record
            relOrgList = new List<Related_Organization__c>();
            relOrgList.add(
                    new Related_Organization__c(
                            Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
                            Locked__c = false,
                            ADCVD_Case__c = adcvdCaseList[0].Id,
                            Investigation__c = investigationList[0].Id,
                            Country_Text__c = 'Mexico'
                    )
            );
            //Create Segment record
            segmentList = new List<Segment__c>();
            segmentList.add(
                    new Segment__c(
                            Id = fflib_IDGenerator.generate(Segment__c.SObjectType),
                            Locked__c = false,
                            ADCVD_Case__c = adcvdCaseList[0].Id,
                            ADCVD_Order__c = orderList[0].Id,
                            Country_Text__c = 'Mexico'
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
            /*
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = false,
                        ADCVD_Case__c = adcvdCaseList[0].Id,
                        Related_Organization__c = relOrgList[0].Id
                )
        );
        */
            staffList.add(
                    new Staffing_Assignment__c(
                            Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                            Locked__c = false,
                            ADCVD_Case__c = adcvdCaseList[0].Id,
                            Segment__c = segmentList[0].Id
                    )
            );

            //Create relationship between ADCVD_Case and Petition
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    Petition__c.ADCVD_Case__c,
                new List<List<Petition__c>>{petitionList}
            );
            //Create relationship between ADCVD_Case and Investigation
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    Investigation__c.ADCVD_Case__c,
                new List<List<Investigation__c>>{investigationList}
            );
            //Create relationship between ADCVD_Case and ADCVD Order
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    ADCVD_Order__c.ADCVD_Case__c,
                new List<List<ADCVD_Order__c>>{orderList}
            );
            //Create relationship between ADCVD_Case and Related Organiztion
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    Related_Organization__c.ADCVD_Case__c,
                new List<List<Related_Organization__c>>{relOrgList}
            );
            //Create relationship between ADCVD_Case and Segment
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    Segment__c.ADCVD_Case__c,
                new List<List<Segment__c>>{segmentList}
            );
            //Create relationship between ADCVD Case and Staffing Assignments
            adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Case__c>.class,
                    adcvdCaseList,
                    Staffing_Assignment__c.ADCVD_Case__c,
                new List<List<Staffing_Assignment__c>>{staffList}
            );
            //Create relationship between Petition and Investigation
            petitionList = (List<Petition__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Petition__c>.class,
                    petitionList,
                    Investigation__c.Petition__c,
                new List<List<Investigation__c>>{investigationList}
            );
            //Create relationship between Investigation and ADCVD Order
            investigationList = (List<Investigation__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Investigation__c>.class,
                    investigationList,
                    ADCVD_Order__c.Investigation__c,
                new List<List<ADCVD_Order__c>>{orderList}
            );
            //Create relationship between Investigation and Related Organization
            investigationList = (List<Investigation__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Investigation__c>.class,
                    investigationList,
                    Related_Organization__c.Investigation__c,
                new List<List<Related_Organization__c>>{relOrgList}
            );
            //Create relationship between ADCVD Order and Segment
            orderList = (List<ADCVD_Order__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Order__c>.class,
                    orderList,
                    Segment__c.ADCVD_Order__c,
                new List<List<Segment__c>>{segmentList}
            );
            //Create relationship between Petition and Staffing Assignments
            petitionList = (List<Petition__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Petition__c>.class,
                    petitionList,
                    Staffing_Assignment__c.Petition__c,
                    new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[0]}
                    }
            );
            //Create relationship between Investigation and Staffing Assignments
            investigationList = (List<Investigation__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Investigation__c>.class,
                    investigationList,
                    Staffing_Assignment__c.Investigation__c,
                    new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[1]}
                    }
            );
            //Create relationship between ADCVD Order and Staffing Assignments
            orderList = (List<ADCVD_Order__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<ADCVD_Order__c>.class,
                    orderList,
                    Staffing_Assignment__c.ADCVD_Order__c,
                    new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[2]}
                    }
            );
            //Create relationship between Related Organization and Staffing Assignments
            /*relOrgList = (List<Related_Organization__c>)fflib_ApexMocksUtils.makeRelationship(
                List<Related_Organization__c>.class,
                relOrgList,
                Staffing_Assignment__c.Related_Organization__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[3]}
                }
        );
        */

            //Create relationship between Segment and Staffing Assignments
            segmentList = (List<Segment__c>) fflib_ApexMocksUtils.makeRelationship(
                    List<Segment__c>.class,
                    segmentList,
                    Staffing_Assignment__c.Segment__c,
                    new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c> {staffList[3]}
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
        //Mock Related Organization TODO Need Related Organiztion Selector
        /*
        ISuspensionAgreementSelector mockSuspensionAgreementSelector = (ISuspensionAgreementSelector) mocks.mock(ISuspensionAgreementSelector.class);
        mocks.startStubbing();
        mocks.when(mockSuspensionAgreementSelector.sObjectType()).thenReturn(Suspension_Agreement__c.SObjectType);
        mocks.when(mockSuspensionAgreementSelector.selectById(new Set<Id> {suspAgrmtList[0].Id})).thenReturn(suspAgrmtList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockSuspensionAgreementSelector);
        */
        //Mock Segment Selector
        ISegmentSelector mockSegmentSelector = (ISegmentSelector) mocks.mock(ISegmentSelector.class);
        mocks.startStubbing();
        mocks.when(mockSegmentSelector.sObjectType()).thenReturn(Segment__c.SObjectType);
        mocks.when(mockSegmentSelector.selectById(new Set<Id> {segmentList[0].Id})).thenReturn(segmentList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockSegmentSelector);
        //Mock Staffing Assignment Selector
        IStaffingAssignmentSelector mockStaffingAssignmentSelector = (IStaffingAssignmentSelector) mocks.mock(IStaffingAssignmentSelector.class);
        mocks.startStubbing();
        mocks.when(mockStaffingAssignmentSelector.sObjectType()).thenReturn(Staffing_Assignment__c.SObjectType);
        mocks.when(mockStaffingAssignmentSelector.selectById(new Set<Id> {
                staffList[0].Id,
                staffList[1].Id,
                staffList[2].Id,
                staffList[3].Id
                //staffList[4].Id
        })).thenReturn(staffList);
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockStaffingAssignmentSelector);
    }
}