({
	getCommercialRecord : function(component, event, helper) {
        var action = component.get("c.getCommDiplTrig");
        // Getting the account id from page
        var taskId = component.get("v.recordId");
        // Setting parameters for server method
        action.setParams({
            taskIds: taskId
        });
        // Callback function to get the response
        action.setCallback(this, function(response) {
            // Getting the response state
            var state = response.getState();
            // Check if response state is success
            if(state === 'SUCCESS') {
                // Getting the list of contacts from response and storing in js variable
                var commObj = response.getReturnValue();
                // Set the list attribute in component with the value returned by function
                component.set("v.commObj",commObj);
            }
            else {
                // Show an alert if the state is incomplete or error
                alert('Error in getting data');
            }
        });
        // Adding the action variable to the global action queue
        $A.enqueueAction(action);
    }
})