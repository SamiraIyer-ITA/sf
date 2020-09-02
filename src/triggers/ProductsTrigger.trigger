trigger ProductsTrigger on Product2 (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	fflib_SObjectDomain.triggerHandler(Products.class);
}