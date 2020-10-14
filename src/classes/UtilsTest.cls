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

}