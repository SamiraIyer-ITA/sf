/**
 * Created by Mark Keckeis on 8/12/2020.
 */

@IsTest
private class OpportunityContactRolesSelectorTest {

	@testSetup static void testSetup() {
		Account acc = TestUtils.createAccount(true);
		Contact contact = TestUtils.createContact('Mark Contact', acc.Id, true);
		Opportunity opp = TestUtils.createOpportunity(acc.Id, null, true);
		OpportunityContactRole ocr = TestUtils.createOpportunityContactRole(opp.Id, contact.Id, true,
				null, 'Business User', true );
	}

	@IsTest
	static void selectById_Positive() {
		OpportunityContactRole ocrFROMSOQL = [SELECT Id FROM OpportunityContactRole LIMIT 1];
		Set<Id> ocrSet = new Set<Id>{ocrFROMSOQL.Id};
		List<OpportunityContactRole> ocrFromSelect = OpportunityContactRolesSelector.newInstance().selectById(ocrSet);
		system.assertEquals(ocrFromSelect[0].Role, 'Business User');
	}

	@IsTest
	static void selectByOppId_Positive() {
		Opportunity oppFROMSOQL = [SELECT Id FROM Opportunity LIMIT 1];
		Set<Id> oppSet = new Set<Id>{oppFROMSOQL.Id};
		OpportunityContactRolesSelector ocrSelector = new OpportunityContactRolesSelector();
		List<OpportunityContactRole> ocrFromSelect = ocrSelector.selectByOpportunityId(oppSet, false);
		system.assertEquals(ocrFromSelect[0].Role, 'Business User');
	}
}