/**
 * 
 *    Created by Joshua Moody
 *    on Mar 14 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class LitigationTriggerHandlerTest {

	/************************************************
    * This class performs unit tests on the ADCVDOrderTriggerHandler
    * under these condititions.
    * 1. Test to ensure that class variables initialize
    * 2. Test to ensure that date calculations are logically correct
    * 3. Test to ensure that parent case values are correctly added on insert
    *************************************************/

	private static Date litigationDate = System.today();
	private static Date testActual = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testCalculated = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
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
	private static Litigation__c intLit{
		get{
			if (intLit == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('International_Litigation');
				intLit = [SELECT Id, RecordTypeId, Request_Filed__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
								Calculated_Final_Signature__c, Prelim_Extension_of_days__c, Status__c, Final_Extension_of_days__c, 
								Prelim_Issues_Due_to_DAS__c, Prelim_Concurrence_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
								Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
								Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c 
								FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return intLit;
		}
	}
	private static Litigation__c remand{
		get{
			if (remand == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Litigation__c').get('Remand');
				remand = [SELECT Id, RecordTypeId, Final_Extension_of_days__c, Expected_Final_Signature_Before_Ext__c, Calculated_Amended_Final_Signature__c,
								Calculated_Draft_Remand_release_to_party__c, Calculated_Final_Signature__c, Court_of_Panel_s_Ruling__c, Status__c, 
								Draft_Remand_Concurrence_Due_to_DAS__c, Draft_Remand_Issues_Due_to_DAS__c, Final_Issues_Due_to_DAS__c, Final_Concurrence_Due_to_DAS__c, 
								Prelim_Team_Meeting_Deadline__c, Final_Team_Meeting_Deadline__c, ADCVD_Case_Number__c, 
								Next_Due_to_DAS_Deadline__c, Next_Major_Deadline__c, Next_Office_Deadline__c 
							FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return remand;
		}
	}

	private static Segment__c adminSeg{
		get{
			if (adminSeg == null) {
				Id recordTypeId = Utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
				adminSeg = [SELECT Id, ADCVD_Case_Number__c FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return adminSeg;
		}
		set;
	}

	//setCalculatedInitiationSignature
	@isTest static void setCalculatedInitiationSignature(){
		Test.startTest();
		//International Litigation
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(intLit.Request_Filed__c.addDays(7));

		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Litigation__c WHERE Id =:intLit.Id  LIMIT 1].Calculated_Initiation_Signature__c);
	}

	//setCalculatedPreliminarySignature
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();

		intLit.Prelim_Extension_of_days__c = 7;
		update intLit;
		intLit = null;

		//International Litigation
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(intLit.Request_Filed__c.addDays(45).addDays(7));

		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Litigation__c WHERE Id =:intLit.Id  LIMIT 1].Calculated_Preliminary_Signature__c);
	}

	//setCalculatedFinalSignature
	@isTest static void setCalculatedFinalSignature(){
		Test.startTest();

		intLit.Final_Extension_of_days__c = 7;
		remand.Final_Extension_of_days__c = 7;
		remand.Expected_Final_Signature_Before_Ext__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(-21));
		List<Litigation__c> updateList = new List<Litigation__c>{intLit, remand};
		update updateList;
		intLit = null;
		remand = null;

		//International Litigation
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(intLit.Request_Filed__c.addDays(180).addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Litigation__c WHERE Id =:intLit.Id  LIMIT 1].Calculated_Final_Signature__c);

		//Remand
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Expected_Final_Signature_Before_Ext__c.addDays(7));

		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedDraftRemandReleaseToParty
	@isTest static void setCalculatedDraftRemandReleaseToParty(){
		Test.startTest();

		remand.Expected_Final_Signature_Before_Ext__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(35));
		update remand;
		remand = null;

		//Remand
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Expected_Final_Signature_Before_Ext__c.addDays(-30));


		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Draft_Remand_release_to_party__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Draft_Remand_release_to_party__c);
	}

	//setCalculatedAmendedFinalSignature
	@isTest static void setCalculatedAmendedFinalSignature(){
		Test.startTest();

		remand.Court_of_Panel_s_Ruling__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(35));
		update remand;
		remand = null;

		//Remand
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Court_of_Panel_s_Ruling__c.addDays(7));

		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Amended_Final_Signature__c);
	}


	/***************************
	* Next Deadlines
	***************************/

	//Next Major Deadline
	@isTest static void setNextMajorDeadlineIntLit() {
		Test.startTest();

		System.assertEquals(intLit.Calculated_Preliminary_Signature__c, intLit.Next_Major_Deadline__c);

		intLit.Actual_Preliminary_Signature__c = intLit.Calculated_Preliminary_Signature__c.addDays(-7);
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Calculated_Final_Signature__c, intLit.Next_Major_Deadline__c);

		intLit.Actual_Final_Signature__c = intLit.Calculated_Final_Signature__c.addDays(-7);
		update intLit;
		intLit = null;

		Test.stopTest();
		System.assertEquals(null, intLit.Next_Major_Deadline__c);
	}
	//Next Major Deadline
	@isTest static void setNextMajorDeadlineRemand() {
		Test.startTest();

		System.assertEquals(remand.Calculated_Draft_Remand_release_to_party__c, remand.Next_Major_Deadline__c);

		remand.Actual_Draft_Remand_released_to_party__c = remand.Calculated_Draft_Remand_release_to_party__c.addDays(-7);
		update remand;
		remand = null;
		System.assertEquals(remand.Calculated_Final_Signature__c, remand.Next_Major_Deadline__c);

		remand.Actual_Final_Signature__c = remand.Calculated_Final_Signature__c.addDays(-7);
		update remand;
		remand = null;

		Test.stopTest();
		System.assertEquals(null, remand.Next_Major_Deadline__c);
	}
	//Next Due to DAS
	@isTest static void setNextDueToDasIntLit() {
		Test.startTest();

		System.assertEquals(intLit.Prelim_Issues_Due_to_DAS__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Prelim_Issues_to_DAS__c = intLit.Prelim_Issues_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Prelim_Concurrence_Due_to_DAS__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Prelim_Concurrence_to_DAS__c = intLit.Prelim_Concurrence_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Calculated_Preliminary_Signature__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Preliminary_Signature__c = intLit.Calculated_Preliminary_Signature__c.addDays(-7);
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Final_Issues_Due_to_DAS__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Final_Issues_to_DAS__c = intLit.Final_Issues_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Final_Concurrence_Due_to_DAS__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Final_Concurrence_to_DAS__c = intLit.Final_Concurrence_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Calculated_Final_Signature__c, intLit.Next_Due_to_DAS_Deadline__c);

		intLit.Actual_Final_Signature__c = intLit.Calculated_Final_Signature__c.addDays(-7);
		update intLit;
		intLit = null;

		Test.stopTest();
		System.assertEquals(null, intLit.Next_Due_to_DAS_Deadline__c);
	}
	//Next Due to DAS
	@isTest static void setNextDueToDasRemand() {
		Test.startTest();

		System.assertEquals(remand.Draft_Remand_Issues_Due_to_DAS__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Draft_Remand_Issues_to_DAS__c = remand.Draft_Remand_Issues_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Draft_Remand_Concurrence_Due_to_DAS__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Draft_Remand_Concurrence_to_DAS__c = remand.Draft_Remand_Concurrence_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Calculated_Draft_Remand_release_to_party__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Draft_Remand_released_to_party__c = remand.Calculated_Draft_Remand_release_to_party__c.addDays(-7);
		update remand;
		remand = null;
		System.assertEquals(remand.Final_Issues_Due_to_DAS__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Final_Issues_to_DAS__c = remand.Final_Issues_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Final_Concurrence_Due_to_DAS__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Final_Concurrence_to_DAS__c = remand.Final_Concurrence_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Calculated_Final_Signature__c, remand.Next_Due_to_DAS_Deadline__c);

		remand.Actual_Final_Signature__c = remand.Calculated_Final_Signature__c.addDays(-7);
		update remand;
		remand = null;

		Test.stopTest();
		System.assertEquals(null, remand.Next_Due_to_DAS_Deadline__c);
	}
	//Next Office Deadline
	@isTest static void setNextOfficeDeadlineIntLit() {
		Test.startTest();

		System.assertEquals(intLit.Prelim_Team_Meeting_Deadline__c, intLit.Next_Office_Deadline__c);

		intLit.Request_Filed__c = intLit.Request_Filed__c.addDays(-35);
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Prelim_Issues_Due_to_DAS__c, intLit.Next_Office_Deadline__c);

		intLit.Actual_Prelim_Issues_to_DAS__c = intLit.Prelim_Issues_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Prelim_Concurrence_Due_to_DAS__c, intLit.Next_Office_Deadline__c);

		intLit.Actual_Prelim_Concurrence_to_DAS__c = intLit.Prelim_Concurrence_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Calculated_Preliminary_Signature__c, intLit.Next_Office_Deadline__c);

		intLit.Request_Filed__c = intLit.Request_Filed__c.addDays(-35);
		intLit.Actual_Preliminary_Signature__c = intLit.Calculated_Preliminary_Signature__c.addDays(-7);
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Final_Team_Meeting_Deadline__c, intLit.Next_Office_Deadline__c);

		intLit.Request_Filed__c = intLit.Request_Filed__c.addDays(-105);
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Final_Issues_Due_to_DAS__c, intLit.Next_Office_Deadline__c);

		intLit.Actual_Final_Issues_to_DAS__c = intLit.Final_Issues_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Final_Concurrence_Due_to_DAS__c, intLit.Next_Office_Deadline__c);

		intLit.Actual_Final_Concurrence_to_DAS__c = intLit.Final_Concurrence_Due_to_DAS__c;
		update intLit;
		intLit = null;
		System.assertEquals(intLit.Calculated_Final_Signature__c, intLit.Next_Office_Deadline__c);

		intLit.Actual_Final_Signature__c = intLit.Calculated_Final_Signature__c.addDays(-7);
		update intLit;
		intLit = null;

		Test.stopTest();
		System.assertEquals(null, intLit.Next_Office_Deadline__c);
	}
	//Next Office Deadline
	@isTest static void setNextOfficeDeadlineRemand() {
		Test.startTest();

		System.assertEquals(remand.Draft_Remand_Issues_Due_to_DAS__c, remand.Next_Office_Deadline__c);

		remand.Actual_Draft_Remand_Issues_to_DAS__c = remand.Draft_Remand_Issues_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Draft_Remand_Concurrence_Due_to_DAS__c, remand.Next_Office_Deadline__c);

		remand.Actual_Draft_Remand_Concurrence_to_DAS__c = remand.Draft_Remand_Concurrence_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Calculated_Draft_Remand_release_to_party__c, remand.Next_Office_Deadline__c);

		remand.Actual_Draft_Remand_released_to_party__c = remand.Calculated_Draft_Remand_release_to_party__c.addDays(-7);
		update remand;
		remand = null;
		System.assertEquals(remand.Final_Issues_Due_to_DAS__c, remand.Next_Office_Deadline__c);

		remand.Actual_Final_Issues_to_DAS__c = remand.Final_Issues_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Final_Concurrence_Due_to_DAS__c, remand.Next_Office_Deadline__c);

		remand.Actual_Final_Concurrence_to_DAS__c = remand.Final_Concurrence_Due_to_DAS__c;
		update remand;
		remand = null;
		System.assertEquals(remand.Calculated_Final_Signature__c, remand.Next_Office_Deadline__c);

		remand.Actual_Final_Signature__c = remand.Calculated_Final_Signature__c.addDays(-7);
		update remand;
		remand = null;

		Test.stopTest();
		System.assertEquals(null, remand.Next_Office_Deadline__c);
	}

	//setPreliminaryStatus, setFinalStatus, setClosedStatus
	@isTest static void setStatus() {
		Test.startTest();

		System.assertEquals('Preliminary', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: intLit.Id LIMIT 1].Status__c);
		intLit.Actual_Preliminary_Signature__c = litigationDate.addDays(14);
		update intLit;
		intLit = null;

		System.assertEquals('Preliminary', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: remand.Id LIMIT 1].Status__c);
		remand.Actual_Draft_Remand_released_to_party__c = litigationDate.addDays(14);
		update remand;
		remand = null;

		System.assertEquals('Final', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: intLit.Id LIMIT 1].Status__c);
		intLit.Actual_Final_Signature__c = litigationDate.addDays(20);
		update intLit;
		intLit = null;

		System.assertEquals('Final', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: remand.Id LIMIT 1].Status__c);
		remand.Actual_Final_Signature__c = litigationDate.addDays(20);
		update remand;
		remand = null;

		Test.stopTest();
		System.assertEquals('Closed', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: intLit.Id LIMIT 1].Status__c);
		System.assertEquals('Closed', [SELECT Id, Status__c FROM Litigation__c WHERE Id =: remand.Id LIMIT 1].Status__c);
	}

	//setCaseValuesFromParent
	@isTest static void setCaseValuesFromParent() {
		Test.startTest();

		Test.stopTest();
		System.assertEquals(intLit.ADCVD_Case_Number__c, adminSeg.ADCVD_Case_Number__c);
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPet = TestUtils.createPetition(litigationDate.addDays(-350), 'AD ME', true);
		Investigation__c testInvAd = TestUtils.createInvestigation('AD', testPet, true);
		ADCVD_Order__c testOrder = TestUtils.createOrder(testInvAd, true);
		Map<String,Segment__c> segsToInsert = new Map<string,Segment__c>();
		List<Litigation__c> litToInsert = new List<Litigation__c>();
		System.runAs(testUser) {
			for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
				Segment__c testSeg = TestUtils.createSegment(testOrder, segRecordTypeName, false);
				segsToInsert.put(segRecordTypeName, testSeg);
			}
			insert segsToInsert.values();
			for(String litRecordTypeName : utils.getRecordTypeDeveloperNameMap('Litigation__c').values()) {
				Litigation__c testLit = TestUtils.createLitigation(segsToInsert.get('Administrative_Review').Id, 'Segment__c', litigationDate, litRecordTypeName, false);
				litToInsert.add(testLit);
			}
			insert litToInsert;
		}
	}
}