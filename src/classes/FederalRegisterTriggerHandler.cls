public without sharing class FederalRegisterTriggerHandler {
	public static boolean preventRecursion = false;
    public static void mainEntry(List<Federal_Register__c> newList, List<Federal_Register__c> oldList, Map<Id, Federal_Register__c> newMap, 
        Map<Id, Federal_Register__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
        Boolean isBefore, Boolean isAfter){
        if(preventRecursion) {return;}

        if(isAfter && isInsert) {
            recalculateInvestigationFederalRegister(newList,oldMap);
        }
        if(isAfter && isUpdate) {
            recalculateInvestigationFederalRegister(newList,oldMap);
        }
        if(isBefore && isDelete) {
            calculateInvestigationsOnDelete(oldMap);
        }
    }
    @TestVisible private static Set<Id> findInvestigationsInScope(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        Set<Id> investigationIdSet = new Set<Id>();
        for(Federal_Register__c fr : newList) {
            if((fr.Type__c == 'Preliminary' ||(oldMap != null && oldMap.get(fr.Id).Type__c == 'Preliminary')) && fr.Investigation__c != null) {
                investigationIdSet.add(fr.Investigation__c);
            }
        }
        return investigationIdSet;
        
    }
    @TestVisible private static void recalculateInvestigationFederalRegister(List<Federal_Register__c> newList, Map<Id,Federal_Register__c> oldMap) {
        calculateInvestigations(findInvestigationsInScope(newList, oldMap));
    }
    @TestVisible private static void calculateInvestigations(Set<Id> investigationIdSet) {
        List<Investigation__c> investigationsToUpdate = [SELECT Id FROM Investigation__c WHERE Id IN: investigationIdSet];
        database.update(investigationsToUpdate, false);
    }
    @TestVisible private static void calculateInvestigationsOnDelete(Map<Id,Federal_Register__c> oldMap) {
        List<Federal_Register__c> frList = [SELECT Id FROM Federal_Register__c WHERE Id IN: oldMap.keySet()];
        for(Federal_Register__c fr : frList) {
            fr.Do_Delete__c = true;
        }
        update frList;
    }
}