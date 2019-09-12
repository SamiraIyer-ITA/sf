/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: AssetsTrigger.trigger
	Purpose: Trigger on Asset custom object utilizing the FFLIB trigger pattern.
 */
trigger AssetsTrigger on Asset (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

	fflib_SObjectDomain.triggerHandler(Assets.class);

}