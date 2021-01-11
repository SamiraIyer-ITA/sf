trigger LeadsTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	fflib_SObjectDomain.triggerHandler(Leads.class);
}