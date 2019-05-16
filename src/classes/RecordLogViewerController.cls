public with sharing class RecordLogViewerController {

	@AuraEnabled
	public static List<Record_Log__c> getRecordLogs(Id relatedRecordId) {
		return [SELECT Data__c FROM Record_Log__c WHERE Related_Record_Id__c = :relatedRecordId ORDER BY CreatedDate];
	}
}