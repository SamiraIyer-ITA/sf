@isTest
public class DateCalculationConditionServiceTest {
	private static FINAL Integer COUNT = 1;

	@isTest static void getConditionalResult() {
		DateCalculationConditionService dccs = new DateCalculationConditionService();
		Map<String,Boolean> dateAssertMap = new Map<String,Boolean>();
		Map<String,Boolean> integerAssertMap = new Map<String,Boolean>();
		Map<String,Boolean> stringAssertMap = new Map<String,Boolean>();
		Map<String,Boolean> stringSetAssertMap = new Map<String,Boolean>();
		List<String> operators = new List<String>();
		Date lesserDate = System.today();
		Date greaterDate = System.today().addDays(1);
		Integer lesserInt = 1;
		Integer greaterInt = 2;
		String baseString = 'Hello';
		String equalString = 'Hello';
		String notEqualString = 'Goodbye';
		Set<String> equalSet = new Set<String> {'Hello', 'Goodbye'};
		Set<String> notEqualSet = new Set<String> {'Later', 'Goodbye'};
		List<Schema.PicklistEntry> pleList = Schema.Date_Calculation__mdt.Conditional_Field_1_Operator__c.getDescribe().getPicklistValues();
		for(Schema.PicklistEntry ple : pleList) {//add all titles from default list to title map
			operators.add(ple.getValue());
		}
		for (String o : operators) {
			if (o == 'Equals' || o.contains('Greater Than')) {
				dateAssertMap.put(o, false);
				integerAssertMap.put(o, false);
				if (o == 'Equals') {
					stringAssertMap.put(o, false);
					stringSetAssertMap.put(o, false);
				}
			} else if (o == 'Not Equals To' || o.contains('Less Than')) {
				dateAssertMap.put(o, true);
				integerAssertMap.put(o, true);
				if (o == 'Not Equals To') {
					stringAssertMap.put(o, true);
					stringSetAssertMap.put(o, true);
				}
			}
		}
		for (String o : dateAssertMap.keySet()) {
			System.assertEquals(dateAssertMap.get(o), dccs.getConditionResult(lesserDate, greaterDate, o));
		}
		for (String o : integerAssertMap.keySet()) {
			System.assertEquals(integerAssertMap.get(o), dccs.getConditionResult(lesserInt, greaterInt, o));
		}
		for (String o : stringAssertMap.keySet()) {
			System.assertEquals(stringAssertMap.get(o), dccs.getConditionResult(baseString, notEqualString, o));
			System.assertNotEquals(stringAssertMap.get(o), dccs.getConditionResult(baseString, equalString, o));
		}
		for (String o : stringSetAssertMap.keySet()) {
			System.assertEquals(stringSetAssertMap.get(o), dccs.getConditionResult(baseString, notEqualSet, o));
			System.assertNotEquals(stringSetAssertMap.get(o), dccs.getConditionResult(baseString, equalSet, o));
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