@IsTest
private class RecusalSelectorTest
{
    @IsTest
    static void testBehavior()
    {
        IRecusalSelector selector = RecusalSelector.newInstance();
        selector.selectById(new Set<Id>());
        selector.selectByRecordTypeIdAndUserAndDate(new Set<Id>(), new Set<Id>(), Date.newInstance(2018, 8, 18));
        selector.selectByUserAndDate(new Set<Id>(), Date.newInstance(2018, 8, 18));
    }
}