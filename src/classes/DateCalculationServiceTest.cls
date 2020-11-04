/**
 * 
 *    Created by Joshua Moody
 *    on Aug 3 2017
 *    MIL Corporation
 * 
 **/
@isTest
public class DateCalculationServiceTest {
  /************************************************
  * This class performs unit tests on the DateCalculationService
  * under these condititions.
  * 1. Test to ensure that the class is initialized when creating a petition
  * 2. Test to ensure that the class is initialized when creating an Investigation
  * 3. Test to ensure that the date calculations are queried and held in class
  * 4. Test to ensure that the date calculations are applied to a record
  *************************************************/

  private static FINAL Integer COUNT = 1;
    
    private static Set<Id> caseIds {
        get {
            if (caseIds == null) {
                caseIds = new Set<Id>();
                for (ADCVD_Case__c ac : [SELECT Id FROM ADCVD_Case__C]) {
                    caseIds.add(ac.Id);
                } 
            }
            return caseIds;
        }
    }

  private static List<Petition__c> petList {
    get {
      if (petList == null) {
        petList = new List<Petition__c>();
        petList = PetitionSelector.allPetitions;
      }
      return petList;
    }
  }

  private static List<Investigation__c> invList {
    get {
      if (invList == null) {
        invList = new List<Investigation__c>();
        invList = InvestigationSelector.allInvestigations;
      }
      return invList;
    }
  }

  @isTest static void setDateCalculations() {
    Test.startTest();
        DateCalculationService dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
    dcs.setDateCalculations('Investigation__c', 'AD');
    Test.stopTest();
    System.assertNotEquals(null, dcs.dateCalculations);
  }

  @isTest static void getCalculatedDates() {
    Test.startTest();
        ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
    caseMapper = caseMapper.getInstance(caseIds);
    PetitionMapper petMapper = (PetitionMapper) caseMapper.getMapper('Petition__c').getInstance();
        InvestigationMapper invMapper = (InvestigationMapper) caseMapper.getMapper('Investigation__c').getInstance();
    DateCalculationService petDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Petition__c');
    petDcs.getCalculatedDates(petList, 'Petition__c', '');
    DateCalculationService invDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
    invDcs.getCalculatedDates(invList, 'Investigation__c', '');
    Test.stopTest();
    for (Petition__c p : petList) {
      System.assertNotEquals(null, p.Calculated_Initiation_Signature__c);
    }
    for (Investigation__c i : invList) {
      System.debug('*** getCalculatedDates assert Investigation__c record: ' + i);
      System.assertNotEquals(null, i.Calculated_Preliminary_Signature__c);
      System.assertNotEquals(null, i.Preliminary_Announcement_Date__c);
      System.assertEquals(null, i.Calc_Amended_Prelim_Determination_Sig__c);
      System.assertEquals(null, i.Amended_Preliminary_Announcement_Date__c);
      System.assertNotEquals(null, i.Prelim_Team_Meeting_Deadline__c);
      System.assertNotEquals(null, i.Calculated_Final_Signature__c);
      System.assertNotEquals(null, i.Final_Announcement_Date__c);
      System.assertEquals(null, i.Calculated_Amended_Final_Signature__c);
      System.assertEquals(null, i.Amended_Final_Announcement_Date__c);
      System.assertNotEquals(null, i.Final_Team_Meeting_Deadline__c);
      System.assertNotEquals(null, i.Est_ITC_Notification_to_DOC_of_Final_Det__c);
      System.assertNotEquals(null, i.Calculated_Order_FR_Signature__c);
      System.assertNotEquals(null, i.Calculated_ITC_Final_FR_Published__c);
      System.assertNotEquals(null, i.Estimated_Order_FR_Published__c);
      System.assertEquals(null, i.Litigation_Hold_Expiration_Date__c);
      System.assertNotEquals(null, i.Calculated_Prelim_Extension_Request_File__c);
      System.assertNotEquals(null, i.Calculated_Postponement_of_PrelimDeterFR__c);
      System.assertNotEquals(null, i.Calculated_ITC_Prelim_Determination__c);
      System.assertNotEquals(null, i.Termination_of_Suspension_Gap_Period_Beg__c);
      System.assertNotEquals(null, i.Petition_Initiation_Signature__c);
    }

  }

  @testSetup static void dataSetup() {
    Date petitionDate = System.today();
    List<ADCVD_Case__c> cList = new List<ADCVD_Case__c>();
    List<Petition__c> pList = new List<Petition__c>();
    List<Investigation__c> iList = new List<Investigation__c>();
    List<Federal_Register__c> frList = new List<Federal_Register__c>();

    User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);

    System.runAs(testUser) {
      //create custom setting configuration to activate triggers, workflow rules, and validation rules
      Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
      AppConfig__c ac = TestUtils.createAppConfig('default', true, true);

      //create test data
      for (Integer i = 0; i < COUNT; i++) {
        ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-12' + i, 'AD ME', testUser, false);
        cList.add(testADCase);
        ADCVD_Case__c testCVDCase = TestUtils.createADCVDCase('C-123-12' + i, 'CVD', testUser, false);
        cList.add(testCVDCase);
      }
      insert cList;
      Integer counter = 0;
      for (ADCVD_Case__c c : cList) {
        if (c.ADCVD_Case_Type__c.indexOf('A') > -1) {
          Petition__c testADPetition = TestUtils.createPetition(c, petitionDate.addDays(counter), false);
          pList.add(testADPetition);
        } else if (c.ADCVD_Case_Type__c.indexOf('C') > -1) {
          Petition__c testCVDPetition = TestUtils.createPetition(c, petitionDate.addDays(counter), false);
          pList.add(testCVDPetition);
        }
        counter++;
      }
      insert pList;
      for (Petition__c p : pList) {
        Investigation__c testInvestigation = TestUtils.createInvestigation(p, false);
        iList.add(testInvestigation);
        Federal_Register__c initFR = TestUtils.createFR(p.Id, 'Petition__c', petitionDate.addDays(120), 'Initiation', false);
        frList.add(initFR);
      }
      insert iList;
      for (Investigation__c i : iList) {
        Federal_Register__c prelimFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Preliminary', false);
        frList.add(prelimFR);
        Federal_Register__c finalFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Final', false);
        frList.add(finalFR);
      }
      insert frList;
    }
  }
}