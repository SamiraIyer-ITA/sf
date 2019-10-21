({
	doInit : function(component, event, helper) {
        console.log('fire init');
		var action = component.get("c.getIndependentPicklist");
        action.setParams({
            ObjectName : component.get("v.objectName"),
            parentField : component.get("v.parentFieldAPI"),
        });
        
        action.setCallback(this, function(response){
         	var status = response.getState();
            if(status === "SUCCESS"){
                var pickListResponse = response.getReturnValue();
                
                //save response 
                component.set("v.pickListMap",pickListResponse.pickListMap);
                component.set("v.parentFieldLabel",pickListResponse.parentFieldLabel);
                
                // create a empty array for store parent picklist values 
                var parentkeys = []; // for store all map keys 
                var parentField = []; // for store parent picklist value to set on lightning:select. 
                
                // Iterate over map and store the key
                for (var pickKey in pickListResponse.pickListMap) {
                    parentkeys.push(pickKey);
                }
                //set the parent field value for lightning:select
                if (parentkeys != undefined && parentkeys.length > 0) {
                    parentField.push('--- None ---');
                } 
                for (var i = 0; i < parentkeys.length; i++) {
                    parentField.push(parentkeys[i]);
                }  
                // set the parent picklist
                component.set("v.parentList", parentField);
            }
        });
        
        $A.enqueueAction(action);
	},
 
    parentFieldChange : function(component, event, helper) {
    	var controllerValue = component.find("parentField").get("v.value");// We can also use event.getSource().get("v.value")
        var pickListMap = component.get("v.pickListMap");
     
        if (controllerValue != '--- None ---') {
      		helper.picklistUpdates(component, event);
        }}
})
