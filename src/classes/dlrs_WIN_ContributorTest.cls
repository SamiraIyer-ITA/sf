/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_WIN_ContributorTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_WIN_ContributorTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new WIN_Contributor__c());
    }
}