/**
 * 
 *    Created by Joshua Moody
 *    on Apr 5 2017
 *    MIL Corporation
 * 
 **/

public without sharing class RecusalTriggerHandler {

	/***********************************************************
   * This class handles all trigger contexts for the Recusal__c
   * object.  It provides methods that:
   * 1. Call services classes sync related recusals to their primary recusals
   ***********************************************************/

	public static void mainEntry(List<Recusal__c> newList, List<Recusal__c> oldList, Map<Id, Recusal__c> newMap, 
		Map<Id, Recusal__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
		Boolean isBefore, Boolean isAfter){
		
        if (!AppConfigService.triggerEnabled) {return;}

		if(isBefore && isInsert) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			syncToPrimary(newList);
		}
		if(isBefore && isUpdate) {
			newList = new LockedRecordHandler().removeLockedRecords(newList);
			syncToPrimary(newList);
		}
		if(isAfter && isInsert) {
			
		}
		if (isAfter && isUpdate) {
            syncRelatedRecusals(newMap);
        }
	}
		

	//Sync related to primary
    @TestVisible private static void syncToPrimary(List<Recusal__c> newList) {
           SyncUtility.syncObject(newList, null, true);
    }
	
    //returns a list of Related Recusals to update if the aligned Primary Recusal is updated
    @TestVisible private static void syncRelatedRecusals(Map<Id,Recusal__c> newMap) {
        List<Recusal__c> relatedRecusals = [SELECT Id FROM Recusal__c WHERE Primary_Recusal_Aligned_To__c IN: newMap.keySet() AND Locked__c =: false];
        update relatedRecusals;
    }
}