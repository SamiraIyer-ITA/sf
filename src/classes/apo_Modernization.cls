public with sharing class apo_Modernization{
 
    //checking if the current user is assigned the APO_MODERNIZATION permission 
    @AuraEnabled(cacheable=false) 
    public static Boolean doesRunningUserHavePermission()
    {
        Set<Id> accessiblePermissionIds = new Set<Id>();
        for (SetupEntityAccess access : [
            SELECT SetupEntityId FROM SetupEntityAccess
            WHERE SetupEntityType = 'CustomPermission' AND ParentId IN (
                SELECT PermissionSetId FROM PermissionSetAssignment
                WHERE AssigneeId = :UserInfo.getUserId()
            )
        ]) accessiblePermissionIds.add(access.SetupEntityId);
    
        return 0 < [
            SELECT count() FROM CustomPermission
            WHERE Id IN :accessiblePermissionIds
            AND DeveloperName = :'APO_MODERNIZATION'
        ];
    }
    
    
}