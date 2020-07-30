global without sharing class Flow_CreateRefundRecord {

	@InvocableMethod(label='Create Refund Record' description='Inserts a Refund record and updates the order(s)' category='Payments')
	global static List<ResponseVariables> createRefundRecord(List<RequestVariables> inputs){

		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();

		if (inputs.isEmpty()) {
			return errorMessageResponse('<li>Nothing to validate.</li>', responseVariables, responseVariablesList);
		}

		List<String> errorList = new List<String>();
		RequestVariables requestVariables = inputs[0];

		try {
			String contractId = requestVariables.contractId;
			String accountType = requestVariables.accountType;
			List<String> refundAmounts = requestVariables.refundAmounts;
			List<String> refundReasons = requestVariables.refundReasons;
			List<String> refundExplanations = requestVariables.refundExplanations;
			List<Order> orders = requestVariables.orders;

			Order myOrder;
			String refundAmountString;

			Map<Id, List<Order>> paymentOrderMap = new Map<Id, List<Order>>();  //Id = Payment Id
			Map<Id, Decimal> paymentRefundMap = new Map<Id, Decimal>();   //Id = Payment Id, Decimal is total refund for that payment
			Map<Id, Decimal> orderRefundMap = new Map<Id, Decimal>();	  // Id = order.id, Decimal is the refund for that order

			for (Integer x=0; x<orders.size(); x++) {
				myOrder = orders[x];
				//Check to make sure that each order is paid
				if (myOrder.Order_Paid__c != true) {
					return errorMessageResponse('<li>All orders must be paid before issuing refunds.</li>', responseVariables, responseVariablesList);
				}
				refundAmountString = refundAmounts[x];
				populatePaymentOrderMap(myOrder, orderRefundMap, refundAmountString, paymentOrderMap);
				populateRefundOrderMap(paymentRefundMap, myOrder, refundAmountString);
			}

			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(paymentOrderMap.keySet());
			Map<Id, Payment2__c> paymentIdMap =new Map<Id, Payment2__c>(payments);

			for(Payment2__c payment :payments) {
				//For each Payment, issue the refund

				//Look at the first Order to get data from the associated Opportunity
				List<Order> orderList = paymentOrderMap.get(payment.Id);
				Set<Id> orderIds = new Set<Id>();
				orderIds.add(orderList[0].Id);
				List<Order> orderListWithDetails = OrdersSelector.newInstance().selectWithOrderItemDetails(orderIds, true);
				Order order = orderListWithDetails[0];

				//Create the refund record
				Payment2__c refund = createPayment2(accountType, contractId, paymentRefundMap, refundReasons, refundExplanations, order, payment);

				if (order.OrderItems.size() != 0) {
					if (String.isNotBlank(order.OrderItems[0].Accounting_code__c)) {
						refund.Project_Code__c = order.OrderItems[0].Accounting_code__c.Left(4) + '231';
					}
				}

				attemptRefundDML(refund, paymentOrderMap, orderRefundMap, payment);
			}//End loop

			if (! errorList.isEmpty()) {
				responseVariables.hasError = true;
				responseVariables.errorReasons = String.join(errorList, '  ');  //Convert the list to a single string
			}
			responseVariablesList.add(responseVariables);
			return responseVariablesList;

		} catch(Exception e) {
			throw new CreateRefundRecordActionException(e.getMessage());
		}
	}

	private static Payment2__c createPayment2(String accountType, String contractId, Map<Id,Decimal> paymentRefundMap,
												List<String> refundReasons, List<String> refundExplanations, Order order, Payment2__c payment) {
		//Create the refund record
		Payment2__c refund = new Payment2__c();

		String recordTypeName = 'NIST_Issued_Refund';
		refund.Payment_Type__c = 'NIST-Handled Refund';
		refund.Payment_2__c = payment.Id;  //A reference to the parent payment record
		refund.Account_Type__c = accountType;
		refund.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get(recordTypeName);
		refund.Contract__c = contractId;
		refund.Payment_Processor__c = '';
		refund.Transaction_Status__c = 'Success';
		refund.Transaction_Amount__c = paymentRefundMap.get(payment.Id);
		refund.Refund_Reason__c = refundReasons[0];  //Only the first refund reason is used
		refund.Refund_Explanation__c = refundExplanations[0];  //Only the first refund explanation is used
		refund.Organization_Name__c 			= order.Opportunity.Account.Name;
		refund.Opportunity_Owner__c 			= order.Opportunity.Owner.Name;
		refund.Opportunity_Created_Date__c 		= order.Opportunity.CreatedDate;
		refund.Collection_Post_Name__c 			= order.Opportunity.Collection_Post__r.Name;
		refund.Collection_Post_Org_Code__c 		= order.Opportunity.Collection_Post__r.Org_Code__c;
		refund.Fulfillment_Post_Name__c 		= order.Opportunity.Fulfillment_Post__r.Name;
		refund.Fulfillment_Post_Org_Code__c 	= order.Opportunity.Fulfillment_Post__r.Org_Code__c;
		refund.Receipt_Ready__c = true;
		return refund;
	}

	private static void populatePaymentOrderMap(Order myOrder, Map<Id,Decimal> orderRefundMap, String refundAmountString, Map<Id,List<Order>> paymentOrderMap) {
		List<order> o = new List<order>();
		orderRefundMap.put(myOrder.Id, Decimal.valueOf(refundAmountString));
		if (paymentOrderMap.containsKey(myOrder.Payment2__c)) {
			o = paymentOrderMap.get(myOrder.Payment2__c);
			o.add(myOrder);
			paymentOrderMap.put(myOrder.Payment2__c, o);
		} else {
			o.add(myOrder);
			paymentOrderMap.put(myOrder.Payment2__c, o);
		}
	}

	private static void populateRefundOrderMap(Map<Id,Decimal> paymentRefundMap, Order myOrder, String refundAmountsString) {
		if (paymentRefundMap.containsKey(myOrder.Payment2__c)) {
			Decimal d = paymentRefundMap.get(myOrder.Payment2__c);
			d += Decimal.ValueOf(refundAmountsString);
			paymentRefundMap.put(myOrder.Payment2__c, d);
		} else {
			paymentRefundMap.put(myOrder.Payment2__c, Decimal.ValueOf(refundAmountsString));
		}
	}

	private static void attemptRefundDML(Payment2__c refund, Map<Id,List<Order>> paymentOrderMap, Map<Id,Decimal> orderRefundMap, Payment2__c payment) {
		try {
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
			uow.registerNew(refund);

			List<Order> ordersByPayment = paymentOrderMap.get(payment.Id);
			for (Integer x = 0; x < ordersByPayment.size(); x++) {
				Order eachOrder = ordersByPayment.get(x);
				eachOrder.Payment2__c = payment.Id;
				eachOrder.Refunded_Amount__c += orderRefundMap.get(eachOrder.Id);
				system.debug('Order.Payment2__c ==> ' + Order.Payment2__c);
				uow.registerDirty(eachOrder, Order.Payment2__c, payment);
			}
			uow.commitWork();
		} catch (Exception e) {
			String errorMessage = 'Unable to insert refund or update order records.' + e.getMessage();
			throw new CreateRefundRecordActionException(errorMessage);
		}
	}

	private static List<ResponseVariables> errorMessageResponse(String errorMessage, ResponseVariables responseVariables, List<ResponseVariables> responseVariablesList) {
		responseVariables.hasError = true;
		responseVariables.errorReasons = errorMessage;
		responseVariablesList.add(responseVariables);
		return responseVariablesList;
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;

		@InvocableVariable(label='Refund Reasons' required=true)
		global List<String> refundReasons;

		@InvocableVariable(label='Refund Amounts' required=true)
		global List<String> refundAmounts;

		@InvocableVariable(label='Refund Explanations' required=true)
		global List<String> refundExplanations;
		// the following three variables are not in the credit card refund flow

		@InvocableVariable(label='Contract Id' required=true)
		global String contractId;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;

		//The total refund
		@InvocableVariable(label='Refund Total' required=true)
		global Decimal refundTotal;

	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Has Error' required=true)
		global Boolean hasError = false;

		@InvocableVariable(label='Error Reasons' required=true)
		global String errorReasons;
	}

	class CreateRefundRecordActionException extends Exception {}

}