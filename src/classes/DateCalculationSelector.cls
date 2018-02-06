/**
 * 
 *    Created by Joshua Moody
 *    on Aug 3 2017
 *    MIL Corporation
 * 
 **/

public without sharing class DateCalculationSelector {

	/******************************************************************
	* This class maps information needed for the DateCalculationService
	* This class provides methods to:
	* 1. Map Federal Registers via a class so that one parent Id is mapped to
	* each of it's Federal Registers
	* 2. Map Petitions, Investigations, and Date Calculation custom metadata
	******************************************************************/

/*
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
*/
	public static Map<ID,ADCVD_FederalRegisterUtility> getFrUtilMap(List<SObject> soList) {
		ADCVD_FederalRegisterUtility listInstance = ADCVD_FederalRegisterUtility.getInstance(soList);
		Map<ID,ADCVD_FederalRegisterUtility> frUtilMap = listInstance.utilMap;
		return frUtilMap;
	}

/*
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
*/

	public static Map<Id,Petition__c> getPetitionsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Petition__c> returnMap = new Map<Id,Petition__c>();
		System.debug('*** getPetitionsInScope soList: ' + soList);
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = Utils.castRecordsToType(soList, soType);
		for (SObject so : Utils.castRecordsToType(soList, soType)) {
			tempIdSet.add((Id)so.get(lookupFieldName));
		}
		for (Petition__c p : PetitionSelector.getPetitionsInContext(tempIdSet, Utils.allFieldsSet('Petition__c'), true)) {
			if (tempIdSet.contains(p.Id)) {
				returnMap.put(p.Id, p);
			}
		}
		return returnMap;
	}

	public static Map<Id,Investigation__c> getInvestigationsInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,Investigation__c> returnMap = new Map<Id,Investigation__c>();
		Set<Id> tempIdSet = new Set<Id>();
		List<SObject> castRecords = Utils.castRecordsToType(soList, soType);
		for (SObject so : castRecords) {
			tempIdSet.add((Id)so.get(lookupFieldName));
		}
		for (Investigation__c i : InvestigationSelector.allInvestigations) {
			if (tempIdSet.contains(i.Id)) {
				returnMap.put(i.Id, i);
			}
		}
		return returnMap;
	}
/*
	public static Map<Id,List<SObject>> getIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,List<SObject>> returnMap = new Map<Id,List<SObject>>();
		Set<Id> tempIdSet = new Set<Id>();
		for (SObject so :  Utils.castRecordsToType(soList, soType)) {
			tempIdSet.add((Id)so.get('Id'));
		}
		for (Issue__c i : IssueSelector.getIssuesInContext(tempIdSet, Utils.allFieldsSet('Issue__c'), true)) {
			List<SObject> tempList = new List<SObject>();
			tempList = returnMap.get((Id)i.get(lookupFieldName)) != null ? returnMap.get((Id)i.get(lookupFieldName)) : tempList;
			tempList.add(i);
			returnMap.put((Id)i.get(lookupFieldName), tempList);
		}
		return returnMap;
	}

	public static Map<Id,Issue__c> getIncompleteIssuesInScope(List<SObject> soList, String soType, String lookupFieldName) {
		Map<Id,List<Issue__c>> issuesMap = (Map<Id,List<Issue__c>>)getIssuesInScope(soList, soType, lookupFieldName);
		Map<Id,Issue__c> returnMap = getIncompleteIssues(soList, issuesMap, lookupFieldName);
		return returnMap;
	}

	public static Map<Id,Issue__c> getIncompleteIssues(List<SObject> soList, Map<Id,List<Issue__c>> issueListMap, String lookupFieldName) {
		Map<Id,Issue__c> returnMap = new Map<Id,Issue__c>();
		Map<Id,Map<String,Issue__c>> parentIdToCompletedIssues = new Map<Id,Map<String,Issue__c>>();
		for (SObject so : soList) {
			List<Issue__c> tempList = issueListMap.get(so.Id) != null ? issueListMap.get(so.Id) : new List<Issue__c>();
			Map<String,Issue__c> tempMap = parentIdToCompletedIssues.get(so.Id) != null ? parentIdToCompletedIssues.get(so.Id) : new Map<String,Issue__c>();
			for (Issue__c i : tempList) {
				if ((tempMap.get(i.Type__c) == null || tempMap.get(i.Type__c).Completed_Issue__c)) {
					tempMap.put(i.Type__c, i);
				}
			}
			for (Issue__c i : tempMap.values()) {
				if (!i.Completed_Issue__c) {
					returnMap.put(i.Id, i);
				}
			}
		}
		return returnMap;
	}
*/
	public static Map<String,Date_Calculation__mdt> getDateCalculationsMap(String soType, String recordType) {
		Map<Integer, Date_Calculation__mdt> tempMap = new Map<Integer, Date_Calculation__mdt>();
		Map<String,Date_Calculation__mdt> returnMap = new Map<String,Date_Calculation__mdt>();
		Integer numberOfCalculations = 0;
		for (Date_Calculation__mdt dc : CustomMetadataSelector.allDateCalculations) {
			if (dc.ADCVD_Objects__r.Object_API_Name__c == soType && dc.Active_Calculation__c &&
				(String.isBlank(recordType) || dc.ADCVD_Objects__r.Record_Type_Name__c == recordType)) {
				tempMap.put((Integer)dc.Order_of_Execution__c, dc);
				numberOfCalculations = numberOfCalculations == 0 ? (Integer) dc.ADCVD_Objects__r.Number_of_Date_Calculations__c : numberOfCalculations;
			}
		}
		for (Integer i = 0; i <= numberOfCalculations; i++) {
			if (tempMap.get(i) != null) {
				returnMap.put(tempMap.get(i).QualifiedAPIName, tempMap.get(i));
			}
		}
		return returnMap;
	}
}