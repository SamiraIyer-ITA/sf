/**
 * 
 *    Created by Eitan Alfiya
 *    on 7/16/2018
 *    MIL Corporation
 * 
 **/
@isTest
public class Suspension_AgreementMapperTest {
    
    @testSetup static void dataSetup(){
        //Suspension Agreement requires to be parented by Investigation
        ADCVD_Case__c adcvdCase1 = TestUtils.createADCVDCase('A-111-111', 'AD ME', false);
        ADCVD_Case__c adcvdCase2 = TestUtils.createADCVDCase('C-222-222', 'CVD', false);
        insert new List<ADCVD_Case__c>{adcvdCase1, adcvdCase2};
        Petition__c petition1 = TestUtils.createPetition(adcvdCase1, Date.today(), false);
        Petition__c petition2 = TestUtils.createPetition(adcvdCase2, Date.today(), false);
        insert new List<Petition__c>{petition1, petition2};
        Investigation__c investigation1 = TestUtils.createInvestigation(petition1, false);
        Investigation__c investigation2 = TestUtils.createInvestigation(petition2, false);
        insert new List<Investigation__c>{investigation1, investigation2};
        Suspension_Agreement__c unlockedSuspension = TestUtils.createSuspensionAgreement(investigation1, Date.today(), false);
        Suspension_Agreement__c lockedSuspension = TestUtils.createSuspensionAgreement(investigation2, Date.today(), false);
        insert new List<Suspension_Agreement__c>{lockedSuspension, unlockedSuspension};
        lockedSuspension.Locked__c = true;
        update lockedSuspension;
		
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

    private static Suspension_Agreement__c unlockedSuspensionAgreement{
        get{
            if(unlockedSuspensionAgreement == null){
                unlockedSuspensionAgreement = [Select Id From Suspension_Agreement__c WHere ADCVD_Case__c =: case1.Id Limit 1];
            }
            return unlockedSuspensionAgreement;
        }
        set;
    }

    private static Suspension_Agreement__c lockedSuspensionAgreement{
        get{
            if(lockedSuspensionAgreement == null){
                lockedSuspensionAgreement = [Select Id From Suspension_Agreement__c WHere ADCVD_Case__c =: case2.Id Limit 2];
            }
            return lockedSuspensionAgreement;
        }
        set;
    }

    @isTest static void testSuspemsionAgreementMapper(){
        ADCVD_CaseMapper adcvdCaseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
        adcvdCaseMapper = adcvdCaseMapper.getInstance(new Set<Id>{case1.Id ,case2.Id});
        //SegmentMapper
        Suspension_AgreementMapper suspensionAgreementMapper = (Suspension_AgreementMapper) adcvdCaseMapper.getMapper('Suspension_Agreement__c').getInstance();
        //Assert that the mapper is accessing the investigations we have inserted
        Map<Id, Suspension_Agreement__c> idToUnlockedSuspensionAgreements = suspensionAgreementMapper.getMap(false);
        Map<Id, Suspension_Agreement__c> idToAllSuspensionAgreements = suspensionAgreementMapper.getMap(true);


        System.assertEquals(unlockedSuspensionAgreement.Id, idToUnlockedSuspensionAgreements.get(unlockedSuspensionAgreement.Id).Id);
        System.assertEquals(null, idToUnlockedSuspensionAgreements.get(lockedSuspensionAgreement.Id));

        System.assertEquals(unlockedSuspensionAgreement.Id, idToAllSuspensionAgreements.get(unlockedSuspensionAgreement.Id).Id);
        System.assertEquals(lockedSuspensionAgreement.Id, idToAllSuspensionAgreements.get(lockedSuspensionAgreement.Id).Id);


        //Extra call for get 100% coverage
        Map<Id, Suspension_Agreement__c> suspensionAgreementsByIds = suspensionAgreementMapper.getMap();
    }

    @isTest static void nullInstanceCoverage(){
        Suspension_AgreementMapper.getInstance();
    }

}