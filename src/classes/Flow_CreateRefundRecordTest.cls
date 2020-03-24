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
		order1.Name = 'Test Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'Test Order X';
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

		order2.Status = 'Paid';
		order2.Order_Paid__c = true;
		update order2;

		//Insert a Payment record
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Check';
		requestVariables.amount = 4800;
		requestVariables.orders = orders;
		requestVariables.contractId = order1.ContractId;
		requestVariables.bankName = 'Bank One';
		requestVariables.checkNumber = '1001';
		requestVariables.checkDate = Date.today();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);

		//Reduction Order 1
		Order reductionOrder1 = new Order(
			IsReductionOrder = true,
			OriginalOrderId = order1.Id,
			Pricebook2Id = order1.Pricebook2Id,
			EffectiveDate = order1.EffectiveDate,
			Status = 'Draft',
			Type = 'Services',
			RecordTypeId = servicesRecordTypeId,
			ContractId = order1.ContractId,
			AccountId = order1.AccountId,
			Name = 'Reduction Order X');

		insert reductionOrder1;

		OrderItem reductionOrderItem1 = new OrderItem();
		reductionOrderItem1.OriginalOrderItemId = orderItem1.Id;
		reductionOrderItem1.OrderId = reductionOrder1.id;
		reductionOrderItem1.Quantity = -2;
		reductionOrderItem1.UnitPrice = 2400;
		reductionOrderItem1.Product2id = product2.id;
		reductionOrderItem1.PricebookEntryId=pbe.id;
		insert reductionOrderItem1;

		//Reduction Order 2
		Order reductionOrder2 = new Order(
			IsReductionOrder = true,
			OriginalOrderId = order2.Id,
			Pricebook2Id = order2.Pricebook2Id,
			EffectiveDate = order2.EffectiveDate,
			Status = 'Draft',
			Type = 'Services',
			RecordTypeId = servicesRecordTypeId,
			ContractId = order1.ContractId,
			AccountId = order2.AccountId,
			Name = 'Reduction Order X');

		insert reductionOrder2;

		OrderItem reductionOrderItem2 = new OrderItem();
		reductionOrderItem2.OriginalOrderItemId = orderItem2.Id;
		reductionOrderItem2.OrderId = reductionOrder2.id;
		reductionOrderItem2.Quantity = -2;
		reductionOrderItem2.UnitPrice = 2400;
		reductionOrderItem2.Product2id = product2.id;
		reductionOrderItem2.PricebookEntryId=pbe.id;
		insert reductionOrderItem2;
	}

	@IsTest
	static void createRefundRecord_Positive_Check() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Reduction Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assertNotEquals(null, returnList[0].refundId);
	}

	@IsTest
	static void createRefundRecord_Positive_Cash() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Reduction Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assertNotEquals(null, returnList[0].refundId);
	}

	@IsTest
	static void createRefundRecord_Positive_BankTransfer() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Reduction Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assertNotEquals(null, returnList[0].refundId);
	}

	@IsTest
	static void createRefundRecord_Exception() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Blah';
		requestVariables.refundAmount = 2000;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Reduction Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assert(exceptionMessage.startsWith('Insert failed.'));
		}
	}


	@IsTest
	static void createRefundRecord_Exception2() {
		Flow_CreateRefundRecord.RequestVariables requestVariables = new Flow_CreateRefundRecord.RequestVariables();
		requestVariables.accountType = 'Services';
		requestVariables.refundAmount = 2000;
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
	static void createRefundRecord_Null() {
		List<Flow_CreateRefundRecord.RequestVariables> requestVariablesList = new List<Flow_CreateRefundRecord.RequestVariables>();
		List<Flow_CreateRefundRecord.ResponseVariables> returnList = Flow_CreateRefundRecord.createRefundRecord(requestVariablesList);
		System.assertEquals(null, returnList);
	}

}