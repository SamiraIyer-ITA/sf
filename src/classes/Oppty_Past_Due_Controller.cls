public class Oppty_Past_Due_Controller {
	/*************************************************************************************************************************************************
	 * Test Class Name : Oppty_Past_Due_Controller_Test
	 * (1) If the "Conference Call Scheduling In Progress" checkbox is unchecked AND Assigned User is blank after one business day from 1st Action
	 * 	   Date a notification is displayed.
	 * (2) The message text is "Please follow up on the opportunity promptly."
	 * (3) If either condition (1 or 2) is met it is captured for reporting purposes.
	 ************************************************************************************************************************************************/

	private static final Date TODAY = Date.today();
	private static final String SATURDAY = 'Saturday';
	private static final String SUNDAY = 'Sunday';

	@AuraEnabled
	public static Boolean getStatus(Id opptyRecordId) {
		List<Opportunity> opps = OpportunitiesSelector.newInstance().selectById(new Set<Id>{ opptyRecordId });
		if (!opps.isEmpty()) {
			Opportunity objOppty = opps[0];
			if (objOppty.Assigned_Date__c != null) {
				Datetime dt = DateTime.newInstance(objOppty.Assigned_Date__c, Time.newInstance(0, 0, 0, 0));
				String dayOfWeek = dt.format('EEEE');
				if (!objOppty.Conference_Call_Scheduling_In_Progress__c
					&& objOppty.Assigned_User__c == null
					&& (objOppty.Assigned_Date__c <= TODAY.addDays(-1)
						&& (dayOfWeek != SATURDAY && dayOfWeek != SUNDAY)
						|| (objOppty.Assigned_Date__c <= TODAY.addDays(-2) && (dayOfWeek == SATURDAY || dayOfWeek == SUNDAY)))
				) {
					return true;
				}
			}
		}
		return false;
	}
}