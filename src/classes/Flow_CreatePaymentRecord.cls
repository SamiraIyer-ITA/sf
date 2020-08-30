global without sharing class Flow_CreatePaymentRecord {

	private static String contractId;
	private static String paymentType;
	private static Decimal amount;
	private static List<Order> orders;
	private static String bankName;
	private static String checkNumber;
	private static Date checkDate;
	private static Datetime bankTransferDatetime;
	private static String accountType;

	@InvocableMethod(label='Create Payment Record' description='Inserts a Payment record and updates the order(s)' category='Payments')
	global static List<String> createPaymentRecord(List<RequestVariables> inputs){

		if (inputs.isEmpty()) {
			return null;
		}

		RequestVariables requestVariables = inputs[0];

		try {
			populateVariables(requestVariables);

			//Create the payment record
			Payment2__c payment = new Payment2__c();

			//Determine the record type id
			String recordTypeName = getRecordTypeNameForPaymentType(payment);

			//Populate Payment Details
			populatePaymentDetails(payment, recordTypeName);

			//Create Payment DML
			savePaymentRecord(payment);

			return new List<String>{(String) payment.Id};

		} catch(Exception e) {
			throw new CreatePaymentRecordActionException(e.getMessage());
		}
	}

	private static void populateVariables(RequestVariables requestVariables) {
		contractId = requestVariables.contractId;
		paymentType = requestVariables.paymentType;
		amount = requestVariables.amount;
		orders = requestVariables.orders;
		bankName = requestVariables.bankName;
		checkNumber = requestVariables.checkNumber;
		checkDate = requestVariables.checkDate;
		bankTransferDatetime = requestVariables.bankTransferDatetime;
		accountType = requestVariables.accountType;
	}

	private static String getRecordTypeNameForPaymentType(Payment2__c payment) {
		String recordTypeName;
		switch on paymentType {
			when 'Check' {

				payment.Bank_Name__c = bankName;
				payment.Check_Number__c = checkNumber;
				payment.Check_Date__c = checkDate;
				payment.Payment_Type__c = 'Check';
				recordTypeName = 'Check_Payment';
			}
			when 'Cash' {
				recordTypeName = 'Cash_Payment';
				payment.Payment_Type__c = 'Cash';
			}
			when 'Bank Transfer' {
				recordTypeName = 'Bank_Transfer_Payment';
				payment.Payment_Type__c = 'Bank Transfer';
				payment.Transaction_Date__c = bankTransferDatetime;
			}
			when else {
				throw new CreatePaymentRecordActionException('Invalid Payment Type');
			}
		}
		return recordTypeName;
	}

	private static void populatePaymentDetails(Payment2__c payment, String recordTypeName) {
		Id ordersId = orders[0].Id;
		payment.Account_Type__c = accountType;
		payment.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get(recordTypeName);
		payment.Contract__c = contractId;
		payment.Payment_Processor__c = '';
		payment.Transaction_Status__c = 'Success';
		payment.Transaction_Amount__c = amount;

		//Look at the first Order to get data from the associated Opportunity
		Set<Id> orderIds = new Set<Id>();
		orderIds.add(ordersId);
		//The OrdersSelector will only return order items that are marked as primary
		List<Order> orders = OrdersSelector.newInstance().selectWithOrderItemDetails(orderIds, true);
		Order order = orders[0];

		payment.Organization_Name__c 			= order.Opportunity.Account.Name;
		payment.Opportunity_Owner__c 			= order.Opportunity.Owner.Name;
		payment.Opportunity_Created_Date__c 	= order.Opportunity.CreatedDate;
		payment.Collection_Post_Name__c 		= order.Opportunity.Collection_Post__r.Name;
		payment.Collection_Post_Org_Code__c 	= order.Opportunity.Collection_Post__r.Org_Code__c;
		payment.Collection_Post_Acronym__c		= order.Opportunity.Collection_Post__r.Acronym__c;
		payment.Fulfillment_Post_Name__c 		= order.Opportunity.Fulfillment_Post__r.Name;
		payment.Fulfillment_Post_Org_Code__c 	= order.Opportunity.Fulfillment_Post__r.Org_Code__c;
		payment.Fulfillment_Post_Acronym__c		= order.Opportunity.Fulfillment_Post__r.Acronym__c;
		if (order.OrderItems.size() != 0) {
			if (String.isNotBlank(order.OrderItems[0].Accounting_code__c)) {
				payment.Project_Code__c = order.OrderItems[0].Accounting_code__c.Left(4) + '231';
			}
		}
	}

	private static void savePaymentRecord(Payment2__c payment) {
		try {
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new List<SObjectType> {Payment2__c.SObjectType, Order.SObjectType});
			uow.registerNew(payment);
			for (Order eachOrder: orders) {
				eachOrder.Payment2__c = payment.Id;
				eachOrder.Order_Paid__c = true;
				payment.Receipt_Ready__c = true;
				uow.registerDirty(eachOrder, Order.Payment2__c, payment);
			}
			uow.commitWork();
		} catch (Exception e) {
			String errorMessage = 'Unable to insert payment or update order records.';
			throw new CreatePaymentRecordActionException(errorMessage + '  ' + e.getMessage());
		}
	}

	//Inputs from Flow to Apex
	global class RequestVariables {
		@InvocableVariable(label='Contract Id' required=true)
		global String contractId;

		@InvocableVariable(label='Payment Type' required=true)
		global String paymentType;  //Bank Transfer, Cash, Check

		@InvocableVariable(label='Payment Amount' required=true)
		global Decimal amount;

		@InvocableVariable(label='Orders' required=true)
		global List<Order> orders;

		@InvocableVariable(label='Bank Name' required=false)
		global String bankName;

		@InvocableVariable(label='Check Number' required=false)
		global String checkNumber;

		@InvocableVariable(label='Check Date' required=false)
		global Date checkDate;

		@InvocableVariable(label='Bank Transfer Datetime' required=false)
		global Datetime bankTransferDatetime;

		@InvocableVariable(label='Account Type' required=true)
		global String accountType;
	}

	class CreatePaymentRecordActionException extends Exception {}


}