/**
 * 
 *    Created by Samira Iyer
 *    on 7/03/2018
 *    MIL Corporation
 * 
 **/
@isTest 
public class PetitionMapperTest {
    
    // Static variables - getters and setters
    private static Date petitionFiledDate = System.today(); 
        
    private static ADCVD_Case__c ADCVD_Case1{
        get{
            if(ADCVD_Case1 == null){
                ADCVD_Case1 = [Select Id, Locked__c From ADCVD_Case__c Where Locked__c = false Limit 1];
            }
            return ADCVD_Case1;
        }
        set;
    }

    private static ADCVD_Case__c ADCVD_Case2{
        get{
            if(ADCVD_Case2 == null){
                ADCVD_Case2 = [Select Id, Locked__c From ADCVD_Case__c Where Locked__c = true Limit 1];
            }
            return ADCVD_Case2;
        }
        set;
    }
    
    private static Petition__c unlockedPetition{
        get{
            if(unlockedPetition == null){
                unlockedPetition = [Select Id, Locked__c From Petition__c Where Locked__c = false Limit 1];
            }
            return unlockedPetition;
        }
        set;
    }
    
    private static Petition__c lockedPetition{
        get{
            if(lockedPetition == null){
                lockedPetition = [Select Id, Locked__c From Petition__c Where Locked__c = true Limit 1];
            }
            return lockedPetition;
        }
        set;
    }       
    
    @isTest static void verifyUnlockedPetition() {
        Test.startTest();  
        //Create Unlocked Petition
        Petition__c unlockedPetition = TestUtils.createPetition(ADCVD_Case1, petitionFiledDate, true);         
        
        //One instance of the ADCVD_CaseMapper
		ADCVD_CaseMapper adcvdCaseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
		adcvdCaseMapper = adcvdCaseMapper.getInstance(new Set<Id>{ADCVD_Case1.Id}); 
                 
		//PetitionMapper
		PetitionMapper petMapper = (PetitionMapper) adcvdCaseMapper.getMapper('Petition__c').getInstance();
		Map<Id, Petition__c> idToUnlockedPetitionMap = petMapper.getMap(false);        
		Map<Id, Petition__c> idToAllPetitionMap = petMapper.getMap(true);
               
        //Extra call for getting 100% coverage
        Map<Id, Petition__c> petIdMap = petMapper.getMap();             		
        Test.stopTest();
         
		//Assert that the mapper is accessing the Petitions we have inserted         
        System.assertEquals(unlockedPetition.Id, idToUnlockedPetitionMap.get(unlockedPetition.Id).Id);
        System.assertEquals(unlockedPetition.Id, idToAllPetitionMap.get(unlockedPetition.Id).Id);       
        System.assertEquals(unlockedPetition.ADCVD_Case__c, idToUnlockedPetitionMap.get(unlockedPetition.Id).ADCVD_Case__c);
		System.assertEquals(unlockedPetition.ADCVD_Case__c, idToAllPetitionMap.get(unlockedPetition.Id).ADCVD_Case__c); 
	    unlockedPetition = null;     
    }

    @isTest static void verifyLockedPetition() {
        Test.startTest();       
        //Create Locked Petition        
        Petition__c lockedPetition = TestUtils.createPetition(ADCVD_Case2, petitionFiledDate, false);
        lockedPetition.Locked__c = true;
		insert lockedPetition;                

    	//One instance of the ADCVD_CaseMapper
		ADCVD_CaseMapper adcvdCaseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
		adcvdCaseMapper = adcvdCaseMapper.getInstance(new Set<Id>{ADCVD_Case2.Id});         
 
		//PetitionMapper
		PetitionMapper petMapper = (PetitionMapper) adcvdCaseMapper.getMapper('Petition__c').getInstance();
		Map<Id, Petition__c> idToUnlockedPetitionMap = petMapper.getMap(false);
		Map<Id, Petition__c> idToAllPetitionMap = petMapper.getMap(true); 
        
        //Extra call for getting 100% coverage
        Map<Id, Petition__c> petIdMap = petMapper.getMap();           
        Test.stopTest();    
        
		//Assert that the mapper is accessing the Petitions we have inserted 		        
        System.assertEquals(null, idToUnlockedPetitionMap.get(lockedPetition.Id));
        System.assertEquals(lockedPetition.Id, idToAllPetitionMap.get(lockedPetition.Id).Id);                 
		System.assertEquals(lockedPetition.ADCVD_Case__c, idToAllPetitionMap.get(lockedPetition.Id).ADCVD_Case__c); 

        lockedPetition = null;                       
    }  

    @istest static void nullInstanceCoverage(){
        Test.startTest();
        PetitionMapper.getInstance();
        Test.stopTest();
    }
    
    @testSetup static void dataSetup(){
    	//Create locked and unlocked ADCVD Cases
    	ADCVD_Case__c ADCVD_Case1 = TestUtils.createADCVDCase('A-900-901', 'AD ME', true);
    	ADCVD_Case__c ADCVD_Case2 = TestUtils.createADCVDCase('A-900-902', 'AD ME', false);
        ADCVD_Case2.Locked__c = true;
        insert ADCVD_Case2;
     }    
}