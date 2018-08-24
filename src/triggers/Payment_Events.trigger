trigger Payment_Events on Payment__c (after update) {
    //Payment_Events_Controller controller = new Payment_Events_Controller(trigger.new, trigger.newMap, trigger.oldMap);
    //controller.createCases();
    if(trigger.isAfter && trigger.isUpdate) {
        PaymentTriggerHandler.createCases(trigger.new, trigger.newMap, trigger.oldMap);
    }
}