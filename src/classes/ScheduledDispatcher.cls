/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 *
 **/
 
public class ScheduledDispatcher implements Schedulable {
	
	public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    public void execute(SchedulableContext sc) 
    {
    	Integer c = [SELECT COUNT() FROM CronTrigger WHERE CronJobDetail.JobType = '7'];
    	if(c<100){
        	Type targetType = Type.forName('SchedulePetitionRefresh');   
        	if(targetType!=null) {
            	IScheduleDispatched obj = 
            		(IScheduleDispatched)targettype.newInstance();
            	obj.execute(sc);
               
        	}
    	}	 
    } 
}