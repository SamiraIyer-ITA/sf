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
	private static List<Investigation__c> iList {
		get {
			if(iList == null) {
				iList = [SELECT Id, Calculated_Final_Signature__c FROM Investigation__c];
			}
			return iList;
		}
	}
	private static Investigation__c iAD {
		get {
			if(iAD == null) {
				Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('AD');
				iAD = [SELECT Id, RecordTypeId, Prelim_Extension_of_days__c, AD_Investigation_Aligned_To__c, 
							Calculated_Final_Signature__c, Petition__c 
						FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
			}
			return iAD;
		}	
	}
	private static Set<Id> investigationIdSet {
		get {
			if(investigationIdSet == null) {
				investigationIdSet = new Set<Id>();
				for(Investigation__c i : iList) {
					investigationIdSet.add(i.Id);
				}
			}
			return investigationIdSet;
		}
	}

	@isTest static void findInvestigationsInScope(){
		Test.startTest();
		Federal_Register__c fr = TestUtils.createFR(iAD.Id, 'Investigation__c', publishDate.addDays(200), 'Preliminary', false);
		List<Federal_Register__c> frList = new List<Federal_Register__c>();
		frList.add(fr);
		//when given a fr list, the method returns an Investigation Id set
		System.assert(FederalRegisterTriggerHandler.findParentsInScope(frList, null).contains(iAD.Id));
		Test.stopTest();
	}
	@isTest static void recalculateInvestigationFederalRegister(){
		Test.startTest();
		//current Final Signature prior to fr insert
		Date testCalculated_Final_Signature = iAD.Calculated_Final_Signature__c;
		iAD.Final_Extension_of_days__c = 1;//Final_Extension_of_days__c must be set to calculate based on an FR
		update iAD;
		Federal_Register__c fr = TestUtils.createFR(iAD.Id, 'Investigation__c', publishDate.addDays(300), 'Preliminary', true);
		//date in database should have increased based on future fr.Published_Date__c of type Preliminary
		System.assert(testCalculated_Final_Signature < [SELECT Calculated_Final_Signature__c FROM Investigation__c WHERE Id =: iAD.Id].Calculated_Final_Signature__c);
		Test.stopTest();
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c p = TestUtils.createPetition(publishDate, 'AD ME', true);
		Investigation__c testInvestigation = TestUtils.createInvestigation('AD', p, true);
	}
}