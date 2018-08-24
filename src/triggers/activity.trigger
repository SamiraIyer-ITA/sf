trigger activity on Task (after insert, after update) {

    activityTriggerHandler handler = new activityTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isAfter){
        handler.afterInsert(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.afterUpdate(Trigger.oldMap, Trigger.new);
    }
}