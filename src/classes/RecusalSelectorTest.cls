@IsTest
private class RecusalSelectorTest
{
    @IsTest
    static void testBehavior()
    {
        IRecusalSelector selector = RecusalSelector.newInstance();
        selector.selectById(new Set<Id>());
        selector.selectByUserAndNoCase(new Set<Id>());
    }
}