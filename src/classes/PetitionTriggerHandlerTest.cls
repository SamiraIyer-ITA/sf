@isTest
public class PetitionTriggerHandlerTest {
	private static Date petitionDate = System.today();
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
	private static List<Petition__c> petitionList {
		get {
			if(petitionList == null) {
				petitionList = [SELECT Id, Petition_Filed__c, Petition_Outcome__c, Case_Number__c, Product__c,
									Case_Type__c, Country__c, Commodity__c, Initiation_Extension_of_days__c,
									Calculated_Initiation_Signature__c 
								FROM Petition__c];
			}
			return petitionList;
		}
	}
	//Petition Filed - Scenarios 1, 2, 5
	@isTest static void petitionFiledDateIsValid(){
		Test.startTest();
		String error = '';
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Petition_Filed__c.addDays(-7);//set Petition_Filed to past week
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Sat'){
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(-1);//roll back to Saturday
			}
			//TB: This will blow up the unit test. Holidays will cause mixed DML exception 
			Holiday h = new Holiday(ActivityDate = p.Petition_Filed__c.addDays(-1), Name = 'Every day is a holiday');//Set previous Friday to holiday
			insert h;
			error = attemptInsert(p);//failed weekend insert
			System.assert(error.contains(''));//needs a portion of Petition Filed on Weekend VR error message
			p.Petition_Filed__c.addDays(-1);
			error = attemptInsert(p);//failed holiday insert
			System.assert(error.contains(''));//needs a portion of Petition Filed on Holiday VR error message
			p.Petition_Filed__c = ADCVD_TollingDayUtility.rollForwardNextBusinessDay(p.Petition_Filed__c);//successful insert
			error = attemptInsert(p);
			System.assertEquals(petitionList.size(), 1);
		}
		Test.stopTest();
	}

	//JM: Good job, Tony!  This is a good framework to start with.
	//Your assert compares a value in the database, adds 2 to it, then validates it against a date 2 days from today
	//Was the petition inserted with a future date?
	//Do you know for sure that the petition insert, which could calculate tolling days, holidays, and weekends, will not adjust your petition filed date?
	@isTest static void petitionFiledDateFuture(){
		Test.startTest();
		Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', true);
		Date futureDate = petitionDate.addDays(2);
		System.assertEquals(petitionList[0].Petition_Filed__c.addDays(2),futureDate);
		Test.stopTest();
	}
	//@isTest static void petitionFiledDateFuture(){
	//	Test.startTest();
	//	Petition__c p = createPetition();
	//	p.Petition_Filed__c = p.PetitionFiled__c.addDays(2);
	//	System.assertEquals(petitionList[0].Petition_Filed__c, petitionDate.addDays(2));
	//	Test.stopTest();
	//}

	//nice touch!!  generally dont see unit tests for validation rules but we will probably wannt them for this project
	//Initiation Extension - Scenarios 1 and 2
	@isTest static void petitionExtensionBound(){
		Test.startTest();
		Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
		if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on a weekday
			p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(5);
		}
		p.Initiation_Extension_of_days__c = 21;//out of bounds
		String error = attemptInsert(p);
		System.assert(error.contains('extension cannot exceed more than 20 days'));
		p.Initiation_Extension_of_days__c = 20;//in bounds
		error = attemptInsert(p);
		System.assertEquals(petitionList[0].Initiation_Extension_of_days__c, 20);
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 1
	@isTest static void businessDayCalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day of the week as Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Mon'){//Set to Monday
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(1);
			}
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(0));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 1(extenstion) + 0(adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}

	//Business Day Calculation without Tolling Day Consideration - Scenario 2
	@isTest static void weekendDayCalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c =2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(5);
			}
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(2));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 2(extension) + 2(Saturday and Sunday adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(2), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}
	//Business Day Calculation without Tolling Day Consideration - Scenario 3
	@isTest static void weekendDayFollowedByHolidayCalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 2;//20+2 will set Calculated Initiation Signature to day of week after Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Saturday
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(5);
			}
			Holiday h = new Holiday(ActivityDate = p.Petition_Filed__c.addDays(24), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
			insert h;
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(3));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 2(extension) + 3(Saturday, Sunday, and holiday Monday adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(3), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}
	//Business Day Calculation without Tolling Day Consideration - Scenario 4
	@isTest static void holidayCalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 1;//20+1 will set Calculated Initiation Signature to same day as Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Mon'){//If not a Monday, roll forward to the next Monday
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(1);
			}
			Holiday h = new Holiday(ActivityDate = p.Petition_Filed__c.addDays(21), Name = 'Every day is a holiday');//Set Monday following Saturday of Calculated Initiation to a holiday
			insert h;
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(1));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 1(extension) + 1(Holiday adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(1), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}
	//Business Day Calculation without Tolling Day Consideration - Scenario 5
	@isTest static void businessDay40CalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Fri'){//if today is not Friday, move the petition filed date ahead to the next Friday, which puts Calculated Initiation on Tuesday
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(5);
			}
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(0));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 20(extenstion) + 0(adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}
	//Business Day Calculation without Tolling Day Consideration - Scenario 6 (not valid, since initiation cannot be more than 20)
	//Business Day Calculation without Tolling Day Consideration - Scenario 7
	@isTest static void weekendDayRollbackCalcWithoutTolling(){
		Test.startTest();
		System.runAs(u){
			Petition__c p = testUtils.createPetition(petitionDate, 'AD ME', false);
			p.Initiation_Extension_of_days__c = 20;//20+20 will set Calculated Initiation Signature to 2 days of the week before Petition Filed
			if(ADCVD_TollingDayUtility.dayOfWeek(p.Petition_Filed__c) != 'Tue'){//if today is not Monday, move the petition filed date ahead to the next Monday, which puts Calculated Initiation on Monday before rollback
				p.Petition_Filed__c = p.Petition_Filed__c.toStartOfWeek().addDays(2);
			}
			System.debug(p.Petition_Filed__c);
			System.debug(p.Petition_Filed__c.addDays(20));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c));
			System.debug(p.Petition_Filed__c.addDays(20).addDays((integer)p.Initiation_Extension_of_days__c).addDays(-2));
			insert p;
			//Petition Filed Date in memory + 20(standard) + 20(extenstion) - 2(Sat and Sun adjustment from trigger) == Calculated Initiation in database
			System.assertEquals(p.Petition_Filed__c.addDays(20).addDays((integer)(p.Initiation_Extension_of_days__c)).addDays(-2), petitionList[0].Calculated_Initiation_Signature__c);
		}
		Test.stopTest();
	}


	@testSetup static void dataSetup() {
		Test.startTest();
		User testUser = testUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
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