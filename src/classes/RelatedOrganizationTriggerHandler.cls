public without sharing class RelatedOrganizationTriggerHandler {
    public static boolean preventRecursion = false;
	public static void mainEntry(List<Related_Organization__c> newList, List<Related_Organization__c> oldList, Map<Id, Related_Organization__c> newMap, 
		Map<Id, Related_Organization__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
		Boolean isBefore, Boolean isAfter) {
		
		if (!AppConfigService.triggerEnabled) {return;}

		if (isBefore && isInsert) {

		}
		if (isBefore && isUpdate) {

		}
		if (isAfter && isUpdate) {

		}
		if(isAfter && isInsert) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			setCaseValuesFromParent(newList);
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(clonedList);
        }
	}

	@TestVisible private static List<Related_Organization__c> clonedList = new List<Related_Organization__c>();

	@TestVisible private static void setCaseValuesFromParent (List<Related_Organization__c> newList) {
		ParentValuesService pvs = new ParentValuesService();
		Map<String,Map<Id,SObject>> parentTypeToChildToParentMap = getParentSObjects(newList);
		for (Related_Organization__c r : newList) {
			Related_Organization__c newR = r.clone(true, false,false,true);
			for (String parentType : parentTypeToChildToParentMap.keySet()) {
				if (newR.get(parentType) == null) {
					continue;
				} else {
					pvs.setCaseValuesFromParent(parentTypeToChildToParentMap.get(parentType).get(newR.Id), newR);
				}
			}
		clonedList.add(newR);
		}
		update clonedList;
	}

	

//TODO: Move to Selector
	@TestVisible private static List<Related_Organization__c> getOrgsWithParentCaseValues(List<Related_Organization__c> newList) {
		List<Related_Organization__c> returnList = new List<Related_Organization__c>();
		for (Related_Organization__c r : [SELECT Id, Petition__c, Investigation__c, ADCVD_Order__c, Segment__c, Litigation__c, Legal_Representation__c, ADCVD_Case_Number__c, ADCVD_Case_Type__c, Country__c, Product__c, CBP_Case_Number__c, 
										Petition__r.ADCVD_Case_Number__c, Petition__r.ADCVD_Case_Type__c, Petition__r.Country__c, Petition__r.Product__c, Petition__r.CBP_Case_Number__c,
										Investigation__r.ADCVD_Case_Number__c, Investigation__r.ADCVD_Case_Type__c, Investigation__r.Country__c, Investigation__r.Product__c, Investigation__r.CBP_Case_Number__c,
										ADCVD_Order__r.ADCVD_Case_Number__c, ADCVD_Order__r.ADCVD_Case_Type__c, ADCVD_Order__r.Country__c, ADCVD_Order__r.Product__c, ADCVD_Order__r.CBP_Case_Number__c,
										Segment__r.ADCVD_Order__c, Segment__r.Suspension_Agreement__c, Segment__r.ADCVD_Case_Number__c, Segment__r.ADCVD_Case_Type__c, Segment__r.Country__c, Segment__r.Product__c, 
										Litigation__r.Petition__r.ADCVD_Case_Number__c, Litigation__r.Petition__r.ADCVD_Case_Type__c, Litigation__r.Petition__r.Country__c, Litigation__r.Petition__r.Product__c, Litigation__r.Petition__r.CBP_Case_Number__c,
										Litigation__r.Investigation__r.ADCVD_Case_Number__c, Litigation__r.Investigation__r.ADCVD_Case_Type__c, Litigation__r.Investigation__r.Country__c, Litigation__r.Investigation__r.Product__c, Litigation__r.Investigation__r.CBP_Case_Number__c,
										Litigation__r.Segment__r.ADCVD_Order__c, Litigation__r.Segment__r.Suspension_Agreement__c, Litigation__r.Segment__r.ADCVD_Case_Number__c, Litigation__r.Segment__r.ADCVD_Case_Type__c, Litigation__r.Segment__r.Country__c, Litigation__r.Segment__r.Product__c 
										//Legal_Representation__r.ADCVD_Case_Number__c, Legal_Representation__r.ADCVD_Case_Type__c, Legal_Representation__r.Country__c, Legal_Representation__r.Product__c, Legal_Representation__r.CBP_Case_Number__c
										FROM Related_Organization__c WHERE Id IN: newList]) {
			returnList.add(r);
		}
		return returnList;
	}

	@TestVisible private static Map<String,Map<Id,SObject>> getParentSObjects(List<Related_Organization__c> newList) {
		List<Related_Organization__c> orgsWithParentCaseValues = getOrgsWithParentCaseValues(newList);
		Map<String,Map<Id,SObject>> returnMap = new Map<String,Map<Id,SObject>>();
		for (Related_Organization__c r : orgsWithParentCaseValues) {
			Map<Id,SObject> childIdToParentMap = new Map<Id,SObject>();
			SObject parent = null;
			String parentType = '';
			String parentRelationshipField = '';
			String litParentRelationshipField = '';
			ParentSortingService pss = new ParentSortingService();
			parentType = pss.getParentSObjectType(r, 'Related_Organization__c');
			System.debug('parentType: ' + parentType);
			if (parentType == 'Litigation__c') {
				litParentRelationshipField = pss.getGrandParentSObjectType(r, 'Litigation__c').replace('__c', '__r');
			}
			parentRelationshipField = parentType.replace('__c', '__r');
			parent = r.getSObject(parentRelationshipField);
			parent.put('Id', r.get(parentType));
			if (parentRelationshipField == 'Litigation__r') {
				parent = r.getSObject(parentRelationshipField).getSObject(litParentRelationshipField);
			}
			if (parentRelationshipField == 'Segment__r') {
				parent.put('ADCVD_Order__c', parent.get('ADCVD_Order__c'));
				parent.put('Suspension_Agreement__c', parent.get('Suspension_Agreement__c'));
			}
			ParentValuesService pvs = new ParentValuesService();
            pvs.setCaseValuesFromParent(parent, parent);
			childIdToParentMap.put((Id)r.get('Id'),parent);
			Map<Id,SObject> tempMap = new Map<Id,SObject>();
			if (returnMap.get(parentType) != null) {
				tempMap = returnMap.get(parentType);
			}
			for (Id childId : childIdToParentMap.keySet()) {
				tempMap.put(childId, childIdToParentMap.get(childId));
			}
			returnMap.put(parentType,tempMap);
		}
		return returnMap;
	}
}