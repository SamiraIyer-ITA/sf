public without sharing class ADCVDOrderTriggerHandler {
    public static boolean preventRecursion = false;
	public static void mainEntry(List<ADCVD_Order__c> newList, List<ADCVD_Order__c> oldList, Map<Id, ADCVD_Order__c> newMap, 
		Map<Id, ADCVD_Order__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, 
		Boolean isBefore, Boolean isAfter) {
		if (preventRecursion) {return;}

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