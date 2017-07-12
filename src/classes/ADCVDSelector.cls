public without sharing class ADCVDSelector {

	public static List<Petition__c> allPetitions {
		get {
			if (allPetitions == null) {
				String query = soqlBuilderAllFields('Petition__c', true);
				allPetitions = database.query(query);
			}
			return allPetitions;
		} set;
	}
	public static List<Investigation__c> allInvestigations {
		get {
			if (allInvestigations == null) {
				String query = soqlBuilderAllFields('Investigation__c', true);
				allInvestigations = database.query(query);
			}
			return allInvestigations;
		} set;
	}
	public static List<Segment__c> allSegments {
		get {
			if (allSegments == null) {
				String query = soqlBuilderAllFields('Segment__c', true);
				allSegments = database.query(query);
			}
			return allSegments;
		} set;
	}
	public static List<ADCVD_Objects__mdt> allAdcvdObjects {
		get {
			if (allAdcvdObjects == null) {
				String query = soqlBuilderAllFields('ADCVD_Objects__mdt', true);
				allAdcvdObjects = database.query(query);
			}
			return allAdcvdObjects;
		} set;
	}
	public static List<Constant__mdt> allConstants {
		get {
			if (allConstants == null) {
				String query = soqlBuilderAllFields('Constant__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c FROM Constant__mdt';
				allConstants = database.query(query);
			}
			return allConstants;
		} set;
	}
	public static List<Date_Calculation__mdt> allDateCalculations {
		get {
			if (allDateCalculations == null) {
				String query = soqlBuilderAllFields('Date_Calculation__mdt', false);
				query += ', ADCVD_Objects__r.Object_API_Name__c, ADCVD_Objects__r.Record_Type_Name__c, ' +
						'Constant_1__r.Number_Value__c, Constant_1__r.String_Value__c, ' +
						'Constant_1__r.Used_with_Field_Named__c, Constant_2__r.Number_Value__c, Constant_2__r.String_Value__c, ' +
						'Constant_2__r.Used_with_Field_Named__c, Constant_3__r.Number_Value__c, Constant_3__r.String_Value__c, ' +
						'Constant_3__r.Used_with_Field_Named__c, Constant_4__r.Number_Value__c, Constant_4__r.String_Value__c, ' +
						'Constant_4__r.Used_with_Field_Named__c FROM Date_Calculation__mdt';
				allDateCalculations = database.query(query);
			}
			return allDateCalculations;
		} set;
	}
	public static List<Issue__c> allIssues {
		get {
			if (allIssues == null) {
				String query = soqlBuilderAllFields('Issue__c', true);
				allIssues = database.query(query);
			}
			return allIssues;
		} set;
	}

	public static Map<ID,ADCVD_FederalRegisterUtility> getFrUtilMap(List<SObject> soList) {
		ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(soList);
		Map<ID,ADCVD_FederalRegisterUtility> frUtilMap = listInstance.utilMap;
		return frUtilMap;
	}

	public static Map<String,Date> getFrDateMap(List<SObject> soList) {
		ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(soList);
		Map<String,Date> frDateMap = listInstance.varMap;
		return frDateMap;
	}

	public static Map<Id,Petition__c> getPetitionsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
		System.debug('*** getPetitionsInScope soList: ' + soList);
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = castRecordsToType(soList, soType);
		for (SObject so : castRecords) {
			tempIdSet.add((Id)so.get(lookupFieldName));
		}
		for (Petition__c p : allPetitions) {
			if (tempIdSet.contains(p.Id)) {
				returnMap.put(p.Id, p);
			}
		}
		return returnMap;
	}

	public static Map<Id,Investigation__c> getInvestigationsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Investigation__c> returnMap = new Map<Id,Investigation__c>();
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = castRecordsToType(soList, soType);
		for (SObject so : castRecords) {
			tempIdSet.add((Id)so.get(lookupFieldName));
		}
		for (Investigation__c i : allInvestigations) {
			if (tempIdSet.contains(i.Id)) {
				returnMap.put(i.Id, i);
			}
		}
		return returnMap;
	}

	public static Map<Id,Issue__c> getIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Issue__c> returnMap = new Map<Id,Issue__c>();
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = castRecordsToType(soList, soType);
		for (SObject so : castRecords) {
			tempIdSet.add((Id)so.get('Id'));
		}
		for (Issue__c i : allIssues) {
			if (tempIdSet.contains((Id)i.get(lookupFieldName))) {
				returnMap.put(i.Id, i);
			}
		}
		return returnMap;
	}

	public static Map<Id,Issue__c> getCompletedIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Issue__c> returnMap = getIssuesInScope(soList, soType, lookupFieldName);
		Map<Id,Map<String,Boolean>> parentIdToCompletedIssues = getCompletedIssues(soList, lookupFieldName);
		for(Id i : returnMap.keySet()) {
			if (!parentIdToCompletedIssues.containsKey(i) || !parentIdToCompletedIssues.get(i).get(returnMap.get(i).Type__c)) {
				returnMap.remove(i);
			}
		}
		return returnMap;
	}

	public static Map<Id,Map<String,Boolean>> getCompletedIssues(List<SObject> soList, String lookupFieldName) {
		Map<Id,Map<String,Boolean>> parentIdToCompletedIssues = new Map<Id,Map<String,Boolean>>();
		Set<Id> tempIdSet = new Set<Id>();
		for (SObject so : soList) {
			if (so.get('Id') != null) {
				tempIdSet.add((Id)so.get('Id'));
			}
		}
		for (Issue__c i : allIssues) {
			Map<String,Boolean> tempMap = new Map<String,Boolean>();
			if (tempIdSet.contains((Id)i.get(lookupFieldName))) {
				if (tempMap.get(i.Type__c) == null || tempMap.get(i.Type__c) == true) {
					Boolean tempBoolean = i.Ops_Status__c == 'Completed' ? true : false;
					tempBoolean = (tempBoolean == true && i.Policy_Status__c == 'Completed') ? true : false;
					tempBoolean = (tempBoolean == true && i.Legal_Status__c == 'Completed') ? true : false;
					tempMap.put(i.Type__c, tempBoolean);
					parentIdToCompletedIssues.put((Id)i.get(lookupFieldName), tempMap);
				}
			}
		}
		return parentIdToCompletedIssues;
	}

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
		if (idOrQualifiedApiName instanceOf Id) {
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

	public static Map<String,Date_Calculation__mdt> getDateCalculationsMap(String soType, String recordType) {
		Map<Integer, Date_Calculation__mdt> tempMap = new Map<Integer, Date_Calculation__mdt>();
		Map<String,Date_Calculation__mdt> returnMap = new Map<String,Date_Calculation__mdt>();
		for (Date_Calculation__mdt dc : allDateCalculations) {
			if (dc.ADCVD_Objects__r.Object_API_Name__c == soType && 
				(String.isBlank(recordType) || dc.ADCVD_Objects__r.Record_Type_Name__c == recordType)) {
				tempMap.put((Integer)dc.Order_of_Execution__c, dc);
			}
		}
		for (Integer i = 0; i < 100; i++) {
			if (tempMap.get(i) != null) {
				returnMap.put(tempMap.get(i).Calculated_Date_Field_Name__c, tempMap.get(i));
			}
		}
		return returnMap;
	}

	public static List<SObject> castRecordsToType(List<SObject> records, String soType) {
	    String listType = 'List<' + soType + '>';
	    List<SObject> returnList = (List<SObject>)Type.forName(listType).newInstance();
	    returnList.addAll(records);
	    return returnList;
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
}