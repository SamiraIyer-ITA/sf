<<<<<<< HEAD
trigger Payment2Trigger on Payment2__c (before insert,before update) {

	if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
		Payment2TriggerHandler.updateSystemSearchString(trigger.new);
	}
=======
/*
	Author: Jeff Weyhrauch
	Date: 5-20-2020
	Name: Payments2Trigger.trigger
	Purpose: Trigger on Payment2 custom object utilizing the FFLIB trigger pattern.
 */
trigger Payment2Trigger on Payment2__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Payments2.class);
>>>>>>> CRM-6490-Modify-Triggers-and-Test-Cases

}