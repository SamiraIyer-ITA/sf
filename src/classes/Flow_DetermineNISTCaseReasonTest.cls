/**
* There is no way to cause an exception, so only positive cases are tested.
*/

@IsTest
private class Flow_DetermineNISTCaseReasonTest {

	@IsTest
	static void determineNISTCaseReason_Positive1() {
		Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User systemAdminUser = TestUtils.createGenericUser('username@test.com', 'username@test.com', systemAdminProfile.Id);

		System.runAs(systemAdminUser) {
			List<Flow_DetermineNISTCaseReason.ResponseVariables> responseList = Flow_DetermineNISTCaseReason.determineNISTCaseReason();
			System.assertEquals('To NIST', responseList[0].caseReason);
		}
	}

	@IsTest
	static void determineNISTCaseReason_Positive2() {
		Profile nistProfile = [SELECT Id FROM Profile WHERE Name='NIST User'];
		User nistUser = TestUtils.createGenericUser('username@test.com', 'username@test.com', nistProfile.Id);

		System.runAs(nistUser) {
			List<Flow_DetermineNISTCaseReason.ResponseVariables> responseList = Flow_DetermineNISTCaseReason.determineNISTCaseReason();
			System.assertEquals('From NIST', responseList[0].caseReason);
		}
	}
}