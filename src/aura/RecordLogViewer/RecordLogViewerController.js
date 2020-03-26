({
	init: function (cmp, event, helper) {
		let recordId = cmp.get("v.recordId");
		helper.callServer(
			cmp,
			"c.getRecordLogs",
			function (response) {
				cmp.set("v.recordLogs", response);
			},
			{
				relatedRecordId: recordId
			}
		);
	},
	expanded: function(cmp, event) {
		let expandedValue = event.getSource().get("v.value");
		cmp.set("v.expanded", expandedValue);
	}
})