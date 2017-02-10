@isTest
public class TollingDayTriggerHandlerTest {
	private static Date petitionDate = System.today();
	private static Date tollingDateStart = System.today().addDays(6);
	private static Date tollingDateEnd = System.today().addDays(13);

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
	//calls db everytime
	private static List<Petition__c> petitionList {
		get {
			petitionList = [SELECT Id, Calculated_Initiation_Signature__c FROM Petition__c];
			return petitionList;
		}
	}
	private static Set<Id> petitionSet {
		get {
			if(petitionSet == null) {
				petitionSet = new Set<Id>();
				petitionSet.add(petitionList[0].Id);
			}
			return petitionSet;
		}
	}
	//calls db everytime
	private static List<Tolling_Day__c> tdList {
		get {
			tdList = [SELECT Id, Start_Date__c, End_Date__c FROM Tolling_Day__c];
			return tdList;
		}
	}

	@isTest static void setDatesInScope(){
		Test.startTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, null);//nulls prior to insert
		System.assertEquals(TollingDayTriggerHandler.latestDate, null);
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
		TollingDayTriggerHandler.setDatesInScope(tdList);
		System.assertEquals(TollingDayTriggerHandler.earliestDate, tollingDateStart);//equal wo the tolling day scope
		System.assertEquals(TollingDayTriggerHandler.latestDate, tollingDateEnd);
		Test.stopTest();
	}
	@isTest static void findPetitionsInScope(){
		Test.startTest();
		Petition__c p = TestUtils.createPetition(tollingDateStart, 'AD ME', true);//insert Petition starting on tolling day
		//create new Tolling Day List in memory for test
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, false);//no insert needed
		tdList.add(td);
		System.assertEquals(TollingDayTriggerHandler.findPetitionsInScope(tdList),petitionSet);//compare petitions from method to inserted set
		Test.stopTest();
	}
	@isTest static void recalculatePetitionTollingDay(){
		Test.startTest();
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(1);//set Petition Filed to Monday
		insert p;
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);//add 8 tolling days
		Test.stopTest();
		//Petition_Filed + 20(standard) + 8 tollingdays = Petition Calculated_Initiation_Signature__c
		System.assertEquals(p.Petition_Filed__c.addDays(28), petitionList[0].Calculated_Initiation_Signature__c);
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
	}
}