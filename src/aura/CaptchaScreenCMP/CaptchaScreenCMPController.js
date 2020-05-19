({  
     onButtonPressed: function(cmp, event, helper) {
      // Figure out which action was called
      var actionClicked = event.getSource().getLocalId();
      // Fire that action
      var navigate = cmp.get('v.navigateFlow');
      navigate(actionClicked);
   },
    sendToVF : function(component, event, helper) {
        console.log('Lightning Sends: ', component.get("v.message"));
        const visualforceDomain = 'https://'+component.get('v.visualforceDomain');
        //Visualforce Page's iframe window object
        const vfWindow = component.find("vfFrame").getElement().contentWindow;
        //Sending message using postMessage function
        //If sending an json object, its better to stringify first and send the object
        vfWindow.postMessage(component.get("v.message"), visualforceDomain);
        //resetting my text box with blank value
        component.set("v.message", "");
    },
    initialize: function(component, event, helper) {
        var urlString = window.location.href;
        var baseURL = urlString.substring(0, urlString.indexOf("/test"));
        component.set("v.s1",urlString);
        component.set("v.s2",baseURL);
        //reterive URL dynamically
        var URLaction = component.get("c.getURL");
        let lcomp = component.find("page1");
        let vfOrigin = baseURL;
        window.addEventListener("message", function(event) {
            if (event.data==="Unlock"){  
                component.set("v.eventData", event.data);    
                component.set("v.captchaStatus", true);
                var appEvent = $A.get("e.c:Flow_NextButtonNAvigation_Event");
                appEvent.setParams({
                    "action" : "PASS" });
                appEvent.fire();
            }    
        }, false);                
    }
})