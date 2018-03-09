public without sharing class Utils {
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
	public static Map<Id,RecordType> recordTypeIdToRecordTypeMap {get {
		if(recordTypeIdToRecordTypeMap == null) {
			recordTypeIdToRecordTypeMap = new Map<Id,RecordType>();
			for (RecordType rt : [SELECT Id, Name, DeveloperName, SObjectType FROM RecordType]) {
				recordTypeIdToRecordTypeMap.put(rt.Id, rt);
			}
		}
		return recordTypeIdToRecordTypeMap;
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
			for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
				if (rt.SObjectType == sObjectName) {
					returnMap.put(rt.Id, rt.DeveloperName);
				}
			}
		}
		return returnMap;
	}
	public static Map<Id,String> getRecordTypeLabelMap(String sObjectName){
		Map<Id,String> returnMap = new Map<Id,String>();
		if (sObjectName != null) {
			for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
				if (rt.SObjectType == sObjectName) {
					returnMap.put(rt.Id, rt.Name);
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
		for(RecordType rt : recordTypeIdToRecordTypeMap.values()){
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

	//Helper Method returns Month from a Date in String format
    public static String getMonthFromDate(Date dt) {
        String monthString = '';
        if (dt != null) {
            Datetime tempDt = Datetime.newInstance(dt, Time.newInstance(0,0,0,0));
            monthString = tempDt.format('MMMMM');
        }
        return monthString;
    }

    public static String soqlBuilderAllFields(String soType, Boolean finishSOQL) {
        Map<String, Schema.SObjectType> schemaMap = utils.cachedGD;
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(soType).getDescribe().fields.getMap();
        Set<String> searchFields = new Set<String>();
        String commaSeparatedFields = '';
        for (String fieldName : fieldMap.keyset()){
            searchFields.add(fieldName.toLowerCase());
        }
        for (String s: searchFields) {
            if (commaSeparatedFields != '') {
                commaSeparatedFields = commaSeparatedFields + ', ' + s;
            } else {
                commaSeparatedFields = s;
            }
        }
        String query = 'SELECT ' + commaSeparatedFields;
        if (finishSOQL) {
        	query += ' FROM ' + soType;
        }
        return query;
    }

    public static Set<String> allFieldsSet(String soType) {
        Map<String, Schema.SObjectType> schemaMap = utils.cachedGD;
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(soType).getDescribe().fields.getMap();
        Set<String> returnSet = new Set<String>();
        for (String fieldName : fieldMap.keyset()){
            returnSet.add(fieldName.toLowerCase());
        }
        return returnSet;
    }

    public static List<SObject> getSObjectsInContext(String sObjectName, Set<Id> sObjectIdSet, Set<String> fields) {
		String query = '';
		for (String fieldName : fields) {
			if (String.isBlank(query)) {
				query = 'SELECT ' + fieldName;
			} else {
				query += ', ' + fieldName;
			}
		}
		query += ' FROM '+ sObjectName +' WHERE Id IN: sObjectIdSet';
		System.debug('****** '+query);
		return database.query(query);
	}

    public static List<SObject> castRecordsToType(List<SObject> records, String soType) {
	    String listType = 'List<' + soType + '>';
	    List<SObject> returnList = (List<SObject>)Type.forName(listType).newInstance();
	    returnList.addAll(records);
	    return returnList;
	}
}