trigger OpportunitiesTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	fflib_SObjectDomain.triggerHandler(Opportunities.class);
}