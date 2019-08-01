/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Taxonomy_TaggingTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_Taxonomy_TaggingTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Taxonomy_Tagging__c());
    }
}