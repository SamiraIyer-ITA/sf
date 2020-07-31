/**
 * Created by Mark Keckeis - Mil Corporation on 7/31/2020.
 */

@IsTest
private class Payment2ConfirmationControllerTest {

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
		update order1;

		//Insert a Credit Card payment that is unrelated to the orders or the contract
		Payment2__c payment1 = TestUtils.createPayment2(true, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Pay.gov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 15.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		update payment1;

		TestUtils.createPaymentSettings();

	}

	@IsTest
	static void completePayment() {
		Payment2__c payment1 =  [SELECT Id FROM Payment2__c Limit 1 ];
		Order order1 = [Select Id FROM Order WHERE Name = 'Test Order X' LIMIT 1];

		PageReference pageRef = Page.Payment2Confirmation;
		pageRef.getParameters().put('orderId', order1.Id);
		pageRef.getParameters().put('AcctType', 'Services');
		pageRef.getParameters().put('paymentId', payment1.Id);
		pageRef.getParameters().put('token', 'token');
		Test.setCurrentPageReference(pageRef);
		Payment2ConfirmationController p2ConfirmationController = new Payment2ConfirmationController();

		p2ConfirmationController.restDoPost();
		system.assert(p2ConfirmationController.completionMessage == 'The payment has been successfully processed.');

	}

	@IsTest
	static void cancelPayment() {
		PageReference pageRef = Page.Payment2Confirmation;
		pageRef.getParameters().put('cancel', 'true');
		Test.setCurrentPageReference(pageRef);
		Payment2ConfirmationController p2ConfirmationController = new Payment2ConfirmationController();
		p2ConfirmationController.restDoPost();
		system.assert(p2ConfirmationController.completionMessage == 'The payment was canceled by the user before submitting to Paygov.');

	}
}