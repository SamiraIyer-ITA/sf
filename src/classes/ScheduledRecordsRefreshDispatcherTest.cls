@isTest
private class ScheduledRecordsRefreshDispatcherTest {


    static testMethod void ScheduleRecordsRefresh() {
        Integer c = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
//        System.assertequals(c,0);
        String cronExp = '0 0 1 ' + string.valueOf((System.today().addDays(1)).day()) + ' ' + string.valueOf(System.today().addDays(1).month()) + ' ?';
        ScheduledRecordsRefreshDispatcher srr = new ScheduledRecordsRefreshDispatcher();

        Test.startTest();
            
            String CronTriggerID = System.schedule('Schedule ADCVD Records Refresh', cronExp, srr);

            Crontrigger ctx = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id =: CronTriggerID ];

            // Verify the job has not run
            System.assertEquals(0, ctx.TimesTriggered);
            
            // verifiy the job is scheduled
            Integer c1 = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
//            System.assertEquals(c1, 1);
            
        //  System.abortJob(CronTriggerID); 
        
            if(System.isScheduled() || Test.isRunningTest()) System.abortJob(CronTriggerID);
            
        
        Test.stopTest();
        
        //if(ScheduleRecordsRefresh.execute()) System.abortJob(CronTriggerID);      
        
        Integer c2 = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
//        System.assertEquals(c2,0);
        
        
    }
}