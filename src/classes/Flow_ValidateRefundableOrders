global without sharing class Flow_ValidateRefundableOrders {

	@InvocableMethod(label='Validate that Orders are Refundable.' description='Validate that Orders are Refundable.' category='Payments')
	global static List<ResponseVariables> validateRefundableOrders(List<RequestVariables> inputs){

		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();

		if (inputs.isEmpty()) {
			responseVariables.isValid = false;
			responseVariables.invalidReasons = '<li>Nothing to validate.</li>';
			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		}

		try {
			List<Order> passedInOrders = inputs[0].orders;

			if (passedInOrders.isEmpty()) {
				responseVariables.isValid = false;
				responseVariables.invalidReasons = '<li>No orders to validate.</li>';
				responseVariablesList.add(responseVariables);
				return responseVariablesList;
			}

			Map<Id, RefundData> refundDataMap = structureRefundInputs(inputs, passedInOrders);

			List<Order> orders = retrievePassedInOrderPaymentInfo(passedInOrders);

			if (passedInOrders.size() != orders.size()) {
				return returnInvalidOrderPayments(responseVariablesList,passedInOrders,responseVariables);
			}

			//Determine the account type.  All orders need to be the same Type.
			String accountType = orders[0].Type;

			//Create the Case Description, if one is needed to create a Case for NIST.
			String caseDescription = '';

			//Calculate the total amount of the refund, for use to inform the user.
			Decimal totalAmount = 0.00;

			List<String> errorList = new List<String>();

			for (Order order: orders) {
				//Populate the case description, with a blank line between each order's info
				RefundData refundData = refundDataMap.get(order.Id);
				if (String.isNotBlank(caseDescription)) {
					caseDescription += '\n\n';
				}

				totalAmount += refundData.refundAmount;  //Add up the total refund amount for all orders

				if (String.isNotBlank(refundData.refundExplanation)) {
					refundData.refundReason += '" with an explanation of "' + refundData.refundExplanation;
				}
				caseDescription += 'A refund of ' + refundData.refundAmountString + ' is requested for Payment Id: ' + order.Payment2__r.Name
					+ ' (Order Number: ' + order.OrderNumber + '). The reason for the refund is "' + refundData.refundReason + '".';

				errorList = determineErrorMessages(order,accountType,refundData);

				if (order.Payment2__r.Payment_Type__c != 'PLASTIC_CARD') {
					responseVariables.nonCreditCardPayment = true;
				}
			}

			return setResponseVariables(responseVariablesList, responseVariables, caseDescription, accountType, errorList, totalAmount);

		} catch(Exception e) {
			throw new ValidateRefundableOrdersActionException(e.getMessage());
		}
	}

	private static Map<Id, RefundData> structureRefundInputs (List<RequestVariables> inputs, List<Order> passedInOrders) {
		/*Create a Map of passedInOrder Ids and refund amounts, refund reasons and refund explanations.
		The map will be used to create a Case Description.
		A Case Description may be needed to create a Case for NIST.*/
		List<String> refundAmounts = inputs[0].refundAmounts;
		List<String> refundReasons = inputs[0].refundReasons;
		List<String> refundExplanations = inputs[0].refundExplanations;
		List<String> currentFormatList = new String[]{'0','number','###,###,##0.00'};
		Map<Id, RefundData> refundDataMap = new Map<Id, RefundData>();
		for (Integer x = 0; x<passedInOrders.size(); x++) {
			RefundData refundData = new RefundData();
			refundData.refundAmount = Decimal.valueOf(refundAmounts[x]);
			refundData.refundAmountString = '$' + String.format(refundData.refundAmount.format(), currentFormatList);
			refundData.refundReason = refundReasons[x];
			refundData.refundExplanation = refundExplanations[x];
			refundDataMap.put(passedInOrders[x].Id, refundData);
		}
		return refundDataMap;
	}

	private static List<Order> retrievePassedInOrderPaymentInfo (List<Order> passedInOrders) {
		//The passed-in orders don't have any payment information, so query for it
		Set<Id> orderIds = new Set<Id>();
		for (Order order: passedInOrders) {
			orderIds.add(order.Id);
		}
		return OrdersSelector.newInstance().selectByPaidNonPaidOnly(orderIds, false, true);
	}

	private static List<ResponseVariables> returnInvalidOrderPayments(List<ResponseVariables> responseVariablesList, List<Order> passedInOrders, ResponseVariables responseVariables) {
		//The passed-in orders must not have been already paid
		List<String> errorList = new List<String>();
		for (Order order: passedInOrders) {
			if (order.Order_Paid__c) {
				errorList.add('<li>Order \'' + order.Name + '\' has not yet been paid.</li>');
			}
		}
		responseVariables.isValid = false;
		if (! errorList.isEmpty()) {
			responseVariables.invalidReasons = String.join(errorList, '  ');  //Convert the list to a single string
		}
		responseVariablesList.add(responseVariables);
		return responseVariablesList;
	}

	private static List<String> determineErrorMessages(Order order, String accountType, RefundData refundData) {
		List<String> errorList = new List<String>();
		//Determine any error messages
		if (! order.Order_Paid__c) {
			errorList.add('<li>Order \'' + order.Name + '\' cannot be refunded because it hasn\'t been paid.</li>');
		}
		if (accountType != order.Type) {
			errorList.add('<li>The  \'Type\' field for all orders must match.</li>');
		}
		if (order.Payment2__c == null) {
			errorList.add('<li>Order \'' + order.Name + '\' is missing a payment.</li>');
		}
		if (Math.abs(refundData.refundAmount) > (order.TotalAmount - order.Refunded_Amount__c)) {
			errorList.add('<li>Order \'' + order.Name + '\' has a total amount that exceeds the amount available to be refunded.</li>');
		}
		return errorList;
	}

	private static List<ResponseVariables> setResponseVariables(List<ResponseVariables> responseVariablesList, ResponseVariables responseVariables,
																					String caseDescription, String accountType, List<String> errorList, Decimal totalAmount) {
		responseVariables.totalAmount = totalAmount;
		if (! errorList.isEmpty()) {
			responseVariables.isValid = false;
			responseVariables.invalidReasons = String.join(errorList, '  ');  //Convert the list to a single string
		} else {
			responseVariables.isValid = true;
		}
		responseVariables.caseDescription = caseDescription;
		responseVariables.accountType = accountType;
		responseVariablesList.add(responseVariables);
		return responseVariablesList;
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;

		@InvocableVariable(label='Refund Amounts' required=true)
		global List<String> refundAmounts;  //Amounts must be of type string because Flows won't pass in Decimal values

		@InvocableVariable(label='Refund Reasons' required=true)
		global List<String> refundReasons;

		@InvocableVariable(label='Refund Explanations' required=true)
		global List<String> refundExplanations;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Total Amount' required=true)
		global Decimal totalAmount;

		@InvocableVariable(label='Is Valid' required=true)
		global Boolean isValid = false;

		@InvocableVariable(label='Invalid Reasons' required=true)
		global String invalidReasons;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;

		@InvocableVariable(label='Non-credit card Payment' required=true)
		global Boolean nonCreditCardPayment = false;

		@InvocableVariable(label='Case Description' required=true)
		global String caseDescription;  //A description of the case, if one is created for NIST.
	}

	class ValidateRefundableOrdersActionException extends Exception {}

	class RefundData {
		Decimal refundAmount;
		String refundAmountString;
		String refundReason;
		String refundExplanation;
	}
}
