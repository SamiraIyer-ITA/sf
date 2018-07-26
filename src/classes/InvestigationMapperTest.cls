/**
 * 
 *    Created by Eitan Alfiya
 *    on 7/9/2018
 *    MIL Corporation
 * 
 **/
@isTest
public class InvestigationMapperTest {

    @testSetup static void dataSetup(){
        //Create adcvd case, related petition, and related investigation
        //A case can only have one petition, that petition can only have one investigation
        ADCVD_Case__c adcvdCase1 = TestUtils.createADCVDCase('A-111-111', 'AD ME', true);
        ADCVD_Case__c adcvdCase2 = TestUtils.createADCVDCase('C-222-222', 'CVD', true);
        Petition__c petition1 = TestUtils.createPetition(adcvdCase1, Date.today(), true);
        Petition__c petition2 = TestUtils.createPetition(adcvdCase2, Date.today(), true);
        
        Investigation__c unlockedInvestigation = TestUtils.createInvestigation(petition1, true);
        Investigation__c lockedInvestigation = TestUtils.createInvestigation(petition2, true);
        lockedInvestigation.Locked__c = true;
        update lockedInvestigation;
        
    }
    
    private static ADCVD_Case__c case1{
        get{
            if(case1 == null){
                case1 = [Select Id From ADCVD_Case__c Where Name='A-111-111' Limit 1];
            }
            return case1;
        }
        set;
    }
    
    private static ADCVD_Case__c case2{
        get{
            if(case2 == null){
                case2 = [Select Id From ADCVD_Case__c Where Name='C-222-222' Limit 1];
            }
            return case2;
        }
        set;
    }
    
    private static Investigation__c lockedInvestigation{
        get{
            if(lockedInvestigation == null){
                lockedInvestigation = [Select Id From Investigation__c Where ADCVD_Case__c =: case2.Id Limit 1];
            }
            return lockedInvestigation;
        }
        set;
    }
    
    private static Investigation__c unlockedInvestigation{
        get{
            if(unlockedInvestigation == null){
                unlockedInvestigation = [Select Id From Investigation__c Where ADCVD_Case__c =: case1.Id Limit 1];
            }
            return unlockedInvestigation;
        }
        set;
    }
    
    @isTest static void testInvestigationMapper(){
        //One instace of the ADCVD_CaseMapper
        ADCVD_CaseMapper adcvdCaseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        adcvdCaseMapper = adcvdCaseMapper.getInstance(new Set<Id>{case1.Id ,case2.Id});
        //InvestigationMapper
        InvestigationMapper invMapper = (InvestigationMapper) adcvdCaseMapper.getMapper('Investigation__c').getInstance();
		//Assert that the mapper is accessing the investigations we have inserted 
		Map<Id, Investigation__c> idToUnlockedInvestigation = invMapper.getMap(false);
        Map<Id, Investigation__c> idToAllInvestigation = invMapper.getMap(true);
        
        List<Investigation__c> allInvestigations = InvestigationMapper.allInvestigations;
        unlockedInvestigation = null;
        lockedInvestigation = null;
        
        System.assertEquals(unlockedInvestigation.Id, idToUnlockedInvestigation.get(unlockedInvestigation.Id).Id);
        System.assertEquals(null, idToUnlockedInvestigation.get(lockedInvestigation.Id));
		
        System.assertEquals(unlockedInvestigation.Id, idToAllInvestigation.get(unlockedInvestigation.Id).Id);
        System.assertEquals(lockedInvestigation.Id, idToAllInvestigation.get(lockedInvestigation.Id).Id); 
        
        //Testing access to all investigations in a static context
        System.assert(allInvestigations.size() == 2);
        
        //Extra call for get 100% coverage
        Map<Id, Investigation__c> invIdMap = invMapper.getMap();
        
    }
    
    @isTest static void nullInstanceCoverage(){
        InvestigationMapper.getInstance();
    }
}