({
	handleRedirect : function(cmp, event) {
		//Redirect to Pay.gov
		let detail = event.getParam("redirectUrl");
		console.log("detail: " + JSON.stringify(detail));
		let urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			"url": detail
		});
		urlEvent.fire();
	},

	handleCloseModal : function(cmp, event) {
		//Close the action modal
		$A.get("e.force:closeQuickAction").fire();
	}

});