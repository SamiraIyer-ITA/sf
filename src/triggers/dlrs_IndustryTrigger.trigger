/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_IndustryTrigger on Industry__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    if(userinfo.getUserType() == 'Standard') {
        dlrs.RollupService.triggerHandler();
    }   
}