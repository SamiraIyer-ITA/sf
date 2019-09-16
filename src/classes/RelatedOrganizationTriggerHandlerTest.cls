
@isTest
public class RelatedOrganizationTriggerHandlerTest {
	private static List<ADCVD_Case__c> adcvdCaseList { get; set;}
	private static List<Petition__c> petitionList {get; set;}
	private static List<Investigation__c> investigationList {get; set;}
	private static List<ADCVD_Order__c> orderList {get; set;}
//	private static List<Suspension_Agreement__c> suspAgrmtList {get; set;}
	private static List<Segment__c> segmentList {get; set;}
	private static List<Related_Organization__c> relOrgList {get; set;}
	private static Map<Id,Related_Organization__c> relOrgMap {get; set;}

	@isTest static void testInitialize(){
		dataSetup();
		selectorSetup();
		RelatedOrganizationMapper relOrgMapper = new RelatedOrganizationMapper(new Set<Id> {
				relOrgList[0].Id,
				relOrgList[1].Id,
				relOrgList[2].Id,
				relOrgList[3].Id
		}
		);

		Test.startTest();
		RelatedOrganizationTriggerHandler.initialize(relOrgList, null);
		Test.stopTest();

		//Assert adcvd case records
		System.assertNotEquals(RelatedOrganizationTriggerHandler.caseMapper, null);
		System.assertEquals(relOrgList[0].IO_Parent__c, 'Petition__c');

	}

	@isTest static void testSetCaseValues(){
		dataSetup();
		selectorSetup();
		RelatedOrganizationMapper relOrgMapper = new RelatedOrganizationMapper(new Set<Id> {
				relOrgList[0].Id,
				relOrgList[1].Id,
				relOrgList[2].Id,
				relOrgList[3].Id
		}
		);

		Test.startTest();
		RelatedOrganizationTriggerHandler.mainEntry(relOrgList, null, true, true, false);
		Test.stopTest();

		//Assert adcvd case records
		System.assertEquals(adcvdCaseList[0].Country__c, relOrgList[0].Country_Text__c);
	}

	@isTest static void testAddNewROsToMapper() {
		dataSetup();
		selectorSetup();
		relOrgMap = new Map<Id, Related_Organization__c>();
		for (Related_Organization__c ro : relOrgList) {
			relOrgMap.put(ro.Id, ro);
		}

		Test.startTest();
		RelatedOrganizationTriggerHandler.mainEntry(relOrgList, relOrgMap, true, false, true);
		Test.stopTest();

		//Assert adcvd case records
		for (Related_Organization__c ro : relOrgList) {
			RelatedOrganizationMapper rom = (RelatedOrganizationMapper) ADCVD_CaseMapper.mapperMap.get('Related_Organization__c');
			System.assert(rom.getMap().containsKey(ro.Id));
		}

	}

	@IsTest
	static void exerciseTrigger() {

		ADCVD_Case__c c = TestUtils.createADCVDCase('A-123-123', 'AD ME', true);
		Petition__c p = TestUtils.createPetition(c, System.today(), true);
		Account a = new Account(name = 'Test Co');
		insert a;
		insert new Related_Organization__c(ADCVD_Case_Number_Text__c = '--This is a test--', IO_Parent__c = 'Petition__c', Petition__c = p.Id, Account__c = a.Id, ADCVD_Entity_Name__c = 'TestName');
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
		//Create Petition record
		petitionList = new List<Petition__c>();
		petitionList.add(
				new Petition__c(
						Id = fflib_IDGenerator.generate(Petition__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id
				)
		);
		//Create Investigation record
		investigationList = new List<Investigation__c>();
		investigationList.add(
				new Investigation__c(
						Id = fflib_IDGenerator.generate(Investigation__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Petition__c = petitionList[0].Id
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
/*
		//Create Suspension Agreement record
		suspAgrmtList = new List<Suspension_Agreement__c>();
		suspAgrmtList.add(
				new Suspension_Agreement__c(
						Id = fflib_IDGenerator.generate(Suspension_Agreement__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						Investigation__c = investigationList[0].Id
				)
		);
*/
		//Create Segment record
		segmentList = new List<Segment__c>();
		segmentList.add(
				new Segment__c(
						Id = fflib_IDGenerator.generate(Segment__c.SObjectType),
						Locked__c = false,
						ADCVD_Case__c = adcvdCaseList[0].Id,
						ADCVD_Order__c = orderList[0].Id
				)
		);
		//Create Interested Organization records
		relOrgList = new List<Related_Organization__c>();
		relOrgList.add(
				new Related_Organization__c(
						Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
						Locked__c = false,
						Petition__c = petitionList[0].Id
				)
		);
		relOrgList.add(
				new Related_Organization__c(
						Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
						Locked__c = false,
						Investigation__c = investigationList[0].Id
				)
		);
		relOrgList.add(
				new Related_Organization__c(
						Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
						Locked__c = false,
						ADCVD_Order__c = orderList[0].Id
				)
		);
//		relOrgList.add(
//				new Related_Organization__c(
//						Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
//						Locked__c = false,
//						Suspension_Agreement__c = suspAgrmtList[0].Id
//				)
//		);
		relOrgList.add(
				new Related_Organization__c(
						Id = fflib_IDGenerator.generate(Related_Organization__c.SObjectType),
						Locked__c = false,
						Segment__c = segmentList[0].Id
				)
		);

		//Create relationship between ADCVD_Case and Petition
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Petition__c.ADCVD_Case__c,
				new List<List<Petition__c>>{petitionList}
		);
		//Create relationship between ADCVD_Case and Investigation
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Investigation__c.ADCVD_Case__c,
				new List<List<Investigation__c>>{investigationList}
		);
		//Create relationship between ADCVD_Case and ADCVD Order
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				ADCVD_Order__c.ADCVD_Case__c,
				new List<List<ADCVD_Order__c>>{orderList}
		);
/*
		//Create relationship between ADCVD_Case and Suspension Agreement
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Suspension_Agreement__c.ADCVD_Case__c,
				new List<List<Suspension_Agreement__c>>{suspAgrmtList}
		);
*/
		//Create relationship between ADCVD_Case and Segment
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Segment__c.ADCVD_Case__c,
				new List<List<Segment__c>>{segmentList}
		);
/*
		//Create relationship between ADCVD Case and Interested Organization
		adcvdCaseList = (List<ADCVD_Case__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Case__c>.class,
				adcvdCaseList,
				Related_Organization__c.ADCVD_Case__c,
				new List<List<Related_Organization__c>>{relOrgList}
		);
*/
		//Create relationship between Petition and Investigation
		petitionList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Petition__c>.class,
				petitionList,
				Investigation__c.Petition__c,
				new List<List<Investigation__c>>{investigationList}
		);
		//Create relationship between Investigation and ADCVD Order
		investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Investigation__c>.class,
				investigationList,
				ADCVD_Order__c.Investigation__c,
				new List<List<ADCVD_Order__c>>{orderList}
		);
/*
		//Create relationship between Investigation and Suspension Agreement
		investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Investigation__c>.class,
				investigationList,
				Suspension_Agreement__c.Investigation__c,
				new List<List<Suspension_Agreement__c>>{suspAgrmtList}
		);
*/
		//Create relationship between ADCVD Order and Segment
		orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Order__c>.class,
				orderList,
				Segment__c.ADCVD_Order__c,
				new List<List<Segment__c>>{segmentList}
		);
		//Create relationship between Petition and Interested Organization
		petitionList = (List<Petition__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Petition__c>.class,
				petitionList,
				Related_Organization__c.Petition__c,
				new List<List<Related_Organization__c>>{
						new List<Related_Organization__c> {relOrgList[0]}
				}
		);
		//Create relationship between Investigation and Interested Organization
		investigationList = (List<Investigation__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Investigation__c>.class,
				investigationList,
				Related_Organization__c.Investigation__c,
				new List<List<Related_Organization__c>>{
						new List<Related_Organization__c> {relOrgList[1]}
				}
		);
		//Create relationship between ADCVD Order and Interested Organization
		orderList = (List<ADCVD_Order__c>)fflib_ApexMocksUtils.makeRelationship(
				List<ADCVD_Order__c>.class,
				orderList,
				Related_Organization__c.ADCVD_Order__c,
				new List<List<Related_Organization__c>>{
						new List<Related_Organization__c> {relOrgList[2]}
				}
		);
//		//Create relationship between Suspension Agreement and Custom Instructions
//		suspAgrmtList = (List<Suspension_Agreement__c>)fflib_ApexMocksUtils.makeRelationship(
//				List<Suspension_Agreement__c>.class,
//				suspAgrmtList,
//				Related_Organization__c.Suspension_Agreement__c,
//				new List<List<Related_Organization__c>>{
//						new List<Related_Organization__c> {relOrgList[3]}
//				}
//		);
		//Create relationship between Segment and Interested Organization
		segmentList = (List<Segment__c>)fflib_ApexMocksUtils.makeRelationship(
				List<Segment__c>.class,
				segmentList,
				Related_Organization__c.Segment__c,
				new List<List<Related_Organization__c>>{
						new List<Related_Organization__c> {relOrgList[3]}
				}
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
		//Mock Petition Selector
		IPetitionSelector mockPetitionSelector = (IPetitionSelector) mocks.mock(IPetitionSelector.class);
		mocks.startStubbing();
		mocks.when(mockPetitionSelector.sObjectType()).thenReturn(Petition__c.SObjectType);
		mocks.when(mockPetitionSelector.selectById(new Set<Id> {petitionList[0].Id})).thenReturn(petitionList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockPetitionSelector);
		//Mock Investigation Selector
		IInvestigationSelector mockInvestigationSelector = (IInvestigationSelector) mocks.mock(IInvestigationSelector.class);
		mocks.startStubbing();
		mocks.when(mockInvestigationSelector.sObjectType()).thenReturn(Investigation__c.SObjectType);
		mocks.when(mockInvestigationSelector.selectById(new Set<Id> {investigationList[0].Id})).thenReturn(investigationList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockInvestigationSelector);
		//Mock ADCVD Order Selector
		ADCVD_IOrderSelector mockADCVD_OrderSelector = (ADCVD_IOrderSelector) mocks.mock(ADCVD_IOrderSelector.class);
		mocks.startStubbing();
		mocks.when(mockADCVD_OrderSelector.sObjectType()).thenReturn(ADCVD_Order__c.SObjectType);
		mocks.when(mockADCVD_OrderSelector.selectById(new Set<Id> {orderList[0].Id})).thenReturn(orderList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockADCVD_OrderSelector);
/*
		//Mock Suspension Agreement
		ISuspensionAgreementSelector mockSuspensionAgreementSelector = (ISuspensionAgreementSelector) mocks.mock(ISuspensionAgreementSelector.class);
		mocks.startStubbing();
		mocks.when(mockSuspensionAgreementSelector.sObjectType()).thenReturn(Suspension_Agreement__c.SObjectType);
		mocks.when(mockSuspensionAgreementSelector.selectById(new Set<Id> {suspAgrmtList[0].Id})).thenReturn(suspAgrmtList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockSuspensionAgreementSelector);
*/
		//Mock Segment Selector
		ISegmentSelector mockSegmentSelector = (ISegmentSelector) mocks.mock(ISegmentSelector.class);
		mocks.startStubbing();
		mocks.when(mockSegmentSelector.sObjectType()).thenReturn(Segment__c.SObjectType);
		mocks.when(mockSegmentSelector.selectById(new Set<Id> {segmentList[0].Id})).thenReturn(segmentList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockSegmentSelector);
		//Mock Interested Organizationanization Selector
		IRelatedOrganizationSelector mockRelatedOrganizationSelector = (IRelatedOrganizationSelector) mocks.mock(IRelatedOrganizationSelector.class);
		mocks.startStubbing();
		mocks.when(mockRelatedOrganizationSelector.sObjectType()).thenReturn(Related_Organization__c.SObjectType);
		mocks.when(mockRelatedOrganizationSelector.selectById(new Set<Id> {
				relOrgList[0].Id,
				relOrgList[1].Id,
				relOrgList[2].Id,
				relOrgList[3].Id
		})).thenReturn(relOrgList);
		mocks.stopStubbing();
		fflibext_Application.Selector.setMock(mockRelatedOrganizationSelector);
	}
}