public without sharing class DateCalculationServiceDispatcher {

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