({
    
    
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
 		var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        baseURL =  baseURL.slice(0, baseURL.lastIndexOf("/"));
        console.log('Running initialize' + urlString + " .........   " + baseURL);
        
        //reterive URL dynamically
         var URLaction = component.get("c.getURL");
        URLaction.setParams({ urlname : component.get("v.urlname") });
        URLaction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
        	     let vfOrigin = baseURL; //response.getReturnValue(); //    "https://danieldev-trade.cs33.force.com";
       			 window.addEventListener("message", function(event) {
       	    		 if (event.origin !== vfOrigin) {
                     return;
            			} 
            		if (event.data==="Unlock"){  
            		    component.set("v.eventData", event.data);    
             		    component.set("v.recaptchaValid", false);
            			}            
        			}, false);                
       		 }
        });
     $A.enqueueAction(URLaction);

        
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap}).fire();
        $A.get("e.siteforce:registerQueryEventMap").setParams({"qsToEvent" : helper.qsToEventMap2}).fire();        
        component.set('v.extraFields', helper.getExtraFields(component, event, helper));
       
    },
    
    UpdateFieldValuesForDependantPickList: function (component, event, helpler) {
        console.log('updates are fired')
        helpler.UpdateFieldValuesDependant(component, event, helpler);
    },
    
       UpdateFieldValuesForIndependantPickList: function (component, event, helpler) {
           console.log('fire off indi event in parent');
        helpler.UpdateFieldValuesIndependant(component, event, helpler);
    },
      
   UpdateFieldValuesIndepentPickList: function (component, event, helpler) {
       console.log('INDI EVENT FIRED');
        helpler.UpdateFieldValues(component, event, helpler);
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
//        if (event.getParam('keyCode')===13) {
      //      helpler.handleSelfRegister(component, event, helpler);
       // }
    }   
})