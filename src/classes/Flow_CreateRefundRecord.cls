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
			refund.Transaction_Amount__c = refundTotal;
			refund.Refund_Reason__c = refundReasons[0];  //Only the first refund reason is used
			refund.Refund_Explanation__c = refundExplanations[0];  //Only the first refund explanation is used

			try {
				fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
				uow.registerNew(refund);
				for (Integer x=0; x<orders.size(); x++) {
					Order eachOrder = orders.get(x);
					String refundAmountString = refundAmounts.get(x);
					Decimal refundAmount = Decimal.valueOf(refundAmountString);
					eachOrder.Payment2__c = refund.Id;
					eachOrder.Refunded_Amount__c += refundAmount;
					uow.registerDirty(eachOrder, Order.Payment2__c, refund);
				}
				uow.commitWork();
			} catch (Exception e) {
				String errorMessage = 'Unable to insert refund or update order records.' + e.getMessage();
				throw new CreateRefundRecordActionException(errorMessage);
			}

			responseVariables.refundId = refund.Id;
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
		@InvocableVariable(label='Contract Id' required=true)
		global String contractId;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;

		//The total refund
		@InvocableVariable(label='Refund Total' required=true)
		global Decimal refundTotal;

		//The individual refund amounts for each order
		//At this time, collections are limited to String values rather than Decimal
		@InvocableVariable(label='Refund Amounts' required=true)
		global List<String> refundAmounts;

		@InvocableVariable(label='Refund Reasons' required=true)
		global List<String> refundReasons;

		@InvocableVariable(label='Refund Explanations' required=true)
		global List<String> refundExplanations;

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

	class CreateRefundRecordActionException extends Exception {}

}