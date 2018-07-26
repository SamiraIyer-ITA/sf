/**
 * 
 *    Created by Samira Iyer
 *    on 7/16/2018
 *    MIL Corporation
 * 
 **/
@isTest
public class LitigationMapperTest
{
    // Static variables - getters and setters
    private static List <Litigation__c> litigationList
    { get; set;}

    @isTest static void verifyLitigationMapper() {

        //Set up the test data
        dataSetup();

        // Supply the mock data to the class being tested
        // Mock the Litigation Selector
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ILitigationSelector mockLitigationSelector = (ILitigationSelector) mocks.mock(ILitigationSelector.class);
        mocks.startStubbing();
        mocks
            .when(mockLitigationSelector.sObjectType())
            .thenReturn(Litigation__c.SObjectType);
        mocks
            .when(mockLitigationSelector.selectById(new Set<Id> {litigationList.get(0).Id, litigationList.get(1).Id}))
            .thenReturn(litigationList);        
        mocks.stopStubbing();
        fflibext_Application.Selector.setMock(mockLitigationSelector);

        // Create Litigation Mapper Instance              
        Test.startTest();                
        LitigationMapper litigationMapper = new LitigationMapper(new Set<Id>{litigationList[0].Id, litigationList[1].Id});  
        Map<Id, Litigation__c> idToUnlockedLitigationMap = litigationMapper.getMap(false);
        Map<Id, Litigation__c> idToAllLitigationMap = litigationMapper.getMap(true); 
        Test.stopTest();
        
        //Assert that the mapper is accessing the Litigations we have inserted
        System.assertEquals(litigationList[0].Id, idToUnlockedLitigationMap.get(litigationList[0].Id).Id);
        System.assertEquals(null, idToUnlockedLitigationMap.get(litigationList[1].Id));

        System.assertEquals(litigationList[0].Id, idToAllLitigationMap.get(litigationList[0].Id).Id);
        System.assertEquals(litigationList[1].Id, idToAllLitigationMap.get(litigationList[1].Id).Id);      
    }

    @istest static void nullInstanceCoverage(){
        LitigationMapper.getNewInstance();
    }

    private static void dataSetup(){
        // Create Litigations
        litigationList = new List<Litigation__c>();
        litigationList.add(
            new Litigation__c(
                Id = fflib_IdGenerator.generate(Litigation__c.SObjectType),
                Locked__c = false));
        litigationList.add(
            new Litigation__c(
                Id = fflib_IdGenerator.generate(Litigation__c.SObjectType),
                Locked__c = true));
    }
}