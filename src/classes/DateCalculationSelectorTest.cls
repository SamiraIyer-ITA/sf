@isTest
public class DateCalculationSelectorTest {
	private static FINAL Integer COUNT = 1;

	private static List<Investigation__c> invList {
		get {
			if (invList == null) {
				invList = new List<Investigation__c>();
				String query = Utils.soqlBuilderAllFields('Investigation__c', true);
				invList = database.query(query);
			}
			return invList;
		}
	}

	@isTest static void getFrDateMap() {
		Test.startTest();
		Map<String,Date> testMap = DateCalculationSelector.getFrDateMap(invList);
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}

	@isTest static void getFrUtilMap() {
		Test.startTest();
		Map<Id, ADCVD_FederalRegisterUtility> testMap = DateCalculationSelector.getFrUtilMap(invList);
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}

	@isTest static void getPetitionsInScope() {
		Test.startTest();
		Map<Id,Petition__c> testMap = DateCalculationSelector.getPetitionsInScope(invList, 'Investigation__c', 'Petition__c');
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}

	@isTest static void getIssuesInScope() {
		Test.startTest();
		Map<Id,Issue__c> testMap = DateCalculationSelector.getIssuesInScope(invList, 'Investigation__c', 'Investigation__c');
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}

	@isTest static void getCompletedIssuesInScope() {
		Test.startTest();
		Map<Id,Issue__c> testMap = DateCalculationSelector.getCompletedIssuesInScope(invList, 'Investigation__c', 'Investigation__c');
		Test.stopTest();
		System.assertEquals(0, testMap.size());
	}

	@isTest static void getCompletedIssues() {
		Test.startTest();
		Map<Id,Map<String,Boolean>> testMap = DateCalculationSelector.getCompletedIssues(invList, 'Investigation__c');
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}

	@isTest static void getDateCalculationsMap() {
		Test.startTest();
		Map<String,Date_Calculation__mdt> testMap = DateCalculationSelector.getDateCalculationsMap('Investigation__c', 'AD');
		Test.stopTest();
		System.assertNotEquals(0, testMap.size());
	}


	@testSetup static void dataSetup() {
		Date petitionDate = System.today();
		List<User> uList = new List<User>();
		List<Petition__c> pList = new List<Petition__c>();
		List<Investigation__c> iList = new List<Investigation__c>();
		List<Issue__c> isList = new List<Issue__c>();
		List<Federal_Register__c> frList = new List<Federal_Register__c>();
		for (Integer i = 0; i < COUNT; i++) {
			User testUser = TestUtils.createAdminUser(false, 'myemail@email.com.testita', i);
			uList.add(testUser);
			Petition__c testADPetition = TestUtils.createPetition(petitionDate.addDays(i), 'AD ME', false);
			pList.add(testADPetition);
			Petition__c testCVDPetition = TestUtils.createPetition(petitionDate.addDays(7+i), 'CVD', false);
			pList.add(testCVDPetition);
		}
		insert uList;
		insert pList;
		for (Petition__c p : pList) {
			Investigation__c testInvestigation = TestUtils.createInvestigation('', p, false);
			iList.add(testInvestigation);
			Issue__c initIssue = TestUtils.createIssue(p.Id, 'Petition__c', 'Initiation', false);
			isList.add(initIssue);
			Federal_Register__c initFR = TestUtils.createFR(p.Id, 'Petition__c', petitionDate.addDays(120), 'Initiation', false);
			frList.add(initFR);
		}
		insert iList;
		for (Investigation__c i : iList) {
			Issue__c prelimIssue = TestUtils.createIssue(i.Id, 'Investigation__c', 'Preliminary', false);
			isList.add(prelimIssue);
			Issue__c amendPrelimIssue = TestUtils.createIssue(i.Id, 'Investigation__c', 'Amended Preliminary', false);
			isList.add(amendPrelimIssue);
			Issue__c finalIssue = TestUtils.createIssue(i.Id, 'Investigation__c', 'Final', false);
			isList.add(finalIssue);
			Issue__c amendedFinalIssue = TestUtils.createIssue(i.Id, 'Investigation__c', 'Amended Final', false);
			isList.add(amendedFinalIssue);
			Federal_Register__c prelimFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Preliminary', false);
			frList.add(prelimFR);
			Federal_Register__c finalFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Final', false);
			frList.add(finalFR);
		}
		insert isList;
		insert frList;
	}
}