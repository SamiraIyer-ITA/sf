@isTest
public class CustomMetadataSelectorTest {

	/************************************************
    * This class performs unit tests on the CustomMetadataSelector
    * under these condititions.
    * 1. Test to ensure that the class is initialized when creating a petition
    * 2. Test to ensure that the class is initialized when creating an investigation
    * 3. Test to ensure that the Constant__mdt is queried and held in static class variables
    * 4. Test to ensure that the ADCVD_Objects__mdt is queried and held in static class variables
    * 5. Test to ensure that the Date_Calculation__mdt is queried and held in static class variables
    *************************************************/

	private static FINAL Integer COUNT = 1;

	@isTest static void allConstants() {
		Test.startTest();
		Test.stopTest();
		System.assertNotEquals(0, CustomMetadataSelector.allConstants.size());
	}

	@isTest static void allAdcvdObjects() {
		Test.startTest();
		Test.stopTest();
		System.assertNotEquals(0, CustomMetadataSelector.allAdcvdObjects.size());
	}

	@isTest static void allDateCalculations() {
		Test.startTest();
		Test.stopTest();
		System.assertNotEquals(0, CustomMetadataSelector.allDateCalculations.size());
	}

	@testSetup static void dataSetup() {
		Date petitionDate = System.today();
		List<User> uList = new List<User>();
		List<Petition__c> pList = new List<Petition__c>();
		List<Investigation__c> iList = new List<Investigation__c>();
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
			Federal_Register__c initFR = TestUtils.createFR(p.Id, 'Petition__c', petitionDate.addDays(120), 'Initiation', false);
			frList.add(initFR);
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