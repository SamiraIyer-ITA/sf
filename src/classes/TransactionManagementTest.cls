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

		OrderItem orderItem1 = new OrderItem();
		orderItem1.OrderId = order1.id;
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.Product2id = product2.id;
		orderItem1.PricebookEntryId=pbe.id;
		insert orderItem1;

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

		CBSBatchCount__c settings = new CBSBatchCount__c();
		settings.Name = 'test';
		//settings.BatchFileCount__c = 1;
		insert settings;
	}

	@IsTest
	static void getCBSdata_Positive() {
		String today = Date.today().format();
		List<Payment2__c> payments = Payment2.getTransactions('Services', 'Credit Card', 'Payments', today, today, 'Transactions Not Yet Downloaded');
		String[] paymentIds = new String[]{payments[0].Id};
		TransactionManagement.CBSData cbsData = TransactionManagement.getCBSdata(paymentIds);
		System.assertNotEquals(null, cbsData.csvString);
	}

}