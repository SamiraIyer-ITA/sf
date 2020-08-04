global without sharing class Flow_IssueCreditCardRefund {

	private static Map<Id, List<Order>> paymentOrderMap = new Map<Id, List<Order>>();  //Id = Payment Id
	private static Map<Id, Decimal> paymentRefundMap = new Map<Id, Decimal>();   //Id = Payment Id, Decimal is total refund for that payment
	private static Map<Id, Decimal> orderRefundMap = new Map<Id, Decimal>();	  // Id = order.id, Decimal is the refund for that order
	private static List<Order> orders;
	private static List<String> orderRefundAmounts;

	@InvocableMethod(label='Issue a Credit Card Refund' description='Issues a Credit Card refund through Pay.gov, inserts a refund (Payment2__c) record, and updates the order(s)' category='Payments')
	global static List<ResponseVariables> issueCreditCardRefund(List<RequestVariables> inputs){
		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();
		List<String> errorList = new List<String>();

		if (inputs.isEmpty()) {
			return errorMessageResponse('<li>Nothing to validate.</li>', responseVariables, responseVariablesList);
		}

		try {
			populateVariables(inputs);

			Order order;
			for (Integer x=0; x<orders.size(); x++) {
				order = orders[x];
				//Check to make sure that each order is paid
				if (order.Order_Paid__c != true) {
					return errorMessageResponse('<li>All orders must be paid before issuing refunds.</li>', responseVariables, responseVariablesList);
				}
				populatePaymentOrderRefundMaps(order, orderRefundAmounts[x]);
			}

			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(paymentOrderMap.keySet());
			Map<Id, Payment2__c> paymentIdMap =new Map<Id, Payment2__c>(payments);

			for(Payment2__c payment :payments) {
				if (payment.Payment_Type__c != 'PLASTIC_CARD') {
					return errorMessageResponse('<li>This refund process is only for credit card payments.  Refunds for other payment types must be processed through NIST.</li>', responseVariables, responseVariablesList);
				}
				issueRefundForPayment(payment);
			}

			if (! errorList.isEmpty()) {
				return errorMessageResponse(String.join(errorList, '  '), responseVariables, responseVariablesList);
			}

			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		} catch(Exception e) {
			throw new IssueCreditCardRefundActionException(e.getMessage());
		}
	}

	private static void populateVariables(List<RequestVariables> inputs) {
		orders = inputs[0].orders;
		orderRefundAmounts = inputs[0].orderRefundAmounts;
	}

	private static void  populatePaymentOrderRefundMaps(Order order, String refundAmountString) {
		orderRefundMap.put(order.Id, Decimal.valueOf(refundAmountString));
		List<order> o = new List<order>();
		if (paymentOrderMap.containsKey(order.Payment2__c)) {
			o = paymentOrderMap.get(order.Payment2__c);
			o.add(order);
			paymentOrderMap.put(order.Payment2__c, o);
		} else {
			o.add(order);
			paymentOrderMap.put(order.Payment2__c, o);
		}
		if (paymentRefundMap.containsKey(order.Payment2__c)) {
			Decimal d = paymentRefundMap.get(order.Payment2__c);
			d += Decimal.ValueOf(refundAmountString);
			paymentRefundMap.put(order.Payment2__c, d);
		} else {
			paymentRefundMap.put(order.Payment2__c, Decimal.ValueOf(refundAmountString));
		}
	}

	private static List<ResponseVariables> errorMessageResponse(String errorMessage, ResponseVariables responseVariables, List<ResponseVariables> responseVariablesList) {
		responseVariables.hasError = true;
		responseVariables.errorReasons = errorMessage;
		responseVariablesList.add(responseVariables);
		return responseVariablesList;
	}

	private static void issueRefundForPayment(Payment2__c payment) {
		String refundBindingName = 'RefundFor' + payment.Payment_Processor__c;
		IRefund refund = (IRefund) di_Injector.Org.getInstance(refundBindingName);

		//For each Payment, issue the refund
		Decimal refundAmount = paymentRefundMap.get(payment.Id);
		List<order> orderList = paymentOrderMap.get(payment.Id);
		Payment2__c refundRecord = refund.issueRefund(payment, orderList, refundAmount, orderRefundMap);
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;

		@InvocableVariable(label='Order Refund Reasons' required=true)
		global List<String> orderRefundReasons;

		@InvocableVariable(label='Order Refund Amounts' required=true)
		global List<String> orderRefundAmounts;

		@InvocableVariable(label='Order Refund Explanations' required=true)
		global List<String> orderRefundExplanations;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Has Error' required=true)
		global Boolean hasError = false;

		@InvocableVariable(label='Error Reasons' required=true)
		global String errorReasons;
	}

	class IssueCreditCardRefundActionException extends Exception {}
}