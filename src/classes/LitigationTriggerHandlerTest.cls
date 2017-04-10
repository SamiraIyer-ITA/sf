@isTest
public class LitigationTriggerHandlerTest {
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
									Calculated_Final_Signature__c, Prelim_Extension_of_days__c, Final_Extension_of_days__c 
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
								Calculated_Draft_Remand_release_to_party__c, Calculated_Final_Signature__c, Court_of_Panel_s_Ruling__c 
							FROM Litigation__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return remand;
		}
	}

	//setCalculatedInitiationSignature
	@isTest static void setCalculatedInitiationSignature(){
		Test.startTest();
		//International Litigation
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(intLit.Request_Filed__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Litigation__c WHERE Id =:intLit.Id  LIMIT 1].Calculated_Initiation_Signature__c);
		Test.stopTest();
	}

	//setCalculatedPreliminarySignature
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();

		intLit.Prelim_Extension_of_days__c = 7;
		update intLit;
		intLit = null;

		//International Litigation
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(intLit.Request_Filed__c.addDays(45).addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Litigation__c WHERE Id =:intLit.Id  LIMIT 1].Calculated_Preliminary_Signature__c);

		Test.stopTest();
	}

	//setPrelimTeamMeetingDeadline
	@isTest static void setPrelimTeamMeetingDeadline(){
		Test.startTest();
		remand.Calculated_Final_Signature__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(35));
		update remand;
		remand = null;
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Calculated_Final_Signature__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM Litigation__c WHERE Id =: remand.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
		Test.stopTest();

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
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Final_Signature__c);
		Test.stopTest();
	}

	//setCalculatedDraftRemandReleaseToParty
	@isTest static void setCalculatedDraftRemandReleaseToParty(){
		Test.startTest();

		remand.Expected_Final_Signature_Before_Ext__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(35));
		update remand;
		remand = null;

		//Remand
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Expected_Final_Signature_Before_Ext__c.addDays(-30));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Draft_Remand_release_to_party__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Draft_Remand_release_to_party__c);

		Test.stopTest();
	}

	//setCalculatedAmendedFinalSignature
	@isTest static void setCalculatedAmendedFinalSignature(){
		Test.startTest();

		remand.Court_of_Panel_s_Ruling__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(litigationDate.addDays(35));
		update remand;
		remand = null;

		//Remand
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(remand.Court_of_Panel_s_Ruling__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Litigation__c WHERE Id =:remand.Id  LIMIT 1].Calculated_Amended_Final_Signature__c);

		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		List<Litigation__c> litToInsert = new List<Litigation__c>();
		System.runAs(testUser) {
			for(String litRecordTypeName : utils.getRecordTypeDeveloperNameMap('Litigation__c').values()) {
				Litigation__c testLit = TestUtils.createLitigation(litigationDate, litRecordTypeName, false);
				litToInsert.add(testLit);
			}
			insert litToInsert;
		}
	}
}