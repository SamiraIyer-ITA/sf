({
    updateSelection : function(cmp, event, helper) {
        cmp.set("v.selection",cmp.find("countrySelect").get("v.value"));
    }
})