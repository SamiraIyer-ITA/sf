({
	doInit : function(cmp, event, helper) {

		var recordId = cmp.get("v.recordId");

		//Call the server
		helper.callServer(
			cmp,
			"c.getPaymentDetails",
			function (response) {
				//Update the card with the returned data
				cmp.set("v.paymentDetailsController", response);
			},
			{
				paymentId: recordId
			}
		);

	},

})
