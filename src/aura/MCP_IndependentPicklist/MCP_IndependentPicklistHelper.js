({
    picklistUpdates: function (component, event, helpler) {
        console.log('fire off parent cmp update');
        var controllerValue = component.find("parentField").get("v.value");// We can also use event.getSource().get("v.value")
        var compEvent = component.getEvent("MCP_IndependentPickListUpdate");
        console.log('event set ' + compEvent);
        compEvent.setParams({"parentValue" : controllerValue,
                             "parentPath"  : component.get("v.parentFieldAPI")} );
		compEvent.fire();
    },
    
    UpdateFieldValues: function (component, event, helpler) {
        var mylist = component.get("v.extraFields");
        var ParentSet = component.find("parentField");
       // var childSey = component.find("childField");
       // console.log('par test ' + ParentSet);
        var index;
        //  extraFields
        
        if(mylist != null)
        {
            for (index in mylist) { 
                console.log(index);
                console.log(mylist[index]);
                console.log('picklist check....' + mylist[index].pickListData.isPickList);
                if(mylist[index].pickListData.isPickList){
                    
                    console.log('picklist Found ');
                    console.log(mylist[index].fieldPath);
                    if(mylist[index].name == 'Country_1__c'){
                        mylist[index].value = component.find('Parent').get("v.value");
                    }
                    if(mylist[index].name == 'Organization_Type__c'){
                        mylist[index].value = component.find('Child').get("v.value");
                    }
                }
            }
        }
    }
})