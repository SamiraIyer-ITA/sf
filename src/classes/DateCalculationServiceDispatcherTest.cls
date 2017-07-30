@isTest
public class DateCalculationServiceDispatcherTest {

	@isTest static void getDateCalculationServiceInstance() {
		Test.startTest();
		DateCalculationService dcs = null;
		dcs = DateCalculationServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
		Test.stopTest();
		System.assertNotEquals(null, dcs);
	}

	@isTest static void getSyncUtilityInstance() {
		Test.startTest();
		SyncUtility su = null;
		su = DateCalculationServiceDispatcher.getSyncUtilityInstance('Investigation__c');
		Test.stopTest();
		System.assertNotEquals(null, su);
	}

}