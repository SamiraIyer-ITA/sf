({
    qsToEventMap: {
        'expid'  : 'e.c:setExpId'
    },
    
    handleForgotPassword: function (component, event, helpler) {
        console.log('click');
        var username = component.find("username").get("v.value");
        var checkEmailUrl = component.get("v.checkEmailUrl");
        var action = component.get("c.forgotPassword");
                console.log('data point1' + username + checkEmailUrl + action);

        action.setParams({username:username, checkEmailUrl:checkEmailUrl});
        action.setCallback(this, function(a) {
                            console.log('enter enqueu block');

            var rtnValue = a.getReturnValue();
                            console.log('ret value' + rtnValue);

            if (rtnValue != null) {
               component.set("v.errorMessage",rtnValue);
               component.set("v.showError",true);
                console.log('Success');
            }
            else{ console.log('Error');}
       });
                console.log('enqueue');

        $A.enqueueAction(action);
                        console.log('enqueued done');

    },

    setBrandingCookie: function (component, event, helpler) {
        var expId = component.get("v.expid");
        if (expId) {
            var action = component.get("c.setExperienceId");
            action.setParams({expId:expId});
            action.setCallback(this, function(a){ });
            $A.enqueueAction(action);
        }
    }
})