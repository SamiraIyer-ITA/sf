@isTest
private class UtilsTest {
	@IsTest
	private static void meaninglessMethodTest(){
		Utils.meaninglessMethod();
	}

	@isTest
	private static void recordTypeIdsBySObjectTypesTest(){

		Map<String, Schema.SObjectType> sobjMap = Schema.getGlobalDescribe();
		Map<String, Id> testMap = new Map<String, Id>();
		testMap = Utils.getRecordTypeMapBySObject(sobjMap.get('Account'));
		system.assertNotEquals(testMap, null);

	}

	@isTest
	private static void getRecordTypeMapBySObjectTest(){

		Schema.SObjectType expected = Schema.Account.getSObjectType();
		Map<String, Id> testMap = new Map<String, Id>();
		testMap = Utils.getRecordTypeMapBySObject(expected);
		system.assertNotEquals(testMap, null);

	}

	@isTest
	private static void getRecordTypeIdBySObjectAndRecordTypeDeveloperNameTest(){

		Schema.SObjectType expected = Schema.Account.getSObjectType();
		Id testId;
		testId = Utils.getRecordTypeIdBySObjectAndRecordTypeDeveloperName(expected, 'Master');
		system.assertNotEquals(testId, null);

	}

	@isTest
	private static void alpha2CountryCodeMapTest(){
		Utils.CountryCodeType a = Utils.CountryCodeType.ALPHA2;
		String b = Utils.getCountryCodeFromAlpha2('US', a);
		system.assertNotEquals(a, null);

		Utils.CountryCodeType c = Utils.CountryCodeType.ALPHA3;
		String d = Utils.getCountryCodeFromAlpha2('US', c);
		system.assertNotEquals(d, null);

		Utils.CountryCodeType e = Utils.CountryCodeType.NUMERIC;
		String f = Utils.getCountryCodeFromAlpha2('US', e);
		system.assertNotEquals(f, null);

	}

	@isTest
	private static void getObjectToFieldMapTest(){
		Map<String,List<String>> aMap = new Map<String,List<String>>();
		aMap = Utils.getObjectToFieldMap('Account');
		system.assertNotEquals(aMap, null);

	}

	@isTest
	private static void getRecordTypeIdMapTest(){
		Map<String,Id> aMap = new Map<String,Id>();
		sObject sObj = Schema.getGlobalDescribe().get('Account').newSObject() ;
		aMap = Utils.getRecordTypeIdMap(sObj);
		system.assertNotEquals(aMap, null);

	}


	@isTest
	private static void castRecordsToTypeTest(){
		List<SObject> lso1 = new List<SObject>();
		List<SObject> lso2 = new List<SObject>();
		sObject sObj1 = Schema.getGlobalDescribe().get('Account').newSObject() ;
		sObject sObj2 = Schema.getGlobalDescribe().get('Account').newSObject() ;
		lso1.add(sObj1);
		lso1.add(sObj2);
		lso2 = Utils.castRecordsToType(lso1, 'Account');
		system.assertNotEquals(lso2, null);

	}

	@isTest
	private static void findObjectNameFromRecordIdPrefixTest(){
		String prefix = '001';
		String objectName;
		objectName = Utils.findObjectNameFromRecordIdPrefix(prefix);
		system.assertEquals(objectName, 'Account');

	}


}