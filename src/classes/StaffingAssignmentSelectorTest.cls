/**
 * Created by skip on 1/18/19.
 */

@IsTest
private class StaffingAssignmentSelectorTest {
    @IsTest
    static void testBehavior() {
        StaffingAssignmentSelector.newInstance().selectById(new Set<Id>());
        StaffingAssignmentSelector.newInstance().selectAllToLimit();
        Set<String> selectFieldsSet = new Set<String>{
                'Title__c', 'User__c', 'User__r.Name'
        };
        StaffingAssignmentSelector.newInstance().selectByParentId('test', selectFieldsSet, '(Petition__c=\'111111111111111\')');
    }
}