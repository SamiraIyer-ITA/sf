({
    doIssueRefund : function(cmp, event, helper) {

        var recordId = cmp.get("v.recordId");

        //Call the server
        helper.callServer(
            cmp,
            "c.issueRefund",
            function (response) {
                //console.log(JSON.stringify(response));
                //Update the component with the returned data
                cmp.set("v.refundLightningController", response);

                if (response.errorMessage != null) {
                    helper.showToast("Refund Error", 0, response.errorMessage, null, null, "error", "sticky");
                } else {
                    //Get the amount refund in currency format
                    var refundAmount = (response.refundObject.Transaction_Amount__c).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
                    this.showToast("Refund Issued", 5000, refundAmount + " has been successfully refunded", null, null, "success", "dismissible");
                }
            },
            {
                paymentId: recordId
            }
        );

    },

})