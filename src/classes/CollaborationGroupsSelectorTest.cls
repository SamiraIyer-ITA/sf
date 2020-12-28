@IsTest
private class CollaborationGroupsSelectorTest {
    
    @IsTest
	static void testSelectById() {
		List<CollaborationGroup> result = CollaborationGroupsSelector.newInstance().selectById(new Set<Id> {});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List not empty');
	}

	@IsTest
	static void testSelectByCollaborationGroupNames() {
		CollaborationGroup collaborationGroup = new CollaborationGroup(
			Name = 'Test Group',
            CollaborationType = 'Public'
		);
		insert collaborationGroup;
		List<CollaborationGroup> groups
            = CollaborationGroupsSelector.newInstance().selectByCollaborationGroupNames(new Set<String>{ 'Test Group' });
        System.assertEquals('Test Group', groups[0].Name, 'Verify group name');
	}

}