@isTest
public with sharing class ADCVD_TollingDayUtilityTest {
	private static Date holidayDate = System.today();
	private static Date tollingDateStart = System.today().addDays(-10);
	private static Date tollingDateEnd = System.today().addDays(-4);
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
	@isTest static void deadlineWithTollingDays(){
		for(integer i = 0; i<7; i++){
			Date myVariableDate = System.today().addDays(-7).addDays(i);
			Date myDeadline = System.today();
			if(!ADCVD_TollingDayUtility.isTollingDay(myVariableDate)){
				System.assertEquals(ADCVD_TollingDayUtility.deadlineWithTollingDays(myVariableDate, myDeadline), myDeadline);
			} else {
				//first iteration has 4 tolling days, reduces by i for each iteration
				System.assertEquals(ADCVD_TollingDayUtility.deadlineWithTollingDays(myVariableDate,myDeadline), myDeadline.addDays(4).addDays(-i));
			}
		}
	}
	@isTest static void getCalculatedDate(){
		//With 11 loops, the testing time will include the tolling period created by class variables
		//Each iteration advances one day, shortening the request but comparing against the same tolling period
		//This will cover scenarios of start prior to tolling start, on tolling start, during tolling, on tolling end date, and with no tolling days
		integer loops = 11;
		for(integer i = 0; i<loops; i++){
			Date myVariableDate = System.today().addDays(-loops).addDays(i);
			Date myDeadline = System.today();
			Date verifiedDeadline = System.today();
			Boolean rollForward = false;
			integer totalTollingDays = 0;
			integer rolledForwardDays = 0;
			integer rolledBackDays = 0;
			//count tolling days in scope
			for(integer j = 0; j<(loops-i); j++){
				Date tempDate = myVariableDate.addDays(j);
				if(ADCVD_TollingDayUtility.isTollingDay(tempDate)){
					totalTollingDays ++;
				}
			}
			//after tolling adjustment, count days until workday
			while(!ADCVD_TollingDayUtility.isWorkingDay(verifiedDeadline.addDays(totalTollingDays+rolledForwardDays))){
				rolledForwardDays++;
			}
			//after tolling adjustment, count days back until workday
			while(!ADCVD_TollingDayUtility.isWorkingDay(verifiedDeadline.addDays(totalTollingDays+rolledBackDays)) && !rollForward){
				if(!ADCVD_TollingDayUtility.isTollingDay(verifiedDeadline.addDays(totalTollingDays+rolledBackDays))){
					rolledBackDays--;
				} else {
					rollForward = true;
				}
			}
			//
			System.assertEquals(ADCVD_TollingDayUtility.getCalculatedDate(myVariableDate, myDeadline, true), verifiedDeadline.addDays(totalTollingDays).addDays(rolledForwardDays));
			if(!rollForward){
				System.assertEquals(ADCVD_TollingDayUtility.getCalculatedDate(myVariableDate, myDeadline, rollForward), verifiedDeadline.addDays(totalTollingDays).addDays(rolledBackDays));
			}
		}
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
		User u = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Holiday h = new Holiday(ActivityDate = holidayDate, Name = 'Every day is a holiday');
		insert h;
		Tolling_Day__c td = TestUtils.createTollingDay(tollingDateStart, tollingDateEnd, u, true);
	}
}