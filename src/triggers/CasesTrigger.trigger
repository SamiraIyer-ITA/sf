/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: CasesTrigger.trigger
	Purpose: Trigger on Case custom object utilizing the FFLIB trigger pattern.
 */
trigger CasesTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Cases.class);

}