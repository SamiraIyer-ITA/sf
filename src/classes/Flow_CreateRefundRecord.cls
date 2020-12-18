global without sharing class Flow_CreateRefundRecord {

	private static String contractId;
	private static String accountType;
	private static List<String> refundAmounts;
	private static List<String> refundReasons;
	private static List<String> refundExplanations;
	private static List<Order> orders;
	private static Map<Id, List<Order>> paymentOrderMap = new Map<Id, List<Order>>();  //Id = Payment Id
	private static Map<Id, Decimal> paymentRefundMap = new Map<Id, Decimal>();   //Id = Payment Id, Decimal is total refund for that payment
	private static Map<Id, Decimal> orderRefundMap = new Map<Id, Decimal>();	  // Id = order.id, Decimal is the refund for that order
	private static Map<Id, Order> orderListWithDetails;  //Id = Order Id.  A map of the Orders, but will each order having more related details
	private static List<Payment2__c> payments = new List<Payment2__c>();

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
			//Populate Variables
			if (! populateVariables(requestVariables)) {
				return errorMessageResponse('<li>All orders must be paid before issuing refunds.</li>', responseVariables, responseVariablesList);
			}

			//For each Payment, create the refund record
			createRefundRecords();

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

	private static void createRefundRecords() {
		for(Payment2__c payment :payments) {
			//Look at the first Order to get data from the associated Opportunity (all Orders are for the same Opportunity)
			List<Order> orderList = paymentOrderMap.get(payment.Id);
			Order order = orderListWithDetails.get(orderList[0].Id);

			//Create the refund record
			Payment2__c refund = createRefundRecord(payment, order);

			//Get the Project Code
			if (order.OrderItems.size() != 0) {
				if (String.isNotBlank(order.OrderItems[0].Accounting_code__c)) {
					refund.Project_Code__c = order.OrderItems[0].Accounting_code__c.Left(4) + '231';
				}
			}

			//Save the refund record
			saveRefundRecord(refund, payment);
		}
	}

	private static Boolean populateVariables(RequestVariables requestVariables) {

		contractId = requestVariables.contractId;
		accountType = requestVariables.accountType;
		refundAmounts = requestVariables.refundAmounts;
		refundReasons = requestVariables.refundReasons;
		refundExplanations = requestVariables.refundExplanations;
		orders = requestVariables.orders;

		//Get all the orders.  Orders are passed in, but not with related item details.
		orderListWithDetails = populateOrderMap();  //Id = Order Id

		for (Integer x=0; x<orders.size(); x++) {
			Order order = orders[x];
			//Check to make sure that each order is paid
			if (order.Order_Paid__c != true) {
				return false;
			}
			String refundAmountString = refundAmounts[x];
			populatePaymentOrderMap(order, refundAmountString);
			populatePaymentRefundMap(order, refundAmountString);
		}

		payments = PaymentsSelector2.newInstance().selectById(paymentOrderMap.keySet());
		return true;
	}

	private static Map<Id, Order> populateOrderMap() {
		//Get a list of the Order Ids
		Set<Id> orderIds = new Set<Id>();
		for (Order order: orders) {
			orderIds.add(order.Id);
		}

		return new Map<Id, Order>(OrdersSelector.newInstance().selectWithOrderItemDetails(orderIds, true));
	}

	private static Payment2__c createRefundRecord(Payment2__c payment, Order order) {
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
		refund.Collection_Post_Acronym__c		= order.Opportunity.Collection_Post__r.Acronym__c;
		refund.Fulfillment_Post_Name__c 		= order.Opportunity.Fulfillment_Post__r.Name;
		refund.Fulfillment_Post_Org_Code__c 	= order.Opportunity.Fulfillment_Post__r.Org_Code__c;
		refund.Fulfillment_Post_Acronym__c		= order.Opportunity.Fulfillment_Post__r.Acronym__c;
		refund.Receipt_Ready__c = true;
		return refund;
	}

	private static void populatePaymentOrderMap(Order order, String refundAmountString) {
		List<order> o = new List<order>();
		orderRefundMap.put(order.Id, Decimal.valueOf(refundAmountString));
		if (paymentOrderMap.containsKey(order.Payment2__c)) {
			o = paymentOrderMap.get(order.Payment2__c);
			o.add(order);
			paymentOrderMap.put(order.Payment2__c, o);
		} else {
			o.add(order);
			paymentOrderMap.put(order.Payment2__c, o);
		}
	}

	private static void populatePaymentRefundMap(Order order, String refundAmountString) {
		if (paymentRefundMap.containsKey(order.Payment2__c)) {
			Decimal d = paymentRefundMap.get(order.Payment2__c);
			d += Decimal.ValueOf(refundAmountString);
			paymentRefundMap.put(order.Payment2__c, d);
		} else {
			paymentRefundMap.put(order.Payment2__c, Decimal.ValueOf(refundAmountString));
		}
	}

	private static void saveRefundRecord(Payment2__c refund, Payment2__c payment) {
		try {
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
			uow.registerNew(refund);

			List<Order> ordersByPayment = paymentOrderMap.get(payment.Id);
			for (Integer x = 0; x < ordersByPayment.size(); x++) {
				Order eachOrder = ordersByPayment.get(x);
				eachOrder.Payment2__c = payment.Id;
				eachOrder.Refunded_Amount__c += orderRefundMap.get(eachOrder.Id);
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