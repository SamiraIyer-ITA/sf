trigger RecusalTrigger on Recusal__c (before update, after update, before insert, after insert, before delete) {
	RecusalTriggerHandler.mainEntry(trigger.New, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
}