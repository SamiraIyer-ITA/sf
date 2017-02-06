@isTest
public with sharing class ADCVD_TollingDayUtilityTest {
	private static Date holidayDate = System.today();
	private static Date tollingDateStart = System.today().addDays(-9);
	private static Date tollingDateEnd = System.today().addDays(-3);
	@isTest static void tollingDayList(){
		System.assert(ADCVD_TollingDayUtility.tollingDayList.size() == 1);	
	}
	@isTest static void tollingDaySet(){
		System.assert(ADCVD_TollingDayUtility.tollingDaySet.size() == 7, ADCVD_TollingDayUtility.tollingDaySet.size());
	}
	@isTest static void holidaySet(){
		System.assert(ADCVD_TollingDayUtility.holidaySet.contains(holidayDate));
	}
	@isTest static void isHoliday(){
		System.assert(ADCVD_TollingDayUtility.isHoliday(holidayDate));
		System.assertEquals(false, ADCVD_TollingDayUtility.isWorkingDay(holidayDate));
	}
	@isTest static void isTollingDay(){
		System.assert(ADCVD_TollingDayUtility.isTollingDay(tollingDateStart));
	}
	@isTest static void rollForwardNextBusinessDay(){
		for(integer i = 0; i<7; i++) {
			Date myVariableDate = System.today().addDays(i);
			if(!ADCVD_TollingDayUtility.isWorkingDay(myVariableDate)){
				System.assert(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(myVariableDate) > System.today());
			}
			System.assert(ADCVD_TollingDayUtility.rollForwardNextBusinessDay(myVariableDate) >= myVariableDate);
		}
	}
	@isTest static void rollBackPreviousBusinessDay(){
		for(integer i = 0; i<7; i++) {
			Date myVariableDate = System.today().addDays(i);
			if(ADCVD_TollingDayUtility.isWorkingDay(myVariableDate)){
				System.assert(ADCVD_TollingDayUtility.rollBackPreviousBusinessDay(myVariableDate) >= myVariableDate);
			} else if(ADCVD_TollingDayUtility.isTollingDay(myVariableDate)) {
				System.assert(ADCVD_TollingDayUtility.rollBackPreviousBusinessDay(myVariableDate) >= myVariableDate);
			} else {
				System.assert(ADCVD_TollingDayUtility.rollBackPreviousBusinessDay(myVariableDate) <= myVariableDate);
			}
		}
	}
	@isTest static void getCacluatedDate(){

	}
	@isTest static void isWorkingDay() {
		integer validations = 0;
		for(integer i = 0; i<7; i++) {
			Date myVariableDate = System.today().addDays(-i);
			if(!ADCVD_TollingDayUtility.isWeekday(myVariableDate)) {
				System.assertEquals(false, ADCVD_TollingDayUtility.isWorkingDay(myVariableDate));
			}
			if(ADCVD_TollingDayUtility.isTollingDay(myVariableDate)) {
				System.assertEquals(false, ADCVD_TollingDayUtility.isWorkingDay(myVariableDate));	
			}
		}
	}
	@testSetup static void dataSetup() {
		Test.startTest();
		User u = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Holiday h = new Holiday(ActivityDate = holidayDate, Name = 'Every day is a holiday');
		insert h;
		system.runAs(u) {
			Tolling_Day__c td = new Tolling_Day__c(Start_Date__c = tollingDateStart, End_Date__c = tollingDateEnd);
			insert td;
		}
	}
}