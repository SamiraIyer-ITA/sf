trigger RecordLogEventTrigger on Record_Log_Event__e (after insert) {
    List<Record_Log__c> logs = new List<Record_Log__c>();
    for (Record_Log_Event__e l: trigger.new) {
        Record_Log__c log = new Record_Log__c();
        log.Data__c = l.Data__c;
        log.Related_Record_Id__c = l.Related_Record_Id__c;
        logs.add(log);
    }

    insert logs;
}