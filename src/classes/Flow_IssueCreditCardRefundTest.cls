@IsTest
private class Flow_IssueCreditCardRefundTest {

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
		payment1.Transaction_Amount__c = 9600.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		order1.Payment2__c = payment1.Id;
		order1.Status = 'Paid';
		order1.Order_Paid__c = true;
		update order1;
	}

	@IsTest
	static void createRefundRecord_Positive() {
		Flow_IssueCreditCardRefund.RequestVariables requestVariables = new Flow_IssueCreditCardRefund.RequestVariables();
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Paid Order X'];
		requestVariables.orders = orders;
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		System.debug(returnList);
		System.assertNotEquals(null, returnList[0].refundId);
	}

	@IsTest
	static void createRefundRecord_Exception() {
		Flow_IssueCreditCardRefund.RequestVariables requestVariables = new Flow_IssueCreditCardRefund.RequestVariables();
		requestVariables.refundAmount = 2000;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		requestVariables.orders = orders;
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
			System.debug(e.getMessage());
		} finally {
			System.assert(exceptionMessage.startsWith('List index out of bounds'));
		}
	}

	@IsTest
	static void createRefundRecord_Exception2() {
		Flow_IssueCreditCardRefund.RequestVariables requestVariables = new Flow_IssueCreditCardRefund.RequestVariables();
		requestVariables.refundAmount = 2000;
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		requestVariablesList.add(requestVariables);
		String exceptionMessage;
		try {
			List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.debug('Exception Message: ' + exceptionMessage);
			System.assertEquals('Attempt to de-reference a null object', exceptionMessage);
		}
	}

	@IsTest
	static void createRefundRecord_Error() {
		Flow_IssueCreditCardRefund.RequestVariables requestVariables = new Flow_IssueCreditCardRefund.RequestVariables();
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Payment2__r.Payment_Type__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER WHERE Name = 'Paid Order X'];
		orders[0].Payment2__r.Payment_Type__c = 'ACH';
		update orders[0].Payment2__r;
		requestVariables.orders = orders;
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		System.debug(returnList);
		System.assert(returnList[0].hasError);
	}

	@IsTest
	static void createRefundRecord_Error2() {
		Flow_IssueCreditCardRefund.RequestVariables requestVariables = new Flow_IssueCreditCardRefund.RequestVariables();
		requestVariables.refundAmount = 200;
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, Refunded_Amount__c, TotalAmount FROM ORDER];
		requestVariables.orders = orders;
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		requestVariablesList.add(requestVariables);
		List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		System.debug(returnList);
		System.assert(returnList[0].hasError);
	}

	@IsTest
	static void createRefundRecord_Null() {
		List<Flow_IssueCreditCardRefund.RequestVariables> requestVariablesList = new List<Flow_IssueCreditCardRefund.RequestVariables>();
		List<Flow_IssueCreditCardRefund.ResponseVariables> returnList = Flow_IssueCreditCardRefund.issueCreditCardRefund(requestVariablesList);
		System.assertEquals(null, returnList[0].refundId);
	}

}