public interface ICollaborationGroupsSelector extends fflib_ISObjectSelector {
	
    List<CollaborationGroup> selectById(Set<Id> idSet);
    List<CollaborationGroup> selectByCollaborationGroupNames(Set<String> nameSet);
}