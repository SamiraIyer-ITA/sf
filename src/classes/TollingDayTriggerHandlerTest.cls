/**
 * 
 *    Modified by Cal Smith
 *    on 11/03/2017 
 *    MIL Corporation
 * 
 **/

@isTest
public class TollingDayTriggerHandlerTest {
	private static Date petitionDate {
		get {
			if(petitionDate == null){
				petitionDate = System.today();
				//petitionDate = petitionDate.today();
			}
			return petitionDate;
		}
	}
	private static Date futureTollingDateStart = System.today().addDays(6);
	private static Date futureTollingDateEnd = System.today().addDays(10);

	private static Date pastTollingDateStart = System.today().addDays(-10);
	private static Date pastTollingDateEnd = System.today().addDays(-6);

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
	//calls db everytime
	private static List<Tolling_Day__c> tdList {
		get {
			tdList = [SELECT Id, Start_Date__c, End_Date__c FROM Tolling_Day__c];
			return tdList;
		}
	}

	@isTest static void setFutureDatesInScope(){
		insertAppConfig();
		Test.startTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, null);//nulls prior to insert
		System.assertEquals(TollingDayTriggerHandler.latestDate, null);
		Tolling_Day__c td = TestUtils.createTollingDay(futureTollingDateStart, futureTollingDateEnd, u, true);
		TollingDayTriggerHandler.setDatesInScope(tdList);

		Test.stopTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, futureTollingDateStart);//equal to the tolling day scope
		System.assertEquals(TollingDayTriggerHandler.maxLatestDate, futureTollingDateEnd);
	}
	@isTest static void setPastDatesInScope(){
		insertAppConfig();
		Test.startTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, null);//nulls prior to insert
		System.assertEquals(TollingDayTriggerHandler.latestDate, null);
		Tolling_Day__c td = TestUtils.createTollingDay(pastTollingDateStart, pastTollingDateEnd, u, true);
		TollingDayTriggerHandler.setDatesInScope(tdList);

		Test.stopTest();
		System.assertEquals(TollingDayTriggerHandler.earliestDate, pastTollingDateStart);//equal to the tolling day scope
		System.assertEquals(TollingDayTriggerHandler.maxLatestDate, pastTollingDateEnd);
	}

	@isTest static void recalculatePastPetitionTollingDay(){
		insertAppConfig();
		Test.startTest();
		Tolling_Day__c td = TestUtils.createTollingDay(pastTollingDateStart, pastTollingDateEnd, u, true);//add 5 tolling days
		Test.stopTest();
		//Petition_Filed + 20(standard) + 3 Extension + 5 tollingdays = Petition Calculated_Initiation_Signature__c
		System.assertEquals(petitionDate.addDays(28), [SELECT Calculated_Initiation_Signature__c 
																FROM Petition__c 
																WHERE Petition_Filed__c =: petitionDate
																LIMIT 1].Calculated_Initiation_Signature__c);
	}
	@isTest static void recalculateFuturePetitionTollingDay(){
		insertAppConfig();
		Test.startTest();
		Tolling_Day__c td = TestUtils.createTollingDay(futureTollingDateStart, futureTollingDateEnd, u, true);//add 5 tolling days
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
	
    public static void insertAppConfig() {
    			AppConfig__c app = new AppConfig__c();
                app.Name = 'default';
                app.Primary_Admin__c = 'csmith@milcorp.com'; 
                app.ADCVD_Admin__c = 'calvin.smith@trade.gov';
                app.TriggersEnabled__c = true;
                app.AppEnabled__c = true;
                app.ChronExp_LitigationSegement__c = ' 0 ' + string.valueOf((system.now().addMinutes(30)).minute()) + ' ' + string.valueOf((system.now().addMinutes(30)).hour()) + ' ' + string.valueOf(system.today().day()) + ' ' + string.valueOf(system.today().Month()) + ' ?';
                system.debug('app.ChronExp_LitigationSegement__c = ' + app.ChronExp_LitigationSegement__c);
                app.ChronExpr_PetitionInvestigation__c = '0 0 1 ' +  string.valueOf((system.today().addDays(1)).day()) + ' ' + string.valueOf(system.today().addDays(1).month()) + ' ?';
                system.debug('ChronExpr_PetitionInvestigation__c = ' + app.ChronExpr_PetitionInvestigation__c); 
                insert app;
    } 	
}