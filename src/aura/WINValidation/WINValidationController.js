({  
	handleRecordUpdated : function(cmp, event, helper) {

		let validationMsg = '';
		let i = 0;

		if (! cmp.get('v.WINRecord.First_Approver__c')) {
			validationMsg = '<br/><br/>'+ ++i + '. You must assign a First Approver to the WIN in order to submit for approval';
		}

		if (! cmp.get('v.WINRecord.Final_Approver__c')) {
			validationMsg = validationMsg + '<br/><br/>'+ ++i + '. You must assign a Final Approver to the WIN in order to submit for approval';
		}

		if ((cmp.get('v.WINRecord.Country_in_Win__c') || cmp.get('v.WINRecord.Sys_Region_in_WIN_Rollup__c')) < 1) {
			validationMsg = validationMsg + '<br/><br/>'+ ++i + '. You must add a Country or Trade Region to the WIN in order to submit for approval.';
		}

		if (cmp.get('v.WINRecord.WIN_Contributors_Rollup__c') < 1) {
			validationMsg = validationMsg + '<br/><br/>'+ ++i + '. You must add a Contributors to the WIN in order to submit for approval.';
		}

		if (cmp.get('v.WINRecord.Industry_Rollup__c') < 1 ) {
			validationMsg= validationMsg + '<br/><br/>'+ ++i + '. You must add an Industry to the WIN in order to submit for approval.';
		}

        if (! cmp.get('v.WINRecord.Client_Verified__c')) {
			validationMsg = validationMsg + '<br/><br/>'+ ++i + '. You must check the Client Verified checkbox in order to submit for approval.';
		}
        
		if (cmp.get('v.WINRecord.Related_Cases_to_WIN_Count__c') < 1 ) {
			validationMsg = validationMsg + '<br/><br/>'+ ++i + '. You must add a Case to the WIN in order to submit for approval.';
		}

		if(validationMsg == '') {
			cmp.set('v.validationMessage', 'All requirements are complete. Please submit for approval.');
		} else {
			cmp.set('v.validationMessage', 'Failed the following validations: ' + validationMsg);
		}

	},
})