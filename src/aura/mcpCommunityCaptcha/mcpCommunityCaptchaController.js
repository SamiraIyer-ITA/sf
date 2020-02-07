({
    doInit: function (cmp, evt, helper){
        let vfOrigin = "https://danieldev-trade.cs33.force.com";
        window.addEventListener("message", function(event) {
            console.log(event.data);
            if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
                return;
            } 
            if (event.data==="Unlock"){            	
              let myButton = cmp.find("myButton");
                myButton.set('v.disabled', false);
            }            
        }, false);                
    },
    doSubmit: function (cmp, evt, helper){
        alert("Do Submit");
    }
    
})