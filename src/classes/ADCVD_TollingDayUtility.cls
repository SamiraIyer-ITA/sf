public without sharing class ADCVD_TollingDayUtility {
	private static ADCVD_TollingDayMapper tollingMapper = new ADCVD_TollingDayMapper().getInstance();

	@TestVisible private static List<Tolling_Day__c> tollingDayList {
		get {
			return tollingMapper.getMap().values();
		}
	}
	@TestVisible private static List<Tolling_Day__c> recordSpecificTollingDayList {get;private set;}
	@TestVisible private static List<Tolling_Day__c> setRecordSpecificTollingDayList(Id parentId) {
		List<Tolling_Day__c> returnList = (parentId != null
				&& tollingMapper.getMap(parentId) != null
				&& !tollingMapper.getMap(parentId).isEmpty())
				? tollingMapper.getMap(parentId).values()
				: new List<Tolling_Day__c>();
		return returnList;
	}
	@TestVisible private static Set<Date> tollingDaySet {
		get {
			tollingDaySet = new Set<Date>();
			for(Tolling_Day__c td: tollingDayList) {
				Date dt = td.Start_Date__c;
				while(dt <= td.End_Date__c) {
					tollingDaySet.add(dt);
					dt = dt.addDays(1);
				}
			}
			if (recordSpecificTollingDayList != null) {
				for(Tolling_Day__c td: recordSpecificTollingDayList) {
					Date dt = td.Start_Date__c;
					while(dt <= td.End_Date__c) {
						tollingDaySet.add(dt);
						dt = dt.addDays(1);
					}
				}
			}
			return tollingDaySet;
		}
		set;
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
		set;
	}

	@TestVisible private static Id bizHoursId {
		get {
			if (bizHoursId == null) {
				for (BusinessHours bh : [SELECT Id FROM BusinessHours WHERE Name =: 'Business Hours - 24 hrs']) {
					bizHoursId = bh.Id;
				}
			}
			return bizHoursId;
		} set;
	}

	/**
	 * Method used to determine deadlines that are set X number of days before, counting only business days prior to a deadline
	 * @param  startDate    Date that is passed in and used to calculate the deadline
	 * @param  businessDays A positive Integer that is passed in and used for the calculation
	 * @return              The deadline that is <businessDays> before startDate
	 */
	public static Date countBackBusinessDays(Date startDate, Integer businessDays) {
		Integer bizDayCounter = 0;
		Date deadline = startDate;
		while (bizDayCounter < businessDays) {
			deadline = deadline.addDays(-1);
			if (isWorkingDayNoTolling(deadline)) {
				bizDayCounter++;
			}
		}
		return deadline;
	}

	public static Date getCalculatedDate(Date startDate, Date deadline, Boolean rollforward, Id recordId) {
		recordSpecificTollingDayList = recordId != null ? setRecordSpecificTollingDayList(recordId) : new List<Tolling_Day__c>();
		return getCalculatedDate(startDate, deadline, rollforward);
	}

		/* Method used to determine the new value of the deadline tolling day, holiday and weekends accounted for
        *  Input Params: 	startDate:  	should be passed in to determine how many of the days are in scope
        *					deadline: 	 	this is the current deadline (without tolling days in scope)
        *					rollforward: 	boolean to either roll the date forward or back to next or previous working day
        *  Return Value: New deadline
        *  (e.g. petition start should be 'start date' for a petition)
        */
	public static Date getCalculatedDate(Date startDate, Date deadline, Boolean rollforward) {
		deadline = deadlineWithTollingDays(startDate, deadline);
		if(rollforward) {
			deadline = rollForwardNextBusinessDay(deadline);
		} else {
			deadline = rollBackPreviousBusinessDay(deadline);
		}
		return deadline;
	}

	public static Date getCalculatedDateNoTolling(Date startDate, Date deadline, Id recordId) {
		recordSpecificTollingDayList = recordId != null ? setRecordSpecificTollingDayList(recordId) : new List<Tolling_Day__c>();
		deadline = deadlineWithTollingDays(startDate, deadline);
		deadline = rollForwardNextBusinessDayNoTolling(deadline);
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
			System.debug(td);
			if (startDate == td || deadline == td || (startDate < td && td < deadline)) { //scenario 3: tolling day = record initiation or record end
				deadline = deadline.addDays(1);
				System.debug(true);
			} else if(startDate > td) { //scenario 1: tolling day occured before the record was initiated
				continue; //process next tolling day
				System.debug(true);
			} else if (deadline < td) { //scenario 2: tolling day after the record ended
				continue;
				System.debug(true);
			}
		}
		return deadline;
	}

	public static Boolean isWorkingDay(Date dt) {
		return isWeekday(dt) && !isHoliday(dt) && !isTollingDay(dt);
	}

	public static Boolean isWorkingDayNoTolling(Date dt) {
		return isWeekday(dt) && !isHoliday(dt);
	}

	/* method returns true if Date entered is a weekday */
	public static Boolean isWeekday(Date dt) {
		String dayOfWeek = dayOfWeek(dt);
		if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat') {
		    return false;
		} else {
		    return true;
		}
	}
	public static String dayOfWeek(DateTime dt){
		return dt.format('E');
	}
	public static String dayOfWeek(Date dt) {
		//dayOfWeek is Sun, Mon, Tue, etc.
		//get timezone offset of user;
		Integer offset = UserInfo.getTimeZone().getOffset(DateTime.newInstance(dt.year(),dt.month(),dt.day(),0,0,0));
		//offest time by 
		Time myTime = Time.newInstance(0, 0, 0, offset);
		DateTime dateTimeToCompare = DateTime.newInstanceGmt(dt, mytime);
		return dayOfWeek(dateTimeToCompare);
	}
	
/*	public static Boolean isHoliday(Date dt) {
		return holidaySet.contains(dt);
	}
*/
	/**
	 * method to check for a holiday.  This accepts a Date, then converts to a DateTime for the call to BusinessHours.
	 * That call retrieves the default business hours, sets the start Date, then adds one millisecond to it, then
	 * gets the day that is returned.  If the returned day != the start Date, then the start
	 * Date was out of business hours.  (addition of one millisecond triggered an entire day change)
	 * @param  dt Date to check
	 * @return    true if out of business hours (isHoliday) or false if in business hours (!isHoliday)
	 */
	public static Boolean isHoliday(Date dt) {
		if (!Test.isRunningTest()) {
			DateTime d = Datetime.newInstance(dt.year(), dt.month(), dt.day());
			return (BusinessHours.add(bizHoursId, d, 1).day() != d.day());
		} else {
			return holidaySet.contains(dt);
		}
	}
	/* method returns true if the Date is a tolling day */
	@TestVisible private static Boolean isTollingDay(Date dt) {
		return tollingDaySet.contains(dt);
	}
	/* method rolls the inputDate forward to next working day */
	@TestVisible private static Date rollForwardNextBusinessDay(Date dt) {
		while (true) { //loop through until a working day is found
			if(isWorkingDay(dt)) {
				return dt;
			} else {
				dt = dt.addDays(1);
			}
		}
		return dt;
	}

	@TestVisible private static Date rollForwardNextBusinessDayNoTolling(Date dt) {
		while (true) { //loop through until a working day is found
			if(isWorkingDayNoTolling(dt)) {
				return dt;
			} else {
				dt = dt.addDays(1);
			}
		}
		return dt;
	}

	@TestVisible private static Date rollBackPreviousBusinessDay(Date dt) {
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
