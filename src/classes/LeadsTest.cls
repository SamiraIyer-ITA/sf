@IsTest
private class LeadsTest {

	static Id leadId = fflib_IDGenerator.generate(Lead.SObjectType);

	@IsTest
	static void testNewInstanceOfLeadsDomain_PassListWithOneNonInsertedObject_ReturnsValidInterface() {
		List<Lead> oppList  = new List<Lead>{ new Lead() };
		ILeads iLeads = (ILeads) Leads.newInstance(oppList);
		System.assertNotEquals(iLeads, null, 'Interface returned as null and should not have');
	}

	@IsTest
	static void testNewInstanceOfLeadsDomain_PassSetWithOneNonInsertedObject_ReturnsValidInterface() {
		Set<Id> leadIds = new Set<Id>{ leadId };
		ILeads iLeads = (ILeads) Leads.newInstance(leadIds);
		System.assertNotEquals(iLeads, null, 'Interface returned as null and should not have');
	}
}