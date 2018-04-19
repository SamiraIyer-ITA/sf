@isTest
public class ADCVD_FederalRegisterUtilityTest {
	private static Date petitionDate = System.today();
	private static String parentObjectName = '';
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
	@isTest static void getInstance() {
		Test.startTest();
		ADCVD_FederalRegisterUtility.getInstance(iList);
		Test.stopTest();
	}
/*	@isTest static void setParentObjectIdSet() {
		Test.startTest();
		ADCVD_FederalRegisterUtility.getInstance(iList);
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
		ADCVD_FederalRegisterUtility.getInstance(iList);
		parentObjectName(iList);//set object name in memory
		String testLookupFieldName = ADCVD_FederalRegisterUtility.setLookupFieldName();//lookupFieldName in utility should match parentObjectName for Investigations
		System.assertEquals(parentObjectName, testLookupFieldName);//confirm the match
		Test.stopTest();
	}
*/
	@testSetup static void dataSetup() {
		Test.startTest();
		//create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
		User u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		petitionDate = ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate, true);
		ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
        Petition__c testADPetition = TestUtils.createPetition(testADCase, petitionDate, true);
        Investigation__c testADinvestigation = TestUtils.createInvestigation(testADPetition, true);
        ADCVD_Order__c testADOrder = TestUtils.createOrder(testADinvestigation, true);
		Segment__c testSeg = TestUtils.createSegment(testADOrder, 'Administrative_Review', true);
		Integer days = 140;
		List<Federal_Register__c> frsToInsert = new List<Federal_Register__c>();
		Schema.DescribeFieldResult f = Federal_Register__c.Type__c.getDescribe();
		for(Schema.PicklistEntry frType : f.getPicklistValues()) {
			Federal_Register__c testInvFR = TestUtils.createFR(testADinvestigation.Id, 'Investigation__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
			frsToInsert.add(testInvFR);
			days += 7;
			Federal_Register__c testSegFR = TestUtils.createFR(testSeg.Id, 'Segment__c', ADCVD_TollingDayUtility.getCalculatedDate(petitionDate, petitionDate.addDays(days), true), frType.getValue(), false);
			days += 7;
			frsToInsert.add(testSegFR);
		}
		insert frsToInsert;
	}
}