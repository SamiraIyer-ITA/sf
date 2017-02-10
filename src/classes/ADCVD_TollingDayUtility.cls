public without sharing class ADCVD_TollingDayUtility {
	@TestVisible private static List<Tolling_Day__c> tollingDayList {
		get {
			if(tollingDayList == null) {
				tollingDayList = [SELECT Id, Start_Date__c, End_Date__c FROM Tolling_Day__c];
			}
			return tollingDayList;
		}
	}
	@TestVisible private static Set<Date> tollingDaySet {
		get {
			if(tollingDaySet == null) {
				tollingDaySet = new Set<Date>();
				for(Tolling_Day__c td: tollingDayList) {
					Date dt = td.Start_Date__c;
					while(dt <= td.End_Date__c) {
						tollingDaySet.add(dt);
						dt = dt.addDays(1);
					}
				}
			}
			return tollingDaySet;
		}
	}

	@TestVisible private static Set<Date> holidaySet {
		get {
			if(holidaySet == null) {
				holidaySet = new Set<Date>();
				for(Holiday h: [SELECT ActivityDate FROM Holiday]) {
					holidaySet.add(h.ActivityDate);
				}
			}
			return holidaySet;
		}
	}
	/* Method used to determine the new value of the deadline tolling day, holiday and weekends accounted for
	*  Input Params: 	startDate:  	should be passed in to determine how many of the days are in scope 
	*					deadline: 	 	this is the current deadline (without tolling days in scope)
	*					rollforward: 	boolean to either roll the date forward or back to next or previous working day
	*  Return Value: New deadline
	*  (e.g. petition start should be 'start date' for a petition)
	*/ 
	public static Date getCalculatedDate(Date startDate, Date deadline, Boolean rollfoward) {
		deadline = deadlineWithTollingDays(startDate, deadline);
		if(rollfoward) {
			deadline = rollForwardNextBusinessDay(deadline);
		} else {
			deadline = rollBackPreviousBusinessDay(deadline);
		}
		return deadline;
	}

	/* Method used to determine the value of the deadline with tolling days taken into account
	*  Input Params: 	startDate:  	should be passed in to determine how many of the days are in scope 
	*					deadline: 	 	this is the current deadline (without tolling days in scope)
	*  Return Value: New deadline
	*  (e.g. petition start should be 'start date' for a petition)
	*/ 
	@TestVisible private static Date deadlineWithTollingDays(Date startDate, Date deadline){
		//iterate through each tolling day in scope
		List<Date> dateList = new List<Date>(tollingDaySet);
		dateList.sort(); //needs to be ordered
		for(Date td: dateList) {
			system.debug(td);
			if (startDate == td || deadline == td || (startDate < td && td < deadline)) { //scenario 3: tolling day = record initiation or record end
				deadline = deadline.addDays(1);
				system.debug(true);
			} else if(startDate > td) { //scenario 1: tolling day occured before the record was initiated
				continue; //process next tolling day
				system.debug(true);
			} else if (deadline < td) { //scenario 2: tolling day after the record ended
				continue;
				system.debug(true);
			}
		}
		return deadline;
	}
	@TestVisible private static Boolean isWorkingDay(Date dt) {
		return isWeekday(dt) && !isHoliday(dt) && !isTollingDay(dt);
	}
	/* method returns true if date entered is a weekday */
	@TestVisible private static Boolean isWeekday(Date dt) {
		String dayOfWeek = dayOfWeek(dt);
		if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat') {
		    return false;
		} else {
		    return true;
		}
	}
	public static String dayOfWeek(dateTime dt){
		return dt.format('E');
	}
	public static String dayOfWeek(date dt) {
		//dayOfWeek is Sun, Mon, Tue, etc.
		//get timezone offset of user;
		integer offset = UserInfo.getTimeZone().getOffset(DateTime.newInstance(dt.year(),dt.month(),dt.day(),0,0,0));
		//offest time by 
		Time myTime = Time.newInstance(0, 0, 0, offset);
		DateTime dateTimeToCompare = datetime.newInstanceGmt(dt, mytime);
		return dayOfWeek(dateTimeToCompare);
	}
	/* method returns true if date entered is a holiday */
	@TestVisible private static Boolean isHoliday(Date dt) {
		return holidaySet.contains(dt);
	}
	/* method returns true if the date is a tolling day */
	@TestVisible private static Boolean isTollingDay(Date dt) {
		return tollingDaySet.contains(dt);
	}
	/* method rolls the inputDate forward to next working day */
	@TestVisible private static date rollForwardNextBusinessDay(date dt) {
		while (true) { //loop through until a working day is found
			if(isWorkingDay(dt)) {
				return dt;
			} else {
				dt = dt.addDays(1);
			}
		}
		return dt;
	}
	
	@TestVisible private static date rollBackPreviousBusinessDay(date dt) {
		while (true) {//loop through until a working day is found
			if(isTollingDay(dt)){
				return rollForwardNextBusinessDay(dt); //assumed we should roll forward if we land on a tolling day
			}
			if(isWorkingDay(dt)) {
				return dt;
			} else {
				dt = dt.addDays(-1);
			}
		}
		return dt;
	}
}