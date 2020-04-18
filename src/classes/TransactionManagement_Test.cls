/**
  * TransactionManagement Test class.
  *
  * Get the transaction (payment/refund) data that will be saved as a file and imported into CBS by NIST.
  *
  * @param paymentIds An array of Payment.Ids.
  *
  * @return A CBSData object containing the batch number and String for the file.
  */

@IsTest
private class TransactionManagement_Test {

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
		payment1.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
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
		payment2.RecordTypeId = Utils.getRecordTypeIdMap('Payment2__c').get('Credit_Card_or_ACH_Payment');
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		insert payment2;

		CBSBatchCount__c settings = new CBSBatchCount__c();
		settings.Name = 'test';
		settings.BatchFileCount__c = 1;
		insert settings;

	}

	@IsTest
	static void getCBSdata_Positive() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		String[] paymentIds = new String[]{payments[0].Id};
		TransactionManagement.CBSData cbsData = TransactionManagement.getCBSdata(paymentIds);
		System.assertNotEquals(null, cbsData.csvString);
		System.assertNotEquals(null, cbsData.batchNumber);
	}

}