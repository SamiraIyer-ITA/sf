@IsTest
private class core_PlatformEventsDistributorTest
{
    @IsTest
    static void exerciseTriggerHandler()
    {
        EventBus.publish(
            new core_Event__e(
                EventName__c = 'ReadyForReconciliation',
                Payload__c = 'some text'));
        Test.getEventBus().deliver();
    }
}