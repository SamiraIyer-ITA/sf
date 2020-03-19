public with sharing class RefundForPayGov implements IRefund {

	public static final String METADATA_SETTINGS_NAME = 'PayGov';

	public Payment2__c issueRefund(Payment2__c payment, List<Order> reductionOrders, Decimal refundAmount) {

		Map<String, Object> paymentSettingsMap = CustomMetadataSelector.getPaymentSettings(METADATA_SETTINGS_NAME);
		String agencyId = (String) paymentSettingsMap.get('Agency_Id__c');

		String remoteAccountName = Payment2.getRemoteAccountName(payment.Account_Type__c);

		PayGovTCSSingleService.PCRefundRequestType pcRefund = new PayGovTCSSingleService.PCRefundRequestType();
		pcRefund.orig_paygov_tracking_id = payment.Remote_Tracking_Id__c;
		pcRefund.transaction_amount = String.valueOf(refundAmount);
		pcRefund.orig_agency_tracking_id = payment.Name;

		PayGovTCSSingleService.TCSSinglePort payGovSingleService = new PayGovTCSSingleService.TCSSinglePort();
		PayGovTCSSingleService.PCRefundResponse_element pcRefundResponse = payGovSingleService.processPCRefund(agencyId, remoteAccountName, pcRefund);

		String transactionStatus;
		String returnCode;
		String returnDetail;
		String payGovTrackingId;
		Decimal returnedTransactionAmount;
		String transactionDate;
		String status;

		if (pcRefundResponse.pcRefund.transaction_status == 'Failed') {
			//Try to cancel the transaction instead of refunding it.  This is needed if the refund is attempted in less than 1 day.
			PayGovTCSSingleService.PCCancelRequestType pcCancel = new PayGovTCSSingleService.PCCancelRequestType();
			pcCancel.orig_paygov_tracking_id = payment.Remote_Tracking_Id__c;
			pcCancel.transaction_amount = String.valueOf(refundAmount);
			pcCancel.agency_tracking_id = payment.Name;
			PayGovTCSSingleService.PCCancelResponse_element pcCancelResponse = payGovSingleService.processPCCancel(agencyId, remoteAccountName, pcCancel);
			if (pcCancelResponse.pcCancel.transaction_status == 'Canceled') {
				payGovTrackingId = String.valueOf(pcCancelResponse.pcCancel.orig_paygov_tracking_id);
				returnedTransactionAmount = Decimal.valueOf(pcCancelResponse.pcCancel.transaction_amount);
				transactionDate = String.valueOf(pcCancelResponse.pcCancel.transaction_date);
				transactionStatus = pcCancelResponse.pcCancel.transaction_status;
				returnCode = pcCancelResponse.pcCancel.return_code;
				returnDetail = pcCancelResponse.pcCancel.return_detail;
			} else {
				//The error from pay.gov is in pcRefundResponse.pcRefund.return_detail.  However, it's not user friendly.
				//The error from pay.gov is: "Force or Refund amount exceeded authorized amount or the Refund amount exceeded remainder amount."
				String errorMessage = 'Partial refunds of transactions that occurred on the same business day are not allowed.  ';
				errorMessage += 'Either wait one business day to process a partial refund or attempt to refund the entire amount of the transaction.';
				AuraHandledException auraHandledException = new AuraHandledException(errorMessage);
				auraHandledException.setMessage(errorMessage);
				throw auraHandledException;
			}
		} else if (pcRefundResponse.pcRefund.transaction_status == 'In Process') {
			//The refund is in process with pay.gov.  No guarantee is made about it's success or failure.
			status = 'Initiated';
		} else {
			status = 'Success';
		}

		payGovTrackingId = String.valueOf(pcRefundResponse.pcRefund.paygov_tracking_id);
		returnedTransactionAmount = Decimal.valueOf(pcRefundResponse.pcRefund.transaction_amount);
		transactionDate = String.valueOf(pcRefundResponse.pcRefund.transaction_date);
		transactionStatus = pcRefundResponse.pcRefund.transaction_status;
		returnCode = pcRefundResponse.pcRefund.return_code;
		returnDetail = pcRefundResponse.pcRefund.return_detail;

		DateTime transactionDateGMT = null;
		if (!String.isEmpty(transactionDate)) {
			transactionDateGMT = DateTime.Valueof(transactionDate.replace('T', ' '));
			transactionDateGMT = getEST(transactionDateGMT);
		}

		Payment2__c refund = new Payment2__c();
		refund.RecordTypeId = Utils.getRecordTypeNameByDeveloperName('Credit_Card_Refund', 'Payment2__c');
		refund.Transaction_Amount__c = refundAmount;
		refund.Transaction_Date__c = transactionDateGMT;
		refund.Return_Code__c = returnCode;
		refund.Return_Detail__c = returnDetail;
		refund.Payment_Processor__c = payment.Payment_Processor__c;
		refund.Transaction_Status__c = status;
		refund.Remote_Tracking_Id__c = payGovTrackingId;
		fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
		uow.registerNew(refund);

		//Only update Orders if the refund was successful
		List<Order> originalOrders = new List<Order>();
		if (status == 'Success') {
			for (Order eachOrder : reductionOrders) {
				eachOrder.Payment2__c = refund.Id;
				eachOrder.Status = 'Paid';
				eachOrder.Order_Paid__c = true;
				uow.registerDirty(eachOrder, Order.Payment2__c, refund);
				//Update the original order to keep track of the refunded amount
				eachOrder.OriginalOrder.Refunded_Amount__c = eachOrder.OriginalOrder.Refunded_Amount__c + Math.abs(eachOrder.TotalAmount);
				originalOrders.add(eachOrder.OriginalOrder);
			}
			uow.registerDirty(originalOrders);
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