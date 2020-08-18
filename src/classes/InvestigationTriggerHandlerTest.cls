/**
 * 
 *    Created by Joshua Moody
 *    on Feb 19 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class InvestigationTriggerHandlerTest {

  /************************************************
  * This class performs unit tests on the InvestigationTriggerHandler
  * under these condititions.
  * 1. Test to ensure that class variables initialize
  * 2. Test to ensure that date calculations are logically correct
  * 3. Test to ensure that status calculations are logically correct
  *************************************************/

  private static Date petitionDate = System.today();
  private static Date testActual = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
  private static Date testCalculated = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
  private static Date testPublishedDate = System.today();
  private static User u{
    get{
      if(u == null){
        u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
                Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
              FROM User WHERE LastName =: 'LastName1' LIMIT 1];
      }
      return u;
    }
  }
  private static List<Investigation__c> iList {
    get {
      if(iList == null) {
        iList = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
              Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
              Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
              Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
              Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
              Calculated_Postponement_of_PrelimDeterFR__c, 
              Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
              Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c,
              Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
              Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c
            FROM Investigation__c];
      }
      return iList;
    }
  }
  private static Investigation__c iAD {
    get {
      if(iAD == null) {
        Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('AD');
        iAD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
              Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
              Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
              Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
              Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
              Calculated_Postponement_of_PrelimDeterFR__c, 
              Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
              Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
              Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
              Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, 
              Calculated_ITC_Prelim_Determination__c 
            FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
      }
      return iAD;
    }  
  }
  private static Investigation__c iCVD {
    get {
      if(iCVD == null) {
        Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('CVD');
        iCVD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
              Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
              Prelim_Team_Meeting_Deadline__c, Calculated_Amended_Final_Signature__c, Actual_Final_Signature__c, Final_Team_Meeting_Deadline__c, 
              Est_ITC_Notification_to_DOC_of_Final_Det__c, ITC_Notification_to_DOC_of_Final_Determ__c, Calculated_Order_FR_Signature__c, 
              Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c, 
              Petition_Initiation_Signature__c, Calculated_Postponement_of_PrelimDeterFR__c, 
              Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Amend_Prelim_Issues_Due_to_DAS__c, Amend_Prelim_Concurrence_Due_to_DAS__c, 
              Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, Amend_Final_Issues_Due_to_DAS__c, Amend_Final_Concurrence_Due_to_DAS__c, 
              Next_Major_Deadline__c, Next_Office_Deadline__c, Next_Announcement_Date__c, Next_Due_to_DAS_Deadline__c, 
              Preliminary_Announcement_Date__c, Amended_Preliminary_Announcement_Date__c, Final_Announcement_Date__c, Amended_Final_Announcement_Date__c, 
              Calculated_ITC_Prelim_Determination__c 
            FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
      }
      return iCVD;
    }  
  }
  private static Federal_Register__c adPrelimFR {
    get {
      if(adPrelimFR == null) {
        adPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'Preliminary' LIMIT 1];
      }
      return adPrelimFR;
    }
  }
  private static Federal_Register__c adPrelimItcFR {
    get {
      if(adPrelimItcFR == null) {
        adPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
      }
      return adPrelimItcFR;
    }
  }
  private static Federal_Register__c adFinalItcFR {
    get {
      if(adFinalItcFR == null) {
        adFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id AND Type__c =: 'ITC Final' LIMIT 1];
      }
      return adFinalItcFR;
    }
  }
  private static Federal_Register__c adOrderFR {
    get {
      if(adOrderFR == null) {
        adOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: adOrder.Id AND Type__c =: 'Order' LIMIT 1];
      }
      return adOrderFR;
    }
  }
  private static Federal_Register__c cvdPrelimFR {
    get {
      if(cvdPrelimFR == null) {
        cvdPrelimFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'Preliminary' LIMIT 1];
      }
      return cvdPrelimFR;
    }
  }
  private static Federal_Register__c cvdPrelimItcFR {
    get {
      if(cvdPrelimItcFR == null) {
        cvdPrelimItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Preliminary' LIMIT 1];
      }
      return cvdPrelimItcFR;
    }
  }
  private static Federal_Register__c cvdFinalItcFR {
    get {
      if(cvdFinalItcFR == null) {
        cvdFinalItcFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id AND Type__c =: 'ITC Final' LIMIT 1];
      }
      return cvdFinalItcFR;
    }
  }
  private static Federal_Register__c cvdOrderFR {
    get {
      if(cvdOrderFR == null) {
        cvdOrderFR = [SELECT Id, Published_Date__c, Type__c FROM Federal_Register__c WHERE ADCVD_Order__c =: cvdOrder.Id AND Type__c =: 'Order' LIMIT 1];
      }
      return cvdOrderFR;
    }
  }
  private static Petition__c adP{
    get{
      if (adP == null) {
        adP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c WHERE ADCVD_Case_Type_Text__c LIKE 'AD%' LIMIT 1];
      }
      return adP;
    }
  }
  private static Petition__c cvdP{
    get{
      if (cvdP == null) {
        cvdP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c WHERE ADCVD_Case_Type_Text__c LIKE 'CVD%' LIMIT 1];
      }
      return cvdP;
    }
  }
  private static ADCVD_Order__c adOrder{
    get{
      if (adOrder == null) {
        adOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iAD.Id LIMIT 1];
      }
      return adOrder;
    }
  }
  private static ADCVD_Order__c cvdOrder{
    get{
      if (cvdOrder == null) {
        cvdOrder = [SELECT Id FROM ADCVD_Order__c WHERE Investigation__c =: iCVD.Id LIMIT 1];
      }
      return cvdOrder;
    }
  }
  

  @isTest static void initialize() {
    Test.startTest();
    InvestigationTriggerHandler.initialize(iList, null);
    Test.stopTest();
    System.assertEquals(adP.Id, InvestigationTriggerHandler.petitionsInScopeMap.get(adP.Id).Id);
    System.assertEquals('AD', InvestigationTriggerHandler.recordTypeNameMap.get(iAD.RecordTypeId));
  }

  //setCalculatedPreliminarySignature

/*  
  @isTest static void setCVDCalculatedPreliminarySignature() {
    Test.startTest();
    //CVD investigation
    //CVD based on calculated
    //cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(65));
    System.assertEquals(testCalculated, 
      [SELECT Id, Calculated_Preliminary_Signature__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Preliminary_Signature__c);
    //CVD based on actual
    cvdP.Petition_Outcome__c = 'Initiated from Petition';
    cvdP.Actual_Initiation_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(-14));//set cvdP.Actual_Initiation_Signature__c
    update cvdP;//update cvdP    
    update iCVD;
    //cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c + Prelim_Extension_of_days__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(65));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calculated_Preliminary_Signature__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Preliminary_Signature__c);
  }
*/

  //setCalcAmendedPrelimDeterminationSig
  //Test has 2 parts that test two dates each: AD and CVD
  /*
  @isTest static void setCalcAmendedPrelimDeterminationSig() {
    Test.startTest();
    //AD investigation
    //AD based on calculated
    System.assertEquals(null, iAD.Calc_Amended_Prelim_Determination_Sig__c);
    iAD.Amend_the_Preliminary_Determination__c = 'No';
    update iAD;
    System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    update iAD;
    iAD = null;//trigger a new query to database
    //iAD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(31));
    System.assertEquals(testCalculated,
      [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

    //AD based on Actual
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);//set iAD.Actual_Preliminary_Signature__c
    update iAD;//calculate based on actual
    iAD = null;//trigger a new query to database
    //iAD.Actual_Preliminary_Signature__c is set, so compare iAD.Actual_Preliminary_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Preliminary_Signature__c.addDays(31));
    System.assertEquals(testActual,
      [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

    //CVD investigation
    //CVD based on calculated
    System.assertEquals(null, iCVD.Calc_Amended_Prelim_Determination_Sig__c);
    iCVD.Amend_the_Preliminary_Determination__c = 'No';
    update iCVD;
    System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    update iCVD;
    iCVD = null;//trigger a new query to database
    //iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
    System.debug(iCVD);
    System.debug(iCVD.Petition__c);
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(31));
    System.assertEquals(testCalculated,
      [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

    //CVD based on Actual
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);//set iCVD.Actual_Preliminary_Signature__c
    update iCVD;//calculate based on actual
    iCVD = null;//trigger a new query to database
    //iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Preliminary_Signature__c.addDays(31));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
  }*/
  //Above method was split into two parts
  @isTest static void setADCalcAmendedPrelimDeterminationSig() {
        Test.startTest();
        //AD investigation
        //AD based on calculated
        System.assertEquals(null, iAD.Calc_Amended_Prelim_Determination_Sig__c);
        iAD.Amend_the_Preliminary_Determination__c = 'No';
        update iAD;
        System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
        iAD.Amend_the_Preliminary_Determination__c = 'Yes';
        update iAD;
        iAD = null;//trigger a new query to database
        //iAD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(31));
        System.assertEquals(testCalculated,
                            [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
        
        //AD based on Actual
        iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);//set iAD.Actual_Preliminary_Signature__c
        update iAD;//calculate based on actual
        iAD = null;//trigger a new query to database
        //iAD.Actual_Preliminary_Signature__c is set, so compare iAD.Actual_Preliminary_Signature__c
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Preliminary_Signature__c.addDays(31));
        
        Test.stopTest();
        System.assertEquals(testActual,
                            [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
    }
    @isTest static void setCVDCalcAmendedPrelimDeterminationSig() {
        Test.startTest();
        //CVD investigation
        //CVD based on calculated
        System.assertEquals(null, iCVD.Calc_Amended_Prelim_Determination_Sig__c);
        iCVD.Amend_the_Preliminary_Determination__c = 'No';
        update iCVD;
        System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
        iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
        update iCVD;
        iCVD = null;//trigger a new query to database
        //iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(31));
        System.assertEquals(testCalculated,
                            [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
        
        //CVD based on Actual
        iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);//set iCVD.Actual_Preliminary_Signature__c
        update iCVD;//calculate based on actual
        iCVD = null;//trigger a new query to database
        //iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
        testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Preliminary_Signature__c.addDays(31));
        
        Test.stopTest();
        System.assertEquals(testActual,
                            [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
    }
    
    
  //setPrelimTeamMeetingDeadline
  //Test has 2 parts that test two dates each: AD and CVD
  @isTest static void setPrelimTeamMeetingDeadline() {
    Test.startTest();
    //AD investigation
    //AD based on calculated
    //iAD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(-21));
    System.assertEquals(testCalculated,
      [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

    //CVD investigation
    //CVD based on calculated
    //iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(-21));

    Test.stopTest();
    System.assertEquals(testCalculated,
      [SELECT Id, Prelim_Team_Meeting_Deadline__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
  }
  //setCalculatedFinalSignature
  //Test has 7 parts: AD Calculated, AD Actual, CVD Calculated, CVD Actual, AD FR Published Date, CVD Aligned to AD, CVD stays Aligned on AD update

/*  
  @isTest static void setADCalculatedPrelimExtensionRequestFile() {
    Test.startTest();
    //AD investigation
    //AD based on calculated
    //adP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(115));
    System.assertEquals(testCalculated,
      [SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);

    //AD based on Actual
    adP.Petition_Outcome__c = 'Initiated from Petition';
    adP.Actual_Initiation_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(-14));//set adP.Actual_Initiation_Signature__c
    update adP;//update adP
    //adP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Actual_Initiation_Signature__c.addDays(115));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);
  }
*/
  
  //setCalculatedPrelimExtensionRequestFile

/*
  @isTest static void setCVDCalculatedPrelimExtensionRequestFile() {
    Test.startTest();
    //CVD investigation
    //CVD based on calculated
    cvdP.Actual_Initiation_Signature__c = null;
    update cvdP;//reset for CVD logic
    //cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(40));
    System.assertEquals(testCalculated, 
      [SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);

    //CVD based on actual
    cvdP.Petition_Outcome__c = 'Initiated from Petition';
    cvdP.Actual_Initiation_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(-14));//set cvdP.Actual_Initiation_Signature__c
    update cvdP;//update cvdP
    //cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(40));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);
  }
*/

  //setCalculatedPostponementOfPrelimDeterFR

/*
  @isTest static void setADCalculatedPostponementOfPrelimDeterFR() {
    Test.startTest();
    //AD investigation
    //AD based on calculated
    //adP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(120));
    System.assertEquals(testCalculated,
      [SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);

    //AD based on Actual
    adP.Petition_Outcome__c = 'Initiated from Petition';
    adP.Actual_Initiation_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(-14));//set adP.Actual_Initiation_Signature__c
    update adP;//update adP
    //adP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Actual_Initiation_Signature__c.addDays(120));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);
  }
*/

  //setCalculatedPostponementOfPrelimDeterFR

/*
  @isTest static void setCVDCalculatedPostponementOfPrelimDeterFR() {
    Test.startTest();
    //CVD investigation
    //CVD based on calculated
    cvdP.Actual_Initiation_Signature__c = null;
    update cvdP;//reset for CVD logic
    //cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
    testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(45));
    System.assertEquals(testCalculated, 
      [SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);

    //CVD based on actual
    PetitionSelector.allPetitions = null;
    cvdP.Petition_Outcome__c = 'Initiated from Petition';
    System.debug(loggingLevel.Error, '*** iCVD.Petition_Initiation_Signature__c: ' + iCVD.Petition_Initiation_Signature__c);
    System.debug(loggingLevel.Error, '*** cvdP.Actual_Initiation_Signature__c: ' + cvdP.Actual_Initiation_Signature__c);
    cvdP.Actual_Initiation_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(-14));//set cvdP.Actual_Initiation_Signature__c
    System.debug(loggingLevel.Error, '*** cvdP.Actual_Initiation_Signature__c: ' + cvdP.Actual_Initiation_Signature__c);
    update cvdP;//update cvdP
    System.debug(loggingLevel.Error, '*** cvdP.Actual_Initiation_Signature__c: ' + cvdP.Actual_Initiation_Signature__c);
    System.debug(loggingLevel.Error, '*** iCVD.Petition_Initiation_Signature__c: ' + iCVD.Petition_Initiation_Signature__c);
    //cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
    testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(45));

    Test.stopTest();
    System.assertEquals(testActual,
      [SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);
  }
*/  
  
  //setCalculatedITCPrelimDetermination
  //Test has 2 parts that test two dates each: AD and CVD

  @isTest static void setCVDTerminationofSuspensionGapPeriodBeg() {
    Test.startTest();
    //CVD Investigation
    //CVD based on FR Published_Date__c with Type__c Preliminary (Final_Extension_of_days__c does not matter)
    //cvdPrelimFR.Published_Date__c is set, so compare cvdPrelimFR.Published_Date__c
    testCalculated = cvdPrelimFR.Published_Date__c.addDays(120);  
    Test.stopTest();
    System.assertEquals(testCalculated,
      [SELECT Id, Termination_of_Suspension_Gap_Period_Beg__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Termination_of_Suspension_Gap_Period_Beg__c);
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateNegativeOutcomes() {
    Test.startTest();

    //Negative Tests for error on Outcome without FR
    iAD.Investigation_Outcome__c = 'ITC Negative Prelim';
    String insufficientDataError = attemptUpsert(iAD);
    System.assert(insufficientDataError.contains('You must enter a ITC Preliminary Federal Register'));

    iAD.Investigation_Outcome__c = 'ITC Negative Final';
    insufficientDataError = attemptUpsert(iAD);
    System.assert(insufficientDataError.contains('You must enter a ITC Final Federal Register'));

    iAD.Investigation_Outcome__c = 'DOC Negative Final';
    insufficientDataError = attemptUpsert(iAD);
    System.debug(loggingLevel.Error, '*** insufficientDataError: ' + iAD);
    System.assert(insufficientDataError.contains('Actual Final Signature date is required'));

    iAD.Investigation_Outcome__c = 'Petition Withdrawn After Initiation';
    insufficientDataError = attemptUpsert(iAD);
    System.assert(insufficientDataError.contains('Petition Withdrawn date is required'));

    List<Federal_Register__c> newFRList = new List<Federal_Register__c>();
    newFRList.add(setFR(iAD.Id, 'Preliminary', false));
    newFRList.add(setFR(iAD.Id, 'Final', false));
    insert newFRList;

    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    iAD.Investigation_Outcome__c = '';
    update iAD;

    iAD.Investigation_Outcome__c = 'Order';
    insufficientDataError = attemptUpsert(iAD);

    Test.stopTest();
    System.assert(insufficientDataError.contains('You must create an ADCVD Order for this Investigation and add an Order Federal Register'));
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateItcNegativePrelim() {
    Test.startTest();

    //NAFTA Country Hold Time
    adP.Country_Text__c = 'Mexico';
    update adP;

    Federal_Register__c adPrelimItcFR = setFR(iAD.Id, 'ITC Preliminary', true);
    iAD.Investigation_Outcome__c = 'ITC Negative Prelim';
    update iAD;

    Test.stopTest();
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adPrelimItcFR.Published_Date__c.addDays(45)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateItcNegativeFinal() {
    Test.startTest();

    //NAFTA Country Hold Time
    adP.Country_Text__c = 'Mexico';
    update adP;

    Federal_Register__c adFinalItcFR =  setFR(iAD.Id, 'ITC Final', true);
    iAD.Investigation_Outcome__c = 'ITC Negative Final';
    update iAD;

    Test.stopTest();
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adFinalItcFR.Published_Date__c.addDays(45)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateDocNegative() {
    Test.startTest();

    //NAFTA Country Hold Time
    adP.Country_Text__c = 'Mexico';
    update adP;

    iAD.Actual_Final_Signature__c = petitionDate.addDays(56);
    iAD.Investigation_Outcome__c = 'DOC Negative Final';
    update iAD;
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Final_Signature__c.addDays(45)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

    iAD.Petition_Withdrawn__c = petitionDate.addDays(63);
    iAD.Investigation_Outcome__c = 'Petition Withdrawn After Initiation';
    update iAD;

    Test.stopTest();
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Petition_Withdrawn__c.addDays(45)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateNaftaOrder() {
    Test.startTest();

    //NAFTA Country Hold Time
    adP.Country_Text__c = 'Mexico';
    update adP;

    //Data setup
    List<Federal_Register__c> newFRList = new List<Federal_Register__c>();
    newFRList.add(setFR(iAD.Id, 'Preliminary', false));
    newFRList.add(setFR(iAD.Id, 'Final', false));
    newFRList.add(TestUtils.createFR(adOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', false));
    insert newFRList;
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    iAD.Investigation_Outcome__c = 'Order';
    update iAD;
    
    Test.stopTest();
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adOrderFR.Published_Date__c.addDays(45)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);
  }

  //setLitigationHoldExpirationDate
  @isTest static void setLitigationHoldExpirationDateNonNaftaOrder() {
    Test.startTest();

    //Data setup
    List<Federal_Register__c> newFRList = new List<Federal_Register__c>();
    newFRList.add(setFR(iCVD.Id, 'Preliminary', false));
    newFRList.add(setFR(iCVD.Id, 'Final', false));
    newFRList.add(TestUtils.createFR(cvdOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', false));
    insert newFRList;

    //Non-NAFTA Country Hold Time
    //default petition country is United States, which is not Canada or Mexico for this test

    //Data setup
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c.addDays(-7);
    iCVD.Investigation_Outcome__c = 'Order';
    update iCVD;
    
    Test.stopTest();
    System.assertEquals('Hold', [SELECT Status__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Status__c);
    System.assertEquals(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdOrderFR.Published_Date__c.addDays(30)), 
      [SELECT Litigation_Hold_Expiration_Date__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Litigation_Hold_Expiration_Date__c);

  }

  //Next Major Deadline
  @isTest static void setNextMajorDeadlineAD() {
    Test.startTest();
    System.assertEquals(iAD.Calculated_Preliminary_Signature__c, iAD.Next_Major_Deadline__c);

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calc_Amended_Prelim_Determination_Sig__c, iAD.Next_Major_Deadline__c);

    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Final_Signature__c, iAD.Next_Major_Deadline__c);

    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Amended_Final_Signature__c, iAD.Next_Major_Deadline__c);

    iAD.Actual_Amended_Final_Signature__c = iAD.Calculated_Amended_Final_Signature__c.addDays(7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Order_FR_Signature__c, iAD.Next_Major_Deadline__c);

    Federal_Register__c orderFR = TestUtils.createFR(adOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', true);
    iAD = null;

    Test.stopTest();
    System.assertEquals(null, iAD.Next_Major_Deadline__c);
  }

  //Next Major Deadline
  @isTest static void setNextMajorDeadlineCVD() {
    Test.startTest();
    System.assertEquals(iCVD.Calculated_Preliminary_Signature__c, iCVD.Next_Major_Deadline__c);

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calc_Amended_Prelim_Determination_Sig__c, iCVD.Next_Major_Deadline__c);

    iCVD.Actual_Amended_Prelim_Determination_Sig__c = iCVD.Calculated_Preliminary_Signature__c.addDays(7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Final_Signature__c, iCVD.Next_Major_Deadline__c);

    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c.addDays(-7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Amended_Final_Signature__c, iCVD.Next_Major_Deadline__c);

    iCVD.Actual_Amended_Final_Signature__c = iCVD.Calculated_Amended_Final_Signature__c.addDays(7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Order_FR_Signature__c, iCVD.Next_Major_Deadline__c);

    Federal_Register__c orderFR = TestUtils.createFR(cvdOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', true);
    iCVD = null;

    Test.stopTest();
    System.assertEquals(null, iCVD.Next_Major_Deadline__c);
  }

  //Next Announcement Date
  @isTest static void setNextAnnouncementDateAD() {
    Test.startTest();
    System.assertEquals(iAD.Preliminary_Announcement_Date__c, iAD.Next_Announcement_Date__c);

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Amended_Preliminary_Announcement_Date__c, iAD.Next_Announcement_Date__c);

    iAD.Actual_Amended_Prelim_Determination_Sig__c = System.today().toStartOfWeek().addDays(-4);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Final_Announcement_Date__c, iAD.Next_Announcement_Date__c);

    
    iAD.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Next_Announcement_Date__c, iAD.Next_Announcement_Date__c);

    iAD.Actual_Amended_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(null, iAD.Next_Announcement_Date__c);
  }

  //Next Announcement Date
  @isTest static void setNextAnnouncementDateCVD() {
    Test.startTest();
    System.assertEquals(iCVD.Preliminary_Announcement_Date__c, iCVD.Next_Announcement_Date__c);

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Actual_Preliminary_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Amended_Preliminary_Announcement_Date__c, iCVD.Next_Announcement_Date__c);

    iCVD.Actual_Amended_Prelim_Determination_Sig__c = System.today().toStartOfWeek().addDays(-4);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Final_Announcement_Date__c, iCVD.Next_Announcement_Date__c);

    
    iCVD.Actual_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Next_Announcement_Date__c, iCVD.Next_Announcement_Date__c);

    iCVD.Actual_Amended_Final_Signature__c = System.today().toStartOfWeek().addDays(-4);
    update iCVD;
    iCVD = null;

    Test.stopTest();
    System.assertEquals(null, iCVD.Next_Announcement_Date__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineADPrelim() {
    Test.startTest();
    System.assertEquals(iAD.Calculated_Postponement_of_PrelimDeterFR__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Signature_of_Prelim_Postponement_FR__c = iAD.Calculated_Preliminary_Signature__c.addDays(-28);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Prelim_Issues_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Prelim_Concurrence_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Preliminary_Signature__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(iAD.Amend_Prelim_Issues_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineCVDPrelim() {
    Test.startTest();
    System.assertEquals(iCVD.Calculated_Postponement_of_PrelimDeterFR__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Signature_of_Prelim_Postponement_FR__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-28);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Prelim_Issues_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Prelim_Concurrence_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Preliminary_Signature__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c;
    update iCVD;
    iCVD = null;

    Test.stopTest();
    System.assertEquals(iCVD.Amend_Prelim_Issues_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineADAmendPrelim() {
    Test.startTest();

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Signature_of_Prelim_Postponement_FR__c = iAD.Calculated_Preliminary_Signature__c.addDays(-28);
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Amend_Prelim_Concurrence_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calc_Amended_Prelim_Determination_Sig__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(iAD.Final_Issues_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineCVDAmendPrelim() {
    Test.startTest();

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Signature_of_Prelim_Postponement_FR__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-28);
    iCVD.Actual_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);
    iCVD.Actual_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c;
    iCVD.Actual_Amend_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Amend_Prelim_Concurrence_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(14);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calc_Amended_Prelim_Determination_Sig__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Amended_Prelim_Determination_Sig__c = iCVD.Calculated_Preliminary_Signature__c.addDays(21);
    update iCVD;
    iCVD = null;

    Test.stopTest();
    System.assertEquals(iCVD.Final_Issues_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineADFinal() {
    Test.startTest();

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Signature_of_Prelim_Postponement_FR__c = iAD.Calculated_Preliminary_Signature__c.addDays(-28);
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    iAD.Actual_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Final_Concurrence_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Final_Signature__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c;
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(iAD.Amend_Final_Issues_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineCVDFinal() {
    Test.startTest();

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Signature_of_Prelim_Postponement_FR__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-28);
    iCVD.Actual_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);
    iCVD.Actual_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c;
    iCVD.Actual_Amend_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(7);
    iCVD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(14);
    iCVD.Actual_Amended_Prelim_Determination_Sig__c = iCVD.Calculated_Preliminary_Signature__c.addDays(21);
    iCVD.Actual_Final_Issues_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(-14);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Final_Concurrence_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Final_Concurrence_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(-7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Final_Signature__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c;
    update iCVD;
    iCVD = null;

    Test.stopTest();
    System.assertEquals(iCVD.Amend_Final_Issues_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineADAmendFinal() {
    Test.startTest();

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Signature_of_Prelim_Postponement_FR__c = iAD.Calculated_Preliminary_Signature__c.addDays(-28);
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    iAD.Actual_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-14);
    iAD.Actual_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c;
    iAD.Actual_Amend_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Amend_Final_Concurrence_Due_to_DAS__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Amend_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Amended_Final_Signature__c, iAD.Next_Due_to_DAS_Deadline__c);

    iAD.Actual_Amended_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(21);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Order_FR_Signature__c, iAD.Next_Due_to_DAS_Deadline__c);

    Federal_Register__c orderFR = TestUtils.createFR(adOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', true);
    iAD = null;

    Test.stopTest();
    System.assertEquals(null, iAD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Due to DAS Deadline
  @isTest static void setNextDueToDasDeadlineCVDAmendFinal() {
    Test.startTest();

    iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
    iCVD.Will_you_Amend_the_Final__c = 'Yes';
    iCVD.Signature_of_Prelim_Postponement_FR__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-28);
    iCVD.Actual_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);
    iCVD.Actual_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-7);
    iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c;
    iCVD.Actual_Amend_Prelim_Issues_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(7);
    iCVD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iCVD.Calculated_Preliminary_Signature__c.addDays(14);
    iCVD.Actual_Amended_Prelim_Determination_Sig__c = iCVD.Calculated_Preliminary_Signature__c.addDays(21);
    iCVD.Actual_Final_Issues_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(-14);
    iCVD.Actual_Final_Concurrence_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(-7);
    iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c;
    iCVD.Actual_Amend_Final_Issues_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(7);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Amend_Final_Concurrence_Due_to_DAS__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Amend_Final_Concurrence_to_DAS__c = iCVD.Calculated_Final_Signature__c.addDays(14);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Amended_Final_Signature__c, iCVD.Next_Due_to_DAS_Deadline__c);

    iCVD.Actual_Amended_Final_Signature__c = iCVD.Calculated_Final_Signature__c.addDays(21);
    update iCVD;
    iCVD = null;
    System.assertEquals(iCVD.Calculated_Order_FR_Signature__c, iCVD.Next_Due_to_DAS_Deadline__c);

    Federal_Register__c orderFR = TestUtils.createFR(cvdOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', true);
    iCVD = null;

    Test.stopTest();
    System.assertEquals(null, iCVD.Next_Due_to_DAS_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineADCalcPrelimExt() {
    Test.startTest();
    //115 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    //-3 adjustment days for weekends
    adP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-135));
    update adP;

    Test.stopTest();
    System.assertEquals(iAD.Calculated_Prelim_Extension_Request_File__c, iAD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineCVDCalcPrelimExt() {
    Test.startTest();
    //40 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    //-3 adjustment days for weekends
    cvdP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-60));
    update cvdP;

    Test.stopTest();
    System.assertEquals(iCVD.Calculated_Prelim_Extension_Request_File__c, iCVD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineADCalcPostponePrelimDeterFR() {
    Test.startTest();
    //120 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    adP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-143));
    update adP;

    Test.stopTest();
//    System.assertEquals(iAD.Calculated_Postponement_of_PrelimDeterFR__c, iAD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineCVDCalcPostponePrelimDeterFR() {
    Test.startTest();
    //45 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    cvdP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-68));
    update cvdP;

    Test.stopTest();
//    System.assertEquals(iCVD.Calculated_Postponement_of_PrelimDeterFR__c, iCVD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  
  @isTest static void setNextOfficeDeadlineADFinal() {
    Test.startTest();
    //75 day offset to Calculated_Preliminary_Signature__c, 
    //10 day Prelim_Extension_of_days__c, 
    //140 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    //-3 adjustment days for weekends
    adP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-245));
    update adP;

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Final_Issues_Due_to_DAS__c, iAD.Next_Office_Deadline__c);
    
    iAD.Actual_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Final_Concurrence_Due_to_DAS__c, iAD.Next_Office_Deadline__c);

    iAD.Actual_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Final_Signature__c, iAD.Next_Office_Deadline__c);

    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c;
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(iAD.Amend_Final_Issues_Due_to_DAS__c, iAD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineADAmendFinal() {
    Test.startTest();
    //31 day offset to Calculated_Final_Signature__c, 
    //75 day offset to Calculated_Preliminary_Signature__c, 
    //10 day Prelim_Extension_of_days__c, 
    //140 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    //-3 adjustment days for weekends
    adP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-276));
    update adP;

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    iAD.Actual_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-14);
    iAD.Actual_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c;
    iAD.Actual_Amend_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(7);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Amend_Final_Concurrence_Due_to_DAS__c, iAD.Next_Office_Deadline__c);

    iAD.Actual_Amend_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(14);
    update iAD;
    iAD = null;
    System.assertEquals(iAD.Calculated_Amended_Final_Signature__c, iAD.Next_Office_Deadline__c);

    iAD.Actual_Amended_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(21);
    update iAD;
    iAD = null;

    Test.stopTest();
    System.assertEquals(iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c, iAD.Next_Office_Deadline__c);
  }

  //Next Office Deadline
  @isTest static void setNextOfficeDeadlineADCalcOrderFR() {
    Test.startTest();
    //45+ day offset to Calculated_Final_Signature__c, (used 55)
    //75 day offset to Calculated_Preliminary_Signature__c, 
    //10 day Prelim_Extension_of_days__c, 
    //140 day offset to Calculated_Initiation_Signature__c, 
    //3 day Initiation_Extension_of_days__c, 
    //20 day offset to Petition_Filed__c, 
    //-3 adjustment days for weekends
    adP.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(System.today().addDays(-300));
    update adP;

    iAD.Amend_the_Preliminary_Determination__c = 'Yes';
    iAD.Will_you_Amend_the_Final__c = 'Yes';
    iAD.Actual_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);
    iAD.Actual_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(-7);
    iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c;
    iAD.Actual_Amend_Prelim_Issues_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(7);
    iAD.Actual_Amend_Prelim_Concurrence_to_DAS__c = iAD.Calculated_Preliminary_Signature__c.addDays(14);
    iAD.Actual_Amended_Prelim_Determination_Sig__c = iAD.Calculated_Preliminary_Signature__c.addDays(21);
    iAD.Actual_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-14);
    iAD.Actual_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(-7);
    iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c;
    iAD.Actual_Amend_Final_Issues_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(7);
    iAD.Actual_Amend_Final_Concurrence_to_DAS__c = iAD.Calculated_Final_Signature__c.addDays(14);
    iAD.Actual_Amended_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(21);
    update iAD;
    iAD = null;

    System.assertEquals(iAD.Calculated_Order_FR_Signature__c, iAD.Next_Office_Deadline__c);

    Federal_Register__c orderFR = TestUtils.createFR(adOrder.Id, 'ADCVD_Order__c', System.today(), 'Order', true);
    iAD = null;

    Test.stopTest();
    System.assertEquals(null, iAD.Next_Office_Deadline__c);
  }

  /********************************
   * Tests for Status Calculations
  *********************************/

  //setLitigationStatus
  @isTest static void setLitigationStatus() {
    Test.startTest();
    System.assertEquals('Inactive', [SELECT Litigation_Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Status__c);
    Litigation__c lit = TestUtils.createLitigation(iAD.Id, 'Investigation__c', petitionDate, 'Remand', true);
    update iAD;

    iAD = null;

    Test.stopTest();
    System.assertEquals('Active', [SELECT Litigation_Status__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Litigation_Status__c);
  }

  //

  @testSetup static void dataSetup() {
    List<ADCVD_Case__c> caseList = new List<ADCVD_Case__c>();
    List<Petition__c> petitionList = new List<Petition__c>();
    List<Investigation__c> investigationList = new List<Investigation__c>();
    List<Federal_Register__c> frList = new List<Federal_Register__c>();
    List<ADCVD_Order__c> orderList = new List<ADCVD_Order__c>();

    User testUser = TestUtils.createStaffingUser(true, 'myemail@email.com.testita', 1);

    System.runAs(testUser) {
    //create custom setting configuration to activate triggers, workflow rules, and validation rules
    Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
    AppConfig__c ac = TestUtils.createAppConfig('default', true, true);

    //create test data
      ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', testUser, false);
    caseList.add(testADCase);
      ADCVD_Case__c testCVDCase = TestUtils.createADCVDCase('C-123-123', 'CVD', testUser, false);
    caseList.add(testCVDCase);
    insert caseList;

    Petition__c testADPetition = TestUtils.createPetition(testADCase, petitionDate, false);
    petitionList.add(testADPetition);
    Petition__c testCVDPetition = TestUtils.createPetition(testCVDCase, petitionDate, false);
    petitionList.add(testCVDPetition);
    insert petitionList;

    Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, false);
    investigationList.add(testADinvestigation);
    Investigation__c testCVDinvestigation = TestUtils.createInvestigation(testCVDPetition, false);
    investigationList.add(testCVDinvestigation);
    insert investigationList;

    Federal_Register__c testAdPrelimFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(210), 'Preliminary', false);
    frList.add(testAdPrelimFR);
    Federal_Register__c testCvdPrelimFR = TestUtils.createFR(testCVDinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(140), 'Preliminary', false);
    frList.add(testCvdPrelimFR);
    //Add initiation federal registers
    Federal_Register__c testAdInitiationFR = TestUtils.createFR(testADPetition.Id, 'Petition__c', petitionDate, 'Initiation', false);
    frList.add(testAdInitiationFR);
    Federal_Register__c testCvdInitiationFR = TestUtils.createFR(testCVDPetition.Id, 'Petition__c', petitionDate, 'Initiation', false);
    frList.add(testCvdInitiationFR);
    insert frList;
    
    ADCVD_Order__c testAdOrder = TestUtils.createOrder(testADinvestigation, false);
    orderList.add(testAdOrder);
    ADCVD_Order__c testCvdOrder = TestUtils.createOrder(testCVDinvestigation, false);
    orderList.add(testCvdOrder);
    insert orderList;
  }
  }

  private static Federal_Register__c setFR(Id parentId, String frType, Boolean doInsert) {
    Federal_Register__c testFR = TestUtils.createFR(parentId, 'Investigation__c', petitionDate.addDays(120), frType, doInsert);
    return testFR;
  }

  private static String attemptUpsert(SObject o){
    String error = '';
    try{
      upsert o;
      error = 'Success';
    } catch (DmlException e) {
      error = e.getMessage();
    }
    return error;
  }

  private static void debugDates(SObject o) {
    Set<String> fieldNames = new Set<String>{
    'Prelim_Extension_of_days__c', 'Calculated_Preliminary_Signature__c', 
    'Actual_Preliminary_Signature__c', 'Calculated_Final_Signature__c', 'Calc_Amended_Prelim_Determination_Sig__c', 
    'Prelim_Team_Meeting_Deadline__c', 'Calculated_Amended_Final_Signature__c', 'Actual_Final_Signature__c', 'Final_Team_Meeting_Deadline__c', 
    'Est_ITC_Notification_to_DOC_of_Final_Det__c', 'ITC_Notification_to_DOC_of_Final_Determ__c', 'Calculated_Order_FR_Signature__c', 
    'Calculated_ITC_Final_FR_Published__c', 'Estimated_Order_FR_Published__c', 'Calculated_Prelim_Extension_Request_File__c', 
    'Calculated_Postponement_of_PrelimDeterFR__c', 
    'Prelim_Issues_Due_to_DAS__c', 'Prelim_Concurrence_Due_to_DAS__c', 'Amend_Prelim_Issues_Due_to_DAS__c', 'Amend_Prelim_Concurrence_Due_to_DAS__c', 
    'Final_Issues_Due_to_DAS__c', 'Final_Concurrence_Due_to_DAS__c', 'Amend_Final_Issues_Due_to_DAS__c', 'Amend_Final_Concurrence_Due_to_DAS__c', 
    'Next_Major_Deadline__c', 'Next_Office_Deadline__c', 'Next_Announcement_Date__c', 'Next_Due_to_DAS_Deadline__c', 
    'Preliminary_Announcement_Date__c', 'Amended_Preliminary_Announcement_Date__c', 'Final_Announcement_Date__c', 'Amended_Final_Announcement_Date__c', 
    'Calculated_ITC_Prelim_Determination__c'};

    for (String field : fieldNames) {
      System.debug(loggingLevel.Error, '***debugDates ' + field + ': ' + o.get(field));
    }
  }
}