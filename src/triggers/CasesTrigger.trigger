/*
    Author: Jeff Weyhrauch
    Date: 3-12-19
    Name: CasesTrigger.trigger
    Purpose: Trigger on Case custom object utilizing the FFLIB trigger pattern.
 */
trigger CasesTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    CaseTriggerHandler.mainEntry(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, 
        trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
    fflib_SObjectDomain.triggerHandler(Cases.class);

}