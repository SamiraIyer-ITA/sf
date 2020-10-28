@IsTest
private class Flow_ValidatePayableOrdersTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Id pricebookId = Test.getStandardPricebookId();

		Product2 product2 = TestUtils.createProduct(true);
		PricebookEntry pbe = TestUtils.createPricebookEntry(pricebookId, product2.Id, true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();

		Contract contract = new Contract();
		contract.Name = 'Contract Test X';
		contract.AccountId = account.Id;

		contract.Pricebook2Id = pricebookId;
		contract.StartDate = Date.newInstance(2020, 01, 01);
		contract.ContractTerm = 30;
		contract.BillingCountry = 'United States';
		contract.ShippingCountry = 'United States';
		contract.Status = 'Draft';
		insert contract;
		contract.Status = 'Activated';
		update contract;
		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, pricebookId);
		order1.Type = 'Services';
		order1.Name = 'Test Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebookId);
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

		OrderItem orderItem2 = new OrderItem();
		orderItem2.OrderId = order2.id;
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.Product2id = product2.id;
		orderItem2.PricebookEntryId=pbe.id;
		insert orderItem2;

	}

	@IsTest
	static void validatePayableOrders_Positive() {
		Flow_ValidatePayableOrders.RequestVariables requestVariables = new Flow_ValidatePayableOrders.RequestVariables();
		List<Order> orders = [SELECT Id, Name, Type, TotalAmount, Order_Paid__c FROM ORDER WHERE Name = 'Test Order X'];
		requestVariables.orders = orders;
		List<Flow_ValidatePayableOrders.RequestVariables> requestVariablesList = new List<Flow_ValidatePayableOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidatePayableOrders.ResponseVariables> returnList = Flow_ValidatePayableOrders.validatePayableOrders(requestVariablesList);
		System.assertEquals(true, returnList[0].isValid);
	}

	@IsTest
	static void validatePayableOrders_Negative() {
		Flow_ValidatePayableOrders.RequestVariables requestVariables = new Flow_ValidatePayableOrders.RequestVariables();
		List<Order> orders = [SELECT Id, Name, Type, TotalAmount, Order_Paid__c FROM ORDER WHERE Name = 'Test Order X'];
		for (Order order: orders) {
			order.Order_Paid__c = true;
		}
		update orders;
		requestVariables.orders = orders;
		List<Flow_ValidatePayableOrders.RequestVariables> requestVariablesList = new List<Flow_ValidatePayableOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidatePayableOrders.ResponseVariables> returnList = Flow_ValidatePayableOrders.validatePayableOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

	@IsTest
	static void validatePayableOrders_EmptyOrders() {
		Flow_ValidatePayableOrders.RequestVariables requestVariables = new Flow_ValidatePayableOrders.RequestVariables();
		List<Order> orders = new List<Order>();
		requestVariables.orders = orders;
		List<Flow_ValidatePayableOrders.RequestVariables> requestVariablesList = new List<Flow_ValidatePayableOrders.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_ValidatePayableOrders.ResponseVariables> returnList = Flow_ValidatePayableOrders.validatePayableOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

	@IsTest
	static void validatePayableOrders_EmptyRequest() {
		List<Flow_ValidatePayableOrders.RequestVariables> requestVariablesList = new List<Flow_ValidatePayableOrders.RequestVariables>();
		List<Flow_ValidatePayableOrders.ResponseVariables> returnList = Flow_ValidatePayableOrders.validatePayableOrders(requestVariablesList);
		System.assertEquals(false, returnList[0].isValid);
	}

}