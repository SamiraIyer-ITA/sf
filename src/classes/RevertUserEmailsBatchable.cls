public with sharing class RevertUserEmailsBatchable implements Database.Batchable<SObject> {

	public Database.QueryLocator start( Database.BatchableContext context ) {
		String strQuery = 'SELECT id, userName, email FROM User WHERE isActive = true AND (Profile.Name = \'System Administrator\' OR Profile.Name = \'Salesforce Developer\') ';
		return Database.getQueryLocator(strQuery);
	}

	public void execute( Database.BatchableContext context, List<User> users ) {
		for ( User u : users ) {
			u.Email = u.Email.replace('@example.com', '').replace('=', '@');
		}
		update users;
	}

	public void finish( Database.BatchableContext context ) {
	}

}