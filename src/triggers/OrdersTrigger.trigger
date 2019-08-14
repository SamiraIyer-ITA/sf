/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: OrdersTrigger.trigger
	Purpose: Trigger on Order custom object utilizing the FFLIB trigger pattern.
 */
trigger OrdersTrigger on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Orders.class);

}