/**
 * 
 *    Created by Joshua Moody
 *    on Aug 3 2017
 *    MIL Corporation
 * 
 **/

@isTest
public class DateCalculationServiceDispatcherTest {

	/************************************************
    * This class performs unit tests on the DateCalculationServiceDispatcher
    * under these condititions.
    * 1. Test to ensure that a class instance is initialized for the DateCalculationService
    * 2. Test to ensure that a class instance is initialized for the SyncUtility (for potential future refactor of this class)
    *************************************************/

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