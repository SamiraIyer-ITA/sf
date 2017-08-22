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
            StaffingAssignmentExtension createStaff = new StaffingAssignmentExtension(newList);
        }
	}
}