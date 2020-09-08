@IsTest
private class Flow_CreateRefundRecordTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product2 = TestUtils.createProduct(true);
		ID standardPbId = Test.getStandardPricebookId();
		PricebookEntry standardPbe = TestUtils.createPricebookEntry(standardPbId, product2.Id, true);
		PricebookEntry pbe = TestUtils.createPricebookEntry(pricebook.Id, product2.Id, true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();
		Contract contract = new Contract();
		contract.Name = 'Contract Test X';
		contract.AccountId = account.Id;
		insert contract;
		contract.Status = 'Activated';
		update contract;
		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order1.Type = 'Services';
		order1.Name = 'Paid Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'Unpaid Order X';
		order2.Order_Paid__c = false;
		order2.ContractId = contract.Id;
		order2.RecordTypeId = servicesRecordTypeId;
		orders.add(order2);
		update orders;

		OrderItem orderItem1 = new OrderItem();
		orderItem1.OrderId = order1.id;
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.Product2id = product2.id;
		orderItem1.PricebookEntryId=pbe.id;
		insert orderItem1;

		order1.Status = 'Paid';
		order1.Order_Paid__c = true;
		update order1;

		OrderItem orderItem2 = new OrderItem();
		orderItem2.OrderId = order2.id;
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.Product2id = product2.id;
		orderItem2.PricebookEntryId=pbe.id;
		insert orderItem2;

		//Insert a Payment record
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Check';
		requestVariables.amount = 4800;
		List<Order> paidOrders = new List<Order>();
		paidOrders.add(order1);
		requestVariables.orders = paidOrders;
		requestVariables.contractId = order1.ContractId;
		requestVariables.bankName = 'Bank One';
		requestVariables.checkNumber = '1001';
		requestVariables.checkDate = Date.today();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
	}

	@IsTest
	static void createRefundRecord_Positive_Check() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundtotal = 200;
		List<String> refundAmounts = new List<String>();
		refundAmounts.add('200.00');
		requestVariables.refundAmounts = refundAmounts;
		List<String> refundReasons = new List<String>();
		refundReasons.add('Other');
		requestVariables.refundReasons = refundReasons;
		List<String> refundExplanations = new List<String>();
		refundExplanations.add('Some other reason');
		requestVariables.refundExplanations = refundExplanations;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Paid Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		//System.assertNotEquals(null, returnList[0].refundId);
	}

	@IsTest
	static void createRefundRecord_Positive_Cash() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundTotal = 200;
		List<String> refundAmounts = new List<String>();
		refundAmounts.add('200.00');
		requestVariables.refundAmounts = refundAmounts;
		List<String> refundReasons = new List<String>();
		refundReasons.add('Other');
		requestVariables.refundReasons = refundReasons;
		List<String> refundExplanations = new List<String>();
		refundExplanations.add('Some other reason');
		requestVariables.refundExplanations = refundExplanations;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Paid Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList); //
		System.assertEquals(false, returnList[0].hasError);
	}

	@IsTest
	static void createRefundRecord_Positive_BankTransfer() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundTotal = 200;
		List<String> refundAmounts = new List<String>();
		refundAmounts.add('200.00');
		requestVariables.refundAmounts = refundAmounts;
		List<String> refundReasons = new List<String>();
		refundReasons.add('Other');
		requestVariables.refundReasons = refundReasons;
		List<String> refundExplanations = new List<String>();
		refundExplanations.add('Some other reason');
		requestVariables.refundExplanations = refundExplanations;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Paid Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assertEquals(false, returnList[0].hasError);
	}

	@IsTest
	static void createRefundRecord_Exception() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Blah';
		requestVariables.refundTotal = 2000;
		List<String> refundAmounts = new List<String>();
		refundAmounts.add('2000.00');
		requestVariables.refundAmounts = refundAmounts;
		List<String> refundReasons = new List<String>();
		refundReasons.add('Other');
		requestVariables.refundReasons = refundReasons;
		List<String> refundExplanations = new List<String>();
		refundExplanations.add('Some other reason');
		requestVariables.refundExplanations = refundExplanations;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Unpaid Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = new List<Flow_CreateRefundRecord.ResponseVariables>();
		try {
			returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		} catch (Exception e) {
			String exceptionMessage = e.getMessage();
		} finally {
			System.assert(returnList[0].hasError);
		}
	}


	@IsTest
	static void createRefundRecord_Exception2() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundTotal = 2000;
		List<String> refundAmounts = new List<String>();
		refundAmounts.add('2000.00');
		requestVariables.refundAmounts = refundAmounts;
		List<String> refundReasons = new List<String>();
		refundReasons.add('Other');
		requestVariables.refundReasons = refundReasons;
		List<String> refundExplanations = new List<String>();
		refundExplanations.add('Some other reason');
		requestVariables.refundExplanations = refundExplanations;
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.debug('Exception Message: ' + exceptionMessage);
			System.assertEquals('Attempt to de-reference a null object', exceptionMessage);
		}
	}

	@IsTest
	static void createRefundRecord_Error() {
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assert(returnList[0].hasError);
	}

}
