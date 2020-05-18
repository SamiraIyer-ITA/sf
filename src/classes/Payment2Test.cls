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
		order1.Name = 'Paid Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'Unpaid Order X';
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
		update order1;

		//Insert a Credit Card payment that is unrelated to the orders or the contract
		Payment2__c payment2 = new Payment2__c();
		payment2.Account_Type__c = 'Services';
		payment2.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		insert payment2;
	}

	@IsTest
	static void getTransactions_Positive_Payment() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		System.assertNotEquals(null, payments[0].Id);
	}

	@IsTest
	static void getTransactions_Negative() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Blah', 'Credit Card', 'Payments', today, today, 'All Transactions');
		System.assert(payments.isEmpty());
	}

	@IsTest
	static void getTransactions_Exception() {
		String today = 'Blah';
		String exceptionMessage;
		try {
			List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'All Transactions');
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void getOrderByPaidNonPaidOnly_Positive() {
		List<Order> orders = [SELECT Id FROM ORDER WHERE Name = 'Paid Order X'];
		Order order = Payment2.getOrderByPaidNonPaidOnly(orders[0].Id, false, false);
		System.assertEquals(orders[0].Id, order.Id);
	}

	@IsTest
	static void getOrderByPaidNonPaidOnly_Null() {
		List<Payment2__c> payments = [Select Id FROM Payment2__c];
		Order order = Payment2.getOrderByPaidNonPaidOnly(payments[0].Id, false, true);
		System.assertEquals(null, order);
	}

	@IsTest
	static void getOrderByPaidNonPaidOnly_Exception() {
		String exceptionMessage;
		try {
			Order order = Payment2.getOrderByPaidNonPaidOnly('Not an Id', false, true);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Script-thrown exception', exceptionMessage);
		}
	}

	@IsTest
	static void getOrdersByContractId_Positive() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Paid Order X'];
		List<Order> orderList = Payment2.getOrdersByContractId(orders[0].ContractId, false, false, false);
		System.assertEquals(orders[0].Id, orderList[0].Id);
	}

	@IsTest
	static void getOrdersByContractId_Positive2() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Paid Order X'];
		List<Order> orderList = Payment2.getOrdersByContractId(orders[0].ContractId, true, false, true);
		System.assertEquals(orders[0].Id, orderList[0].Id);
	}

	@IsTest
	static void getOrdersByContractId_Empty() {
		List<Payment2__c> payments = [Select Id FROM Payment2__c];
		List<Order> orderList = Payment2.getOrdersByContractId(payments[0].Id, false, false, true);
		System.assertEquals(true, orderList.isEmpty());
	}

	@IsTest
	static void getOrdersByContractId_Exception() {
		String exceptionMessage;
		try {
			List<Order> orderList = Payment2.getOrdersByContractId('Not an Id', false, false, true);
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
		List<Order> orders = [SELECT Id, ContractId, Payment2__c FROM ORDER WHERE Name = 'Paid Order X'];
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