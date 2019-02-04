/**
 * 
 *    Updated by Tim Barsotti
 *    on Apr 3 2017
 *    MIL Corporation
 * 
 **/
 public without sharing class MetadataHelper {
 	/************************************************
    * This class is used across multiple projects and teams.
    * It provides methods that perform various repeatable
    * functions to return metadata from the org.
    *************************************************/
    
	public static Map<String, Schema.SObjectType> gd { 
        get {
            if(gd == null) { 
                gd = Schema.getGlobalDescribe();
            } 
            return gd;
        } set;
    }
	public static List<String> getFieldsForSobject(String sObjectName) {
		List<String> fieldList = new List<String>();
		for(Schema.SObjectField field: gd.get(sObjectName).getDescribe().fields.getMap().values()) {
			if(field.getDescribe().isUpdateable() || field.getDescribe().isCreateable()) {
				fieldList.add(String.ValueOf(field));
			}
		}
		fieldList.sort();
		return fieldList;
	}
	public static Map<String, List<SelectOption>> sObjectNameToFieldOptions(List<String> objectNames) {
		Map<String, List<SelectOption>> sObjectFieldMap = new Map<String, List<SelectOption>>();
		for(String s: objectNames) {
			sObjectFieldMap.put(s, getFieldListForObject(s));
		}
		return sObjectFieldMap;
	}
	public static List<String> getChildObjects(String sObjectName) {
		List<String> childObjects = new List<String>();
		system.debug(gd.get(sObjectName).getDescribe().getChildRelationships());
        for(Schema.ChildRelationship rel : gd.get(sObjectName).getDescribe().getChildRelationships()){
            Schema.DescribeSObjectResult obj = rel.getChildsObject().getDescribe();
            //only Add if updateable and creatable
            if(obj.isCreateable() && obj.isUpdateable()) {
            	childObjects.add(String.ValueOf(rel.getChildsObject()));
            }
        }
        childObjects.sort();
        return childObjects;
	}
	public static List<SelectOption> getFieldListForObject(String sObjName) {
		List<SelectOption> selectList = new List<SelectOption>();
		for(String s: getFieldsForSobject(sObjName)) {
			selectList.add(new SelectOption(s, s));
		}
		return selectList;
	}
    public static Id getRecordTypeIdByName(String sObjName, String recordTypeName) {
		if(String.isBlank(sObjName) 
			|| String.isBlank(recordTypeName)
			|| gd.get(sObjName) == null
			|| gd.get(sObjName).getDescribe().getRecordTypeInfosByName() == null
			|| gd.get(sObjName).getDescribe().getRecordTypeInfosByName().get(recordTypeName) == null
			) {
			return null;
		}
		return gd.get(sObjName).getDescribe().getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
	}
    public static String getObjectPrefix(String sObjName) {
        if(String.isBlank(sObjName) || 
			gd.get(sObjName).getDescribe() == null) {
            return null;
        }
        return gd.get(sObjName).getDescribe().getKeyPrefix();
    }
}