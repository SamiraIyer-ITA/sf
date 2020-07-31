/**
 * Created by jeffweyhrauch on 7/9/20.
 */

@IsTest
private class REST_BeginPaymentTest {
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
		Contract contract = TestUtils.createContract(false, account.Id);
		contract.Name = 'Contract Test X';

		opp.Pricebook2Id = pricebook.Id;
		update opp;

		contract.AccountId = account.Id;
		insert contract;
		contract.Status = 'Activated';
		update contract;

		Quote quote1 = TestUtils.createQuote(true, opp.Id, pricebook.Id, 'Test Quote');

		//Insert a Payment record for Order 1 and Order 2
		QuoteLineItem quoteLineItem1 = TestUtils.createQuoteLineItem(false, product2.Id, quote1.Id, pbe.Id);
		quoteLineItem1.Quantity = 2;
		quoteLineItem1.UnitPrice = 2400.00;
		insert quoteLineItem1;

		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order1.Type = 'Services';
		order1.Name = 'Paid Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		order1.OpportunityId = opp.Id;
		order1.QuoteId = quote1.Id;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'Unpaid Order X';
		order2.ContractId = contract.Id;
		order2.OpportunityId = opp.Id;
		order2.RecordTypeId = servicesRecordTypeId;
		order2.QuoteId = quote1.Id;
		orders.add(order2);
		update orders;

		OrderItem orderItem1 = TestUtils.createStandardOrderItem(false, order1.Id, pbe.Id);
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.Product2id = product2.id;
		orderItem1.QuoteLineItemId = quoteLineItem1.Id;
		insert orderItem1;

		OrderItem orderItem2 = TestUtils.createStandardOrderItem(false, order2.Id, pbe.Id);
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.Product2id = product2.id;
		orderItem2.QuoteLineItemId = quoteLineItem1.Id;
		insert orderItem2;

		//Insert a Payment record for Order 1
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		order1.Payment2__c = payment1.Id;
		order1.Order_Paid__c = true;
		update order1;

		//Insert a Credit Card payment that is unrelated to the orders or the contract
		Payment2__c payment2 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment2.Account_Type__c = 'Services';
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		insert payment2;
	}

	@isTest static void testBeginPaymentCallout_Success() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new REST_PaymentMock());
		// This causes a fake response to be sent
		// from the class that implements HttpCalloutMock.
		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();

		params.projectCode = '9999ABC';
		params.accountType = 'Services';
		params.accountHolderName = 'Jeff';
		params.transactionAmount = '100.00';
		params.organizationName = 'Jorg Industries';
		params.billingAddress = '311 Jorg Street';
		params.billingCity = 'Beverly Hills';
		params.billingStateCode = 'CA';
		params.billingZip = '90210';
		params.billingCountryCode = 'USA';
		params.failurePage = 'https://www.test.com/failure';
		params.confirmationPage = 'https://www.test.com/confirmation';
		params.orderId = orders[0].Id;

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.requestURI = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/CreatePayment';  // sample Endpoint
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

		REST_BeginPayment.doPost(params);
	}

	@IsTest
	static void testBeginPaymentCallout_Fail() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new REST_PaymentMock());

		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();

		params.projectCode = '9999ABC';
		params.accountType = 'Services';
		params.accountHolderName = 'Jeff';
		params.transactionAmount = '100.00';
		params.organizationName = 'Jorg Industries';
		params.billingAddress = '311 Jorg Street';
		params.billingCity = 'Beverly Hills';
		params.billingStateCode = 'CA';
		params.billingZip = '90210';
		params.billingCountryCode = 'USA';
		params.confirmationPage = 'https://www.test.com/confirmation';
		params.orderId = orders[0].Id;

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.requestURI = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/CreatePayment';  // sample Endpoint
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

		REST_BeginPayment.doPost(params);
	}

	@IsTest
	static void testBeginPaymentCallout2_Fail() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new REST_PaymentMock());

		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();

		params.projectCode = '9999ABC';
		params.accountType = 'Services';
		params.accountHolderName = 'Jeff';
		params.transactionAmount = '100.00';
		params.failurePage = 'https://www.test.com/failure';
		params.confirmationPage = 'https://www.test.com/confirmation';

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.requestURI = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/CreatePayment';  // sample Endpoint
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;

		REST_BeginPayment.doPost(params);
	}
}