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
			System.debug('User u: ' + u);
			return u;
		}
	}
	private static List<Investigation__c> iList {
		get {
			if(iList == null) {
				iList = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, Calculated_Preliminary_Signature__c, 
							Actual_Preliminary_Signature__c, Calculated_Final_Signature__c, Calc_Amended_Prelim_Determination_Sig__c, Petition__c, 
							Prelim_Team_Meeting_Deadline__c 
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
							Prelim_Team_Meeting_Deadline__c
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
							Prelim_Team_Meeting_Deadline__c
						FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
			}
			return iCVD;
		}	
	}
	private static Federal_Register__c fr {
		get {
			if(fr == null) {
				fr = [SELECT Id, Published_Date__c, Investigation__c, Type__c FROM Federal_Register__c LIMIT 1];
			}
			return fr;
		}
	}
	private static Petition__c p{
		get{
			if (p == null) {
				p = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c LIMIT 1];
			}
			System.System.debug('Petition p: ' + p);
			return p;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		InvestigationTriggerHandler.initialize(iList, null);
		System.assertEquals(p.Id, InvestigationTriggerHandler.petitionsInScopeMap.get(p.Id).Id);
		System.assertEquals('AD', InvestigationTriggerHandler.recordTypeNameMap.get(iAD.RecordTypeId));
	}

	//setCalculatedPreliminarySignature
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		//p.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Calculated_Initiation_Signature__c.addDays(140));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//AD based on Actual
		p.Actual_Initiation_Signature__c = p.Calculated_Initiation_Signature__c.addDays(-14);//set p.Actual_Initiation_Signature__c
		iAD.Prelim_Extension_of_days__c = iAD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and avoid NPE in this test
		update p;//update p
		update iAD;//update iAD, adds Prelim_Extension_of_days__c.  Calling update since this is a future call in org
		//p.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Actual_Initiation_Signature__c.addDays(140).addDays(7));
		System.assertEquals(testActual,
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//CVD investigation
		//CVD based on calculated
		p.Actual_Initiation_Signature__c = null;
		update p;//reset for CVD logic
		//p.Actual_Initiation_Signature__c is null, so compare Calculated_Initiation_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Calculated_Initiation_Signature__c.addDays(65));
		System.assertEquals(testCalculated, 
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Preliminary_Signature__c);

		//CVD based on actual
		p.Actual_Initiation_Signature__c = p.Calculated_Initiation_Signature__c.addDays(-14);//set p.Actual_Initiation_Signature__c
		iCVD.Prelim_Extension_of_days__c = iCVD.Prelim_Extension_of_days__c == null ? 7 : 7;//add Prelim_Extension_of_days__c and avoid NPE in this test
		update p;//update p
		update iCVD;//update iCVD, adds Prelim_Extension_of_days__c. Calling update since this is a future call in org
		//p.Actual_Initiation_Signature__c is set, so compare Actual_Initiation_Signature__c + Prelim_Extension_of_days__c
		testActual = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Actual_Initiation_Signature__c.addDays(65).addDays(7));
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
		//fr.Published_Date__c is set, so compare fr.Published_Date__c + iAD.Final_Extension_of_days__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(fr.Published_Date__c.addDays(75).addDays(1));
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD based on Alignment to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c);
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);

		//CVD stays Aligned
		iAD.Final_Extension_of_days__c = 60;
		update iAD;
		iAD = null;//trigger a new query to database
		iCVD = null;//trigger a new query to database
		//iCVD.Actual_Preliminary_Signature__c is set, so compare iCVD.Actual_Preliminary_Signature__c
		testCalculated = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(iAD.Calculated_Final_Signature__c);
		System.assertEquals(testCalculated,
			[SELECT Id, Calculated_Final_Signature__c FROM  Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c);
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
		Investigation__c testADinvestigation = TestUtils.createInvestigation('AD', testPetition, true);
		Investigation__c testCVDinvestigation = TestUtils.createInvestigation('CVD', testPetition, true);
		Federal_Register__c testAdFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', testPublishedDate.addDays(210), 'Preliminary', true);
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