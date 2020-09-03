global without sharing class Flow_IssueCreditCardRefund {

	@InvocableMethod(label='Issue a Credit Card Refund' description='Issues a Credit Card refund through Pay.gov, inserts a refund (Payment2__c) record, and updates the order(s)' category='Payments')
	global static List<ResponseVariables> issueCreditCardRefund(List<RequestVariables> inputs){

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
			Decimal refundAmount = inputs[0].refundAmount;
			List<Order> orders = inputs[0].orders;

			//Verify that all orders have the same payment Id
			Id paymentId = orders[0].Payment2__c;
			for (Order order: orders) {
				if (paymentId != order.Payment2__c) {
					responseVariables.hasError = true;
					responseVariables.errorReasons = '<li>All orders weren\'t processed on the same payment.</li>';
					responseVariablesList.add(responseVariables);
					return responseVariablesList;
				}
			}

			List<Payment2__c> payments = PaymentsSelector2.newInstance().selectById(new Set<Id>{paymentId});
			Payment2__c payment = payments[0];

			if (payment.Payment_Type__c != 'PLASTIC_CARD') {
				responseVariables.hasError = true;
				responseVariables.errorReasons = '<li>This refund process is only for credit card payments.  Refunds for other payment types must be processed through NIST.</li>';
				responseVariablesList.add(responseVariables);
				return responseVariablesList;
			}

			String refundBindingName = 'RefundFor' + payment.Payment_Processor__c;
			IRefund refund = (IRefund) di_Injector.Org.getInstance(refundBindingName);
			Payment2__c refundRecord =  refund.issueRefund(payment, orders, refundAmount);

			responseVariables.refundId = refundRecord.Id;
			if (! errorList.isEmpty()) {
				responseVariables.hasError = true;
				responseVariables.errorReasons = String.join(errorList, '  ');  //Convert the list to a single string
			}
			responseVariablesList.add(responseVariables);
			return responseVariablesList;

		} catch(Exception e) {
			throw new IssueCreditCardRefundActionException(e.getMessage());
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Refund Amount' required=true)
		global Decimal refundAmount;

		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Refund Id' required=true)
		global String refundId;

		@InvocableVariable(label='Has Error' required=true)
		global Boolean hasError = false;

		@InvocableVariable(label='Error Reasons' required=true)
		global String errorReasons;

	}

	class IssueCreditCardRefundActionException extends Exception {}

}