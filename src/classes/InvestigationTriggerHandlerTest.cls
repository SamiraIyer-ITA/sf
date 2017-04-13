@isTest
public class InvestigationTriggerHandlerTest {
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
							Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c 
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
							Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c 
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
							Calculated_ITC_Final_FR_Published__c, Estimated_Order_FR_Published__c, Calculated_Prelim_Extension_Request_File__c 
						FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
			}
			return iCVD;
		}	
	}
	private static Federal_Register__c adFR {
		get {
			if(adFR == null) {
				adFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iAD.Id LIMIT 1];
			}
			return adFR;
		}
	}
	private static Federal_Register__c cvdFR {
		get {
			if(cvdFR == null) {
				cvdFR = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c WHERE Investigation__c =: iCVD.Id LIMIT 1];
			}
			return cvdFR;
		}
	}
	private static Petition__c adP{
		get{
			if (adP == null) {
				adP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c WHERE Case_Type__c LIKE 'AD%' LIMIT 1];
			}
			return adP;
		}
	}
	private static Petition__c cvdP{
		get{
			if (cvdP == null) {
				cvdP = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c WHERE Case_Type__c LIKE 'CVD%' LIMIT 1];
			}
			return cvdP;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		InvestigationTriggerHandler.initialize(iList, null);
		System.assertEquals(adP.Id, InvestigationTriggerHandler.petitionsInScopeMap.get(adP.Id).Id);
		System.assertEquals('AD', InvestigationTriggerHandler.recordTypeNameMap.get(iAD.RecordTypeId));
	}

	//setCalculatedPreliminarySignature
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//adP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(140));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//AD based on Actual
		adP.Actual_Initiation_Signature__c = adP.Calculated_Initiation_Signature__c.addDays(-14);//set adP.Actual_Initiation_Signature__c
		iAD.Prelim_Extension_of_days__c = iAD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and test avoiding an NPE in this test
		update adP;//update adP
		update iAD;//update iAD, adds Prelim_Extension_of_days__c
		//adP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Actual_Initiation_Signature__c.addDays(140).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//CVD investigation
		//CVD based on calculated
		cvdP.Actual_Initiation_Signature__c = null;
		update cvdP;//reset for CVD logic
		//cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(65));
		System.assertEquals(testCalculated, 
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//CVD based on actual
		cvdP.Actual_Initiation_Signature__c = cvdP.Calculated_Initiation_Signature__c.addDays(-14);//set cvdP.Actual_Initiation_Signature__c
		iCVD.Prelim_Extension_of_days__c = iCVD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and test avoiding an NPE in this test
		update cvdP;//update cvdP
		update iCVD;//update iCVD, adds Prelim_Extension_of_days__c
		//cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(65).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Preliminary_Signature__c);
		Test.stopTest();
	}

	//setCalcAmendedPrelimDeterminationSig
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalcAmendedPrelimDeterminationSig(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		System.assertNotEquals(null, iAD.Calc_Amended_Prelim_Determination_Sig__c);
		iAD.Amend_the_Preliminary_Determination__c = 'No';
		update iAD;
		System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
		iAD.Amend_the_Preliminary_Determination__c = 'Yes';
		update iAD;
		iAD = null;//trigger a new query to database
		//iAD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(31));
		System.assertEquals(testCalculated,
			[SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

		//AD based on Actual
		iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);//set iAD.Actual_Preliminary_Signature__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.Actual_Preliminary_Signature__c is set, so compare iAD.Actual_Preliminary_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Preliminary_Signature__c.addDays(31));
		System.assertEquals(testActual,
			[SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

		//CVD investigation
		//CVD based on calculated
		System.assertNotEquals(null, iCVD.Calc_Amended_Prelim_Determination_Sig__c);
		iCVD.Amend_the_Preliminary_Determination__c = 'No';
		update iCVD;
		System.assertEquals(null, [SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
		iCVD.Amend_the_Preliminary_Determination__c = 'Yes';
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(31));
		System.assertEquals(testCalculated,
			[SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);

		//CVD based on Actual
		iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);//set iCVD.Actual_Preliminary_Signature__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Preliminary_Signature__c.addDays(31));
		System.assertEquals(testActual,
			[SELECT Id, Calc_Amended_Prelim_Determination_Sig__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calc_Amended_Prelim_Determination_Sig__c);
		Test.stopTest();
	}
	//setPrelimTeamMeetingDeadline
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setPrelimTeamMeetingDeadline(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Prelim_Team_Meeting_Deadline__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Prelim_Team_Meeting_Deadline__c);
		Test.stopTest();
	}
	//setCalculatedFinalSignature
	//Test has 7 parts: AD Calculated, AD Actual, CVD Calculated, CVD Actual, AD FR Published Date, CVD Aligned to AD, CVD stays Aligned on AD update
	@isTest static void setCalculatedFinalSignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.Actual_Preliminary_Signature__c is null, and iAD.Final_Extension_of_days__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Preliminary_Signature__c.addDays(75));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Final_Signature__c);

		//AD based on Actual
		iAD.Actual_Preliminary_Signature__c = iAD.Calculated_Preliminary_Signature__c.addDays(-14);//set iAD.Actual_Preliminary_Signature__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.Actual_Preliminary_Signature__c is set, so compare iAD.Actual_Preliminary_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Preliminary_Signature__c.addDays(75));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.Actual_Preliminary_Signature__c is null, so compare Calculated_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Preliminary_Signature__c.addDays(75));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD based on Actual
		iCVD.Actual_Preliminary_Signature__c = iCVD.Calculated_Preliminary_Signature__c.addDays(-14);//set iCVD.Actual_Preliminary_Signature__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Preliminary_Signature__c.addDays(75));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);

		//AD based on FR Published_Date__c with Type__c Preliminary
		iAD.Final_Extension_of_days__c = 1;
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//adFR.Published_Date__c is set, so compare adFR.Published_Date__c + iAD.Final_Extension_of_days__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adFR.Published_Date__c.addDays(75).addDays(1));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//compare alignment to iAD.Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c);
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD stays Aligned
		iAD.Final_Extension_of_days__c = 60;
		update iAD;
		iAD = null;//trigger a new query to database
		iCVD = null;//trigger a new query to database
		//compare alignment to iAD.Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c);
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);
	}
	//setCalculatedAmendedFinalSignature
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedAmendedFinalSignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		System.assertNotEquals(null, iAD.Calculated_Amended_Final_Signature__c);
		iAD.Will_you_Amend_the_Final__c = 'No';
		update iAD;
		System.assertEquals(null, [SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		iAD.Will_you_Amend_the_Final__c = 'Yes';
		update iAD;
		iAD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c.addDays(31));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//AD based on Actual
		iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(-14);//set iAD.Actual_Final_Signature__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is set, so compare iAD.Actual_Final_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Final_Signature__c.addDays(31));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//CVD investigation
		//CVD based on calculated
		System.assertNotEquals(null, iCVD.Calculated_Amended_Final_Signature__c);
		iCVD.Will_you_Amend_the_Final__c = 'No';
		update iCVD;
		System.assertEquals(null, [SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		iCVD.Will_you_Amend_the_Final__c = 'Yes';
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Final_Signature__c.addDays(31));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//CVD based on Actual
		iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c.addDays(-14);//set iCVD.Actual_Final_Signature__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Final_Signature__c is set, so compare iCVD.Actual_Final_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Final_Signature__c.addDays(31));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is set, so compare alignment to iAD.Actual_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Final_Signature__c.addDays(31));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Amended_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Amended_Final_Signature__c);
		Test.stopTest();
	}
	//setPrelimTeamMeetingDeadline
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setFinalTeamMeetingDeadline(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Final_Team_Meeting_Deadline__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is null, so compare alignment to iAD.Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c.addDays(-21));
		System.assertEquals(testCalculated,
			[SELECT Id, Final_Team_Meeting_Deadline__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Final_Team_Meeting_Deadline__c);
		Test.stopTest();
	}
	//setEstITCNotificationtoDOCofFinalDet
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setEstITCNotificationtoDOCofFinalDet(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c.addDays(45));
		System.assertEquals(testCalculated,
			[SELECT Id, Est_ITC_Notification_to_DOC_of_Final_Det__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Est_ITC_Notification_to_DOC_of_Final_Det__c);

		//AD based on Actual
		iAD.Actual_Final_Signature__c = iAD.Calculated_Final_Signature__c.addDays(-14);//set iAD.Actual_Final_Signature__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is set, so compare iAD.Actual_Final_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Final_Signature__c.addDays(45));
		System.assertEquals(testActual,
			[SELECT Id, Est_ITC_Notification_to_DOC_of_Final_Det__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Est_ITC_Notification_to_DOC_of_Final_Det__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.Actual_Final_Signature__c is null, so compare Calculated_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Calculated_Final_Signature__c.addDays(45));
		System.assertEquals(testCalculated,
			[SELECT Id, Est_ITC_Notification_to_DOC_of_Final_Det__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Est_ITC_Notification_to_DOC_of_Final_Det__c);

		//CVD based on Actual
		iCVD.Actual_Final_Signature__c = iCVD.Calculated_Final_Signature__c.addDays(-14);//set iCVD.Actual_Final_Signature__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Final_Signature__c is set, so compare iCVD.Actual_Final_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Actual_Final_Signature__c.addDays(45));
		System.assertEquals(testActual,
			[SELECT Id, Est_ITC_Notification_to_DOC_of_Final_Det__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Est_ITC_Notification_to_DOC_of_Final_Det__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.Actual_Final_Signature__c is set, so compare alignment to iAD.Actual_Final_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Actual_Final_Signature__c.addDays(45));
		System.assertEquals(testCalculated,
			[SELECT Id, Est_ITC_Notification_to_DOC_of_Final_Det__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Est_ITC_Notification_to_DOC_of_Final_Det__c);
		Test.stopTest();
	}
	//setCalculatedOrderFRSignature
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedOrderFRSignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(3));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Order_FR_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Order_FR_Signature__c);

		//AD based on Actual
		iAD.ITC_Notification_to_DOC_of_Final_Determ__c = iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(3));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Order_FR_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Order_FR_Signature__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(3));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Order_FR_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Order_FR_Signature__c);

		//CVD based on Actual
		iCVD.ITC_Notification_to_DOC_of_Final_Determ__c = iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(3));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Order_FR_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Order_FR_Signature__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(3));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Order_FR_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Order_FR_Signature__c);
		Test.stopTest();
	}
	//setCalculatedITCFinalFRPublished
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedITCFinalFRPublished(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(5));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_ITC_Final_FR_Published__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_ITC_Final_FR_Published__c);

		//AD based on Actual
		iAD.ITC_Notification_to_DOC_of_Final_Determ__c = iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(5));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_ITC_Final_FR_Published__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_ITC_Final_FR_Published__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(5));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_ITC_Final_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_ITC_Final_FR_Published__c);

		//CVD based on Actual
		iCVD.ITC_Notification_to_DOC_of_Final_Determ__c = iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(5));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_ITC_Final_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_ITC_Final_FR_Published__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(5));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_ITC_Final_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_ITC_Final_FR_Published__c);
		Test.stopTest();
	}
	//setEstimatedOrderFRPublished
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setEstimatedOrderFRPublished(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Estimated_Order_FR_Published__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Estimated_Order_FR_Published__c);

		//AD based on Actual
		iAD.ITC_Notification_to_DOC_of_Final_Determ__c = iAD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Estimated_Order_FR_Published__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Estimated_Order_FR_Published__c);

		//CVD investigation
		//CVD based on calculated
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is null, so compare Est_ITC_Notification_to_DOC_of_Final_Det__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Estimated_Order_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Estimated_Order_FR_Published__c);

		//CVD based on Actual
		iCVD.ITC_Notification_to_DOC_of_Final_Determ__c = iCVD.Est_ITC_Notification_to_DOC_of_Final_Det__c.addDays(-14);//set iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		update iCVD;//calculate based on actual
		iCVD = null;//trigger a new query to database
		//iCVD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iCVD.ITC_Notification_to_DOC_of_Final_Determ__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iCVD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Estimated_Order_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Estimated_Order_FR_Published__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iAD.ITC_Notification_to_DOC_of_Final_Determ__c is set, so compare iAD.ITC_Notification_to_DOC_of_Final_Determ__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.ITC_Notification_to_DOC_of_Final_Determ__c.addDays(7));
		System.assertEquals(testCalculated,
			[SELECT Id, Estimated_Order_FR_Published__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Estimated_Order_FR_Published__c);
		Test.stopTest();
	}
	//setCalculatedPrelimExtensionRequestFile
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedPrelimExtensionRequestFile(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//adP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(115));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);

		//AD based on Actual
		adP.Actual_Initiation_Signature__c = adP.Calculated_Initiation_Signature__c.addDays(-14);//set adP.Actual_Initiation_Signature__c
		update adP;//update adP
		//adP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Actual_Initiation_Signature__c.addDays(115));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);

		//CVD investigation
		//CVD based on calculated
		cvdP.Actual_Initiation_Signature__c = null;
		update cvdP;//reset for CVD logic
		//cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(40));
		System.assertEquals(testCalculated, 
			[SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);

		//CVD based on actual
		cvdP.Actual_Initiation_Signature__c = cvdP.Calculated_Initiation_Signature__c.addDays(-14);//set cvdP.Actual_Initiation_Signature__c
		update cvdP;//update cvdP
		//cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(40));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Prelim_Extension_Request_File__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Prelim_Extension_Request_File__c);
		Test.stopTest();
	}
	//setCalculatedPostponementOfPrelimDeterFR
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedPostponementOfPrelimDeterFR(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//adP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Calculated_Initiation_Signature__c.addDays(120));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);

		//AD based on Actual
		adP.Actual_Initiation_Signature__c = adP.Calculated_Initiation_Signature__c.addDays(-14);//set adP.Actual_Initiation_Signature__c
		update adP;//update adP
		//adP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Actual_Initiation_Signature__c.addDays(120));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);

		//CVD investigation
		//CVD based on calculated
		cvdP.Actual_Initiation_Signature__c = null;
		update cvdP;//reset for CVD logic
		//cvdP.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Calculated_Initiation_Signature__c.addDays(45));
		System.assertEquals(testCalculated, 
			[SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);

		//CVD based on actual
		cvdP.Actual_Initiation_Signature__c = cvdP.Calculated_Initiation_Signature__c.addDays(-14);//set cvdP.Actual_Initiation_Signature__c
		update cvdP;//update cvdP
		//cvdP.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Actual_Initiation_Signature__c.addDays(45));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Postponement_of_PrelimDeterFR__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Postponement_of_PrelimDeterFR__c);
		Test.stopTest();
	}
	//setCalculatedITCPrelimDetermination
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedITCPrelimDetermination(){
		Test.startTest();
		//AD investigation
		//AD based on Petition_Filed__c
		iAD.Prelim_Extension_of_days__c = iAD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and test avoiding an NPE in this test
		update iAD;//update iAD, adds Prelim_Extension_of_days__c
		//compare Petition_Filed__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adP.Petition_Filed__c.addDays(45).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_ITC_Prelim_Determination__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_ITC_Prelim_Determination__c);

		//CVD investigation
		//CVD based on Petition_Filed__c
		iCVD.Prelim_Extension_of_days__c = iCVD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and test avoiding an NPE in this test
		update iCVD;//update iCVD, adds Prelim_Extension_of_days__c
		//compare Petition_Filed__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdP.Petition_Filed__c.addDays(45).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_ITC_Prelim_Determination__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_ITC_Prelim_Determination__c);
		Test.stopTest();
	}
	//setTerminationofSuspensionGapPeriodBeg
	//Test has 2 parts: AD and CVD
	@isTest static void setTerminationofSuspensionGapPeriodBeg(){
		Test.startTest();
		//AD based on FR Published_Date__c with Type__c Preliminary without Final_Extension_of_days__c
		//adFR.Published_Date__c is set, so compare adFR.Published_Date__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adFR.Published_Date__c.addDays(121));
		System.assertEquals(testCalculated,
			[SELECT Id, Termination_of_Suspension_Gap_Period_Beg__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Termination_of_Suspension_Gap_Period_Beg__c);
		//AD based on FR Published_Date__c with Type__c Preliminary with Final_Extension_of_days__c
		iAD.Final_Extension_of_days__c = 1;
		update iAD;//calculate based on actual
		iAD = null;//trigger a new query to database
		//adFR.Published_Date__c is set, so compare adFR.Published_Date__c + 60 (which is in constant and triggered by existence of Final_Extension_of_days__c)
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(adFR.Published_Date__c.addDays(181));
		System.assertEquals(testCalculated,
			[SELECT Id, Termination_of_Suspension_Gap_Period_Beg__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Termination_of_Suspension_Gap_Period_Beg__c);

		//CVD Investigation
		//CVD based on FR Published_Date__c with Type__c Preliminary (Final_Extension_of_days__c does not matter)
		//cvdFR.Published_Date__c is set, so compare cvdFR.Published_Date__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(cvdFR.Published_Date__c.addDays(121));
		System.assertEquals(testCalculated,
			[SELECT Id, Termination_of_Suspension_Gap_Period_Beg__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Termination_of_Suspension_Gap_Period_Beg__c);
		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testADPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
		Petition__c testCVDPetition = TestUtils.createPetition(petitionDate, 'CVD', true);
		Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testADPetition, true);
		Federal_Register__c testAdFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(210), 'Preliminary', true);
		Investigation__c testCVDinvestigation = TestUtils.createInvestigation('CVD', testCVDPetition, true);
		Federal_Register__c testCvdFR = TestUtils.createFR(testCVDinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(140), 'Preliminary', true);
	}

	private static String attemptInsert(SObject o){
		String error = '';
		try{
			insert o;
			error = 'Success';
		} catch (DmlException e) {
			error = e.getMessage();
		}
		return error;
	}
}