/**
 * Created by skip on 1/18/19.
 */

@IsTest
private class StaffingAssignmentMapperTest {

    private static List<ADCVD_Case__c> adcvdCaseList { get; set; }
    private static List<Petition__c> petitionsList { get; set; }
    private static List<Staffing_Assignment__c> staffList { get; set; }

    @isTest static void testStaffingAssignmentMapper() {

        dataSetup();
        selectorSetup();
        Test.startTest();
        StaffingAssignmentMapper staffMapper = new StaffingAssignmentMapper(new Set<Id>{
                staffList[0].Id, staffList[1].Id
        });
        Map<Id, SObject> idToUnlockedStaffMap = staffMapper.getMap(false);
        Map<Id, SObject> idToAllStaffMap = staffMapper.getMap(true);

        Test.stopTest();

        //Assert adcvd case records
        System.assertEquals(staffList[0].Id, idToUnlockedStaffMap.get(staffList[0].Id).Id);
        System.assertEquals(null, idToUnlockedStaffMap.get(staffList[1].Id));
        System.assertEquals(staffList[0].Id, idToAllStaffMap.get(staffList[0].Id).Id);
        System.assertEquals(staffList[1].Id, idToAllStaffMap.get(staffList[1].Id).Id);

    }

    @IsTest static void testBehavior() {
        StaffingAssignmentMapper.getInstance();
        StaffingAssignmentMapper.getNewInstance();
    }


    private static void dataSetup() {
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
        adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Petition__c.ADCVD_Case__c,
                new List<List<Petition__c>>{
                        new List<Petition__c>{
                                petitionsList.get(0)
                        }
                }
        );
        //Create Staffing Assignment records, one locked and one unlocked
        staffList = new List<Staffing_Assignment__c>();
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = false,
                        Staff_Parent__c = 'Petition__c',
                        Petition__c = petitionsList[0].Id
                )
        );
        staffList.add(
                new Staffing_Assignment__c(
                        Id = fflib_IDGenerator.generate(Staffing_Assignment__c.SObjectType),
                        Locked__c = true,
                        Staff_Parent__c = 'Petition__c',
                        Petition__c = petitionsList[0].Id
                )
        );
        //Create relationship between ADCVD Case and Staffing Assignments
        adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
                List<ADCVD_Case__c>.class,
                adcvdCaseList,
                Staffing_Assignment__c.ADCVD_Case__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c>{
                                staffList.get(0)
                        },
                        new List<Staffing_Assignment__c>{
                                staffList.get(1)
                        }
                }
        );
        //Create relationship between Petition and Staffing Assignments
        petitionsList = (List<Petition__c>) fflib_ApexMocksUtils.makeRelationship(
                List<Petition__c>.class,
                petitionsList,
                Staffing_Assignment__c.Petition__c,
                new List<List<Staffing_Assignment__c>>{
                        new List<Staffing_Assignment__c>{
                                staffList.get(0)
                        },
                        new List<Staffing_Assignment__c>{
                                staffList.get(1)
                        }
                }
        );
    }

    private static void selectorSetup() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);

        mocks.startStubbing();
        mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
        mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id>{
                adcvdCaseList.get(0).Id
        })).thenReturn(adcvdCaseList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);

        IStaffingAssignmentSelector mockStaffingAssignmentSelector = (IStaffingAssignmentSelector) mocks.mock(IStaffingAssignmentSelector.class);

        mocks.startStubbing();
        mocks.when(mockStaffingAssignmentSelector.sObjectType()).thenReturn(Staffing_Assignment__c.SObjectType);
        mocks.when(mockStaffingAssignmentSelector.selectById(new Set<Id>{
                staffList.get(0).Id, staffList.get(1).Id
        })).thenReturn(staffList);
        mocks.stopStubbing();

        fflibext_Application.Selector.setMock(mockStaffingAssignmentSelector);


    }
}