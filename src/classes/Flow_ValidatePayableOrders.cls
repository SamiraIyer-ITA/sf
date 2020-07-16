global without sharing class Flow_ValidatePayableOrders {

	@InvocableMethod(label='Validate that Orders are Payable.' description='Validate that Orders are Payable.' category='Payments')
	global static List<ResponseVariables> validatePayableOrders(List<RequestVariables> inputs){

		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();

		if (inputs.isEmpty()) {
			responseVariables.isValid = false;
			responseVariables.invalidReasons = '<li>Nothing to validate.</li>';
			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		}

		try {
			List<Order> orders = inputs[0].orders;

			if (orders.isEmpty()) {
				responseVariables.isValid = false;
				responseVariables.invalidReasons = '<li>No orders to validate.</li>';
				responseVariablesList.add(responseVariables);
				return responseVariablesList;
			}

			//Determine the account type.  All orders are assumed to be of the same type
			String accountType = orders[0].Type;

			//Make sure the count of the orders is the same as the passed-in orders.
			Decimal totalAmount = 0.00;
			List<String> errorList = new List<String>();
			for (Order order: orders) {
				totalAmount += order.TotalAmount;  //Add up the total amount for all orders
				if (order.IsReductionOrder) {
					errorList.add('<li>Order \'' + order.Name + '\' is a reduction order.</li>');
				}
				if (order.Order_Paid__c && (! order.IsReductionOrder)) {
					errorList.add('<li>Order \'' + order.Name + '\' has already been paid.</li>');
				}
				if (accountType != order.Type) {
					errorList.add('<li>The  \'Type\' field for all orders must match.</li>');
				}
			}

			responseVariables.totalAmount = totalAmount;
			if (! errorList.isEmpty()) {
				responseVariables.isValid = false;
				responseVariables.invalidReasons = String.join(errorList, '  ');  //Convert the list to a single string
			} else {
				responseVariables.isValid = true;
			}
			responseVariables.accountType = accountType;
			responseVariablesList.add(responseVariables);
			return responseVariablesList;

		} catch(Exception e) {
			throw new ValidatePayableOrdersActionException(e.getMessage());
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;
	}

	//Outputs from Apex to Flow
	global class ResponseVariables {
		@InvocableVariable(label='Total Amount' required=true)
		global Decimal totalAmount = 0.00;

		@InvocableVariable(label='Is Valid' required=true)
		global Boolean isValid;

		@InvocableVariable(label='Invalid Reasons' required=true)
		global String invalidReasons;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType = '';
	}

	class ValidatePayableOrdersActionException extends Exception {}

}