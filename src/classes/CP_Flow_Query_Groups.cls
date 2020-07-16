global class CP_Flow_Query_Groups {
    
 @InvocableMethod(label='Return Group Id' description='Queries Group Id for flows Work around for Spring 2020 Release')
    global static list<Group> getId(List<RequestVariables> inputs) {
        List<Group> groupIds = new List<Group>();
        RequestVariables userInput = inputs[0];
        groupIds = [SELECT Id,Name FROM GROUP WHERE DeveloperName =: userinput.groupName LIMIT 1]; 
        if(groupIds.isempty()){
            return null;
        }
        else
        {
            return new List<Group>{groupIds[0]};
        }
    }
     global class RequestVariables {
        @InvocableVariable(label='Group DeveloperName' required=true)
        global String groupName;
        
}
    
}