/**
* 
*    Created by Eitan Alfiya
*    on 7/13/2018
*    MIL Corporation
* 
**/
@isTest
public class SegmentMapperTest {
	
    @testSetup static void dataSetup(){
        //Segments only needs an ADCVD Case as parent, multiple segments can be linked to the same ADCVD Case
        //Create both locked and unlocked records for testing
        ADCVD_Case__c adcvdCase1 = TestUtils.createADCVDCase('A-111-111', 'AD ME', false);
        ADCVD_Case__c adcvdCase2 = TestUtils.createADCVDCase('C-222-222', 'CVD', false);
        insert new List<ADCVD_Case__c>{adcvdCase1, adcvdCase2};
        Petition__c petition1 = TestUtils.createPetition(adcvdCase1, Date.today(), false);
        Petition__c petition2 = TestUtils.createPetition(adcvdCase2, Date.today(), false);
        insert new List<Petition__c>{petition1, petition2};
        Investigation__c investigation1 = TestUtils.createInvestigation(petition1, false);
        Investigation__c investigation2 = TestUtils.createInvestigation(petition2, false);
        insert new List<Investigation__c>{investigation1, investigation2};
		ADCVD_Order__c order1 = TestUtils.createOrder(investigation1, false);
		ADCVD_Order__c order2 = TestUtils.createOrder(investigation2, false);
        insert new List<ADCVD_Order__c>{order1, order2};
        Segment__c segmentUnlocked = TestUtils.createSegment(order1, 'Administrative_Review', false);
        Segment__c segmentLocked = TestUtils.createSegment(order2, 'Administrative_Review', false);
        insert new List<Segment__c>{segmentUnlocked, segmentLocked};
        segmentLocked.Locked__c = true;
        update segmentLocked;
    }
    
    private static ADCVD_Case__c case1{
        get{
            if(case1 == null){
                case1 = [Select Id From ADCVD_Case__c Where Name = 'A-111-111' Limit 1];
            }
            return case1;
        }
        set;
    }
    
    private static ADCVD_Case__c case2{
        get{
            if(case2 == null){
                case2 = [Select Id From ADCVD_Case__c Where Name = 'C-222-222' Limit 1];
            }
            return case2;
        }
        set;
    }
    
    private static Segment__c unlockedSegment{
        get{
            if(unlockedSegment == null){
                unlockedSegment = [Select Id From Segment__c Where ADCVD_Case__c =: case1.Id Limit 1];
            }
            return unlockedSegment;
        }
        set;
    }
    
    private static Segment__c lockedSegment{
        get{
            if(lockedSegment == null){
                lockedSegment = [Select Id From Segment__c Where ADCVD_Case__c =: case2.Id Limit 1];
            }
            return lockedSegment;
        }
        set;
    }
    
    static testMethod void testSegmentMapper(){
        Test.startTest();
        ADCVD_CaseMapper adcvdCaseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        adcvdCaseMapper = adcvdCaseMapper.getInstance(new Set<Id>{case1.Id ,case2.Id});
        //SegmentMapper
        SegmentMapper segmentMapper = (SegmentMapper) adcvdCaseMapper.getMapper('Segment__c').getInstance();
		//Assert that the mapper is accessing the investigations we have inserted 
		Map<Id, Segment__c> idToUnlockedSegments = segmentMapper.getMap(false);
        Map<Id, Segment__c> idToAllSegments = segmentMapper.getMap(true);
        
        Test.stopTest();
        
        System.assertEquals(unlockedSegment.Id, idToUnlockedSegments.get(unlockedSegment.Id).Id);
        System.assertEquals(null, idToUnlockedSegments.get(lockedSegment.Id));
		
        System.assertEquals(unlockedSegment.Id, idToAllSegments.get(unlockedSegment.Id).Id);
        System.assertEquals(lockedSegment.Id, idToAllSegments.get(lockedSegment.Id).Id); 
        
        
        //Extra call for get 100% coverage
        Map<Id, Segment__c> segmentIdMap = segmentMapper.getMap();
    }
    
    static testMethod void nullInstanceCoverage(){
        Test.startTest();
        SegmentMapper.getInstance();
        Test.stopTest();
    }
}