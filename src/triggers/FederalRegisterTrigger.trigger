trigger FederalRegisterTrigger on Federal_Register__c (before update, after update, before insert, after insert, before delete) {
	FederalRegisterTriggerHandler.mainEntry(trigger.New, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
}