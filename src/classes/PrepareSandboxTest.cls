@IsTest
private class PrepareSandboxTest {

	@IsTest
	static void test_post_copy() {
		Profile p = [ SELECT Id FROM Profile WHERE Name = 'System Administrator' ];
		User user1;
		System.runAs( new User( Id = UserInfo.getUserId() ) ) {
			user1 = createNewUser( p.Id, 'Alpha', 'User 1', 'user_1=salesforce.com@example.com' );
			insert user1;
		}

		Test.startTest();
			Test.testSandboxPostCopyScript(
				new PrepareSandbox(), // apex class to run
				'00D1a000040BlpQ', // org id
				'00D90000000KY45', // sandbox id
				'My Sandbox' // sandbox name
			);
		Test.stopTest();
		user1 = [ SELECT Id, Email FROM User WHERE Id = :user1.Id ];
		System.assertEquals(user1.Email, 'user_1@salesforce.com');
	}

	private static User createNewUser( Id profileId, String firstName, String lastName, String email ) {
		Integer rand = Math.round( Math.random() * 1000 );
		return new User(
			IsActive = true,
			ProfileId = profileId,
			Alias = firstName.substring(0,1) + lastName.substring(1,5),
			FirstName = firstName,
			LastName = lastName,
			Email = email,
			Username = rand + email,
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'America/Chicago'
		);
	}

}