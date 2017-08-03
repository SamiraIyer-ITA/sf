@isTest
public class TollingDayTriggerHandlerTest {
	private static Date petitionDate {
		get {
			if(petitionDate == null){
				petitionDate = System.today();
				petitionDate = petitionDate.toStartOfWeek().addDays(1);
			}
			return petitionDate;
		}
	}
	private static Date tollingDateStart = System.today().addDays(6);
	private static Date tollingDateEnd = System.today().addDays(10);

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

		Test.stopTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, tollingDateStart);//equal to the tolling day scope
		System.assertEquals(TollingDayTriggerHandler.latestDate, tollingDateEnd);
	}
	@isTest static void findPetitionsInScope(){
		Test.startTest();
		//create new Tolling Day List in memory for test
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, false);//no insert needed
		tdList.add(td);

		Test.stopTest();
		System.assertEquals(TollingDayTriggerHandler.findPetitionsInScope(tdList),petitionSet);//compare petitions from method to inserted set
	}
	@isTest static void recalculatePetitionTollingDay(){
		Test.startTest();
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);//add 5 tolling days
		Test.stopTest();
		//Petition_Filed + 20(standard) + 3 Extension + 5 tollingdays = Petition Calculated_Initiation_Signature__c
		System.assertEquals(petitionDate.addDays(28), [SELECT Calculated_Initiation_Signature__c 
																FROM Petition__c 
																WHERE Petition_Filed__c =: petitionDate
																LIMIT 1].Calculated_Initiation_Signature__c);
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', true);//TestUtils creates with a 3 day extension
		System.debug('Petition_Filed__c ' + p.Petition_Filed__c);
	}
}