public class CollaborationGroupsSelector extends fflib_SObjectSelector implements ICollaborationGroupsSelector {
    
    public static ICollaborationGroupsSelector newInstance(){
        return (ICollaborationGroupsSelector) fflibext_Application.Selector.newInstance(CollaborationGroup.SObjectType);
    }
    
    public List<CollaborationGroup> selectById(Set<Id> idSet) {
        return (List<CollaborationGroup>) selectSObjectsById(idSet);
    }
    
    public List<CollaborationGroup> selectByCollaborationGroupNames(Set<String> nameSet) {
        return (List<CollaborationGroup>)
            	Database.query(
                    newQueryFactory()
						.setCondition('Name IN :nameSet')
						.toSOQL()
                );
    }
    
    private List<Schema.SObjectField> getSObjectFieldList() {
        //add more fields as appropriate
        return new List<Schema.SObjectField>{
            CollaborationGroup.Id,
           	CollaborationGroup.Name
       };
     }
    
    private Schema.SObjectType getSObjectType() {
        return CollaborationGroup.SObjectType;
    }
}