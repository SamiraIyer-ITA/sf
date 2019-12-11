({
    picklistUpdates: function (component, event, helpler) {
        var controllerValue = component.find("parentField").get("v.value");// We can also use event.getSource().get("v.value")
        var controllerValue2 = component.find("childField").get("v.value");// We can also use event.getSource().get("v.value")
        var pickListMap = component.get("v.pickListMap");
        component.set("v.currentParentValue" ,controllerValue);
        component.set("v.currentChildValue" ,controllerValue2);
         var vx = component.get("v.updateValues");
         $A.enqueueAction(vx);
    },
    
})
