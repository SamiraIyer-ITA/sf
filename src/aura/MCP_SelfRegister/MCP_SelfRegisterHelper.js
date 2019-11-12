({
    qsToEventMap: {
        'startURL'  : 'e.c:setStartUrl'
    },
    
    qsToEventMap2: {
        'expid'  : 'e.c:setExpId'
    },
    
    UpdateFieldValuesDependant: function (component, event, helpler) {
        var mylist = component.get("v.extraFields");
        var ParentSet = objChild.get('v.currentParentValue'); //component.find("Parent");
        var childSet =  objChild.get('v.currentChildValue'); //component.find("Child");
        var parentFieldPath = objChild.get('v.parentFieldAPI');
        var childFieldPath =  objChild.get('v.childFieldAPI');
        var baseFeldPath;
        var index;
        
        if(mylist != null)
        {
            for (index in mylist) { 
                if(mylist[index].pickListData.isPickList){
                    if(mylist[index].name == parentFieldPath){
                        mylist[index].value = ParentSet; //component.find('Parent').get("v.value");
                    }
                    if(mylist[index].name == childFieldPath){ //Organization_Type__c'){
                        mylist[index].value = childSet; //component.find('Child').get("v.value");
                    }
                }
            }
        }
    },
    
    UpdateFieldValuesIndependant: function (component, event, helpler) {
        var mylist = component.get("v.extraFields");
        var ParentSet = objChild.get('v.currentParentValue'); //component.find("Parent");
        var parentFieldPath = objChild.get('v.parentFieldAPI');
        var baseFeldPath;
        var index;
        
        if(mylist != null)
        {
            for (index in mylist) { 
                if(mylist[index].pickListData.isPickList){
                    if(mylist[index].name == parentFieldPath){
                        mylist[index].value = ParentSet; //component.find('Parent').get("v.value");
                    }
                }
            }
        }
    },
    
    handleSelfRegister: function (component, event, helpler) {
        console.log('Attemping to save data!!!!!');
        var accountId = component.get("v.accountId");
        var regConfirmUrl = component.get("v.regConfirmUrl");
        var firstname = component.find("firstname").get("v.value");
        var lastname = component.find("lastname").get("v.value");
        var email = component.find("email").get("v.value");
        var includePassword = component.get("v.includePasswordField");
        var password = component.find("password").get("v.value");
        var confirmPassword = component.find("confirmPassword").get("v.value");
        var action = component.get("c.selfRegister");
        var extraFields = JSON.stringify(component.get("v.extraFields"));   // somehow apex controllers refuse to deal with list of maps
        var startUrl = component.get("v.startUrl");
        
        startUrl = decodeURIComponent(startUrl);
        
        action.setParams({firstname:firstname,lastname:lastname,email:email,
                          password:password, confirmPassword:confirmPassword, accountId:accountId, regConfirmUrl:regConfirmUrl, extraFields:extraFields, startUrl:startUrl, includePassword:includePassword});
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    getExtraFields : function (component, event, helpler) {
        var action = component.get("c.getExtraFields");
        action.setParam("extraFieldsFieldSet", component.get("v.extraFieldsFieldSet"));
        action.setCallback(this, function(a){
            var rtnValue = a.getReturnValue();
            if (rtnValue !== null) {
                component.set('v.extraFields',rtnValue);
            }
            helpler.captchaCallback();
        });
        $A.enqueueAction(action);
    },
    
    setBrandingCookie: function (component, event, helpler) {        
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }, 
    
    captchaCallback:  function() {
        //   grecaptcha.reset();
    }
})