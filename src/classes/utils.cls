public without sharing class utils {
	//use this reference for Global Describe to store in cache memory
	public static Map<String,Schema.SObjectType> cachedGD {
		get{
			if(cachedGD == null || cachedGD.isEmpty()) {
				cachedGD = Schema.getGlobalDescribe();
			}
			return cachedGD;
		}
		set;
	}
	public static Map<Id,RecordType> recordTypeDeveloperNameMap {get {
		if(recordTypeDeveloperNameMap == null) {
			recordTypeDeveloperNameMap = new Map<Id,RecordType>();
			for (RecordType rt : [SELECT Id, DeveloperName, SObjectType FROM RecordType]) {
				recordTypeDeveloperNameMap.put(rt.Id, rt);
			}
		}
		return recordTypeDeveloperNameMap;
		} set;
	}
	private static void setCachedGD() {
		if(cachedGD.isEmpty()) {
			cachedGD = Schema.getGlobalDescribe();
		}
	}

	public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
		String objectName = '';
		try{
			//Get prefix from record ID
			//This assumes that you have passed at least 3 characters
			String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
			//setCachedGD();
			//Loop through all the sObject types returned by Schema
			for(Schema.SObjectType soType : cachedGD.values()){
				Schema.DescribeSObjectResult r = soType.getDescribe();
				String prefix = r.getKeyPrefix();
				 
				//Check if the prefix matches with requested prefix
				if(prefix!=null && prefix.equals(myIdPrefix)){
					objectName = r.getName();
					System.debug('Object Name! ' + objectName);
					break;
				}
			}
		}catch(Exception e){
			System.debug(e);
		}
		return objectName;
	}

	//Gets API name of the passed Object
	public static String getSObjectName(SObject o) {
		Schema.DescribeSObjectResult dsr = o.getSObjectType().getDescribe();
		String sObjectName = dsr.getName();
		return sObjectName;
	}
	//Gets a map of Record Type Ids to Developer Names for the object name
	public static Map<Id,String> getRecordTypeDeveloperNameMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		if (sObjectName != null) {
			for(RecordType rt : recordTypeDeveloperNameMap.values()){
				if (rt.SObjectType == sObjectName) {
					returnMap.put(rt.Id, rt.DeveloperName);
				}
			}
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
	//Gets a map of an object's fields in the form: String object name, List<String> field names
	public static Map<String,List<String>> getObjectToFieldMap(String sObjectName) {
		Map<String,List<String>> returnMap = new Map<String,List<String>>();
		List<String> fieldList = new List<String>();
		Schema.DescribeSObjectResult dsr = cachedGD.get(sObjectName).getDescribe();
		Map<String,Schema.SObjectField> tempFieldMap = dsr.fields.getMap();
		for(String fieldName : tempFieldMap.keySet()) {
			fieldList.add(fieldName);
		}
		returnMap.put(sObjectName, fieldList);
		return returnMap;

	}
	public static Map<String,List<String>> getObjectToFieldMap(SObject o) {
		String sObjectName = getSObjectName(o);
		Map<String,List<String>> returnMap = getObjectToFieldMap(sObjectName);
		return returnMap;
	}
	//Gets a map of an object's fields in the form: String object name, List<String> field names
	public static Map<String,Schema.SObjectField> getFieldMap(String sObjectName) {
		Map<String,Schema.SObjectField> returnMap = new Map<String,Schema.SObjectField>();
		List<String> fieldList = new List<String>();
		Schema.DescribeSObjectResult dsr = cachedGD.get(sObjectName).getDescribe();
		returnMap = dsr.fields.getMap();
		return returnMap;

	}
	public static Map<String,Schema.SObjectField> getFieldMap(SObject o) {
		String sObjectName = getSObjectName(o);
		Map<String,Schema.SObjectField> returnMap = getFieldMap(sObjectName);
		return returnMap;
	}

	//Visualforce Page Utilities
	
	public static String parseUrlForId(String retUrl) {
		if(!String.isBlank(retUrl)){
			retUrl = retUrl.replaceAll('/', '');
			system.debug(retUrl);
			if(retUrl.contains('?')) {
				List<String> urlSplit = retUrl.split('\\?');
				retUrl = urlSplit[0];
			}
		}
		return retUrl;
	}
}