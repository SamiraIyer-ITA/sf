/**
 * Created by skip on 1/18/19.
 */

@IsTest
private class StaffingAssignmentSelectorTest {
    @IsTest
    static void testBehavior() {
        StaffingAssignmentSelector.newInstance().selectById(new Set<Id>());
        StaffingAssignmentSelector.newInstance().selectAllToLimit();
    }
}