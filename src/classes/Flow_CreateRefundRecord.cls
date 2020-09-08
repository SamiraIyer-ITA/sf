global without sharing class Flow_CreateRefundRecord {

	@InvocableMethod(label='Create Refund Record' description='Inserts a Refund record and updates the order(s)' category='Payments')
	global static List<ResponseVariables> createRefundRecord(List<RequestVariables> inputs){
		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();
		List<String> errorList = new List<String>();

		if (inputs.isEmpty()) {
			responseVariables.hasError = true;
			responseVariables.errorReasons = '<li>Nothing to validate.</li>';
			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		}

		try {
			String contractId = inputs[0].contractId;
			String accountType = inputs[0].accountType;
			Decimal refundTotal = inputs[0].refundTotal;
			List<String> refundAmounts = inputs[0].refundAmounts;
			List<String> refundReasons = inputs[0].refundReasons;
			List<String> refundExplanations = inputs[0].refundExplanations;
			List<Order> orders = inputs[0].orders;

			Order myOrder;
			String refundAmountString;

			Map<Id, List<Order>> paymentOrderMap = new Map<Id, List<Order>>();  //Id = Payment Id
			Map<Id, Decimal> paymentRefundMap = new Map<Id, Decimal>();   //Id = Payment Id, Decimal is total refund for that payment
			Map<Id, Decimal> orderRefundMap = new Map<Id, Decimal>();	  // Id = order.id, Decimal is the refund for that order

			for (Integer x=0; x<orders.size(); x++) {
				myOrder = orders[x];
				//Check to make sure that each order is paid
				if (myOrder.Order_Paid__c != true) {
					responseVariables.hasError = true;
					responseVariables.errorReasons = '<li>All orders must be paid before issuing refunds.</li>';
					responseVariablesList.add(responseVariables);
					return responseVariablesList;
				}
				List<order> o = new List<order>();
				refundAmountString = refundAmounts[x];
				orderRefundMap.put(myOrder.Id, Decimal.valueOf(refundAmountString));
				if (paymentOrderMap.containsKey(myOrder.Payment2__c)) {
					o = paymentOrderMap.get(myOrder.Payment2__c);
					o.add(myOrder);
					paymentOrderMap.put(myOrder.Payment2__c, o);
				} else {
					o.add(myOrder);
					paymentOrderMap.put(myOrder.Payment2__c, o);
				}

				if (paymentRefundMap.containsKey(myOrder.Payment2__c)) {
					Decimal d = paymentRefundMap.get(myOrder.Payment2__c);
					d += Decimal.ValueOf(refundAmounts[x]);
					paymentRefundMap.put(myOrder.Payment2__c, d);
				} else {
					paymentRefundMap.put(myOrder.Payment2__c, Decimal.ValueOf(refundAmounts[x]));
				}
			}

			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(paymentOrderMap.keySet());
			Map<Id, Payment2__c> paymentIdMap =new Map<Id, Payment2__c>(payments);

			// Info from Opportunity
			Id orderId = orders[0].Id;
			Order orderWithData = [
					SELECT Id, (SELECT Order.Payment2__r.Id, ITA_Product_Code__c FROM OrderItems WHERE IsPrimary__c = TRUE LIMIT 1),
							Opportunity.Account.Name, Opportunity.Owner.Name, Opportunity.CreatedDate,
							Opportunity.Collection_Post__r.Name, Opportunity.Collection_Post__r.Org_Code__c,
							//Opportunity.Collection_Post__r.Acronym__c, Opportunity.Fulfillment_Post__r.Acronym__c add these after they exist
							Opportunity.Fulfillment_Post__r.Name, Opportunity.Fulfillment_Post__r.Org_Code__c
					FROM Order
					WHERE Id = :orderId
					LIMIT 1
			];
			for(Payment2__c payment :payments) {
				//For each Payment, issue the refund
				Decimal refundAmount = paymentRefundMap.get(payment.Id);
				List<order> orderList = paymentOrderMap.get(payment.Id);
				//Payment2__c refundRecord = refund.issueRefund(payment, orderList, refundAmount, orderRefundMap);

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
				refund.Organization_Name__c 			= orderWithData.Opportunity.Account.Name;
				refund.Opportunity_Owner__c 			= orderWithData.Opportunity.Owner.Name;
				refund.Opportunity_Created_Date__c 		= orderWithData.Opportunity.CreatedDate;
				refund.Collection_Post_Name__c 			= orderWithData.Opportunity.Collection_Post__r.Name;
				refund.Collection_Post_Org_Code__c 		= orderWithData.Opportunity.Collection_Post__r.Org_Code__c;
				refund.Fulfillment_Post_Name__c 		= orderWithData.Opportunity.Fulfillment_Post__r.Name;
				refund.Fulfillment_Post_Org_Code__c 	= orderWithData.Opportunity.Fulfillment_Post__r.Org_Code__c;
				if (orderWithData.OrderItems.size() != 0) {
					if (String.isNotBlank(orderWithData.OrderItems[0].ITA_Product_Code__c)) {
						refund.Project_Code__c = orderWithData.OrderItems[0].ITA_Product_Code__c.Left(4) + '231';
					}
				}

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
//
		@InvocableVariable(label='Has Error' required=true)
		global Boolean hasError = false;

		@InvocableVariable(label='Error Reasons' required=true)
		global String errorReasons;
	}

	class CreateRefundRecordActionException extends Exception {}

}
