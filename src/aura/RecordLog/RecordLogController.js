({
	init : function(cmp, event, helper) {
       	let logData = cmp.get('v.log');
        if(logData!=null) {
			helper.parseLog(cmp, logData);                    
        }
	},
    expandedEvent : function(cmp) {
        let items = cmp.get('v.items');
        let expandedValue = cmp.get("v.expandAll");
        for (let i = 0; i < items.length; i++) {
        	items[i].expanded = expandedValue;
        }
		cmp.set('v.items', items);
	}
})