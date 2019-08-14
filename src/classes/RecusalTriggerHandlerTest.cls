/**
 * 
 *    Created by Joshua Moody
 *    on June 29 2019
 *    MIL Corporation
 * 
 **/
@isTest
public class RecusalTriggerHandlerTest {
	private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
	private static List<Recusal__c> recusalList {get; set;}
	private static Map<Id,Recusal__c> recusalMap {get; set;}

	@isTest static void testInitialize(){
		dataSetup();
		selectorSetup();

		Test.startTest();
		RecusalTriggerHandler.initialize(recusalList, null);
		Test.stopTest();

		//Assert adcvd case records
		System.assertNotEquals(RecusalTriggerHandler.caseMapper, null);
		System.assertEquals(recusalList[0].Recusal_Parent__c, 'ADCVD_Case__c');

	}

	@isTest static void testSetCaseValues(){
		dataSetup();
		selectorSetup();

		Test.startTest();
		RecusalTriggerHandler.mainEntry(recusalList, null, null, null, true, false, false, false, true, false);
		Test.stopTest();

		//Assert adcvd case records
		System.assertEquals(adcvdCaseList[0].Country__c, recusalList[0].Country_Text__c);
	}

	@IsTest
	static void exerciseTrigger() {
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		Recusal__c testRecusal = TestUtils.createRecusal(testUser.Id, System.today(), System.today().addDays(3), true);
	}

	private static void dataSetup() {
		// Create ADCVD_Case record
		adcvdCaseList = new List<ADCVD_Case__c>();
		adcvdCaseList.add(
				new ADCVD_Case__c(
						Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
						Locked__c = false,
						Country__c = 'Mexico'
				)
		);
		
		//Create Recusal records
		recusalList = new List<Recusal__c>();
		recusalList.add(
				new Recusal__c(
						Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id
				)
		);
		recusalList.add(
				new Recusal__c(
						Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
						Locked__c = true
				)
		);
		recusalList.add(
				new Recusal__c(
						Id = fflib_IDGenerator.generate(Recusal__c.SObjectType),
						Locked__c = false
				)
		);

		//Create relationship between ADCVD Case and Recusal
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Recusal__c.ADCVD_Case__c,
				new List<List<Recusal__c>>{new List<Recusal__c>{recusalList[0]}}
		);
	}

	private static void selectorSetup() {
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		//Mock ADCVD Case Selector
		ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);
		mocks.startStubbing();
		mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
		mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id> {adcvdCaseList[0].Id})).thenReturn(adcvdCaseList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);
		//Mock Recusal Selector
		IRecusalSelector mockRecusalSelector = (IRecusalSelector) mocks.mock(IRecusalSelector.class);
		mocks.startStubbing();
		mocks.when(mockRecusalSelector.sObjectType()).thenReturn(Recusal__c.SObjectType);
		mocks.when(mockRecusalSelector.selectById(new Set<Id> {
				recusalList[0].Id,
				recusalList[1].Id,
				recusalList[2].Id
		})).thenReturn(recusalList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockRecusalSelector);
	}
}
