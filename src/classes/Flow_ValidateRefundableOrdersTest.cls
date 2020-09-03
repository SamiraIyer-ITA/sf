@IsTest
private class Flow_ValidateRefundableOrdersTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product2 = TestUtils.createProduct(true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();
		ID standardPbId = Test.getStandardPricebookId();
		PricebookEntry standardPbe = TestUtils.createPricebookEntry(standardPbId, product2.Id, true);
		PricebookEntry pbe = TestUtils.createPricebookEntry(pricebook.Id, product2.Id, true);
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
	static void validateRefundableReductionOrders_Positive() {
		Flow_ValidateRefundableReductionOrders.RequestVariables requestVariables = new Flow_ValidateRefundableReductionOrders.RequestVariables();
		List<Order> orders = [SELECT Id, Name, Order_Paid__c, IsReductionOrder FROM ORDER WHERE Name = 'Reduction Order X'];
		requestVariables.orders = orders;
		List<Flow_ValidateRefundableReductionOrders.RequestVariables> requestVariablesList = new List<Flow_ValidateRefundableReductionOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidateRefundableReductionOrders.ResponseVariables> returnList = Flow_ValidateRefundableReductionOrders.validateRefundableReductionOrders(requestVariablesList);
		System.assertEquals(true, returnList[0].isValid);
	}

	@IsTest
	static void validateRefundableReductionOrders_Negative1() {
		Flow_ValidateRefundableReductionOrders.RequestVariables requestVariables = new Flow_ValidateRefundableReductionOrders.RequestVariables();
		List<Order> orders = [SELECT Id, Name, Order_Paid__c, IsReductionOrder FROM ORDER WHERE Name = 'Reduction Order X'];
		for (Order order: orders) {
			order.Order_Paid__c = true;
		}
		update orders;
		requestVariables.orders = orders;
		List<Flow_ValidateRefundableReductionOrders.RequestVariables> requestVariablesList = new List<Flow_ValidateRefundableReductionOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidateRefundableReductionOrders.ResponseVariables> returnList = Flow_ValidateRefundableReductionOrders.validateRefundableReductionOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

	@IsTest
	static void validateRefundableReductionOrders_Negative2() {
		Flow_ValidateRefundableReductionOrders.RequestVariables requestVariables = new Flow_ValidateRefundableReductionOrders.RequestVariables();
		List<Order> orders = [SELECT Id, Name, Order_Paid__c, IsReductionOrder, OriginalOrder.Order_Paid__c, OriginalOrder.Payment2__c FROM ORDER WHERE Name = 'Reduction Order X'];
		orders[0].Type = 'Blah';
		orders[0].OriginalOrder.Order_Paid__c = false;
		orders[0].OriginalOrder.Payment2__c = null;
		update orders;
		requestVariables.orders = orders;
		List<Flow_ValidateRefundableReductionOrders.RequestVariables> requestVariablesList = new List<Flow_ValidateRefundableReductionOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidateRefundableReductionOrders.ResponseVariables> returnList = Flow_ValidateRefundableReductionOrders.validateRefundableReductionOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}


	@IsTest
	static void validateRefundableReductionOrders_EmptyOrders() {
		Flow_ValidateRefundableReductionOrders.RequestVariables requestVariables = new Flow_ValidateRefundableReductionOrders.RequestVariables();
		List<Order> orders = new List<Order>();
		requestVariables.orders = orders;
		List<Flow_ValidateRefundableReductionOrders.RequestVariables> requestVariablesList = new List<Flow_ValidateRefundableReductionOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidateRefundableReductionOrders.ResponseVariables> returnList = Flow_ValidateRefundableReductionOrders.validateRefundableReductionOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

	@IsTest
	static void validateRefundableReductionOrders_EmptyRequest() {
		List<Flow_ValidateRefundableReductionOrders.RequestVariables> requestVariablesList = new List<Flow_ValidateRefundableReductionOrders.RequestVariables>();
		List<Flow_ValidateRefundableReductionOrders.ResponseVariables> returnList = Flow_ValidateRefundableReductionOrders.validateRefundableReductionOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

}