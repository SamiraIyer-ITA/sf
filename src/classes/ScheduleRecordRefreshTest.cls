/**
 *
 *    Created by Skip Kleckner
 *    on June 13 2019
 *    MIL Corporation
 *
 **/

@IsTest
public class ScheduleRecordRefreshTest {

	private static List<ADCVD_Case__c> adcvdCaseList { get; set; }
	private static List<Petition__c> petitionList { get; set; }
	private static List<Investigation__c> investigationList { get; set; }
	private static List<ADCVD_Order__c> orderList { get; set; }
	private static List<Litigation__c> litigationList { get; set; }
	private static List<Segment__c> segmentList { get; set; }

	@IsTest
	static void testRefreshDueDates() {
		dataSetup();
		selectorSetup();
		Test.startTest();

		ADCVD_Case__c c = adcvdCaseList.get(0);
		Petition__c p = petitionList.get(0);
		ADCVD_Order__c o = orderList.get(0);
		Investigation__c i = investigationList.get(0);
		Litigation__c l = litigationList.get(0);
		Segment__c s = segmentList.get(0);

		ScheduleRecordsRefresh srr = new ScheduleRecordsRefresh();
		srr.refreshDueDates();

		System.assertEquals(1, srr.petitionsToRefresh.size());
		System.assertEquals(1, srr.segmentsToRefresh.size());
		System.assertEquals(1, srr.investigationsToRefresh.size());
		System.assertEquals(1, srr.litigationsToRefresh.size());
		System.assertEquals(1, srr.caseIdSet.size());

		System.assertEquals(true, srr.petitionsToRefresh.get(0).Schedule_Refresh__c);
		System.assertEquals(false, srr.segmentsToRefresh.get(0).Schedule_Refresh__c);
		System.assertEquals(true, srr.investigationsToRefresh.get(0).Schedule_Refresh__c);
		System.assertEquals(true, srr.litigationsToRefresh.get(0).Schedule_Refresh__c);

		Test.stopTest();
	}

	@testSetup static void dataSetup() {
		TestUtils.createAppConfig('default', true, true);
		// Create ADCVD_Case record
		adcvdCaseList = new List<ADCVD_Case__c>();
		adcvdCaseList.add(
				new ADCVD_Case__c(
						Id = fflib_IdGenerator.generate(ADCVD_Case__c.SObjectType),
						Locked__c = false,
						Country__c = 'Mexico'
				)
		);

		//Create Petition record
		petitionList = new List<Petition__c>();
		petitionList.add(
				new Petition__c(
						Id = fflib_IDGenerator.generate(Petition__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Country_Text__c = 'Mexico',
						Schedule_Refresh__c = false,
						Next_Announcement_Date__c = System.today().addDays(-1),
						Next_Due_to_DAS_Deadline__c = System.today().addDays(-1),
						Next_Office_Deadline__c = System.today().addDays(-1)
				)
		);

		//Create Investigation record
		investigationList = new List<Investigation__c>();
		investigationList.add(
				new Investigation__c(
						Id = fflib_IDGenerator.generate(Investigation__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Petition__c = petitionList[0].Id,
						Schedule_Refresh__c = false,
						Next_Announcement_Date__c = System.today().addDays(-1),
						Next_Due_to_DAS_Deadline__c = System.today().addDays(-1),
						Next_Office_Deadline__c = System.today().addDays(-1)
				)
		);

		//Create ADCVD Order record
		orderList = new List<ADCVD_Order__c>();
		orderList.add(
				new ADCVD_Order__c(
						Id = fflib_IDGenerator.generate(ADCVD_Order__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Investigation__c = investigationList[0].Id
				)
		);

		//Create Litigation record
		litigationList = new List<Litigation__c>();
		litigationList.add(
				new Litigation__c(
						Id = fflib_IDGenerator.generate(Litigation__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Schedule_Refresh__c = false,
						Next_Announcement_Date__c = System.today().addDays(-1),
						Next_Due_to_DAS_Deadline__c = System.today().addDays(-1),
						Next_Office_Deadline__c = System.today().addDays(-1)

				)
		);

		//Create Segment record
		segmentList = new List<Segment__c>();
		segmentList.add(
				new Segment__c(
						Id = fflib_IDGenerator.generate(Segment__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Schedule_Refresh__c = true,
						Next_Announcement_Date__c = System.today().addDays(-1),
						Next_Due_to_DAS_Deadline__c = System.today().addDays(-1),
						Next_Office_Deadline__c = System.today().addDays(-1)

				)
		);

		//Create relationship between ADCVD_Case and Petition
		adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Petition__c.ADCVD_Case__c,
				new List<List<Petition__c>>{
						petitionList
				}
		);

		//Create relationship between ADCVD_Case and Investigation
		adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(List<ADCVD_Case__c>.class, adcvdCaseList, Investigation__c.ADCVD_Case__c, new List<List<Investigation__c>>{investigationList} );

		//Create relationship between ADCVD_Case and ADCVD Order
		adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				ADCVD_Order__c.ADCVD_Case__c,
				new List<List<ADCVD_Order__c>>{
						orderList
				}
		);

		//Create relationship between ADCVD_Case and Litigation
		adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Litigation__c.ADCVD_Case__c,
				new List<List<Litigation__c>>{
						litigationList
				}
		);
		//Create relationship between ADCVD_Case and Segment
		adcvdCaseList = (List<ADCVD_Case__c>) fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Segment__c.ADCVD_Case__c,
				new List<List<Segment__c>>{
						segmentList
				}
		);

		//Create relationship between Petition and Investigation
		petitionList = (List<Petition__c>) fflib_ApexMocksUtils.makeRelationship(
				List<Petition__c>.class,
				petitionList,
				Investigation__c.Petition__c,
				new List<List<Investigation__c>>{
						investigationList
				}
		);
		//Create relationship between Investigation and ADCVD Order
		investigationList = (List<Investigation__c>) fflib_ApexMocksUtils.makeRelationship(
				List<Investigation__c>.class,
				investigationList,
				ADCVD_Order__c.Investigation__c,
				new List<List<ADCVD_Order__c>>{
						orderList
				}
		);
	}

	private static void selectorSetup() {
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		//Mock ADCVD Case Selector
		ADCVD_ICaseSelector mockADCVD_CaseSelector = (ADCVD_ICaseSelector) mocks.mock(ADCVD_ICaseSelector.class);
		mocks.startStubbing();
		mocks.when(mockADCVD_CaseSelector.sObjectType()).thenReturn(ADCVD_Case__c.SObjectType);
		mocks.when(mockADCVD_CaseSelector.selectByIdWithRelations(new Set<Id>{adcvdCaseList[0].Id})).thenReturn(adcvdCaseList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockADCVD_CaseSelector);

		//Mock Petition Selector
		IPetitionSelector mockPetitionSelector = (IPetitionSelector) mocks.mock(IPetitionSelector.class);
		mocks.startStubbing();
		mocks.when(mockPetitionSelector.sObjectType()).thenReturn(Petition__c.SObjectType);
		mocks.when(mockPetitionSelector.selectByWhereClause(ScheduleRecordsRefresh.wc)).thenReturn(petitionList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockPetitionSelector);

		//Mock Investigation Selector
		IInvestigationSelector mockInvestigationSelector = (IInvestigationSelector) mocks.mock(IInvestigationSelector.class);
		mocks.startStubbing();
		mocks.when(mockInvestigationSelector.sObjectType()).thenReturn(Investigation__c.SObjectType);
		mocks.when(mockInvestigationSelector.selectByWhereClause(ScheduleRecordsRefresh.wc)).thenReturn(investigationList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockInvestigationSelector);

		//Mock ADCVD Order Selector
		ADCVD_IOrderSelector mockADCVD_OrderSelector = (ADCVD_IOrderSelector) mocks.mock(ADCVD_IOrderSelector.class);
		mocks.startStubbing();
		mocks.when(mockADCVD_OrderSelector.sObjectType()).thenReturn(ADCVD_Order__c.SObjectType);
		mocks.when(mockADCVD_OrderSelector.selectById(new Set<Id>{orderList[0].Id})).thenReturn(orderList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockADCVD_OrderSelector);

		//Mock Litigation Selector
		ILitigationSelector mockLitigationSelector = (ILitigationSelector) mocks.mock(ILitigationSelector.class);
		mocks.startStubbing();
		mocks.when(mockLitigationSelector.sObjectType()).thenReturn(Litigation__c.SObjectType);
		mocks.when(mockLitigationSelector.selectByWhereClause(ScheduleRecordsRefresh.wc)).thenReturn(litigationList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockLitigationSelector);

		//Mock Segment Selector
		ISegmentSelector mockSegmentSelector = (ISegmentSelector) mocks.mock(ISegmentSelector.class);
		mocks.startStubbing();
		mocks.when(mockSegmentSelector.sObjectType()).thenReturn(Segment__c.SObjectType);
		mocks.when(mockSegmentSelector.selectByWhereClause(ScheduleRecordsRefresh.wc)).thenReturn(segmentList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockSegmentSelector);
	}
}