public class Oppty_Past_Due_Controller {
    /*************************************************************************************************************************************************
     * Test Class Name : Oppty_Past_Due_Controller_Test
	 * (1) If the "Conference Call Scheduling In Progress" checkbox is unchecked AND Assigned User is blank after one business day from 1st Action 
     * 	   Date a notification is displayed.
     * (2) The message text is "Please follow up on the opportunity promptly."
     * (3) If either condition (1 or 2) is met it is captured for reporting purposes.
     ************************************************************************************************************************************************/
	@AuraEnabled
    public static Boolean getStatus(Id opptyRecordId) {
        if(null != opptyRecordId) {
            Opportunity objOppty = [Select Id, Name, Assigned_User__c, Assigned_Date__c, Conference_Call_Scheduling_In_Progress__c From Opportunity Where Id =: opptyRecordId LIMIT 1];
            
			if(null != objOppty) {
                System.debug('Debug Log for objOppty.Assigned_Date__c'+objOppty.Assigned_Date__c);
        		Datetime dt = DateTime.newInstance(objOppty.Assigned_Date__c, Time.newInstance(0, 0, 0, 0));
                String dayOfWeek=dt.format('EEEE');
                System.debug('Day : ' + dayOfWeek);
				if(objOppty.Conference_Call_Scheduling_In_Progress__c == false 
                   && null == objOppty.Assigned_User__c
                   && (
                       objOppty.Assigned_Date__c <= Date.today().addDays(-1) && (dayOfWeek != 'Saturday' && dayOfWeek != 'Sunday')
                   		|| 
                       (objOppty.Assigned_Date__c <= Date.today().addDays(-2) && (dayOfWeek == 'Saturday' || dayOfWeek == 'Sunday'))
                   	  )
                   )
				{
					return true;
				}
            }
        }
        return false;
    } 
}