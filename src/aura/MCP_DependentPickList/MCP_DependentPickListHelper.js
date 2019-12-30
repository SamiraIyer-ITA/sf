({
    picklistUpdates: function (component, event, helpler) {
        console.log('fire off parent cmp update');
        var controllerValue = component.find("parentField").get("v.value");// We can also use event.getSource().get("v.value")
        var controllerValue2 = component.find("childField").get("v.value");// We can also use event.getSource().get("v.value")
       
        var compEvent = component.getEvent("MCP_DependentPickListUpdate");
        console.log('event set ' + compEvent);
        compEvent.setParams({"parentValue" : controllerValue,
                             "childValue"  : controllerValue2,
                             "childPath"   : component.get("v.childFieldAPI"),
                             "parentPath"  : component.get("v.parentFieldAPI")} );
   console.log('event has been fired!');
		compEvent.fire();

        
        
        
        var pickListMap = component.get("v.pickListMap");
        component.set("v.currentParentValue" ,controllerValue);
        component.set("v.currentChildValue" ,controllerValue2);
        console.log('child level values set to ' + controllerValue + ':' + controllerValue2)
         //var vx = component.get("v.updateValues");
        // $A.enqueueAction(vx);
    },
    
})