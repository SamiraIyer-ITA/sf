@isTest
public class PetitionSelectorTest {

	private static FINAL Integer COUNT = 1;
	
	@isTest static void allPetitions() {
		Test.startTest();
		Test.stopTest();
		System.assertEquals((COUNT*2), PetitionSelector.allPetitions.size());
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		//create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
		Date petitionDate = System.today();
		List<User> uList = new List<User>();
		List<ADCVD_Case__c> cList = new List<ADCVD_Case__c>();
		List<Petition__c> pList = new List<Petition__c>();
		List<Investigation__c> iList = new List<Investigation__c>();
		List<Federal_Register__c> frList = new List<Federal_Register__c>();
		for (Integer i = 0; i < COUNT; i++) {
			User testUser = TestUtils.createAdminUser(false, 'myemail@email.com.testita', i);
			uList.add(testUser);
			ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-12' + i, 'AD ME', false);
			cList.add(testADCase);
			ADCVD_Case__c testCVDCase = TestUtils.createADCVDCase('C-123-12' + i, 'CVD', false);
			cList.add(testCVDCase);
		}
		insert uList;
		insert cList;
		Integer counter = 0;
		for (ADCVD_Case__c c : cList) {
			if (c.ADCVD_Case_Type__c.indexOf('A') > -1) {
				Petition__c testADPetition = TestUtils.createPetition(c, petitionDate.addDays(counter),false);
				pList.add(testADPetition);
			} else if (c.ADCVD_Case_Type__c.indexOf('C') > -1) {
				Petition__c testCVDPetition = TestUtils.createPetition(c, petitionDate.addDays(counter),false);
				pList.add(testCVDPetition);
			}
			counter++;
		}
		insert pList;
		for (Petition__c p : pList) {
			Investigation__c testInvestigation = TestUtils.createInvestigation(p, false);
			iList.add(testInvestigation);
		}
		insert iList;
		for (Investigation__c i : iList) {
			Federal_Register__c prelimFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Preliminary', false);
			frList.add(prelimFR);
			Federal_Register__c finalFR = TestUtils.createFR(i.Id, 'Investigation__c', petitionDate.addDays(120), 'Final', false);
			frList.add(finalFR);
		}
		insert frList;
	}
}