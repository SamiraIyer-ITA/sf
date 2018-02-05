@isTest
public class DateCalculationServiceTest {

	/************************************************
    * This class performs unit tests on the DateCalculationService
    * under these condititions.
    * 1. Test to ensure that the class is initialized when creating a petition
    * 2. Test to ensure that the class is initialized when creating an Investigation
    * 3. Test to ensure that the date calculations are queried and held in class
    * 4. Test to ensure that the date calculations are applied to a record
    *************************************************/

	private static FINAL Integer COUNT = 1;

	private static List<Petition__c> petList {
		get {
			if (petList == null) {
				petList = new List<Petition__c>();
				petList = PetitionSelector.allPetitions;
			}
			return petList;
		}
	}

	private static List<Investigation__c> invList {
		get {
			if (invList == null) {
				invList = new List<Investigation__c>();
				invList = InvestigationSelector.allInvestigations;
			}
			return invList;
		}
	}

	@isTest static void setDateCalculations() {
		Test.startTest();
		DateCalculationService dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
		dcs.setDateCalculations('Investigation__c', 'AD');
		Test.stopTest();
		System.assertNotEquals(null, dcs.dateCalculations);
	}

	@isTest static void getCalculatedDates() {
		Test.startTest();
		DateCalculationService petDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Petition__c');
		petDcs.getCalculatedDates(petList, 'Petition__c', '');
		DateCalculationService invDcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
		invDcs.getCalculatedDates(invList, 'Investigation__c', '');
		Test.stopTest();
		for (Petition__c p : petList) {
			System.assertNotEquals(null, p.Calculated_Initiation_Signature__c);
		}
		for (Investigation__c i : invList) {
			System.debug('*** getCalculatedDates assert Investigation__c record: ' + i);
			System.assertNotEquals(null, i.Calculated_Preliminary_Signature__c);
			System.assertNotEquals(null, i.Preliminary_Announcement_Date__c);
			System.assertEquals(null, i.Calc_Amended_Prelim_Determination_Sig__c);
			System.assertEquals(null, i.Amended_Preliminary_Announcement_Date__c);
			System.assertNotEquals(null, i.Prelim_Team_Meeting_Deadline__c);
			System.assertNotEquals(null, i.Calculated_Final_Signature__c);
			System.assertNotEquals(null, i.Final_Announcement_Date__c);
			System.assertEquals(null, i.Calculated_Amended_Final_Signature__c);
			System.assertEquals(null, i.Amended_Final_Announcement_Date__c);
			System.assertNotEquals(null, i.Final_Team_Meeting_Deadline__c);
			System.assertNotEquals(null, i.Est_ITC_Notification_to_DOC_of_Final_Det__c);
			System.assertNotEquals(null, i.Calculated_Order_FR_Signature__c);
			System.assertNotEquals(null, i.Calculated_ITC_Final_FR_Published__c);
			System.assertNotEquals(null, i.Estimated_Order_FR_Published__c);
			System.assertEquals(null, i.Litigation_Hold_Expiration_Date__c);
			System.assertNotEquals(null, i.Calculated_Prelim_Extension_Request_File__c);
			System.assertNotEquals(null, i.Calculated_Postponement_of_PrelimDeterFR__c);
			System.assertNotEquals(null, i.Calculated_ITC_Prelim_Determination__c);
			System.assertNotEquals(null, i.Termination_of_Suspension_Gap_Period_Beg__c);
			System.assertNotEquals(null, i.Petition_Initiation_Signature__c);
		}

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
			Petition__c testCVDPetition = TestUtils.createPetition(petitionDate.addDays(i), 'CVD', false);
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