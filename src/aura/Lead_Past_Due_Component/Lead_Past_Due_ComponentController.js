({
	doInit : function(component, event, helper) {
		var action = component.get("c.getStatus");
		action.setParams({
            "leadRecordId": component.get("v.recordId")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.showMsg", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
    
        // Send action off to be executed
        $A.enqueueAction(action);
	}
})