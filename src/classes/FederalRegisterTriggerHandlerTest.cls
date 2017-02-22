@isTest
public class FederalRegisterTriggerHandlerTest {
	private static Date publishDate = System.today();
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			return u;
		}
	}
	private static List<Investigation__c> investigationList {
		get {
			if(investigationList == null) {
				investigationList = [SELECT Id, Calculated_Final_Signature__c FROM Investigation__c];
			}
			return investigationList;
		}
	}
	private static Set<Id> investigationIdSet {
		get {
			if(investigationIdSet == null) {
				investigationIdSet = new Set<Id>();
				for(Investigation__c i : investigationList) {
					investigationIdSet.add(i.Id);
				}
			}
			return investigationIdSet;
		}
	}

	@isTest static void findInvestigationsInScope(){
		Test.startTest();
		Federal_Register__c fr = TestUtils.createFR(publishDate.addDays(200), false);
		fr.Investigation__c = investigationList[0].Id;
		List<Federal_Register__c> frList = new List<Federal_Register__c>();
		frList.add(fr);
		//when given a fr list, the method returns an Investigation Id set
		System.assert(FederalRegisterTriggerHandler.findInvestigationsInScope(frList).contains(investigationList[0].Id));
		Test.stopTest();
	}
	@isTest static void recalculateInvestigationFederalRegister(){
		Test.startTest();
		Federal_Register__c fr = TestUtils.createFR(publishDate.addDays(300), false);
		//curent Final Signature prior to fr insert
		Date testCalculated_Final_Signature = investigationList[0].Calculated_Final_Signature__c;
		fr.Investigation__c = investigationList[0].Id;
		insert fr;
		//date in database should have increased based on future fr.Preliminary_FR_Published__c
		System.assert(testCalculated_Final_Signature < [SELECT Calculated_Final_Signature__c FROM Investigation__c WHERE Id =: investigationList[0].Id].Calculated_Final_Signature__c);
		Test.stopTest();
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c p = TestUtils.createPetition(publishDate, 'AD ME', true);
		Investigation__c testInvestigation = TestUtils.createInvestigation('AD', p, true);
	}
}