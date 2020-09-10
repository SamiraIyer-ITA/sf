@IsTest
private class Payment2Test {

	@testSetup
	static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Opportunity opp = TestUtils.createOpportunity(account.Id, 'a string', true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Pricebook2 pricebook = TestUtils.createPricebook(program.Id);
		Product2 product2 = TestUtils.createProduct(true);
		product2.IsPrimary__c = true;
		product2.Accounting_Code__c = '1BFS';
		update product2;
		ID standardPbId = Test.getStandardPricebookId();
		PricebookEntry standardPbe = TestUtils.createPricebookEntry(standardPbId, product2.Id, true);
		PricebookEntry pbe = TestUtils.createPricebookEntry(pricebook.Id, product2.Id, true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();

		Contract contract = TestUtils.createContract(true, account.Id);
		contract.Name = 'Contract Test X';
		contract.Status = 'Activated';
		update contract;

		opp.Pricebook2Id = pricebook.Id;
		update opp;

		Quote quote1 = TestUtils.createQuote(true, opp.Id, pricebook.Id, 'Test Quote');

		//Insert a Payment record for Order 1 and Order 2
		QuoteLineItem quoteLineItem1 = TestUtils.createQuoteLineItem(true, product2.Id, quote1.Id, pbe.Id);
		quoteLineItem1.Quantity = 2;
		quoteLineItem1.UnitPrice = 2400.00;
		update quoteLineItem1;

		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createStandardOrder(true, account.Id, pricebook.Id );
		order1.Type = 'Services';
		order1.Name = 'Paid Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		order1.OpportunityId = opp.Id;
		order1.QuoteId = quote1.Id;
		orders.add(order1);
		Order order2 = TestUtils.createStandardOrder(true, account.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'Unpaid Order X';
		order2.ContractId = contract.Id;
		order2.OpportunityId = opp.Id;
		order2.RecordTypeId = servicesRecordTypeId;
		order2.QuoteId = quote1.Id;
		orders.add(order2);
		update orders;

		OrderItem orderItem1 = TestUtils.createStandardOrderItem(true, order1.id, pbe.id );
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.QuoteLineItemId = quoteLineItem1.Id;
		update orderItem1;

		OrderItem orderItem2 = TestUtils.createStandardOrderItem(true, order2.id, pbe.id);
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.QuoteLineItemId = quoteLineItem1.Id;
		update orderItem2;

		//Insert a Payment record for Order 1
		String recordType = 'Credit_Card_or_ACH_Payment';
		Payment2__c payment1 = TestUtils.createPayment2(true, recordType);
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		update payment1;

		order1.Payment2__c = payment1.Id;
		order1.Order_Paid__c = true;
		update order1;

		//Insert a Credit Card payment that is unrelated to the orders or the contract
		Payment2__c payment2 = TestUtils.createPayment2(true, recordType);
		payment2.Account_Type__c = 'Services';
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		update payment2;


	}

	@IsTest
	static void getTransactions_Positive_Payment() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		System.assertNotEquals(null, payments[0].Id);
	}

	@IsTest
	static void getTransactions_Positive_Payment_ACH() {
		//Insert a Credit Card payment that is unrelated to the orders or the contract
		String recordType = 'Credit_Card_or_ACH_Payment';
		Payment2__c payment3 = TestUtils.createPayment2(true, recordType);
		payment3.Account_Type__c = 'Services';
		payment3.Payment_Processor__c = 'Pay.gov';
		payment3.Transaction_Status__c = 'Received';
		payment3.Transaction_Amount__c = 15.00;
		payment3.Payment_Type__c = 'ACH';
		update payment3;

		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'ACH', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		System.assertNotEquals(null, payments[0].Id);
	}

	@IsTest
	static void getTransactions_Positive_Refund() {
		//Insert a Credit Card payment that is unrelated to the orders or the contract
		String recordType = 'Credit_Card_Refund';
		Payment2__c payment3 = TestUtils.createPayment2(true, recordType);
		payment3.Account_Type__c = 'Services';
		payment3.Payment_Processor__c = 'Pay.gov';
		payment3.Transaction_Status__c = 'Success';
		payment3.Transaction_Amount__c = 15.00;
		payment3.Payment_Type__c = 'Credit Card Refund';
		update payment3;

		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card Refund', 'Refunds', today, today, 'Transactions Not Yet Downloaded');
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
	static void authorizePayment_Positive() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();
		params.failurePage = 'https://www.test.com/failure';
		params.confirmationPage = 'https://www.test.com/confirmation';
		params.orderId = orders[0].Id;
		Payment2__c payment = Payment2.createPayment(params);
		String serializedDetails = Payment2.getPaymentProcessorData(payment.Id, params);
		String paymentRedirectUrl = Payment2.authorizePayment(serializedDetails);
		System.assertNotEquals(null, paymentRedirectUrl);
	}

	@IsTest
	static void authorizePayment_Positive_MoreParams() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();
		Collection_Fulfillment__c cp = TestUtils.createCollectionFulfillment(true, '56789','12345');
		Collection_Fulfillment__c fp = TestUtils.createCollectionFulfillment(true, '67890','23456');
		List<Collection_Fulfillment__c> cfList = new List<Collection_Fulfillment__c>{cp,fp};
		params.projectCode = '9999ABC';
		params.accountType = 'Services';
		params.accountHolderName = 'Jeff';
		params.transactionAmount = '100.00';
		params.collectionPost = cp.Id;
		params.fulfillmentPost = fp.Id;
		params.organizationName = 'Jorg Industries';
		params.userId = UserInfo.getUserId();
		params.billingAddress = '311 Jorg Street';
		params.billingCity = 'Beverly Hills';
		params.billingStateCode = 'CA';
		params.billingZip = '90210';
		params.billingCountryCode = 'USA';


		params.failurePage = 'https://www.test.com/failure';
		params.confirmationPage = 'https://www.test.com/confirmation';
		params.orderId = orders[0].Id;
		Payment2__c payment = Payment2.createPayment(params);
		String serializedDetails = Payment2.getPaymentProcessorData(payment.Id, params);
		String paymentRedirectUrl = Payment2.authorizePayment(serializedDetails);
		System.assertNotEquals(null, paymentRedirectUrl);
	}

	@IsTest
	static void authorizePayment_Positive_NoOrderId() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();

		Collection_Fulfillment__c cp = TestUtils.createCollectionFulfillment(true, '56789','12345');
		Collection_Fulfillment__c fp = TestUtils.createCollectionFulfillment(true, '67890','23456');
		List<Collection_Fulfillment__c> cfList = new List<Collection_Fulfillment__c>{cp,fp};
		params.projectCode = '9999ABC';
		params.accountType = 'Services';
		params.accountHolderName = 'Jeff';
		params.transactionAmount = '100.00';
		params.collectionPost = cp.Id;
		params.fulfillmentPost = fp.Id;

		params.failurePage = 'https://www.test.com/failure';
		params.confirmationPage = 'https://www.test.com/confirmation';

		String exceptionMessage;
		try {
			Payment2__c payment = Payment2.createPayment(params);
			String serializedDetails = Payment2.getPaymentProcessorData(payment.Id, params);
			String paymentRedirectUrl = Payment2.authorizePayment(serializedDetails);
		} catch(Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Either orderId or these values are required: accountType, transactionAmount, projectCode, collectionPost,  fulfillmentPost, organizationName', exceptionMessage);
		}
	}

	@IsTest
	static void authorizePayment_Negative_NoFailurePage() {
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();
		params.failurePage = null;
		params.confirmationPage = 'https://www.test.com/confirmation';
		params.orderId = orders[0].Id;

		String exceptionMessage;
		try {
			Payment2__c payment = Payment2.createPayment(params);
			String serializedDetails = Payment2.getPaymentProcessorData(payment.Id, params);
			String paymentRedirectUrl = Payment2.authorizePayment(serializedDetails);
		} catch(Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('paymentId, params.confirmationPage, and params.failurePage are required parameters.', exceptionMessage);
		}
	}

	@IsTest
	static void confirmPayment_Positive() {
		List<Order> orders = [SELECT Id, ContractId, Payment2__c FROM ORDER WHERE Name = 'Paid Order X'];
		String confirmPayment = Payment2.confirmPayment('Services', (String) orders[0].Payment2__c, 'myToken', orders[0].Id);
		System.assertEquals(confirmPayment,'{"paymentConfirmed":true,"errorMessage":null}');
	}

	@IsTest
	static void confirmPayment_Exception() {
		String exceptionMessage;
		try {
			String paymentId = Payment2.confirmPayment('Unknown', null, 'myToken', '');
		} catch (Exception e) {
			exceptionMessage = e.getMessage();
		} finally {
			System.assertEquals('Unknown remote account name.', exceptionMessage);
		}
	}

	@IsTest
	static void testUpdateSystemSearchString_CallWithoutSetup_IssuesNoErrors(){
		Payment2__c e = new Payment2__c();
		List<Payment2__c> payment2List = new List<Payment2__c> {e};

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflibext_ISObjectUnitOfWork mock_uow = (fflibext_ISObjectUnitOfWork) mocks.mock(fflibext_ISObjectUnitOfWork.class);

		// Default stub is acceptable; not expecting anything special.  Just don't want a real UOW called.
		fflibext_Application.UnitOfWork.setMock(mock_uow);
		try {
			Payments2.newInstance(payment2List).updateSystemSearchString(payment2List);
			System.assert(true); // Should be the only assert in this test that actually executes
		} catch (Exception ex){
			System.assert(false, 'updateSystemSearchString caused an exception and should not have');
			System.debug(ex.getStackTraceString());
		}
	}

	@IsTest
	static void testPayments2Trigger_InsertPayment2Record_TriggerIsCovered() {
		try {
			string recordType = 'Credit_Card_or_ACH_Payment';
			Payment2__c p2 = TestUtils.createPayment2(true, recordType);
		} catch (Exception e) {}
	}

}
