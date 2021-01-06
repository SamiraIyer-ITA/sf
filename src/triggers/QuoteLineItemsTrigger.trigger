trigger QuoteLineItemsTrigger on QuoteLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	fflib_SObjectDomain.triggerHandler(QuoteLineItems.class);
}