trigger RelatedOrganizationTrigger on Related_Organization__c (before update, after update, before insert, after insert, before delete) {
	RelatedOrganizationTriggerHandler.mainEntry(trigger.New, trigger.newMap, trigger.isInsert, trigger.isBefore, trigger.isAfter);
}