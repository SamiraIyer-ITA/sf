@isTest
public class InvestigationTriggerHandlerTest {
	private static Date petitionDate = System.today();
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
		Investigation__c i = TestUtils.createInvestigation('AD', p, true);
		List<Investigation__c> iList = new List<Investigation__c>();
		iList.add(i);
		InvestigationTriggerHandler.initialize(iList, null);
		System.assertEquals(p.Id, InvestigationTriggerHandler.petitionsInScopeMap.get(p.Id).Id);
		System.assertEquals('AD', InvestigationTriggerHandler.recordTypeNameMap.get(i.RecordTypeId));
	}

	//setCalculatedPreliminarySignature
	//Test has 2 parts that test two dates each: AD and CVD
	@isTest static void setCalculatedPreliminarySignature(){
		Test.startTest();
		//AD investigation
		//AD based on calculated
		Investigation__c iAD = TestUtils.createInvestigation('AD', p, true);
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
		Investigation__c iCVD = TestUtils.createInvestigation('CVD', p, true);
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

	//basic framework for tests that also test alignment
	//Test has 2 parts that test 2 dates each and 3rd part that tests alignment
/*	@isTest static void setCalculatedFinalSignature() {
		Test.startTest();
		//AD Investigation
		//AD based on calculated
		


		//CVD Investigation
		//CVD based on actual



		//CVD aligned to AD
		iCVD.AD_Investigation_Aligned_To__c = iAD.Id;
		update iCVD;
		System.assertEquals([SELECT Calculated_Final_Signature__c FROM Investigation__c WHERE Id =: iAD.Id LIMIT 1].Calculated_Final_Signature__c,
							[SELECT Calculated_Final_Signature__c FROM Investigation__c WHERE Id =: iCVD.Id LIMIT 1].Calculated_Final_Signature__c)
	}
*/
	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
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