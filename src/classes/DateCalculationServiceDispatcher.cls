/**
 * 
 *    Created by Joshua Moody
 *    on Aug 3 2017
 *    MIL Corporation
 * 
 **/

public without sharing class DateCalculationServiceDispatcher {

	/************************************************
    * This class dispatches instances of the DateCalculationService.
    * It also has code in it to call an instance of the SyncUtility, 
    * but that cannot be used until that service class is refactored to
    * run as an instance.  This class provides methods that:
    * 1. Dispatch instances of the DateCalculationService
    *************************************************/

	@TestVisible private static Map<String,DateCalculationService> dcsMap = new Map<String,DateCalculationService>();
	@TestVisible private static Map<String,SyncUtility> suMap = new Map<String,SyncUtility>();

	public static DateCalculationService getDateCalculationServiceInstance(String soTypeOrRecordType) {
		DateCalculationService dcs = (DateCalculationService) Type.forName('DateCalculationService').newInstance();
		/*if (dcsMap.get(soTypeOrRecordType) == null) {
			dcsMap.put(soTypeOrRecordType, dcs);
		} else {
			dcs = dcsMap.get(soTypeOrRecordType);
		}
		System.debug(dcsMap);*/
		return dcs;
	}
	public static SyncUtility getSyncUtilityInstance(String soType) {
		SyncUtility su = (SyncUtility) Type.forName('SyncUtility').newInstance();
		if (!String.isBlank(soType) && suMap.get(soType) == null) {
			suMap.put(soType, su);
		}
		return suMap.get(soType);
	}
}