@IsTest
private class SObjectsFieldMapperTest {

	@TestSetup
	static void setup() {
		Account acct = new Account(
			Name = 'Test Account',
			Description = 'Test Description'
		);
		insert acct;
		Contact con = new Contact(
			AccountId = acct.Id,
			FirstName = 'Test',
			LastName = 'Contact 1',
			Email = 'testContact1@test.org'
		);
		insert con;
	}

	@IsTest
	static void testFieldMapping() {
		Contact con = [SELECT AccountId, Account.Description FROM Contact LIMIT 1];
		Contact testContact  = (Contact) new MockContactMapper().getTargetRecord(con);
		System.assertEquals(con.AccountId, testContact.AccountId);
		System.assertEquals('Test', testContact.FirstName);
		System.assertEquals('Contact 2', testContact.LastName);
		System.assertEquals(con.Account.Description, testContact.Description);
		System.assertEquals('Test Title', testContact.Title);
	}

	private class MockContactMapper extends SObjectsFieldMapper {

		public override Schema.SObjectType targetSObjectType() {
			return Contact.SObjectType;
		}

		public override Map<String, String> targetFieldsBySourceFields() {
			return new Map<String, String>{
				'AccountId' => 'AccountId',
				'Account.Description' => 'Description'
			};
		}

		public override void setAdditionalTargetRecordFields(SObject targetRecord) {
			targetRecord.put('Email', 'testContact2@test.org');
			targetRecord.put('FirstName', 'Test');
			targetRecord.put('LastName', 'Contact 2');
		}

		public override void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {
			targetRecord.put('Title', 'Test Title');
		}
	}
}