trigger ADCVDCaseTrigger on ADCVD_Case__c (before update, after update, before insert, after insert, before delete) {
    ADCVDCaseTriggerHandler.mainEntry(trigger.New, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isBefore, trigger.isAfter);
}