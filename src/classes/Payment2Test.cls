@IsTest
private class Payment2Test {

	@testSetup
	static void testSetup() {
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
		//order3 is an unpaid order
		Order order3 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order3.Type = 'Services';
		order3.Name = 'Test Order 3';
		order3.ContractId = contract.Id;
		order3.RecordTypeId = servicesRecordTypeId;
		orders.add(order3);
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

		OrderItem orderItem3 = new OrderItem();
		orderItem3.OrderId = order3.id;
		orderItem3.Quantity = 2;
		orderItem3.UnitPrice = 2400;
		orderItem3.Product2id = product2.id;
		orderItem3.PricebookEntryId=pbe.id;
		insert orderItem3;

		//Insert a Payment record for Order 1 and Order 2
		Payment2__c payment1 = new Payment2__c();
		payment1.Account_Type__c = 'Services';
		payment1.RecordTypeId = Utils.getRecordTypeNameByDeveloperName('Credit_Card_or_ACH_Payment', 'Payment2__c');
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		order1.Payment2__c = payment1.Id;
		order1.Status = 'Paid';
		update order1;

		order2.Payment2__c = payment1.Id;
		order2.Status = 'Paid';
		update order2;

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

		//Insert a Credit Card payment that is unrelated to the orders or the contract
		Payment2__c payment2 = new Payment2__c();
		payment2.Account_Type__c = 'Services';
		payment2.RecordTypeId = Utils.getRecordTypeNameByDeveloperName('Credit_Card_or_ACH_Payment', 'Payment2__c');
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		insert payment2;
	}

	@IsTest
	static void getTransactions_Positive_Payment() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payment', today, today);
		System.assertNotEquals(null, payments[0].Id);
	}

	@IsTest
	static void getTransactions_Negative() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Blah', 'Credit Card', 'Payment', today, today);
		System.assert(payments.isEmpty());
	}

	@IsTest
	static void getTransactions_Exception() {
		String today = 'Blah';
		String exceptionMessage;
		try {
			List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payment', today, today);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void getOrder_Positive() {
		List<Order> orders = [SELECT Id FROM ORDER WHERE Name = 'Test Order X'];
		Order order = Payment2.getOrder(orders[0].Id);
		System.assertEquals(orders[0].Id, order.Id);
	}

	@IsTest
	static void getOrder_Null() {
		List<Payment2__c> payments = [Select Id FROM Payment2__c];
		Order order = Payment2.getOrder(payments[0].Id);
		System.assertEquals(null, order);
	}

	@IsTest
	static void getOrder_Exception() {
		String exceptionMessage;
		try {
			Order order = Payment2.getOrder('Not an Id');
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void getOrderWithReductionOrderDetails_Positive() {
		List<Order> orders = [SELECT Id FROM ORDER WHERE Name = 'Reduction Order X'];
		Order order = Payment2.getOrderWithReductionOrderDetails(orders[0].Id, false, true, false, false);
		System.assertEquals(orders[0].Id, order.Id);
	}

	@IsTest
	static void getOrderWithReductionOrderDetails_Null() {
		List<Payment2__c> payments = [Select Id FROM Payment2__c];
		Order order = Payment2.getOrderWithReductionOrderDetails(payments[0].Id, false, false, false, true);
		System.assertEquals(null, order);
	}

	@IsTest
	static void getOrderWithReductionOrderDetails_Exception() {
		String exceptionMessage;
		try {
			Order order = Payment2.getOrderWithReductionOrderDetails('Not an Id', false, false, false, true);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void getOrdersByContractId_Positive() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		List<Order> orderList = Payment2.getOrdersByContractId(orders[0].ContractId, true, false, false, false);
		System.assertEquals(orders[0].Id, orderList[0].Id);
	}

	@IsTest
	static void getOrdersByContractId_Positive2() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Reduction Order X'];
		List<Order> orderList = Payment2.getOrdersByContractId(orders[0].ContractId, false, true, true, false);
		System.assertEquals(orders[0].Id, orderList[0].Id);
	}

	@IsTest
	static void getOrdersByContractId_Empty() {
		List<Payment2__c> payments = [Select Id FROM Payment2__c];
		List<Order> orderList = Payment2.getOrdersByContractId(payments[0].Id, false, false, false, true);
		System.assertEquals(true, orderList.isEmpty());
	}

	@IsTest
	static void getOrdersByContractId_Exception() {
		String exceptionMessage;
		try {
			List<Order> orderList = Payment2.getOrdersByContractId('Not an Id', false, false, false, true);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void startElectronicPayment_Positive() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Test Order 3'];
		String[] orderIds = new String[]{};
		for (Order order: orders) {
			orderIds.add(order.Id);
		}
		String serializedDetails = Payment2.startElectronicPayment('Services', orders[0].ContractId, orderIds, null, '', '', 'Contract', orders[0].ContractId);
		Payment2.PaymentAuthenticationDetails paymentAuthenticationDetails = (Payment2.PaymentAuthenticationDetails)JSON.deserialize(serializedDetails, Payment2.PaymentAuthenticationDetails.class);
		System.assertEquals('4800.00', paymentAuthenticationDetails.transactionAmount);
	}

	@IsTest
	static void startElectronicPayment_Exception() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Test Order 3'];
		String[] orderIds = new String[]{};
		String exceptionMessage;
		try {
			String serializedDetails = Payment2.startElectronicPayment('Blah', orders[0].ContractId, orderIds, null, '', '', 'Contract', orders[0].ContractId);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void authorizePayment_Positive() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Test Order 3'];
		String[] orderIds = new String[]{};
		for (Order order: orders) {
			orderIds.add(order.Id);
		}
		String serializedDetails = Payment2.startElectronicPayment('Services', orders[0].ContractId, orderIds, null, '', '', 'Contract', orders[0].ContractId);
		String paymentRedirectUrl = Payment2.authorizePayment(serializedDetails);
		System.assertNotEquals(null, paymentRedirectUrl);
	}

	@IsTest
	static void confirmPayment_Positive() {
		List<Order> orders = [SELECT Id, ContractId, Payment2__c FROM ORDER WHERE Name = 'Test Order X'];
		String[] orderIds = new String[]{};
		for (Order order: orders) {
			orderIds.add(order.Id);
		}
		String paymentId = Payment2.confirmPayment('Services', (String) orders[0].Payment2__c, 'myToken', orderIds);
		System.assertEquals((String) orders[0].Payment2__c, paymentId);
	}

	@IsTest
	static void confirmPayment_Exception() {
		String[] orderIds = new String[]{};
		String exceptionMessage;
		try {
			String paymentId = Payment2.confirmPayment('Services', null, 'myToken', orderIds);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

}