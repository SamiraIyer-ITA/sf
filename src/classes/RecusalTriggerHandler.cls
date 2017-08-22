public without sharing class RecusalTriggerHandler {
	public static boolean preventRecursion = false;
	public static void mainEntry(List<Recusal__c> newList, List<Recusal__c> oldList, Map<Id, Recusal__c> newMap, 
		Map<Id, Recusal__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
		Boolean isBefore, Boolean isAfter){
		
        if (!AppConfigService.triggerEnabled) {return;}

		if(isBefore && isInsert) {
			syncToPrimary(newList);
		}
		if(isBefore && isUpdate) {
			syncToPrimary(newList);
		}
		if(isAfter && isInsert) {
			
		}
		if (isAfter && isUpdate) {
            //initialize(newList, newMap);
            syncRelatedRecusals(newMap);
        }
	}
		

	//Sync related to primary
    @TestVisible private static void syncToPrimary(List<Recusal__c> newList) {
           SyncUtility.syncObject(newList, null, true);
    }
	
/*    
    //Class properties
    @TestVisible private static Map<Id,ADCVD_RecusalUtility> recUtilMap = new Map<Id,ADCVD_RecusalUtility>();

    //Setup Methods used to set class level variables
    @TestVisible private static void initialize(List<Investigation__c> newList, Map<Id,Investigation__c> newMap) {
        if (newMap != null) {
            ADCVD_RecusalUtility listInstance = ADCVD_RecusalUtility.getInstance(newMap.values());//pass newMap to only get Investigations with an Id
            recUtilMap = listInstance.utilMap;

        }
    }
*/
    //returns a list of Related Recusals to update if the aligned Primary Recusal is updated
    @TestVisible private static void syncRelatedRecusals(Map<Id,Recusal__c> newMap) {
        List<Recusal__c> relatedRecusals = [SELECT Id FROM Recusal__c WHERE Primary_Recusal_Aligned_To__c IN: newMap.keySet()];
        update relatedRecusals;
    }
}