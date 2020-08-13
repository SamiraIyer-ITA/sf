/**
 * Leads Test
 * Test Leads trigger and related FFLIB supporting framework
 *
 * @author Daniel Haro
 */
@IsTest
private class LeadsTest {
	static ILeadsService service = LeadsService.service();
	static Id leadId = fflib_IDGenerator.generate(Lead.SObjectType);
 	static Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
  	static Id contactId = fflib_IDGenerator.generate(Contact.SObjectType);
    static Map<String, Schema.RecordTypeInfo> recordTypeMap
		= Lead.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

	@IsTest
	static void testNewInstanceOfLeadsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Lead> leadList  = new List<Lead>{ new Lead() };
		ILeads iLeads = (ILeads) Leads.newInstance(leadList);
        LeadsImplManager serviceManager = LeadsService.service( leadList);
		System.assertNotEquals(iLeads, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfLeadsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> leadIds = new Set<Id>{ leadId };
		ILeads iLeads = (ILeads) Leads.newInstance(leadIds);
		System.assertNotEquals(iLeads, null, 'Interface returned as null and should not have');
	}
    
    @IsTest
	static void test_LeadsTrigger_WithDml() {
		// Insert lead with required fields to test Leads trigger as rest of tests are not using dml
		insert new Lead(
			LastNameLocal = 'Test last name',
			Status = 'New',
			Company = 'test co 1',
            Source_Detail__c = 'test source 1',
            Assigned_Date__c = null,
            email = 'daniel.haro@trade.gov',
            LastName = 'tester1'
		);
	}

	@IsTest
	static void test_OnAfterUpdate_PostToChatter_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
        ICollaborationGroupsSelector mockSelector = (ICollaborationGroupsSelector) mocks.mock(ICollaborationGroupsSelector.class);

		// Given - Create mock data
		Lead existingTestLead = new Lead(
			Id = leadId,
			RecordTypeId = recordTypeMap.get('Export').getRecordTypeId(),
			Status = 'New',
            Assigned_User__c = null,
            Assigned_Date__c = null,
            Email = 'daniel.haro@trade.gov'

		);
		existingTestLead = getLeadWithRecordTypeNameFormulaField(existingTestLead, 'Export');
		Lead testLead = existingTestLead.clone(true, true, false, false);
        
        List<CollaborationGroup> mockGroups = new List<CollaborationGroup>{
            new CollaborationGroup(
                Id = fflib_IDGenerator.generate(CollaborationGroup.SObjectType),
                Name = 'Export Lead'
            )
        };
		
        // Given - Set criteria to check next stage
		testLead.Assigned_User__c = system.UserInfo.getUserId();
        
        mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(CollaborationGroup.SObjectType);
		mocks.when(mockSelector.selectByCollaborationGroupNames(new Set<String>{ 'Export Lead' }))
			.thenReturn(mockGroups);
		mocks.stopStubbing();
        
        // Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeInsert
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Lead>{ testLead },
			new Map<Id, Lead>( new List<Lead>{ existingTestLead })
		);
    	fflib_SObjectDomain.triggerHandler(Leads.class);
        system.assertNotEquals(null, testLead.Assigned_Date__c);
	}
    
	@IsTest
	static void test_OnBeforeUpdate_UpdateAssigmentDate_NoDml() {
		// Given - Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		ICollaborationGroupsSelector mockSelector = (ICollaborationGroupsSelector) mocks.mock(ICollaborationGroupsSelector.class);

		// Given - Create mock data
		Lead existingTestLead = new Lead(
			Id = leadId,
			RecordTypeId = recordTypeMap.get('Export').getRecordTypeId(),
			Status = 'New',
            Assigned_User__c = null,
            Assigned_Date__c = null,
            Email = 'daniel.haro@trade.gov'
		);
		existingTestLead = getLeadWithRecordTypeNameFormulaField(existingTestLead, 'Export');
        
        List<CollaborationGroup> mockGroups = new List<CollaborationGroup>{
            new CollaborationGroup(
                Id = fflib_IDGenerator.generate(CollaborationGroup.SObjectType),
                Name = 'Export Lead'
            )
        };
		
        // Given - Set lead criteria
		Lead testLead = existingTestLead.clone(true, true, false, false);
		testLead.Assigned_User__c = System.UserInfo.getUserId();
        
        mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(CollaborationGroup.SObjectType);
		mocks.when(mockSelector.selectByCollaborationGroupNames(new Set<String>{ 'Export Lead' }))
			.thenReturn(mockGroups);
		mocks.stopStubbing();
        
        // Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);


		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Lead>{ testLead },
			new Map<Id, Lead>(
				new List<Lead>{ existingTestLead }
			)
		);
    }

	@IsTest
	static void test_OnBeforeUpdate_updateAssignedUser_NoDml() {
		// Given - Create mocks (we need to mock this as it's used in other triggers and will cause errors)
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		ICollaborationGroupsSelector mockSelector = (ICollaborationGroupsSelector) mocks.mock(ICollaborationGroupsSelector.class);
        
		//NPD_ChatterPosts.intelGroupName = GROUP_NAME;
		// Given - Create mock data
		Account testAccount = new Account(
        	 Id = accountId,
        	 NameLocal = 'test Account'
        );
        Contact testContact = new Contact(
        	 Id = contactId,
        	 LastNameLocal = 'test Account'
        );
		Lead existingTestLead = new Lead(
			Id = leadId,
			RecordTypeId = recordTypeMap.get('Export').getRecordTypeId(),
			Status = 'New',
            Assigned_User__c = null,
            Email = 'daniel.haro@trade.gov',
            LastName = 'Haro',
            Company = 'Test Co.',
            Registrant__c = testContact.Id
		);
		existingTestLead = getLeadWithRecordTypeNameFormulaField(existingTestLead, 'Export');
		Lead testLead = existingTestLead.clone(true, true, false, false);
        
        List<CollaborationGroup> mockGroups = new List<CollaborationGroup>{
            new CollaborationGroup(
                Id = fflib_IDGenerator.generate(CollaborationGroup.SObjectType),
                Name = 'Export Lead'
            )
        };
        
       	// Given - Set lead criteria
		testLead.Assigned_User__c = system.UserInfo.getUserId();
             
        mocks.startStubbing();
		mocks.when(mockSelector.sObjectType()).thenReturn(CollaborationGroup.SObjectType);
		mocks.when(mockSelector.selectByCollaborationGroupNames(new Set<String>{ 'Export Lead' }))
			.thenReturn(mockGroups);
		mocks.stopStubbing();
        
        // Given - Inject mocks
		fflibext_Application.Selector.setMock(mockSelector);

		// When - Use the test database to mock an onBeforeUpdate
		fflib_SObjectDomain.Test.Database.onUpdate(
			new List<Lead>{ existingTestLead },
			new Map<Id, Lead>(
				new List<Lead>{	testLead})
		);
		fflib_SObjectDomain.triggerHandler(Leads.class);
		system.assertNotEquals(null, existingTestLead.Assigned_Date__c);
	}

	/*
	 * We need to set the read only record type developer name using the apex mock utils method
	 */
	private static Lead getLeadWithRecordTypeNameFormulaField(Lead tempLead, String mockFormula) {
		tempLead = (Lead)fflib_ApexMocksUtils.setReadOnlyFields(
			tempLead, 
			Lead.class,
			new Map<SObjectField, Object> {lead.Record_Type_Developer_Name__c => mockFormula}
		);
		return tempLead;
	}
}
