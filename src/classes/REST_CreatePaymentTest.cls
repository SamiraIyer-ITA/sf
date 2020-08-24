/**
 * Created by jeffweyhrauch on 7/9/20.
 */

@IsTest
private class REST_CreatePaymentTest {
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
		opp.Pricebook2Id = pricebook.Id;
		update opp;
		Contract contract = TestUtils.createContract(true, account.Id);
		contract.Status = 'Activated';
		update contract;

		Quote quote1 = TestUtils.createQuote(true, opp.Id, pricebook.Id, 'Test Quote');

		//Insert a Payment record for Order 1 and Order 2
		QuoteLineItem quoteLineItem1 = TestUtils.createQuoteLineItem(true, product2.Id, quote1.Id, pbe.Id);
		quoteLineItem1.Quantity = 2;
		quoteLineItem1.UnitPrice = 2400.00;
		update quoteLineItem1;

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

		OrderItem orderItem1 = TestUtils.createStandardOrderItem(true, order1.Id, pbe.Id);
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.QuoteLineItemId = quoteLineItem1.Id;
		update orderItem1;

		OrderItem orderItem2 = TestUtils.createStandardOrderItem(true, order2.Id, pbe.Id);
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.QuoteLineItemId = quoteLineItem1.Id;
		update orderItem2;

		//Insert a Payment record for Order 1
		Payment2__c payment1 = TestUtils.createPayment2(true, 'Credit_Card_or_ACH_Payment');
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
		Payment2__c payment2 = TestUtils.createPayment2(true, 'Credit_Card_or_ACH_Payment');
		payment2.Account_Type__c = 'Services';
		payment2.Payment_Processor__c = 'Pay.gov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 15.00;
		payment2.Payment_Type__c = 'PLASTIC_CARD';
		update payment2;
	}

	@isTest static void testCreatePaymentCallout_Success() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new REST_PaymentMock());

		List<Order> orders = [SELECT Id, ContractId FROM ORDER WHERE Name = 'Unpaid Order X'];
		REST_BeginPaymentParams params = new REST_BeginPaymentParams();

		Collection_Fulfillment__c cp = new Collection_Fulfillment__c(Post__c='56789',Org_Code__c='12345');
		Collection_Fulfillment__c fp = new Collection_Fulfillment__c(Post__c='67890',Org_Code__c='23456');
		List<Collection_Fulfillment__c> cfList = new List<Collection_Fulfillment__c>{cp,fp};
		insert cfList;
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

		Boolean hasException = false;
		try {
			REST_CreatePayment.doPost(params);
		} catch (Exception e) {
			hasException = true;
		}
		System.assertEquals(false, hasException);
	}

}