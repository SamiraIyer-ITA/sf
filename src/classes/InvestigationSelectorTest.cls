@isTest
public class InvestigationSelectorTest {
	
	private static FINAL Integer COUNT = 1;

	@isTest static void allInvestigations() {
		Test.startTest();
		Test.stopTest();
		System.assertEquals((COUNT*2), InvestigationSelector.allInvestigations.size());
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