trigger ApplicationContactTrigger on Participant_Contact__c (after update) {
    ApplicationContactTriggerHandler.mainEntry(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, 
            trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
}