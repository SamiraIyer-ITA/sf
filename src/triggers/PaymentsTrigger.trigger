/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: PaymentsTrigger.trigger
	Purpose: Trigger on Payment__c custom object utilizing the FFLIB trigger pattern.
 */
trigger PaymentsTrigger on Payment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Payments.class);

}