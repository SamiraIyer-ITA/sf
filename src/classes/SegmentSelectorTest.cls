@IsTest
private class SegmentSelectorTest
{
    @IsTest
    static void testBehavior()
    {
        SegmentSelector.newInstance().selectById(new Set<Id>());
        SegmentSelector.newInstance().selectAllToLimit();
    }
}