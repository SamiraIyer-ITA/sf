@isTest
public class SuspensionAgreementTriggerHandlerTest {
	private static Date suspDate = System.today();
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
	private static Suspension_Agreement__c sa{
		get{
			if (sa == null) {
				sa = [SELECT Id, Suspension_Date__c, Investigation__c, Office_Assignment__c, Anniversary_Month__c,
							 Next_Sunset_Initiation_Date__c, Termination_Date__c 
					 FROM Suspension_Agreement__c LIMIT 1];
			}
			return sa;
		}
	}
	private static Federal_Register__c suspensionAgreementFR{
		get{
			if (suspensionAgreementFR == null) {
				suspensionAgreementFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Suspension Agreement' LIMIT 1];
			}
			return suspensionAgreementFR;
		}
	}
	private static Federal_Register__c continuationFR{
		get{
			if (continuationFR == null) {
				continuationFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Continuation' LIMIT 1];
			}
			return continuationFR;
		}
	}
	private static Federal_Register__c termFR{
		get{
			if (termFR == null) {
				termFR = [SELECT Id, Suspension_Agreement__c, Type__c, Published_Date__c FROM Federal_Register__c WHERE Type__c =: 'Termination' LIMIT 1];
			}
			return termFR;
		}
	}

	@isTest static void initialize(){
		Test.startTest();
		List<Suspension_Agreement__c> aList = new List<Suspension_Agreement__c>();
		aList.add(sa);
		SuspensionAgreementTriggerHandler.initialize(aList, null);
		System.assert(SuspensionAgreementTriggerHandler.frUtilMap.isEmpty());
		Test.stopTest();
	}

	
	@isTest static void setAnniversaryMonth() {
		Test.startTest();
		testCalculated = suspDate.toStartOfMonth().addYears(4).addMonths(11);
        Datetime dt = Datetime.newInstance(testCalculated, null);
		String month = dt.format('MMMMM');
		Test.stopTest();
		System.assertEquals(month, sa.Anniversary_Month__c);
	}

	@isTest static void setNextSunsetInitiationDate() {
		Test.startTest();
		System.assertEquals(null, sa.Next_Sunset_Initiation_Date__c); 
		setFR(sa.Id, 'Suspension Agreement'); 
		sa = null;
		testCalculated = suspDate.toStartOfMonth().addYears(4).addMonths(11);
		System.assertEquals(testCalculated, sa.Next_Sunset_Initiation_Date__c);
		suspDate = suspDate.addMonths(1);
		setFR(sa.Id, 'Continuation');
		sa = null;
		testCalculated = suspDate.toStartOfMonth().addYears(4).addMonths(11);
		System.assertEquals(testCalculated, sa.Next_Sunset_Initiation_Date__c);
		suspDate = suspDate.addMonths(1);
		setFR(sa.Id, 'Termination');
		sa = null;
		System.assertEquals(null, sa.Next_Sunset_Initiation_Date__c);
		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPet = TestUtils.createPetition(suspDate.addDays(-14),'AD ME', true);
		Investigation__c testInv = TestUtils.createInvestigation('AD', testPet, true);
		Suspension_Agreement__c testSuspAgr = TestUtils.createSuspensionAgreement(testInv, suspDate, true);
		List<Segment__c> segsToInsert = new List<Segment__c>();
		System.runAs(testUser) {
			for(String segRecordTypeName : utils.getRecordTypeDeveloperNameMap('Segment__c').values()) {
				Segment__c testSeg = TestUtils.createSegment(testSuspAgr, segRecordTypeName, false);
				segsToInsert.add(testSeg);
			}
			insert segsToInsert;
		}
	}

	private static void setFR(Id parentId, String frType) {
		Federal_Register__c testFR = new Federal_Register__c();
		testFR.Suspension_Agreement__c = parentId;
		testFR.Type__c = frType;
		testFR.Published_Date__c = suspDate;
		insert testFR;
	}
}