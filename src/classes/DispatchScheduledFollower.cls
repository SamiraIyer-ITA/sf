/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 **/
 
public with sharing class DispatchScheduledFollower Implements Schedulable {
		
	public Interface IScheduleDispatched 
    { 
        void execute(SchedulableContext sc); 
    } 
    
    public void execute(SchedulableContext sc) 
    {
        Type targetType = Type.forName('ScheduleLitigationSegmentRefresh');   
        if(targetType!=null) {
            IScheduleDispatched obj = 
            	(IScheduleDispatched)targettype.newInstance();
            obj.execute(sc);   
        } 
    } 
}