({
    initialize: function(component, event, helper) {
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();        
        component.set('v.extraFields', helper.getExtraFields(component, event, helper));
        
        //	https://danieldev-trade.cs33.force.com/MCPCommunity
    },
    
    UpdateFieldValuesForDependantPickList: function (component, event, helpler) {
        console.log('save button pressed!');
        helpler.UpdateFieldValuesDependant(component, event, helpler);
    },
    
       UpdateFieldValuesForIndependantPickList: function (component, event, helpler) {
        console.log('save button pressed!');
        helpler.UpdateFieldValuesIndependant(component, event, helpler);
    },
      
    UpdateFieldValuesIndepentPickList: function (component, event, helpler) {
        console.log('save button pressed!');
       // helpler.UpdateFieldValues(component, event, helpler);
    },
    
    handleSelfRegister: function (component, event, helpler) {
        console.log('button pressed');
        helpler.handleSelfRegister(component, event, helpler);
    },
    
    setStartUrl: function (component, event, helpler) {
        var startUrl = event.getParam('startURL');
        if(startUrl) {
            component.set("v.startUrl", startUrl);
        }
    },
    
    setExpId: function (component, event, helper) {
        var expId = event.getParam('expid');
        if (expId) {
            component.set("v.expid", expId);
        }
        helper.setBrandingCookie(component, event, helper);
    },
    
    onKeyUp: function(component, event, helpler){
        //checks for "enter" key
        if (event.getParam('keyCode')===13) {
            helpler.handleSelfRegister(component, event, helpler);
        }
    }   
})