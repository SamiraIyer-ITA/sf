/**
 * Test the FederalRegisterMapper and FederalRegisterSelector.
 * These classes are already covered by trigger tests, such as in the InvestigationTriggerHandlerTest.
 * However, they are specifically tested here.
 */

@isTest
public class FederalRegisterTest {

  @testSetup static void setup() {
    //Create custom setting configuration to activate triggers, workflow rules, and validation rules
    Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
    AppConfig__c ac = TestUtils.createAppConfig('default', true, true);

    //Create test data
    Date dateToday = System.today();
    User u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
    Date petitionDate = ADCVD_TollingDayUtility.getCalculatedDate(dateToday, dateToday, true);
    ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
    Petition__c testADPetition = TestUtils.createPetition(testADCase, petitionDate, true);
    Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
    ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
    Segment__c testSeg = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
    Suspension_Agreement__c testSA = TestUtils.createSuspensionAgreement(testADinvestigation, dateToday, true);
    Integer days = 140;
    List<Federal_Register__c> frsToInsert = new List<Federal_Register__c>();
    Schema.DescribeFieldResult f = Federal_Register__c.Type__c.getDescribe();
    for(Schema.PicklistEntry frType : f.getPicklistValues()) {
      //Petition
      Federal_Register__c testPetFR = TestUtils.createFR(testADPetition.Id, 'Petition__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
	  testPetFR.ADCVD_Case__c = testADCase.Id;      
	  frsToInsert.add(testPetFR);
      days += 7;
      //Investigation
      Federal_Register__c testInvFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
      testInvFR.ADCVD_Case__c = testADCase.Id;  
      frsToInsert.add(testInvFR);
      days += 7;
      //Order
      Federal_Register__c testOrderFR = TestUtils.createFR(testADOrder.Id, 'ADCVD_Order__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
	  testOrderFR.ADCVD_Case__c = testADCase.Id;
      days += 7;
      frsToInsert.add(testOrderFR);
      //Segment
      Federal_Register__c testSegFR = TestUtils.createFR(testSeg.Id, 'Segment__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
	  testSegFR.ADCVD_Case__c = testADCase.Id;
      days += 7;
      frsToInsert.add(testSegFR);
	  //Suspension Agreement
      Federal_Register__c testSAFR = TestUtils.createFR(testSA.Id, 'Suspension_Agreement__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
	  testSAFR.ADCVD_Case__c = testADCase.Id;        
      days += 7;
      frsToInsert.add(testSAFR);
    }
    insert frsToInsert;
  }

  @isTest static void petitionTest() {

    Test.startTest();

    //Get the Case Id
    ADCVD_Case__c adcvdCase = [SELECT Id FROM ADCVD_Case__c LIMIT 1];  //Only 1 was inserted
    Set<Id> caseIdSet = new Set<Id>();
    caseIdSet.add(adcvdCase.Id);

    //Initialize the ADCVD_CaseSelector
    new ADCVD_CaseSelector(caseIdSet);

    //Get the Petition Id
    Petition__c petition = [SELECT Id FROM Petition__c WHERE ADCVD_Case__c = : adcvdCase.Id LIMIT 1];  //Only 1 was inserted
    Set<Id> petitionIds = new Set<Id>();
    petitionIds.add(petition.Id);

    //Test the FederalRegisterMapper for the Segment
    FederalRegisterMapper frm = new FederalRegisterMapper(petitionIds, 'Petition__c');
    System.assert(frm.masterMap.containsKey(petition.Id));
    System.assertEquals(((FederalRegisterMapper.FederalRegistersInScope) frm.masterMap.get(petition.id)).myId, petition.Id);

    Test.stopTest();
  }

  @isTest static void investigationTest() {

    Test.startTest();

    //Get the Case Id
    ADCVD_Case__c adcvdCase = [SELECT Id FROM ADCVD_Case__c LIMIT 1];  //Only 1 was inserted
    Set<Id> caseIdSet = new Set<Id>();
    caseIdSet.add(adcvdCase.Id);

    //Initialize the ADCVD_CaseSelector
    new ADCVD_CaseSelector(caseIdSet);

    //Get the Investigation Id
    Investigation__c investigation = [SELECT Id FROM Investigation__c WHERE ADCVD_Case__c = : adcvdCase.Id LIMIT 1];  //Only 1 was inserted
    Set<Id> investigationIds = new Set<Id>();
    investigationIds.add(investigation.Id);

    //Test the FederalRegisterMapper for the Investigation
    FederalRegisterMapper frm = new FederalRegisterMapper(investigationIds, 'Investigation__c');
    System.assert(frm.masterMap.containsKey(investigation.Id));
    System.assertEquals(((FederalRegisterMapper.FederalRegistersInScope) frm.masterMap.get(investigation.id)).myId, investigation.Id);

    Test.stopTest();
  }

  @isTest static void orderTest() {

    Test.startTest();

    //Get the Case Id
    ADCVD_Case__c adcvdCase = [SELECT Id FROM ADCVD_Case__c LIMIT 1];  //Only 1 was inserted
    Set<Id> caseIdSet = new Set<Id>();
    caseIdSet.add(adcvdCase.Id);

    //Initialize the ADCVD_CaseSelector
    new ADCVD_CaseSelector(caseIdSet);

    //Get the ADCVD Order Id
    ADCVD_Order__c adcvdOrder = [SELECT Id FROM ADCVD_Order__c WHERE ADCVD_Case__c = : adcvdCase.Id LIMIT 1];  //Only 1 was inserted
    Set<Id> adcvdOrderIds = new Set<Id>();
    adcvdOrderIds.add(adcvdOrder.Id);

    //Test the FederalRegisterMapper for the Order
    FederalRegisterMapper frm = new FederalRegisterMapper(adcvdOrderIds, 'ADCVD_Order__c');
    System.assert(frm.masterMap.containsKey(adcvdOrder.Id));
    System.assertEquals(((FederalRegisterMapper.FederalRegistersInScope) frm.masterMap.get(adcvdOrder.id)).myId, adcvdOrder.Id);

    Test.stopTest();
  }

  @isTest static void segmentTest() {

    Test.startTest();

    //Get the Case Id
    ADCVD_Case__c adcvdCase = [SELECT Id FROM ADCVD_Case__c LIMIT 1];  //Only 1 was inserted
    Set<Id> caseIdSet = new Set<Id>();
    caseIdSet.add(adcvdCase.Id);

    //Initialize the ADCVD_CaseSelector
    new ADCVD_CaseSelector(caseIdSet);

    //Get the Segment Id
    Segment__c segment = [SELECT Id FROM Segment__c WHERE ADCVD_Case__c = : adcvdCase.Id LIMIT 1];  //Only 1 was inserted
    Set<Id> segmentIds = new Set<Id>();
    segmentIds.add(segment.Id);

    //Test the FederalRegisterMapper for the Segment
    FederalRegisterMapper frm = new FederalRegisterMapper(segmentIds, 'Segment__c');
    System.assert(frm.masterMap.containsKey(segment.Id));
    System.assertEquals(((FederalRegisterMapper.FederalRegistersInScope) frm.masterMap.get(segment.id)).myId, segment.Id);

    Test.stopTest();
  }
    
  @isTest static void suspensionAgreementTest() {

    Test.startTest();

    //Get the Case Id
    ADCVD_Case__c adcvdCase = [SELECT Id FROM ADCVD_Case__c LIMIT 1];  //Only 1 was inserted
    Set<Id> caseIdSet = new Set<Id>();
    caseIdSet.add(adcvdCase.Id);

    //Initialize the ADCVD_CaseSelector
    new ADCVD_CaseSelector(caseIdSet);

    //Get the Segment Id
    Suspension_Agreement__c suspensionAgreement = [SELECT Id FROM Suspension_Agreement__c WHERE ADCVD_Case__c = : adcvdCase.Id LIMIT 1];  //Only 1 was inserted
    Set<Id> suspensionAgreements = new Set<Id>();
    suspensionAgreements.add(suspensionAgreement.Id);

    //Test the FederalRegisterMapper for the Suspension Agreement
    FederalRegisterMapper frm = new FederalRegisterMapper(suspensionAgreements, 'Suspension_Agreement__c');
    System.assert(frm.masterMap.containsKey(suspensionAgreement.Id));
    System.assertEquals(((FederalRegisterMapper.FederalRegistersInScope) frm.masterMap.get(suspensionAgreement.id)).myId, suspensionAgreement.Id);

    Test.stopTest();
  }  

}