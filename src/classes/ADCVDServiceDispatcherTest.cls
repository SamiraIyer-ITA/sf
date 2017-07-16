@isTest
public class ADCVDServiceDispatcherTest {

	@isTest static void getDateCalculationServiceInstance() {
		Test.startTest();
		DateCalculationService dcs = null;
		dcs = ADCVDServiceDispatcher.getDateCalculationServiceInstance('Investigation__c');
		Test.stopTest();
		System.assertNotEquals(null, dcs);
	}

	@isTest static void getSyncUtilityInstance() {
		Test.startTest();
		SyncUtility su = null;
		su = ADCVDServiceDispatcher.getSyncUtilityInstance('Investigation__c');
		Test.stopTest();
		System.assertNotEquals(null, su);
	}

}