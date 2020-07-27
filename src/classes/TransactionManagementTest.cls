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
private class TransactionManagementTest {

	@testSetup
	static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Opportunity opp = TestUtils.createOpportunity(account.Id, 'a string', true);
		Program__c program = TestUtils.createProgram('Test Program', true);
		Product2 product2 = TestUtils.createProduct(true);
		ID standardPbId = Test.getStandardPricebookId();
		PricebookEntry standardPbe = TestUtils.createPricebookEntry(standardPbId, product2.Id, true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();

		opp.Pricebook2Id = standardPbId;
		update opp;

		Contract contract = TestUtils.createContract(true, account.Id);
		contract.Name = 'Contract Test X';
		contract.Status = 'Activated';
		update contract;

		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, standardPbId);
		order1.Type = 'Services';
		order1.Name = 'Test Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		update order1;
		orders.add(order1);

		OrderItem orderItem1 = TestUtils.createStandardOrderItem(true, order1.Id,  standardPbe.Id);
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		update orderItem1;

		//Insert a Payment record for Order 1
		String recordType = 'Credit_Card_or_ACH_Payment';
		Payment2__c payment1 = TestUtils.createPayment2(true, recordType);
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Project_Code__c = '1GKY231';
		payment1.Fulfillment_Post_Org_Code__c = '50-00-00';
		payment1.Fulfillment_Post_Acronym__c = 'ACRONY';
		payment1.Organization_Name__c = 'Test Org';
		update payment1;

		Quote quote1 = testUtils.createQuote(true, opp.Id, standardPbId, 'Test Quote');

		QuoteLineItem quoteLineItem1 = TestUtils.createQuoteLineItem(true, product2.Id, quote1.Id, standardPbe.Id);
		quoteLineItem1.Quantity = 1;
		quoteLineItem1.UnitPrice = 100.00;
		update quoteLineItem1;


		CBSBatchCount__c settings = new CBSBatchCount__c();
		settings.Name = 'test';
		//settings.BatchFileCount__c = 1;
		insert settings;
	}

	@IsTest
	static void getCBSdata_AccountTypeS() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		String[] paymentIds = new String[]{payments[0].Id};
		TransactionManagement.CBSData cbsData = TransactionManagement.getCBSdata(paymentIds);
		System.assertNotEquals(null, cbsData.csvString);
	}

	@IsTest
	static void getCBSdata_AccountTypeVA() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		String[] paymentIds = new String[]{payments[0].Id};
		payments[0].Account_Type__c = 'Events';
		payments[0].Payment_Type__c = 'ACH';
		update payments;
		TransactionManagement.CBSData cbsData = TransactionManagement.getCBSdata(paymentIds);
		System.assertNotEquals(null, cbsData.csvString);
	}

	@IsTest
	static void getCBSdata_AccountType9() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		String[] paymentIds = new String[]{payments[0].Id};
		payments[0].Account_Type__c = 'Privacy Shield';
		update payments;
		TransactionManagement.CBSData cbsData = TransactionManagement.getCBSdata(paymentIds);
		System.assertNotEquals(null, cbsData.csvString);
	}
}