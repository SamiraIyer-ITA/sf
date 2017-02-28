public without sharing class FederalRegisterTriggerHandler {
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Federal_Register__c> newList, List<Federal_Register__c> oldList, Map<Id, Federal_Register__c> newMap, 
        Map<Id, Federal_Register__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isAfter && isInsert) {
            recalculateParentsOfFederalRegister(newList,oldMap);
        }
        if(isAfter && isUpdate) {
            recalculateParentsOfFederalRegister(newList,oldMap);
        }
        if(isBefore && isDelete) {
            calculateInvestigationsOnDelete(oldMap);
        }
    }
    @TestVisible private static Set<Id> findParentsInScope(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        Set<Id> parentIdSet = new Set<Id>();
        for(Federal_Register__c fr : newList) {
            if(fr.Investigation__c != null) {
                parentIdSet.add(fr.Investigation__c);
            }
            if(fr.Segment__c != null) {
                parentIdSet.add(fr.Segment__c);
            } 
        }
        return parentIdSet;
        
    }
    @TestVisible private static void recalculateParentsOfFederalRegister(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        Set<Id> parentIdSet = findParentsInScope(newList, oldMap);
        calculateInvestigations(parentIdSet);
        calculateSegments(parentIdSet);
    }
    @TestVisible private static void calculateInvestigations(Set<Id> parentIdSet) {
        List<Investigation__c> investigationsToUpdate = [SELECT Id FROM Investigation__c WHERE Id IN: parentIdSet];
        database.update(investigationsToUpdate, false);
    }
    @TestVisible private static void calculateSegments(Set<Id> parentIdSet) {
        List<Segment__c> segmentsToUpdate = [SELECT Id FROM Segment__c WHERE Id IN: parentIdSet];
        database.update(segmentsToUpdate, false);
    }
    @TestVisible private static void calculateInvestigationsOnDelete(Map<Id,Federal_Register__c> oldMap) {
        List<Federal_Register__c> frList = [SELECT Id FROM Federal_Register__c WHERE Id IN: oldMap.keySet()];
        for(Federal_Register__c fr : frList) {
            fr.Do_Delete__c = true;
        }
        update frList;
    }
}