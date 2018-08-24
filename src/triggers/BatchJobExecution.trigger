trigger BatchJobExecution on BatchJobScheduler__c (after insert,before insert) {
    try{
        if(Trigger.isAfter)
        {
            BatchTriggerFlag__c flag = BatchTriggerFlag__c.getInstance('isActiveFlag');
            if(Trigger.isInsert && flag.isActive__c != true)
            {
                for(BatchJobScheduler__c batch: Trigger.New)
                {
                 	flag.RecordId__c = batch.Id;
                    flag.isActive__c = true;
                }
                Update flag;
                Id batchId = Database.executeBatch(new mccdBatchProcess(),99);
            }
            if(flag.isActive__c == true)
            {
                System.debug(' ** An Active process is running ** ');
            }
        }
        if(Trigger.isBefore)
        {
            for(BatchJobScheduler__c bj : Trigger.new)
            {
                bj.Job_Status__c = 'Processing';
            }
        }
    }
    Catch(Exception Err)
    {
        System.debug('The following err :'+err);
    }
}