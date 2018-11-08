trigger CustomInstructionTrigger on Custom_Instruction__c (before insert, after insert)
{
	
	CustomInstructionTriggerHandler.mainEntry(trigger.New, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isBefore, trigger.isAfter);
}