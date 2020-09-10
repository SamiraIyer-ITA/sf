@IsTest
private with sharing class REST_EmailTransactionReceiptTest {
	@IsTest
	static void REST_EmailTransactionReceipt_Success_Payment() {
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Receipt_Ready__c = true;
		payment1.Receipt_Sent_To__c = 'test@test.gov';
		insert payment1;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@test.gov',payment1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		//System.assert(responseMap.get('errorMessage') == null);
		System.assertEquals(true,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Success_FromOrder() {

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
		opp.Pricebook2Id = pricebook.Id;
		update opp;

		Contract contract = TestUtils.createContract(true, account.Id);
		contract.Name = 'Contract Test X';
		contract.Status = 'Activated';
		update contract;

		Quote quote1 = TestUtils.createQuote(true, opp.Id, standardPbId,  'Test Quote');

		//Insert a Payment record for Order 1 and Order 2
		QuoteLineItem quoteLineItem1 = TestUtils.createQuoteLineItem(true, product2.Id, quote1.Id, standardPbe.Id );
		quoteLineItem1.Quantity = 2;
		quoteLineItem1.UnitPrice = 2400.00;
		update quoteLineItem1;

		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Receipt_Ready__c = true;
		payment1.Receipt_Allowed__c = true;
		payment1.Receipt_Sent_To__c = 'test@test.gov';
		insert payment1;

		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order1.Type = 'Services';
		order1.Name = 'Paid Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		order1.OpportunityId = opp.Id;
		order1.QuoteId = quote1.Id;
		order1.Payment2__c = payment1.Id;
		orders.add(order1);
		update orders;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@test.gov',order1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		//System.assert(responseMap.get('errorMessage') == 'Attempt to de-reference a null object');
		System.assertEquals(true,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Success_Refund() {
		//Insert a Payment record for Order 1
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_Refund');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'Credit Card Refund';
		payment1.Receipt_Ready__c = true;
		payment1.Receipt_Sent_To__c = 'test@test.gov';
		insert payment1;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@test.gov',payment1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assert(responseMap.get('errorMessage') == '');
		System.assertEquals(true,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Fail1() {
		String response = REST_EmailTransactionReceipt.emailReceipt('test@email.com','');
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		String errorMessage = String.valueOf(responseMap.get('errorMessage'));
		Map<String, Object> errorMap = (Map<String, Object>)JSON.deserializeUntyped(errorMessage);
		System.assertEquals('Required field is missing: recordId.',String.valueOf(errorMap.get('error')));
		System.assertEquals(false,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Fail2() {
		//Insert a Payment record for Order 1
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@email.com',payment1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assertEquals('Receipt does not yet have fields necessary to send the receipt.',String.valueOf(responseMap.get('errorMessage')));
		System.assertEquals(false,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Fail4() {
		String response = REST_EmailTransactionReceipt.emailReceipt('test@email.com',UserInfo.getUserId());
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assertEquals('Attempt to de-reference a null object',String.valueOf(responseMap.get('errorMessage')));
		System.assertEquals(false,responseMap.get('receiptSent'));
	}

	@IsTest
	static void REST_EmailTransactionReceipt_Fail5() {
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Receipt_Ready__c = false;
		payment1.Receipt_Sent_To__c = 'test@test.gov';
		insert payment1;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@test.gov',payment1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assertEquals('Receipt does not yet have fields necessary to send the receipt.',responseMap.get('errorMessage'));
		System.assertEquals(false,responseMap.get('receiptSent'));
	}
	@IsTest
	static void REST_EmailTransactionReceipt_Fail6() {
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Receipt_Ready__c = true;
		payment1.Receipt_Allowed__c = false;
		payment1.Receipt_Sent_To__c = 'test@test.gov';
		insert payment1;

		String response = REST_EmailTransactionReceipt.emailReceipt('test@test.gov',payment1.Id);
		Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assertEquals('This receipt should not be sent to the client.',responseMap.get('errorMessage'));
		System.assertEquals(false,responseMap.get('receiptSent'));
	}

}
