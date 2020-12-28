@IsTest
private class Oppty_Past_Due_Controller_Test {

	static Map<String, Integer> daysByDayOfTheWeek = new Map<String, Integer>{
		'Monday' => -1,
		'Tuesday' => -2,
		'Wednesday' => -3,
		'Thursday' => -4,
		'Friday' => -5
	};
	static Date today = Date.today();

	@IsTest static void testGetStatus() {
		Account objAccount = new Account(Name = 'Test Account');
		insert objAccount;

		Contact objContact = new Contact(LastName = 'Test', AccountId = objAccount.Id);
		insert objContact;

		Datetime dt = DateTime.newInstance(today, Time.newInstance(0, 0, 0, 0));
		Integer calculatedDays = daysByDayOfTheWeek.get(dt.format('EEEE'));

		Opportunity objOpportunity = new Opportunity(
			AccountId = objAccount.Id,
			Name = 'Test Opportunity',
			StageName = 'Qualification',
			CloseDate = Date.today().addDays(20),
			Assigned_Date__c = calculatedDays != null
				? today.addDays(calculatedDays)
				: today
		);
		insert objOpportunity;

		Oppty_Past_Due_Controller.getStatus(objOpportunity.Id);
	}
}