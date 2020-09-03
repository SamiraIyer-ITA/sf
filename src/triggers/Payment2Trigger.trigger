trigger Payment2Trigger on Payment2__c (before insert,before update) {

	if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
		Payment2TriggerHandler.updateSystemSearchString(trigger.new);
	}

}