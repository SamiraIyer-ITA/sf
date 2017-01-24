trigger Page_Evets on Page__c (before insert, before update, after insert, after update) {
    Page_Events_Controller controller = new Page_Events_Controller(trigger.new);
    if(trigger.isBefore){
        controller.createCleanURL();
    }
    if(trigger.isAfter){
        controller.checkExisting();
    }
}