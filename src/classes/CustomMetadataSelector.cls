/**
*
*    Created by Joshua Moody
*    on August 3 2017
*    MIL Corporation
*
**/
public without sharing class CustomMetadataSelector {

	/**********In the process of deprecating************
	* This class queries custom metadata objects and stores them in class
	* for faster reference by classes using custom metadata.
	* This class provides methods to:
	* 1. Query all custom metadata used in the ADCVD App
	* 2. Map those records for the easiest consumption by classes
	******************************************************************/

	public static List<ADCVD_Objects__mdt> allAdcvdObjects {
		get {
			if (allAdcvdObjects == null) {
				String query = Utils.soqlBuilderAllFields('ADCVD_Objects__mdt', true);
				allAdcvdObjects = Database.query(query);
			}
			return allAdcvdObjects;
		} set;
	}

	public static List<Constant__mdt> allConstants {
		get {
			if (allConstants == null) {
				String query = Utils.soqlBuilderAllFields('Constant__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c FROM Constant__mdt';
				allConstants = Database.query(query);
			}
			return allConstants;
		} set;
	}

	public static List<Automated_Chatter_Post__mdt> allPosts {
		get {
			if (allPosts == null) {
				String query = Utils.soqlBuilderAllFields('Automated_Chatter_Post__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c FROM Automated_Chatter_Post__mdt';
				allPosts = Database.query(query);
			}
			return allPosts;
		} set;
	}

	public static List<Date_Calculation__mdt> allDateCalculations {
		get {
			if (allDateCalculations == null) {
				String query = Utils.soqlBuilderAllFields('Date_Calculation__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c, ADCVD_Objects__r.Number_of_Date_Calculations__c, ' +
						'Constant_1__r.Number_Value__c, Constant_1__r.String_Value__c, ' +
						'Constant_1__r.Used_with_Field_Named__c, Constant_2__r.Number_Value__c, Constant_2__r.String_Value__c, ' +
						'Constant_2__r.Used_with_Field_Named__c, Constant_3__r.Number_Value__c, Constant_3__r.String_Value__c, ' +
						'Constant_3__r.Used_with_Field_Named__c, Constant_4__r.Number_Value__c, Constant_4__r.String_Value__c, ' +
						'Constant_4__r.Used_with_Field_Named__c FROM Date_Calculation__mdt';
				allDateCalculations = Database.query(query);
			}
			return allDateCalculations;
		} set;
	}
	public static Map<String, Map<String, Integer>> defaultRoleMap {
		get {
			if (defaultRoleMap == null) {
				defaultRoleMap = new Map<String, Map<String, Integer>>();
				List<Constant__mdt> tempList = new List<Constant__mdt>();
				String query = Utils.soqlBuilderAllFields('Constant__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c, ADCVD_Objects__r.Type__c FROM Constant__mdt';
				query += ' WHERE Staffing_Assignment_Default__c = true AND Staffing_Role__c != null AND Number_Value__c != null';
				tempList = Database.query(query);
				for (Constant__mdt c : tempList) {
					Map<String, Integer> tempMap = new Map<String, Integer>();
					if (defaultRoleMap.get(c.ADCVD_Objects__r.Object_API_Name__c) != null) {
						tempMap = defaultRoleMap.get(c.ADCVD_Objects__r.Object_API_Name__c);
					}
					Integer tempInteger = c.Number_Value__c != null ? (Integer) c.Number_Value__c : 0;
					tempMap.put(c.Staffing_Role__c, tempInteger);
					defaultRoleMap.put(c.ADCVD_Objects__r.Object_API_Name__c, tempMap);
				}
			}
			return defaultRoleMap;
		} set;
	}

	//returns an SObjectType as the key and all it's potential parent SObjectTypes as value in a set
    public static Map<SObjectType, Set<SObjectType>> childToParentsSObjectMap {
        get {
            if (childToParentsSObjectMap == null) {
				childToParentsSObjectMap = new Map<SObjectType, Set<SObjectType>>();
                for (ADCVD_Objects__mdt ao : [SELECT Object_API_Name__c, Record_Type_Name__c,
                                            (SELECT String_Value__c FROM Constants__r WHERE Parent_Value__c =: true)
                                            FROM ADCVD_Objects__mdt]) {
					if (ao.Constants__r != null && !ao.Constants__r.isEmpty()) {
						SObjectType keyType = Utils.cachedGD.get(ao.Object_API_Name__c);
						Set<SObjectType> tempSet = childToParentsSObjectMap.get(keyType) != null
											? childToParentsSObjectMap.get(keyType) : new Set<SObjectType>();
						for (Constant__mdt c : ao.Constants__r) {
							tempSet.add(Utils.cachedGD.get(c.String_Value__c));
						}
						childToParentsSObjectMap.put(keyType, tempSet);
					}
				}
            }
			return childToParentsSObjectMap;
        } set;
    }
	//same logic as parentToChildMap but returns strings instead of SObjectTypes.
	//can be removed after all sobject references are using SObjectType instead of strings
	public static Map<String, Set<String>> childToParentsStringMap {
		get {
			if (childToParentsStringMap == null) {
				childToParentsStringMap = new Map<String, Set<String>>();
				for (ADCVD_Objects__mdt ao : [SELECT Object_API_Name__c, Record_Type_Name__c,
				(SELECT String_Value__c FROM Constants__r WHERE Parent_Value__c =: true)
				FROM ADCVD_Objects__mdt]) {
					if (ao.Constants__r != null && !ao.Constants__r.isEmpty()) {
						String keyType = ao.Object_API_Name__c;
						Set<String> tempSet = childToParentsStringMap.get(keyType) != null
							? childToParentsStringMap.get(keyType) : new Set<String>();
						for (Constant__mdt c : ao.Constants__r) {
							tempSet.add(c.String_Value__c);
						}
						childToParentsStringMap.put(keyType, tempSet);
					}
				}
			}
			return childToParentsStringMap;
		} set;
	}

	public static Map<String,List<Automated_Chatter_Post__mdt>> sObjectToPostMap = new Map<String,List<Automated_Chatter_Post__mdt>>();

	public static Map<String,Constant__mdt> getConstantNameToConstantMap(String offsetFieldName) {
		Map<String,Constant__mdt> returnMap = new Map<String,Constant__mdt>();
		for (Constant__mdt c : allConstants) {
			if ((Boolean)c.get(offsetFieldName)) {
				returnMap.put(c.QualifiedApiName, c);
			}
		}
		return returnMap;
	}

	public static Constant__mdt getConstant(String idOrQualifiedApiName) {
		Constant__mdt returnConstant = null;
		if (idOrQualifiedApiName instanceof Id) {
			Id i = (Id) idOrQualifiedApiName;
			for (Constant__mdt c : allConstants) {
				if (c.Id == i) {
					returnConstant = c;
					break;
				}
			}
		} else {
			for (Constant__mdt c : allConstants) {
				if (c.QualifiedApiName == idOrQualifiedApiName) {
					returnConstant = c;
					break;
				}
			}
		}
		return returnConstant;
	}

	public static List<Automated_Chatter_Post__mdt> getPostsList(String sObjectName) {
		if (sObjectToPostMap.isEmpty()) {
			for (Automated_Chatter_Post__mdt acp : allPosts) {
				List<Automated_Chatter_Post__mdt> tempList = new List<Automated_Chatter_Post__mdt>();
				if (sObjectToPostMap.get(acp.ADCVD_Objects__r.Object_API_Name__c) != null) {
					tempList = sObjectToPostMap.get(acp.ADCVD_Objects__r.Object_API_Name__c);
				}
				tempList.add(acp);
				sObjectToPostMap.put(acp.ADCVD_Objects__r.Object_API_Name__c, tempList);
			}
		}
		return sObjectToPostMap.get(sObjectName);
	}

	public Map<String,Integer> getDefaultUserRolesMap(String parentSObjectType) {
		return defaultRoleMap.get(parentSObjectType);
	}

	public Set<String> getParentsForChildSObject(String childSObjectType) {
		return childToParentsStringMap.get(childSObjectType);
	}

	public static Map<String, Object> getPaymentSettings(String paymentProcessor) {
		String query = Utils.soqlBuilderAllFields('Payment_Mapping__mdt', true);
		query += ' WHERE DeveloperName = :paymentProcessor LIMIT 1';
		Payment_Mapping__mdt mdt = Database.query(query);
		return mdt == null ? null: mdt.getPopulatedFieldsAsMap();
	}
}