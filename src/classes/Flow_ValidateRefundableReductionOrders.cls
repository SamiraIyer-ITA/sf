global without sharing class Flow_ValidateRefundableReductionOrders {

	@InvocableMethod(label='Validate that Reduction Orders are Refundable.' description='Validate that Reduction Orders are Refundable.' category='Payments')
	global static List<ResponseVariables> validateRefundableReductionOrders(List<RequestVariables> inputs){

		ResponseVariables responseVariables = new ResponseVariables();
		List<ResponseVariables> responseVariablesList = new List<ResponseVariables>();

		if (inputs.isEmpty()) {
			responseVariables.isValid = false;
			responseVariables.invalidReasons = '<li>Nothing to validate.</li>';
			responseVariablesList.add(responseVariables);
			return responseVariablesList;
		}

		try {
			List<Order> ordersWithoutParentOrders = inputs[0].orders;

			if (ordersWithoutParentOrders.isEmpty()) {
				responseVariables.isValid = false;
				responseVariables.invalidReasons = '<li>No orders to validate.</li>';
				responseVariablesList.add(responseVariables);
				return responseVariablesList;
			}

			//The passed-in orders don't have information about their parent orders, so query them
			Set<Id> orderIds = new Set<Id>();
			for (Order order: ordersWithoutParentOrders) {
					orderIds.add(order.Id);
			}

			List<Order> orders = OrdersSelector.newInstance().selectWithReductionOrderDetails(orderIds, false, true, true, false);

			List<String> errorList = new List<String>();
			if (ordersWithoutParentOrders.size() != orders.size()) {
				//The orders were either already paid or are not reduction orders.
				for (Order order: ordersWithoutParentOrders) {
					if (! order.IsReductionOrder) {
						errorList.add('<li>Order \'' + order.Name + '\' is a not a reduction order.</li>');
					}
					if (order.Order_Paid__c && order.IsReductionOrder) {
						errorList.add('<li>Order \'' + order.Name + '\' has already been refunded.</li>');
					}
				}
				responseVariables.isValid = false;
				if (! errorList.isEmpty()) {
					responseVariables.invalidReasons = String.join(errorList, '  ');  //Convert the list to a single string
				}
				responseVariablesList.add(responseVariables);
				return responseVariablesList;
			}

			//Determine the account type.  All orders need to be the same Type.
			String accountType = orders[0].Type;

			Decimal totalAmount = 0.00;
			for (Order order: orders) {
				totalAmount += order.TotalAmount;  //Add up the total amount for all orders
				if (! order.IsReductionOrder) {
					errorList.add('<li>Order \'' + order.Name + '\' is a not a reduction order.</li>');
				}
				if (order.Order_Paid__c) {
					errorList.add('<li>Order \'' + order.Name + '\' has already been used for a refund.</li>');
				}
				if (accountType != order.Type) {
					errorList.add('<li>The  \'Type\' field for all orders must match.</li>');
				}
				if (order.OriginalOrderId == null) {
					errorList.add('<li>Order \'' + order.Name + '\' has no original order associated with it.</li>');
				} else {
					if (order.OriginalOrder.IsReductionOrder) {
						errorList.add('<li>Order \'' + order.Name + '\' is associated with a parent order that should not be a reduction order.</li>');
					}
					if (! order.OriginalOrder.Order_Paid__c) {
						errorList.add('<li>Order \'' + order.Name + '\' is associated with a parent order that was not paid.</li>');
					}
					if (order.OriginalOrder.Payment2__c == null) {
						errorList.add('<li>Order \'' + order.Name + '\' is associated with a parent order that is missing a payment.</li>');
					}
					if (Math.abs(order.TotalAmount) > (order.OriginalOrder.TotalAmount - order.OriginalOrder.Refunded_Amount__c)) {
						errorList.add('<li>Order \'' + order.Name + '\' has a total amount that exceeds the amount available to be refunded.</li>');
					}
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
			throw new ValidateRefundableReductionOrdersActionException(e.getMessage());
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
		global Decimal totalAmount;

		@InvocableVariable(label='Is Valid' required=true)
		global Boolean isValid;

		@InvocableVariable(label='Invalid Reasons' required=true)
		global String invalidReasons;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;
	}

	class ValidateRefundableReductionOrdersActionException extends Exception {}

}