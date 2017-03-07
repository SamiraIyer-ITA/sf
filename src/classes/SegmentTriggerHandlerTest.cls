@isTest
public class SegmentTriggerHandlerTest {
	private static Date segmentDate = System.today();
	private static Date testActual = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static Date testCalculated = System.today();//reusable date variable for each test to add roll forward logic allowing data normalization
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			System.debug('User u: ' + u);
			return u;
		}
	}
	private static ADCVD_Order__c o{
		get{
			if (o == null) {
				o = [SELECT Id, Anniversary_Month__c FROM ADCVD_Order__c LIMIT 1];
			}
			return o;
		}
	}
	private static Federal_Register__c fr{
		get{
			if (fr == null) {
				fr = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c LIMIT 1];
			}
			return fr;
		}
	}
	private static Segment__c adminSeg{
		get{
			if (adminSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
				adminSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c,
									Calculated_Final_Signature__c 
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return adminSeg;
		}
	}
	private static Segment__c nsSeg{
		get{
			if (nsSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('New_Shipper_Review');
				nsSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Calculated_Initiation_Signature__c,
								Actual_Initiation_Signature__c, Calculated_Final_Signature__c 
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return nsSeg;
		}
	}
	private static Segment__c siSeg{
		get{
			if (siSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Scope_Inquiry');
				siSeg = [SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c, Initiation_Extension_of_days__c, RecordTypeId, Request_Filed__c, 
								Prelim_Extension__c, Calculated_Preliminary_Signature__c, Actual_Date_of_Decision_on_HoP__c, Calculated_Final_Signature__c 
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return siSeg;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		List<Segment__c> sList = new List<Segment__c>();
		sList.add(adminSeg);
		SegmentTriggerHandler.initialize(sList, null);
		//TODO
		Test.stopTest();
	}
	//setDeadlineForDecisionForHoP
	@isTest static void setDeadlineForDecisionForHoP(){
		Test.startTest();
		//Setup start dates
		setStartDates();
		setExtensions();
		//Scope Inquiry
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Request_Filed__c.addDays(45).addDays(7));
		//compare Request_Filed__c + Initiation_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Deadline_for_Decision_on_How_to_Proceed__c);
		Test.stopTest();
	}
	//setCalculatedPreliminarySignature
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();

		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Administrative Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Final_Date_of_Anniversary_Month__c.addDays(245).addDays(7));
		//compare Final_Date_of_Anniversary_Month__c + Prelim_Extension__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//New Shipper Review
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));
		//compare Calculated_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Based on Actual
		nsSeg.Actual_Initiation_Signature__c = nsSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update nsSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Initiation_Signature__c.addDays(180).addDays(7));
		//compare Actual_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Scope Inquiry
		//Based on Formal
		siSeg.Actual_Date_of_Decision_on_HoP__c = siSeg.Deadline_for_Decision_on_How_to_Proceed__c.addDays(-14);
		update siSeg;
		getNewSegs();//trigger new query in class variables
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(75).addDays(7));
		//compare Actual_Date_of_Decision_on_HoP__c + Prelim_Extension__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Based on Not Formal
		siSeg.Decision_on_How_to_Proceed__c = '';
		update siSeg;
		System.assertEquals(null,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
		Test.stopTest();
	}
	//setPrelimTeamMeetingDeadline
	@isTest static void setPrelimTeamMeetingDeadline(){
		Test.startTest();

		//setup start dates
		setStartDates();
		getNewSegs();

		//Admin Review
		//compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//New Shipper
		//compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//Scope Inquiry
		////Based on Formal
		//compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: siSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
		
		//Based on Not Formal
		siSeg.Decision_on_How_to_Proceed__c = '';
		update siSeg;
		System.assertEquals(null,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
		Test.stopTest();
	}
	//setCalculatedFinalSignature
	@isTest static void setCalculatedFinalSignature(){
		Test.startTest();

		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Administrative Review
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Preliminary_Signature__c.addDays(120).addDays(7));
		//compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on FR Preliminary Published Date
		setFR(adminSeg.Id);
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(fr.Published_Date__c.addDays(120).addDays(7));
		//compare fr.Published_Date__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//New Shipper Review
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Preliminary_Signature__c.addDays(90).addDays(7));
		//compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Actual
		nsSeg.Actual_Preliminary_Signature__c = nsSeg.Calculated_Preliminary_Signature__c.addDays(-14);
		update nsSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Preliminary_Signature__c.addDays(90).addDays(7));
		//compare Actual_Preliminary_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Scope Inquiry
		//Based on Formal
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(120).addDays(7));
		//compare Actual_Date_of_Decision_on_HoP__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Not Formal
		siSeg.Decision_on_How_to_Proceed__c = '';
		update siSeg;
		System.assertEquals(null,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);
		Test.stopTest();
	}

	//setFinalTeamMeetingDeadline
	@isTest static void setFinalTeamMeetingDeadline(){
		Test.startTest();

		//setup start dates
		setStartDates();
		getNewSegs();

		//Admin Review
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//New Shipper
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//Scope Inquiry
		//Based on Formal
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: siSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//Based on Not Formal
		siSeg.Decision_on_How_to_Proceed__c = '';
		update siSeg;
		System.assertEquals(null,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
		
		Test.stopTest();
	}

	//setCalculatedAmendedFinalSignature
	@isTest static void setCalculatedAmendedFinalSignature(){
		Test.startTest();

		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Administrative Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c.addDays(37));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//New Shipper Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Final_Signature__c.addDays(37));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		ADCVD_Order__c testOrder = TestUtils.createOrder(true);
		List<Segment__c> segsToInsert = new List<Segment__c>();
		System.runAs(testUser) {
			for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
				Segment__c testSeg = TestUtils.createSegment(testOrder, segRecordTypeName, false);
				segsToInsert.add(testSeg);
			}
			insert segsToInsert;
			System.debug(segsToInsert);
		}
	}

	private static void setStartDates() {
		List<Segment__c> segsToUpdate = new List<Segment__c>();
		adminSeg.Final_Date_of_Anniversary_Month__c = segmentDate;
		segsToUpdate.add(adminSeg);
		nsSeg.Calculated_Initiation_Signature__c = segmentDate;
		segsToUpdate.add(nsSeg);
		siSeg.Request_Filed__c = segmentDate;
		siSeg.Actual_Date_of_Decision_on_HoP__c = segmentDate.addDays(21);
		siSeg.Decision_on_How_to_Proceed__c = 'Formal';
		segsToUpdate.add(siSeg);

		update segsToUpdate;
	}

	private static void setExtensions() {
		List<Segment__c> segsToUpdate = new List<Segment__c>();
		adminSeg.Prelim_Extension__c = adminSeg.Prelim_Extension__c == null ? 7 : 7;
		adminSeg.Final_Extension_of_days__c = adminSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(adminSeg);
		nsSeg.Prelim_Extension__c = nsSeg.Prelim_Extension__c == null ? 7 : 7;
		nsSeg.Final_Extension_of_days__c = nsSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(nsSeg);
		siSeg.Prelim_Extension__c = siSeg.Prelim_Extension__c == null ? 7 : 7;
		siSeg.Final_Extension_of_days__c = siSeg.Final_Extension_of_days__c == null ? 7 : 7;
		siSeg.Initiation_Extension_of_days__c = siSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(siSeg);

		update segsToUpdate;
	}

	private static void setFR(Id parentId) {
		Federal_Register__c testFR = new Federal_Register__c();
		testFR.Segment__c = parentId;
		testFR.Type__c = 'Preliminary';
		testFR.Published_Date__c = segmentDate.addDays(120);
		insert testFR;
	}

	private static void getNewSegs() {
		adminSeg = null;
		nsSeg = null;
		siSeg = null;
	}

}