@isTest
public class ADCVD_FederalRegisterUtilityTest {
	private static Date petitionDate = ADCVD_TollingDayUtility.getCalculatedDate(System.today(),System.today(),true);
	private static String parentObjectName = '';
	private static Map<Id,Map<String,List<Federal_Register__c>>> testParentIdToFRsMap = new Map<Id,Map<String,List<Federal_Register__c>>>();
	private static List<Investigation__c> iList {
		get {
			if(iList == null) {
				iList = [SELECT Id, RecordTypeId, AD_Investigation_Aligned_To__c, Calculated_Final_Signature__c, Petition__c FROM Investigation__c];
			}
			return iList;
		}
	}
	private static List<Segment__c> sList {
		get {
			if(sList == null) {
				sList = [SELECT Id FROM Segment__c];
			}
			return sList;
		}
	}
	private static Federal_Register__c invFR {
		get {
			if(invFR == null) {
				invFR = [SELECT Id FROM Federal_Register__c WHERE Investigation__c !=: null LIMIT 1];
			}
			return invFR;
		}
		
	}
	private static Federal_Register__c segFR {
		get {
			if(segFR == null) {
				segFR = [SELECT Id FROM Federal_Register__c WHERE Segment__c !=: null LIMIT 1];
			}
			return segFR;
		}
		
	}
	private static List<SObject> setToSObjectList(List<SObject> parentObjectList) {
		List<SObject> returnList = (List<SObject>) parentObjectList;
		return returnList;
	}
	private static void parentObjectName(List<SObject> soList) {
		parentObjectName = utils.getSObjectName(soList[0]);
	}

	@isTest static void initialize() {
		Test.startTest();
		parentObjectName(iList);
		ADCVD_FederalRegisterUtility.initialize(iList);
		System.assertEquals(parentObjectName, ADCVD_FederalRegisterUtility.parentObjectName);//correct parent object name
		ADCVD_FederalRegisterUtility.getParentIdToFRsMap(iList);//run through utility with Investigation__c parentObjectList
		System.assertEquals(ADCVD_FederalRegisterUtility.getParentIdToFRsMap(iList).size(), 1);//confirm the map is populated
		parentObjectName(sList);//change to Segment__c in memory
		ADCVD_FederalRegisterUtility.initialize(sList);//change parentObjectName to Segment__c in utility and clear map
		System.assertEquals(parentObjectName, ADCVD_FederalRegisterUtility.parentObjectName);//confirm parentObjectName changed
		System.assertEquals(ADCVD_FederalRegisterUtility.parentIdToFRsMap.size(), 0);//confirm map size is 0
		Test.stopTest();
	}
	@isTest static void setParentObjectIdSet() {
		Test.startTest();
		Set<Id> testSet = new Set<Id>();
		Set<Id> utilitySet = new Set<Id>();
		for(Investigation__c i : iList) {
			testSet.add(i.Id);
		}
		utilitySet = ADCVD_FederalRegisterUtility.setParentObjectIdSet(iList);
		System.assertEquals(testSet, utilitySet);
		Test.stopTest();
	}
	@isTest static void setLookupFieldName() {
		Test.startTest();
		parentObjectName(iList);//set object name in memory
		ADCVD_FederalRegisterUtility.initialize(iList);//set parentObjectName in utility
		String testLookupFieldName = ADCVD_FederalRegisterUtility.setLookupFieldName();//lookupFieldName in utility should match parentObjectName for Investigations
		System.assertEquals(parentObjectName, testLookupFieldName);//confirm the match
		Test.stopTest();
	}
	@isTest static void addFRsToMap() {
		Test.startTest();
		parentObjectName(iList);
		List<Federal_Register__c> tempList = new List<Federal_Register__c>();
		tempList.add(invFR);
		Map<String,List<Federal_Register__c>> tempMap = new Map<String,List<Federal_Register__c>>();
		tempMap.put('Preliminary', tempList);
		testParentIdToFRsMap.put(iList[0].Id, tempMap);//create map in memory
		ADCVD_FederalRegisterUtility.initialize(iList);
		ADCVD_FederalRegisterUtility.addFRsToMap(iList);//create map in utility
		System.assertEquals(testParentIdToFRsMap.get(iList[0].Id).get('Preliminary'), 
							ADCVD_FederalRegisterUtility.parentIdToFRsMap.get(iList[0].Id).get('Preliminary'));
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPet = TestUtils.createPetition(petitionDate, 'AD ME', true);
		Investigation__c testInv = TestUtils.createInvestigation('AD', testPet, true);
		ADCVD_Order__c testOrder = TestUtils.createOrder(true);
		Segment__c testSeg = TestUtils.createSegment(testOrder, 'Administrative_Review', true);
		Federal_Register__c testInvFR = TestUtils.createFR(ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(210), true), 'Preliminary', false);
		testInvFR.Investigation__c = testInv.Id;
		Federal_Register__c testSegFR = TestUtils.createFR(ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(210), true), 'Preliminary', false);
		testSegFR.Segment__c = testSeg.Id;
		List<Federal_Register__c> insertList = new List<Federal_Register__c>{testInvFR, testSegFR};
		insert insertList;
	}
}