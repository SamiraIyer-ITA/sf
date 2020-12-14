@IsTest
private class OrdersSelectorTest {

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
		order2.Name = 'Nonpaid Order X';
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

		//Insert a Payment record for Order 1
		Payment2__c payment1 = new Payment2__c();
		payment1.Account_Type__c = 'Services';
		payment1.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		order1.Payment2__c = payment1.Id;
		order1.Status = 'Paid';
		order1.Order_Paid__c = true;
		update order1;
	}

	@IsTest
	static void selectById_Positive() {
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM Order WHERE Name = 'Paid Order X'];
		Set<Id> orderIds = new Set<Id>();
		for (Order order: orders) {
			orderIds.add(order.Id);
		}
		List<Order> result = OrdersSelector.newInstance().selectById(orderIds);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List empty');
	}

	@IsTest
	static void selectByPaidNonPaidOnly_Positive() {
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM Order WHERE Name = 'Nonpaid Order X'];
		Set<Id> orderIds = new Set<Id>();
		for (Order order: orders) {
			orderIds.add(order.Id);
		}
		List<Order> result = OrdersSelector.newInstance().selectByPaidNonPaidOnly(orderIds, true, false);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List empty');
	}

	@IsTest
	static void selectByContractId_Positive() {
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM Order WHERE Name = 'Paid Order X'];
		Set<Id> contractIds = new Set<Id>();
		contractIds.add(orders[0].ContractId);
		List<Order> result = OrdersSelector.newInstance().selectByContractId(contractIds, false, false, true);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List empty');
	}

	@IsTest
	static void selectWithOrderItemDetails_Postive() {
		Set<Id> idSet = new Map<Id, Order>([SELECT Id FROM Order]).keySet();
		List<Order> result = OrdersSelector.newInstance().selectWithOrderItemDetails(idSet, false);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(idSet.size(), result.size());
	}

	@IsTest
	static void selectWithOrderItemDetails_Postive_IsPrimary() {
		Set<Id> idSet = new Map<Id, Order>([SELECT Id FROM Order]).keySet();
		List<Order> result = OrdersSelector.newInstance().selectWithOrderItemDetails(idSet, true);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(idSet.size(), result.size());
	}

	@IsTest
	static void selectWithOrderItemDetails_Negative() {
		Set<Id> idSet = new Map<Id, Order>([SELECT Id FROM Order]).keySet();
		List<Order> result = OrdersSelector.newInstance().selectWithOrderItemDetails(idSet, false);
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertNotEquals(0, result.size(), 'List empty');
	}

	@IsTest
	static void selectOrdersByOpportunities() {
		List<Order> result = OrdersSelector.newInstance().selectOrdersByOpportunities(new Set<Id>{});
		System.assertNotEquals(null, result, 'Selector returned null instead of list');
		System.assertEquals(0, result.size(), 'List empty');
	}

}