@IsTest
private class Flow_CreatePaymentRecordTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();
		Contract contract = new Contract();
		contract.Name = 'Contract Test X';
		contract.AccountId = account.Id;
		insert contract;
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
	}

	@IsTest
	static void createPaymentRecord_Positive_Check() {
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Check';
		requestVariables.amount = 4300;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		requestVariables.bankName = 'Bank One';
		requestVariables.checkNumber = '1001';
		requestVariables.checkDate = Date.today();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		System.assertNotEquals(null, returnList);
	}

	@IsTest
	static void createPaymentRecord_Positive_Cash() {
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Cash';
		requestVariables.amount = 4300;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		System.assertNotEquals(null, returnList);
	}

	@IsTest
	static void createPaymentRecord_Positive_BankTransfer() {
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Bank Transfer';
		requestVariables.amount = 4300;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		requestVariables.bankTransferDatetime = Datetime.now();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		System.assertNotEquals(null, returnList);
	}

	@IsTest
	static void createPaymentRecord_Exception() {
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Unknown';
		requestVariables.amount = 4300;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		requestVariables.bankName = 'Bank One';
		requestVariables.checkNumber = '1001';
		requestVariables.checkDate = Date.today();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Invalid Payment Type', exceptionMessage);
		}
	}

	@IsTest
	static void createPaymentRecord_Exception2() {
		Flow_CreatePaymentRecord.RequestVariables requestVariables = new Flow_CreatePaymentRecord.RequestVariables();
		requestVariables.paymentType = 'Check';
		requestVariables.amount = 4300;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Test Order X'];
		for (Order order: orders) {
			order.Type = 'Blah';
		}
		update orders;
		requestVariables.orders = orders;
		if (! orders.isEmpty()) {
			requestVariables.contractId = orders[0].ContractId;
		}
		requestVariables.accountType = 'Blah';
		requestVariables.bankName = 'Bank One';
		requestVariables.checkNumber = '1001';
		requestVariables.checkDate = Date.today();
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.debug('Exception Message: ' + exceptionMessage);
			System.assert(exceptionMessage.startsWith('Unable to insert payment or update order records.'));
		}
	}

	@IsTest
	static void createPaymentRecord_Null() {
		List<Flow_CreatePaymentRecord.RequestVariables> requestVariablesList = new List<Flow_CreatePaymentRecord.RequestVariables>();
		List<String> returnList = Flow_CreatePaymentRecord.createPaymentRecord(requestVariablesList);
		System.assertEquals(null, returnList);
	}

}