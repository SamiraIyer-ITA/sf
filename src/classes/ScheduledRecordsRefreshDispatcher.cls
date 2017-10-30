public class ScheduledRecordsRefreshDispatcher implements Schedulable {
	
	public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    public void execute(SchedulableContext sc) 
    {
    	Integer c = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
    	if(c<100){
        	Type targetType = Type.forName('ScheduleRecordsRefresh');   
        	if(targetType!=null) {
            	IScheduleDispatched obj = (IScheduleDispatched)targetType.newInstance();
            	obj.execute(sc);
        	}
    	}	 
    } 
}