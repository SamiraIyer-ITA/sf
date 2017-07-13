public without sharing class DateCalculationSelector {

	public static Map<String,List<SObject>> allRecordsMap {
		get {
			if (allRecordsMap == null) {
				allRecordsMap = new Map<String,List<SObject>>();
				allRecordsMap.put('Petition__c', PetitionSelector.allPetitions);
				allRecordsMap.put('Investigation__c', InvestigationSelector.allInvestigations);
				allRecordsMap.put('Issue__c', IssueSelector.allIssues);
			}
			return allRecordsMap;
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

	public static Map<Id,SObject> getSObjectsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,SObject> returnMap = new Map<Id,SObject>();
		Set<Id> tempIdSet = new Set<Id>();
		if (lookupFieldName == null) {return returnMap;}
		for (SObject so : Utils.castRecordsToType(soList, soType)) {
			tempIdSet.add((Id)so.get(lookupFieldName));
		}
		for (SObject so : allRecordsMap.get(soType)) {
			if (tempIdSet.contains(so.Id)) {
				returnMap.put(so.Id, so);
			}
		}
		return returnMap;
	}
/*
	public static Map<Id,Petition__c> getPetitionsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
		System.debug('*** getPetitionsInScope soList: ' + soList);
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = castRecordsToType(soList, soType);
		for (SObject so : castRecordsToType(soList, soType)) {
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
*/
	public static Map<Id,SObject> getIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,SObject> returnMap = new Map<Id,SObject>();
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = Utils.castRecordsToType(soList, soType);
		for (SObject so : castRecords) {
			tempIdSet.add((Id)so.get('Id'));
		}
		for (SObject so : castRecords) {
			if (tempIdSet.contains((Id)so.get(lookupFieldName))) {
				returnMap.put(so.Id, so);
			}
		}
		return returnMap;
	}

	public static Map<Id,Issue__c> getCompletedIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Issue__c> returnMap = (Map<Id,Issue__c>)getIssuesInScope(soList, soType, lookupFieldName);
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
		for (Issue__c i : IssueSelector.allIssues) {
			Map<String,Boolean> tempMap = new Map<String,Boolean>();
			if (tempIdSet.contains((Id)i.get(lookupFieldName))) {
				if (tempMap.get(i.Type__c) == null || tempMap.get(i.Type__c) == true) {
					tempMap.put(i.Type__c, i.Completed_Issue__c);
					parentIdToCompletedIssues.put((Id)i.get(lookupFieldName), tempMap);
				}
			}
		}
		return parentIdToCompletedIssues;
	}

	public static Map<String,Date_Calculation__mdt> getDateCalculationsMap(String soType, String recordType) {
		Map<Integer, Date_Calculation__mdt> tempMap = new Map<Integer, Date_Calculation__mdt>();
		Map<String,Date_Calculation__mdt> returnMap = new Map<String,Date_Calculation__mdt>();
		for (Date_Calculation__mdt dc : CustomMetadataSelector.allDateCalculations) {
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
}