@isTest
public class PetitionTriggerHandlerTest {
	private static Date petitionDate = System.today();
	
	//TB: we have a isWeekday method in the utility class
	private static Set<String> weekDays = new Set<String>{'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};
	
	
	private static String dayOfWeek {
		get{
			if(dayOfWeek == null){
				//TB: Why are we repeating this code? It already exists in the ADCVD_TollingDayUtil
				integer offset = UserInfo.getTimeZone().getOffset(DateTime.newInstance(petitionDate.year(),petitionDate.month(),petitionDate.day(),0,0,0));
				//offest time by 
				Time myTime = Time.newInstance(0, 0, 0, offset);
				DateTime dateTimeToCompare = datetime.newInstanceGmt(petitionDate, mytime);
				dayOfWeek = dateTimeToCompare.format('E');
			}
			return dayOfWeek;
		}
	}
	private static User u{
		get{
			if(u == null){
				u = [SELECT Id, ProfileId, isActive, Alias, LanguageLocaleKey, LastName, FirstName, 
								Email, EmailEncodingKey, TimeZoneSidKey, CommunityNickname, Username 
							FROM User WHERE LastName =: 'LastName1' LIMIT 1];
			}
			System.debug('User u: '+u);
			return u;
		}
	}

	//Petition Filed - Scenarios 1, 2, 5
	@isTest static void petitionFiledDateIsValid(){
		Test.startTest();
		String error = '';
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Sat'){
			petitionDate = petitionDate.toStartOfWeek().addDays(-8);//roll back to Saturday
		}
		Holiday h = new Holiday(ActivityDate = petitionDate.addDays(-1), Name = 'Every day is a holiday');//Set previous Friday to holiday
		insert h;
		System.runAs(u){//change context because of holiday insert
			Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
			error = attemptInsert(p);//failed weekend insert
			System.assert(error.contains(''));//needs a portion of Petition Filed on Weekend VR error message
			p.Petition_Filed__c.addDays(-1);
			error = attemptInsert(p);//failed holiday insert
			System.assert(error.contains(''));//needs a portion of Petition Filed on Holiday VR error message
			p.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Petition_Filed__c);//successful insert
			error = attemptInsert(p);
			System.assertNotEquals(p.Id, null);
		}
		Test.stopTest();
	}

	//Initiation Extension - Scenarios 1 and 2
	@isTest static void petitionExtensionBound(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on a weekday
			petitionDate = petitionDate.toStartOfWeek().addDays(5);
		}
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Initiation_Extension_of_days__c = 21;//out of bounds
		String error = attemptInsert(p);
		System.assert(error.contains('extension cannot exceed more than 20 days'));
		p.Initiation_Extension_of_days__c = 20;//in bounds
		error = attemptInsert(p);
		System.assertEquals(20, [SELECT Id, Initiation_Extension_of_days__c FROM  Petition__c WHERE Id =: p.Id].Initiation_Extension_of_days__c);
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 1
	@isTest static void businessDayCalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Mon'){//Set to Monday
			petitionDate = petitionDate.toStartOfWeek().addDays(1);
		}
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day of the week as Petition Filed
		System.debug(p.Petition_Filed__c);
		System.debug(p.Petition_Filed__c.addDays(20));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(0));
		insert p;
		System.assertNotEquals(p.Id, null);
		//Petition Filed Date in memory + 20(standard) + 1(extenstion) + 0(adjustment from trigger) == Calculated Initiation in database
		System.assertEquals(petitionDate.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)), 
			[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 2
	@isTest static void weekendDayCalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
			petitionDate = petitionDate.toStartOfWeek().addDays(5);
		}
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Initiation_Extension_of_days__c =2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
		System.debug(p.Petition_Filed__c);
		System.debug(p.Petition_Filed__c.addDays(20));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(2));
		insert p;
		System.assertNotEquals(p.Id, null);
		//Petition Filed Date in memory + 20(standard) + 2(extension) + 2(Saturday and Sunday adjustment from trigger) == Calculated Initiation in database
		System.assertEquals(petitionDate.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(2), 
			[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 3
	@isTest static void weekendDayFollowedByHolidayCalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
			petitionDate = petitionDate.toStartOfWeek().addDays(5);
		}
		Holiday h = new Holiday(ActivityDate = petitionDate.addDays(24), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
		insert h;
		System.runAs(u){//change context because of holiday insert
			Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(3));
			insert p;
			System.assertNotEquals(p.Id, null);
			//Petition Filed Date in memory + 20(standard) + 2(extension) + 3(Saturday, Sunday, and holiday Monday adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(petitionDate.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(3), 
				[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 4
	@isTest static void holidayCalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Mon'){//If not a Monday, roll forward to the next Monday
			petitionDate = petitionDate.toStartOfWeek().addDays(1);
		}
		Holiday h = new Holiday(ActivityDate = petitionDate.addDays(21), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
		insert h;
		System.runAs(u){
			Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day as Petition Filed
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(1));
			insert p;
			System.assertNotEquals(p.Id, null);
			//Petition Filed Date in memory + 20(standard) + 1(extension) + 1(Holiday adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(petitionDate.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(1), 
				[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 5
	@isTest static void businessDay40CalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Tuesday
			petitionDate = petitionDate.toStartOfWeek().addDays(5);
		}
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
		System.debug(p.Petition_Filed__c);
		System.debug(p.Petition_Filed__c.addDays(20));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(0));
		insert p;
		System.assertNotEquals(p.Id, null);
		//Petition Filed Date in memory + 20(standard) + 20(extenstion) + 0(adjustment from trigger) == Calculated Initiation in database
		System.assertEquals(petitionDate.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)), 
			[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 6 (not valid, since initiation cannot be more than 20)
	//Business Day Calculation without Tolling Day Consideration - Scenario 7
	@isTest static void weekendDayRollbackCalcWithoutTolling(){
		Test.startTest();
		if(ADCVD_TollingDayUtility.dayOfWeek(petitionDate) != 'Tue'){//if today is not Monday, move the petition filed date ahead to the next Monday, which puts Calculated Initiation on Monday before rollback
			petitionDate = petitionDate.toStartOfWeek().addDays(2);
		}
		Petition__c p = TestUtils.createPetition(petitionDate, 'AD ME', false);
		p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
		System.debug(p.Petition_Filed__c);
		System.debug(p.Petition_Filed__c.addDays(20));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
		System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(-2));
		insert p;
		System.assertNotEquals(p.Id, null);
		//Petition Filed Date in memory + 20(standard) + 20(extension) - 2(Sat and Sun adjustment from trigger) == Calculated Initiation in database
		System.assertEquals(petitionDate.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)).addDays(-2), 
			[SELECT Id, Calculated_Initiation_Signature__c FROM  Petition__c WHERE Id =: p.Id LIMIT 1].Calculated_Initiation_Signature__c);
		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
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