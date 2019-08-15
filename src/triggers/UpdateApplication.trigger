trigger UpdateApplication on Asset (after insert, after update) 
{
	AssetTriggerHandler.mainEntry(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap, Trigger.isInsert,
		Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.isBefore, Trigger.isAfter);

	Set<Id> applicationIdsNew = new Set<Id>();
	for(Asset a : Trigger.new){
		applicationIdsNew.add(a.Participant__c);
	}

	Map<Id, Participation__c> applicationMapNew = new Map<Id, Participation__c>([SELECT Id, Name, Able_To_Recertify__c FROM Participation__c WHERE Id IN: applicationIdsNew]);
	update applicationMapNew.values();
}