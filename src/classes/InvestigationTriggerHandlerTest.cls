@isTest
public class InvestigationTriggerHandlerTest {
	private static Date petitionDate = System.today();
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			System.debug('User u: ' + u);
			return u;
		}
	}
	private static Petition__c p{
		get{
			if (p == null) {
				p = [SELECT Id, Petition_Filed__c, Actual_Initiation_Signature__c, Calculated_Initiation_Signature__c FROM Petition__c LIMIT 1];
			}
			System.System.debug('Petition p: ' + p);
			return p;
		}
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 1
	@isTest static void adCalculatedPreliminarySignature(){
		Test.startTest();
		Investigation__c i = TestUtils.createInvestigation('AD', p, true);
		System.assertEquals(p.Calculated_Initiation_Signature__c.addDays(140), 
			[SELECT Id, Calculated_Preliminary_Signature__c FROM  Investigation__c WHERE Id =: i.Id LIMIT 1].Calculated_Preliminary_Signature__c);
		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c testPetition = TestUtils.createPetition(petitionDate, 'AD ME', true);
	}

	private static String attemptInsert(SObject o){
		String error = '';
		try{
			insert o;
			error = 'Success';
		} catch (DmlException e) {
			error = e.getMessage();
		}
		return error;
	}
}