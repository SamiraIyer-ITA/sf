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
	private static Federal_Register__c prelimFR{
		get{
			if (prelimFR == null) {
				prelimFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Preliminary' LIMIT 1];
			}
			return prelimFR;
		}
	}
	private static Federal_Register__c initFR{
		get{
			if (initFR == null) {
				initFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Initiation' LIMIT 1];
			}
			return initFR;
		}
	}
	private static Federal_Register__c finalFR{
		get{
			if (finalFR == null) {
				finalFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Final' LIMIT 1];
			}
			return finalFR;
		}
	}
	private static Federal_Register__c itcFinalFR{
		get{
			if (itcFinalFR == null) {
				itcFinalFR = [SELECT Id, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'ITC Final' LIMIT 1];
			}
			return itcFinalFR;
		}
	}
	private static Federal_Register__c revoFR{
		get{
			if (revoFR == null) {
				revoFR = [SELECT Id, ADCVD_Order__c, Segment__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Revocation' LIMIT 1];
			}
			return revoFR;
		}
	}
	private static Segment__c adminSeg{
		get{
			if (adminSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Administrative_Review');
				adminSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Final_Date_of_Anniversary_Month__c, Calculated_Preliminary_Signature__c,
									Calculated_Final_Signature__c, Actual_Final_Signature__c 
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
								Actual_Initiation_Signature__c, Calculated_Final_Signature__c, Actual_Preliminary_Signature__c, Actual_Final_Signature__c
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
	private static Segment__c expedSeg{
		get{
			if (expedSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Expedited_Review');
				expedSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Initiation_Signature__c, Calculated_Preliminary_Signature__c,
									Calculated_Final_Signature__c, Actual_Final_Signature__c, Actual_Preliminary_Signature__c
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return expedSeg;
		}
	}
	private static Segment__c acSeg{
		get{
			if (acSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Anti_Circumvention_Review');
				acSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Initiation_Extension_of_days__c, Calculated_Preliminary_Signature__c,
									Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
									Application_Accepted__c
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return acSeg;
		}
	}
	private static Segment__c ccSeg{
		get{
			if (ccSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Changed_Circumstances_Review');
				ccSeg = [SELECT Id, RecordTypeId, Prelim_Extension__c, Calculated_Preliminary_Signature__c, Is_This_Review_Expedited__c,
									Calculated_Final_Signature__c , Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c,
									All_parties_in_agreement_to_the_outcome__c, Request_Filed__c
								FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return ccSeg;
		}
	}
	private static Segment__c ssSeg{
		get{
			if (ssSeg == null) {
				Id recordTypeId = utils.getRecordTypeIdMap('Segment__c').get('Sunset_Review');
				ssSeg = [SELECT Id, RecordTypeId, Calculated_Final_Signature__c, Update_ACE_Customs_Module__c, Adequacy_of_Respondents_Submission__c, 
							Actual_Final_Signature__c, Actual_Revocation_or_Continuation_FR__c, Calculated_Revocation_or_Continuation_FR__c, 
							Issue_Liquidation_Revocation_Instruction__c, Rebuttal_Comments_Due__c, Adequacy_Determination_Letter_120_day__c, 
							Adequacy_Determination_Letter_240_day__c, Comments_on_Adequacy_Determination_Filed__c, Memorandum_on_Adequacy_Determination__c, 
							Notify_ITC_of_No_Domestic_Interest__c, Inadequate_Domestic_Response_note_to_ITC__c, Notice_of_Intent_to_Participate__c, 
							Notify_Cluster_Coordinator_No_Interest__c, Substantive_Response_Due_For_All_Parties__c, Inform_Cluster_Coordinator_if_No_Respons__c, 
							Notice_of_intent_to_participate_Ips__c, Domestic_Party_File_Substan_Response__c, Review_to_address_zeroing_in_Segments__c, 
							Respondent_File_Substantive_Response__c, Prelim_Extension__c, Initiation_Extension_of_days__c, Final_Extension_of_days__c
							FROM Segment__c WHERE RecordTypeId =: recordTypeId LIMIT 1];
			}
			return ssSeg;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		List<Segment__c> sList = new List<Segment__c>();
		sList.add(adminSeg);
		sList.add(acSeg);
		sList.add(ccSeg);
		sList.add(expedSeg);
		sList.add(nsSeg);
		sList.add(siSeg);
		sList.add(ssSeg);

		SegmentTriggerHandler.initialize(sList, null);
		Test.stopTest();
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(adminSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(acSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(ccSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(expedSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(adminSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(siSeg.RecordTypeId),null);
		System.assertNotEquals(SegmentTriggerHandler.recordTypeNameMap.get(ssSeg.RecordTypeId),null);
		
	}

	//setDeadlineForDecisionForHoP
	@isTest static void setDeadlineForDecisionForHoP(){
		Test.startTest();
		//Setup start dates
		setStartDates();
		setExtensions();
		//Scope Inquiry
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Request_Filed__c.addDays(45).addDays(7));
		
		Test.stopTest();
		//compare Request_Filed__c + Initiation_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Deadline_for_Decision_on_How_to_Proceed__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Deadline_for_Decision_on_How_to_Proceed__c);
	}

	//setCalculatedInitationSignature
	@isTest static void setCalculatedInitationSignature() {
		Test.startTest();
		//Setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();
		//Anti-Circumvention Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Application_Accepted__c.addDays(45).addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);

		//Changed-Circumstances Reivew
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Request_Filed__c.addDays(45).addDays(7));
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);
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
		clearFormal();
		System.assertEquals(null,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Expedited Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        //Anti-Circumvention Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Initiation_Signature__c.addDays(120).addDays(7));
		//compare Calculated_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Based on Actual
		acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update acSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Actual_Initiation_Signature__c.addDays(120).addDays(7));
		//compare Actual_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

        //Changed-Circumstances Review
        ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
        update ccSeg;
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(180).addDays(7));
		//compare Calculated_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//Based on Actual
		ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(180).addDays(7));
		
		Test.stopTest();
		//compare Actual_Initiation_Signature__c + Prelim_Extension__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Preliminary_Signature__c);
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
		clearFormal();
		System.assertEquals(null,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//Expedited Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//Anti-Circumvention Review
		acSeg.Type_of_Circumvention_Inquiry__c = 'Later-Developed Merchandise';
		update acSeg;
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: acSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//Changed-Circumstances Review
		ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
		update ccSeg;
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Preliminary_Signature__c.addDays(-21));
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
	}

	//setCalculatedFinalSignature for the Administrative Review
	@isTest static void setCalculatedFinalSignatureAdminReview(){
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
		setFR(adminSeg.Id, 'Preliminary');
		update adminSeg;
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(prelimFR.Published_Date__c.addDays(120).addDays(7));
		//compare prelimFR.Published_Date__c + Final_Extension_of_days__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedFinalSignature for the New Shipper Review
	@isTest static void setCalculatedFinalSignatureNewShipperReview(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

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
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedFinalSignature for the Scope Inquiry
	@isTest static void setCalculatedFinalSignatureScopeInquiry(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Scope Inquiry
		//Based on Formal
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(120).addDays(7));
		//compare Actual_Date_of_Decision_on_HoP__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Not Formal
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(siSeg.Actual_Date_of_Decision_on_HoP__c.addDays(120).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Calculated_Final_Signature__c);
		clearFormal();

		Test.stopTest();
		System.assertEquals(null,
			[SELECT Id, Final_Extension_of_days__c, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Final_Extension_of_days__c);
	}

	//setCalculatedFinalSignature for the Expedited Review
	@isTest static void setCalculatedFinalSignatureExpeditedReview(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Expedited Review
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Preliminary_Signature__c.addDays(90).addDays(7));
		//compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Actual
		expedSeg.Actual_Preliminary_Signature__c = expedSeg.Calculated_Preliminary_Signature__c.addDays(-14);
		update expedSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Actual_Preliminary_Signature__c.addDays(90).addDays(7));
		//compare Actual_Preliminary_Signature__c + Final_Extension_of_days__c
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedFinalSignature for the Anti Circumvention Review
	@isTest static void setCalculatedFinalSignatureAntiCircumventionReview(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Anti_circumvention Review
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Initiation_Signature__c.addDays(300).addDays(7));
		//compare Calculated_Preliminary_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Actual
		acSeg.Actual_Initiation_Signature__c = acSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update acSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Actual_Initiation_Signature__c.addDays(300).addDays(7));
		//compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedFinalSignature for the Changed-Circumstances Review
	@isTest static void setCalculatedFinalSignatureChangedCircumstancesReview(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Changed-Circumstances Review
		//Based on Calculated
		ccSeg.Is_This_Review_Expedited__c = 'Yes';
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(45).addDays(7));
		//compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//Based on Actual
		ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(45).addDays(7));
		//compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);	

		ccSeg.Is_This_Review_Expedited__c ='No';
		ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
		ccSeg.Actual_Initiation_Signature__c = null;
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(45).addDays(7));
		//compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);	

		ccSeg.All_parties_in_agreement_to_the_outcome__c = 'No';
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Initiation_Signature__c.addDays(270).addDays(7));
		//compare Calculated_Initiation_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);	

		ccSeg.Actual_Initiation_Signature__c = ccSeg.Calculated_Initiation_Signature__c.addDays(-14);
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(270).addDays(7));
		//compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);	

		ccSeg.All_parties_in_agreement_to_the_outcome__c = 'Yes';
		update ccSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Actual_Initiation_Signature__c.addDays(45).addDays(7));
		//compare Actual_Initiation_Signature__c + Final_Extension_of_days__c
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	//setCalculatedFinalSignature for the Sunset Review
	@isTest static void setCalculatedFinalSignatureSunsetReview(){
		Test.startTest();
		
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();
		
		//Sunset Review
		testCalculated = ssSeg.Calculated_Final_Signature__c;
		System.assertEquals(null, testCalculated);//initially null without days set
		setFR(ssSeg.Id, 'Initiation');//create FR needed for calculations

		//90 Days
		ss90();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(90));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//120 Days
		ss120();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(120));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);

		//240 Days
		ss240();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(240).addDays(7).addDays(7));
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Final_Signature__c);
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
		clearFormal();
		System.assertEquals(null,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM Segment__c WHERE Id =: siSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//Expedited Review
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//Anti-Circumvention Review
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: acSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//Changed-Circumstances Review
		//compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Calculated_Final_Signature__c.addDays(-21));
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Segment__c WHERE Id =: ccSeg.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
	}

	//setCalculatedAmendedFinalSignature
	@isTest static void setCalculatedAmendedFinalSignature(){
		Test.startTest();

		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();

		//Administrative Review
		//Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Calculated_Final_Signature__c.addDays(37));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		//Actual
		adminSeg.Actual_Final_Signature__c = adminSeg.Calculated_Final_Signature__c.addDays(-14);
		update adminSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adminSeg.Actual_Final_Signature__c.addDays(37));
		//compare Actual_Final_Signature__c +37 days
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: adminSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//New Shipper Review
		//Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Calculated_Final_Signature__c.addDays(37));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		//Actual
		nsSeg.Actual_Final_Signature__c = nsSeg.Calculated_Final_Signature__c.addDays(-14);
		update nsSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(nsSeg.Actual_Final_Signature__c.addDays(37));
		//compare Actual_Final_Signature__c +37 days
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: nsSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//Expedited Review
		//Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Calculated_Final_Signature__c.addDays(37));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		//Actual
		expedSeg.Actual_Final_Signature__c = expedSeg.Calculated_Final_Signature__c.addDays(-14);
		update expedSeg;
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(expedSeg.Actual_Final_Signature__c.addDays(37));
		//compare Actual_Final_Signature__c +37 days
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM Segment__c WHERE Id =: expedSeg.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
	}

	@isTest static void setNotifyItcIfAffirmPrelimIsDetermine(){
        Test.startTest();

        //setup start dates
        setStartDates();
        getNewSegs();
        //Anti-Circumvention Review
        //based on Calculated_Preliminary_Signature__c
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Calculated_Preliminary_Signature__c.addDays(7));
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_ITC_If_Affirmative_Prelim_Determ__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Notify_ITC_If_Affirmative_Prelim_Determ__c);
        
        //based on Preliminary FR
        setFR(acSeg.Id, 'Preliminary');
        update acSeg;
        getNewSegs();
        testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(prelimFR.Published_Date__c.addDays(2));
        
        Test.stopTest();
        System.assertEquals(testCalculated,
            [SELECT Id, Notify_ITC_If_Affirmative_Prelim_Determ__c FROM Segment__c WHERE Id =: acSeg.Id LIMIT 1].Notify_ITC_If_Affirmative_Prelim_Determ__c);
    }

	@isTest static void setCalculatedInitiationSignature(){
		Test.startTest();

		//New Method. Was unsure what values to put for Application_Accepted__c in Anti-Circumvention and Request_Filed__c in Changed-Circumstances.  I rolled back by a year. Can change if needed/. - TT
		//setup start dates
		setStartDates();
		setExtensions();
		getNewSegs();
		//Anti-Circumvention Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(acSeg.Application_Accepted__c.addDays(45).addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c where Id =: acSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);

		//Changed-Circumstances Review
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ccSeg.Request_Filed__c.addDays(45).addDays(7));
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Initiation_Signature__c FROM Segment__c where Id =: ccSeg.Id LIMIT 1].Calculated_Initiation_Signature__c);
	}
	
	//Sunset Review Fields
	//setCalculatedRevocationOrContinuationFR
	@isTest static void setCalculatedRevocationOrContinuationFR(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'ITC Final');
		getNewSegs();

		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(itcFinalFR.Published_Date__c.addDays(7));
		//compare Calculated_Revocation_or_Continuation_FR__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Revocation_or_Continuation_FR__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Calculated_Revocation_or_Continuation_FR__c);
	}

	//sets Update_ACE_Customs_Module__c for 90 day Sunset Reviews
	@isTest static void setUpdateAceCustomsModule90(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//90 Day Calculations
		ss90();
		getNewSegs();
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Final_Signature__c.addDays(6));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

		//Based on Actual
		ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Final_Signature__c.addDays(6));
		//compare Actual_Final_Signature__c
		System.assertEquals(testActual,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

		//Based on FR
		setFR(ssSeg.Id, 'Final');
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(-1));
		//compare Published_Date__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
	}

	//sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Calculated_Revocation_or_Continuation_FR__c
	@isTest static void setUpdateAceCustomsModuleCalc(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');

		//120 Day Calculations for Calculated_Revocation_or_Continuation_FR__c
		setFR(ssSeg.Id, 'ITC Final');
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(6));
		//compare Calculated_Revocation_or_Continuation_FR__c
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

		//240 Calculations for Calculated_Revocation_or_Continuation_FR__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(6));
		//compare Calculated_Revocation_or_Continuation_FR__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
	}

	//sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Actual_Revocation_or_Continuation_FR__c
	@isTest static void setUpdateAceCustomsModuleActual(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');

		//120 Day Calculations for Actual_Revocation_or_Continuation_FR__c
		setFR(ssSeg.Id, 'ITC Final');
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		ss120();
		getNewSegs();
		ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(6));
		//compare Actual_Revocation_or_Continuation_FR__c
		System.assertEquals(testActual,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

		//240 Calculations for Actual_Revocation_or_Continuation_FR__c
		ss240();
		getNewSegs();
		ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(6));
		//compare Actual_Revocation_or_Continuation_FR__c
		
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
	}

	//sets Update_ACE_Customs_Module__c for 120/240 day Sunset Reviews based on Published_Date__c
	@isTest static void setUpdateAceCustomsModulePublishedDate(){
		Test.startTest();

		//120 Day Calculations for Published_Date__c
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		setFR(o.Id, 'Revocation');
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(-1));
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);

		//240 Day Calculations for Published_Date__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(-1));
		//compare Published_Date__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Update_ACE_Customs_Module__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Update_ACE_Customs_Module__c);
	}

	//sets Issue_Liquidation_Revocation_Instruction__c for 90 day Sunset Reviews
	@isTest static void setIssueLiquidationRevocationInstruction90(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//90 Day Calculations
		ss90();
		getNewSegs();
		//Based on Calculated
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Final_Signature__c.addDays(22));
		//compare Calculated_Final_Signature__c
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

		//Based on Actual
		ssSeg.Actual_Final_Signature__c = ssSeg.Calculated_Final_Signature__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Final_Signature__c.addDays(22));
		//compare Actual_Final_Signature__c
		System.assertEquals(testActual,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

		//Based on FR
		setFR(ssSeg.Id, 'Final');
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(finalFR.Published_Date__c.addDays(15));
		//compare Published_Date__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
	}

	//sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Calculated_Revocation_or_Continuation_FR__c
	@isTest static void setIssueLiquidationRevocationInstructionCalc(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');

		//120 Day Calculations for Calculated_Revocation_or_Continuation_FR__c
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		setFR(ssSeg.Id, 'ITC Final');
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(22));
		//compare Calculated_Revocation_or_Continuation_FR__c
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

		//240 Calculations for Calculated_Revocation_or_Continuation_FR__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(22));
		//compare Calculated_Revocation_or_Continuation_FR__c
				
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
	}

	//sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Actual_Revocation_or_Continuation_FR__c
	@isTest static void setIssueLiquidationRevocationInstructionActual(){
		Test.startTest();

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');

		//120 Day Calculations for Actual_Revocation_or_Continuation_FR__c
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		setFR(ssSeg.Id, 'ITC Final');
		ss120();
		getNewSegs();
		
		ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(22));
		//compare Actual_Revocation_or_Continuation_FR__c
		System.assertEquals(testActual,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

		//240 Calculations for Actual_Revocation_or_Continuation_FR__c
		ss240();
		getNewSegs();
		ssSeg.Actual_Revocation_or_Continuation_FR__c = ssSeg.Calculated_Revocation_or_Continuation_FR__c.addDays(-14);
		update ssSeg;
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Actual_Revocation_or_Continuation_FR__c.addDays(22));
		//compare Actual_Revocation_or_Continuation_FR__c
				
		Test.stopTest();
		System.assertEquals(testActual,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
	}

	//sets Issue_Liquidation_Revocation_Instruction__c for 120/240 day Sunset Reviews based on Published_Date__c
	@isTest static void setIssueLiquidationRevocationInstructionPublished(){
		Test.startTest();

		//120 Day Calculations for Published_Date__c
		ssSeg.Continuation_or_Revocation__c = 'Revocation';
		setFR(o.Id, 'Revocation');
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(15));
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);

		//240 Day Calculations for Published_Date__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(revoFR.Published_Date__c.addDays(15));
		//compare Published_Date__c
		
		Test.stopTest();
		System.assertEquals(testCalculated,
			[SELECT Id, Issue_Liquidation_Revocation_Instruction__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Issue_Liquidation_Revocation_Instruction__c);
	}

	//sets Rebuttal_Comments_Due__c
	@isTest static void setRebuttalCommentsDue(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//120 Day Calculations for Published_Date__c
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(35));
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);

		//240 Day Calculations for Published_Date__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(35));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Rebuttal_Comments_Due__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Rebuttal_Comments_Due__c);
	}

	//sets Adequacy_Determination_Letter_120_day__c or Adequacy_Determination_Letter_240_day__c
	@isTest static void setAdequacyDeterminationandLetterToITC(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Adequacy_Determination_Letter_120_day__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_120_day__c);
		System.assertEquals(null,
			[SELECT Id, Adequacy_Determination_Letter_240_day__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_240_day__c);
		
		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//120 Day Calculations for Published_Date__c
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(50));
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Adequacy_Determination_Letter_120_day__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_120_day__c);

		//240 Day Calculations for Published_Date__c
		ss240();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(50));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Adequacy_Determination_Letter_240_day__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Adequacy_Determination_Letter_240_day__c);
	}

	//sets Comments_on_Adequacy_Determination_Filed__c
	@isTest static void setCommentsOnAdequacyDeterminationFiled(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Comments_on_Adequacy_Determination_Filed__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Comments_on_Adequacy_Determination_Filed__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//120 Day Calculations for Published_Date__c
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(70));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Comments_on_Adequacy_Determination_Filed__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Comments_on_Adequacy_Determination_Filed__c);
	}

	//sets Memorandum_on_Adequacy_Determination__c
	@isTest static void setMemorandumOnAdequacyDetermination(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Memorandum_on_Adequacy_Determination__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Memorandum_on_Adequacy_Determination__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//120 Day Calculations for Published_Date__c
		ss120();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(110));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Memorandum_on_Adequacy_Determination__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Memorandum_on_Adequacy_Determination__c);
	}

	//sets Notify_ITC_of_No_Domestic_Interest__c
	@isTest static void setNotifyItcOfNoDomesticInterest(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Notify_ITC_of_No_Domestic_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_ITC_of_No_Domestic_Interest__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//90 Day Calculations for Published_Date__c
		ss90();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(20));

		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Notify_ITC_of_No_Domestic_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_ITC_of_No_Domestic_Interest__c);
	}

	//sets Inadequate_Domestic_Response_note_to_ITC__c
	@isTest static void setInadequateDomesticResponseNoteToITC(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Inadequate_Domestic_Response_note_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inadequate_Domestic_Response_note_to_ITC__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//90 Day Calculations for Published_Date__c
		ss90();
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(40));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Inadequate_Domestic_Response_note_to_ITC__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inadequate_Domestic_Response_note_to_ITC__c);
	}

	//sets Notice_of_Intent_to_Participate__c
	@isTest static void setNoticeOfIntentToParticipate(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Notice_of_Intent_to_Participate__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notice_of_Intent_to_Participate__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(15));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Notice_of_Intent_to_Participate__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notice_of_Intent_to_Participate__c);
	}

	//sets Notify_Cluster_Coordinator_No_Interest__c
	@isTest static void setNotifyClusterCoordinatorNoInterest(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Notify_Cluster_Coordinator_No_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_Cluster_Coordinator_No_Interest__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Notice_of_Intent_to_Participate__c.addDays(1));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Notify_Cluster_Coordinator_No_Interest__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Notify_Cluster_Coordinator_No_Interest__c);
	}

	//sets Substantive_Response_Due_For_All_Parties__c
	@isTest static void setSubstantiveResponseDueForAllParties(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Substantive_Response_Due_For_All_Parties__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Substantive_Response_Due_For_All_Parties__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(initFR.Published_Date__c.addDays(30));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Substantive_Response_Due_For_All_Parties__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Substantive_Response_Due_For_All_Parties__c);
	}

	//sets Inform_Cluster_Coordinator_if_No_Respons__c
	@isTest static void setInformClusterCoordinatorIfNoRespons(){
		Test.startTest();

		//date should not be set unless there is an Initial FR published date
		System.assertEquals(null,
			[SELECT Id, Inform_Cluster_Coordinator_if_No_Respons__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inform_Cluster_Coordinator_if_No_Respons__c);

		//setup start dates
		setFR(ssSeg.Id, 'Initiation');
		//Same Day Calculations for 90, 120, and 240 for Published_Date__c...this is "Review Information" in VFP
		getNewSegs();
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(ssSeg.Substantive_Response_Due_For_All_Parties__c.addDays(1));
		
		Test.stopTest();
		//compare Published_Date__c
		System.assertEquals(testCalculated,
			[SELECT Id, Inform_Cluster_Coordinator_if_No_Respons__c FROM Segment__c WHERE Id =: ssSeg.Id LIMIT 1].Inform_Cluster_Coordinator_if_No_Respons__c);
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
		}
	}

	private static void setStartDates() {
		List<Segment__c> segsToUpdate = new List<Segment__c>();
		//ACR
		acSeg.Application_Accepted__c = segmentDate;
		segsToUpdate.add(acSeg);
		//AR
		adminSeg.Final_Date_of_Anniversary_Month__c = segmentDate;
		adminSeg.Will_you_Amend_the_Final__c = 'Yes';
		segsToUpdate.add(adminSeg);
		//CCR
		ccSeg.Request_Filed__c = segmentDate;
		segsToUpdate.add(ccSeg);
		//ER
		expedSeg.Calculated_Initiation_Signature__c = segmentDate;
		expedSeg.Will_you_Amend_the_Final__c = 'Yes';
		segsToUpdate.add(expedSeg);
		//NSR
		nsSeg.Calculated_Initiation_Signature__c = segmentDate;
		nsSeg.Will_you_Amend_the_Final__c = 'Yes';
		segsToUpdate.add(nsSeg);
		//SI
		siSeg.Request_Filed__c = segmentDate;
		siSeg.Actual_Date_of_Decision_on_HoP__c = segmentDate.addDays(21);
		siSeg.Decision_on_How_to_Proceed__c = 'Formal';
		siSeg.Will_you_Amend_the_Final__c = 'Yes';
		segsToUpdate.add(siSeg);

		update segsToUpdate;
	}

	private static void setExtensions() {
		List<Segment__c> segsToUpdate = new List<Segment__c>();
		//ACR
		acSeg.Initiation_Extension_of_days__c = acSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
		acSeg.Prelim_Extension__c = acSeg.Prelim_Extension__c == null ? 7 : 7;
		acSeg.Final_Extension_of_days__c = adminSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(acSeg);
		//AR
		adminSeg.Prelim_Extension__c = adminSeg.Prelim_Extension__c == null ? 7 : 7;
		adminSeg.Final_Extension_of_days__c = adminSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(adminSeg);
		//CCR
		ccSeg.Initiation_Extension_of_days__c = ccSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
		ccSeg.Prelim_Extension__c = ccSeg.Prelim_Extension__c == null ? 7 : 7;
		ccSeg.Final_Extension_of_days__c = ccSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(ccSeg);
		//ER
		expedSeg.Prelim_Extension__c = expedSeg.Prelim_Extension__c == null ? 7 : 7;
		expedSeg.Final_Extension_of_days__c = expedSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(expedSeg);
		//NSR
		nsSeg.Prelim_Extension__c = nsSeg.Prelim_Extension__c == null ? 7 : 7;
		nsSeg.Final_Extension_of_days__c = nsSeg.Final_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(nsSeg);
		//SI
		siSeg.Prelim_Extension__c = siSeg.Prelim_Extension__c == null ? 7 : 7;
		siSeg.Final_Extension_of_days__c = siSeg.Final_Extension_of_days__c == null ? 7 : 7;
		siSeg.Initiation_Extension_of_days__c = siSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(siSeg);
		//SSR
		ssSeg.Prelim_Extension__c = ssSeg.Prelim_Extension__c == null ? 7 : 7;
		ssSeg.Final_Extension_of_days__c = ssSeg.Final_Extension_of_days__c == null ? 7 : 7;
		ssSeg.Initiation_Extension_of_days__c = ssSeg.Initiation_Extension_of_days__c == null ? 7 : 7;
		segsToUpdate.add(ssSeg);

		update segsToUpdate;
	}

	private static void clearFormal() {
		siSeg.Decision_on_How_to_Proceed__c = '';
		siSeg.Prelim_Extension__c = siSeg.Prelim_Extension__c = null;
		siSeg.Final_Extension_of_days__c = siSeg.Final_Extension_of_days__c = null;
		siSeg.Initiation_Extension_of_days__c = siSeg.Initiation_Extension_of_days__c = null;
		update siSeg;
	}

	private static void setFR(Id parentId, String frType) {
		String parentName = 'Segment__c';
		if (frType == 'Revocation') {
			parentName = 'ADCVD_Order__c';
		}
		Federal_Register__c testFR = TestUtils.createFR(parentId, parentName, segmentDate.addDays(120), frType, true);
	}

	private static void getNewSegs() {
		adminSeg = null;
		nsSeg = null;
		siSeg = null;
		expedSeg = null;
		acSeg = null;
		ccSeg = null;
		ssSeg = null;
	}

	private static void ss90() {
		ssSeg.Notice_of_intent_to_participate_Ips__c = 'No';
		ssSeg.Domestic_Party_File_Substan_Response__c = 'No';
		ssSeg.Review_to_address_zeroing_in_Segments__c = '';
		ssSeg.Respondent_File_Substantive_Response__c = '';
		ssSeg.Adequacy_of_Respondents_Submission__c = '';
		update ssSeg;
	}

	private static void ss120() {
		ssSeg.Notice_of_intent_to_participate_Ips__c = 'Yes';
		ssSeg.Domestic_Party_File_Substan_Response__c = 'Yes';
		ssSeg.Review_to_address_zeroing_in_Segments__c = 'No';
		ssSeg.Respondent_File_Substantive_Response__c = 'No';
		ssSeg.Adequacy_of_Respondents_Submission__c = 'Inadequate or Non-Substantive';
		update ssSeg;
	}

	private static void ss240() {
		ssSeg.Notice_of_intent_to_participate_Ips__c = 'Yes';
		ssSeg.Domestic_Party_File_Substan_Response__c = 'Yes';
		ssSeg.Review_to_address_zeroing_in_Segments__c = 'Yes';
		ssSeg.Respondent_File_Substantive_Response__c = 'Yes';
		ssSeg.Adequacy_of_Respondents_Submission__c = 'Adequate or Substantive';
		update ssSeg;
	}

}