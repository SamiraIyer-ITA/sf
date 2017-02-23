public without sharing class utils {

	//Gets API name of the passed Object
	public static String getSObjectName(SObject o) {
		Schema.DescribeSObjectResult dsr = o.getSObjectType().getDescribe();
		String sObjectName = dsr.getName();
		return sObjectName;
	}
	//Gets a map of Record Type Ids to Developer Names for the object name
	public static Map<Id,String> getRecordTypeDeveloperNameMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType =: sObjectName]){
			returnMap.put(rt.Id, rt.DeveloperName);
		}
		return returnMap;
	}
	public static Map<Id,String> getRecordTypeDeveloperNameMap(SObject o){
		String sObjectName = getSObjectName(o);
		Map<Id,String> returnMap = getRecordTypeDeveloperNameMap(sObjectName);
		return returnMap;
	}
	//Gets a map of Record Type Developer Names to Record Type Ids for the object name
	public static Map<String,Id> getRecordTypeIdMap(String sObjectName){
		Map<String,Id> returnMap = new Map<String,Id>();
		for(RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType =: sObjectName]){
			returnMap.put(rt.DeveloperName, rt.Id);
		}
		return returnMap;
	}
	public static Map<String,Id> getRecordTypeIdMap(SObject o){
		String sObjectName = getSObjectName(o);
		Map<String,Id> returnMap = getRecordTypeIdMap(sObjectName);
		return returnMap;
	}
}
