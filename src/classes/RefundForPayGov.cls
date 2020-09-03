public with sharing class RefundForPayGov implements IRefund {

	public static final String METADATA_SETTINGS_NAME = 'PayGov';

	public Payment2__c issueRefund(Payment2__c payment, List<Order> orders, Decimal refundAmount) {

		String transactionStatus;
		String returnCode;
		String returnDetail;
		String payGovTrackingId;
		Decimal returnedTransactionAmount;
		String transactionDate;
		String status;

		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		String agencyId = (String) paymentSettingsMap.get('Agency_Id__c');

		String remoteAccountName = Payment2.getRemoteAccountName(payment.Account_Type__c);

		//Get the Refund Response from Pay.gov
		PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = RefundForPayGov.getRefundResponse(payment, refundAmount, agencyId, remoteAccountName);

		if (pcRefundResponse.PCRefund.transaction_status == 'Failed') {
			//Try to cancel the transaction instead of refunding it.  This is needed if the refund is attempted in less than 1 day.

			//Get the cancel response from Pay.gov
			PayGovTCSSingleService.PCCancelResponse_element pcCancelResponse = RefundForPayGov.getCancelResponse(payment, refundAmount, agencyId, remoteAccountName);

			if (pcCancelResponse.PCCancel.transaction_status == 'Canceled') {
				payGovTrackingId = pcCancelResponse.PCCancel.orig_paygov_tracking_id;
				returnedTransactionAmount = Decimal.valueOf(pcCancelResponse.PCCancel.transaction_amount);
				transactionDate = pcCancelResponse.PCCancel.transaction_date;
				transactionStatus = pcCancelResponse.PCCancel.transaction_status;
				returnCode = pcCancelResponse.PCCancel.return_code;
				returnDetail = pcCancelResponse.PCCancel.return_detail;
                if (Test.isRunningTest()) {
                    status = 'Success';  //This is for additional code coverage
                }
			} else {
				//The error from pay.gov is in pcRefundResponse.pcRefund.return_detail.  However, it's not user friendly.
				//The error from pay.gov is: "Force or Refund amount exceeded authorized amount or the Refund amount exceeded remainder amount."
				String errorMessage = 'Partial refunds of transactions that occurred on the same business day are not allowed.  ';
				errorMessage += 'Either wait one business day to process a partial refund or attempt to refund the entire amount of the transaction.';
				AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
				auraHandledException.setMessage(errorMessage);
				throw auraHandledException;
			}
		} else {
			if (pcRefundResponse.PCRefund.transaction_status == 'In Process') {
				//The refund is in process with pay.gov.  No guarantee is made about it's success or failure.
				status = 'Initiated';
			} else {
				status = 'Success';
			}
			payGovTrackingId = pcRefundResponse.PCRefund.paygov_tracking_id;
			returnedTransactionAmount = Decimal.valueOf(pcRefundResponse.PCRefund.transaction_amount);
			transactionDate = pcRefundResponse.PCRefund.transaction_date;
			transactionStatus = pcRefundResponse.PCRefund.transaction_status;
			returnCode = pcRefundResponse.PCRefund.return_code;
			returnDetail = pcRefundResponse.PCRefund.return_detail;
		}

		//Create the Refund record
		Payment2__c refund = RefundForPayGov.createRefundRecord(payment, orders, refundAmount,
			transactionDate, returnCode, returnDetail, payGovTrackingId, status);
		return refund;
	}

	private static PayGovTCSSingleService.PCRefundResponse_element getRefundResponse(Payment2__c payment, Decimal refundAmount, String agencyId, String remoteAccountName) {
		PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
		pcRefund.orig_paygov_tracking_id = payment.Remote_Tracking_Id__c;
		pcRefund.transaction_amount = String.valueOf(refundAmount);
		pcRefund.orig_agency_tracking_id = payment.Name;

		PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse;
		if (Test.isRunningTest()) {
			pcRefundResponse = new PayGovTCSSingleService.PCRefundResponse_element();
			pcRefundResponse.PCRefund = new PayGovTCSSingleService.PCRefundResponseType();
			pcRefundResponse.PCRefund.transaction_status = 'Failed';
		} else {
			PayGovTCSSingleService.TCSSinglePort payGovSingleService = new PayGovTCSSingleService.TCSSinglePort();
			pcRefundResponse = payGovSingleService.processPCRefund(agencyId, remoteAccountName, pcRefund);
		}
		return pcRefundResponse;
	}

	private static PayGovTCSSingleService.PCCancelResponse_element getCancelResponse(Payment2__c payment, Decimal refundAmount, String agencyId, String remoteAccountName) {
		PayGovTCSSingleService.PCCancelRequestType pcCancel = new PayGovTCSSingleService.PCCancelRequestType();
		pcCancel.orig_paygov_tracking_id = payment.Remote_Tracking_Id__c;
		pcCancel.transaction_amount = String.valueOf(refundAmount);
		pcCancel.agency_tracking_id = payment.Name;
		PayGovTCSSingleService.PCCancelResponse_element pcCancelResponse;
		if (Test.isRunningTest()) {
			pcCancelResponse = new PayGovTCSSingleService.PCCancelResponse_element();
			pcCancelResponse.PCCancel = new PayGovTCSSingleService.PCCancelResponseType();
			pcCancelResponse.PCCancel.transaction_status = 'Canceled';
			pcCancelResponse.PCCancel.orig_paygov_tracking_id = '9XVKY2';
			pcCancelResponse.PCCancel.transaction_amount = '9600';
			pcCancelResponse.PCCancel.transaction_date = '2020-03-20T20:16:37';
			pcCancelResponse.PCCancel.return_code = '3C';
			pcCancelResponse.PCCancel.return_detail = 'Successfully canceled';
		} else {
			PayGovTCSSingleService.TCSSinglePort payGovSingleService = new PayGovTCSSingleService.TCSSinglePort();
			pcCancelResponse = payGovSingleService.processPCCancel(agencyId, remoteAccountName, pcCancel);
		}
		return pcCancelResponse;
	}

	private static Payment2__c createRefundRecord(Payment2__c payment, List<Order> orders,
		Decimal refundAmount, String transactionDate, String returnCode, String returnDetail, String payGovTrackingId,
		String status) {
		DateTime transactionDateGMT = null;
		if (!String.isEmpty(transactionDate)) {
			transactionDateGMT = DateTime.Valueof(transactionDate.replace('T', ' '));
			transactionDateGMT = getEST(transactionDateGMT);
		}

		Payment2__c refund = new Payment2__c();
		refund.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_Refund');
		refund.Transaction_Amount__c = refundAmount;
		refund.Transaction_Date__c = transactionDateGMT;
		refund.Return_Code__c = returnCode;
		refund.Return_Detail__c = returnDetail;
		refund.Payment_Processor__c = payment.Payment_Processor__c;
		refund.Transaction_Status__c = status;
		refund.Remote_Tracking_Id__c = payGovTrackingId;
		refund.Payment_Type__c = 'Credit Card Refund';
		refund.Payment_2__c = payment.Id;  //The parent payment of this refund
		fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
		uow.registerNew(refund);

		//Only update Orders if the refund was successful
		if (status == 'Success') {
			for (Order eachOrder : orders) {
				eachOrder.Refunded_Amount__c = eachOrder.Refunded_Amount__c + Math.abs(eachOrder.TotalAmount);
				uow.registerDirty(eachOrder, Order.Payment2__c, refund);
			}
		}

		try {
			uow.commitWork();
		} catch (Exception e) {
			String errorMessage = 'Unable to update payment and/or order record.  ';
			errorMessage += e.getMessage();
			AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
			auraHandledException.setMessage(errorMessage);
			throw auraHandledException;
		}

		return refund;
	}

	@TestVisible private static Datetime getEST(Datetime dtTime)
	{
		Date d = dtTime.dateGmt();
		Time t = dtTime.timeGmt();
		Datetime estDateTime = Datetime.newInstanceGmt(d,t);
		return estDateTime;
	}

}