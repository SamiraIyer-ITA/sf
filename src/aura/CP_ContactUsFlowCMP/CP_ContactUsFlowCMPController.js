({
	 init : function (cmp) {
         
      /*   //ecaptcha code
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

         /*/
         
         
         var flowName = $A.get("$Label.CP_ContactUsFlowNAme");
        var flow = cmp.find("flow");
               flow.startFlow("CP_Contact_Request_Standard_Flow");

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
    
})
