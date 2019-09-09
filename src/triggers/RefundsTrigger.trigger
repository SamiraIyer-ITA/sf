/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: RefundsTrigger.trigger
	Purpose: Trigger on Refund__c custom object utilizing the FFLIB trigger pattern.
 */
trigger RefundsTrigger on Refund__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Refunds.class);

}