/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_IndustryTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_IndustryTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Industry__c());
    }
}