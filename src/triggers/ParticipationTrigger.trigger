trigger ParticipationTrigger on Participation__c (before insert, before update, after insert, after update, before delete, after delete) {

	fflib_SObjectDomain.triggerHandler(Participation.class);

}