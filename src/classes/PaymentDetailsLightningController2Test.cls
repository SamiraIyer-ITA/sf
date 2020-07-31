@isTest
public class PaymentDetailsLightningController2Test {

	@testSetup static void createTestData() {
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
		order1.Name = 'Credit Card Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		orders.add(order1);
		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebook.Id);
		order2.Type = 'Services';
		order2.Name = 'ACH Order X';
		order2.ContractId = contract.Id;
		order2.RecordTypeId = servicesRecordTypeId;
		orders.add(order2);
		update orders;

		OrderItem orderItem1 = TestUtils.createStandardOrderItem(false, order1.Id, pbe.Id);
		orderItem1.Quantity = 2;
		orderItem1.UnitPrice = 2400;
		orderItem1.Product2id = product2.id;
		insert orderItem1;

		OrderItem orderItem2 = TestUtils.createStandardOrderItem(false, order2.Id, pbe.Id);
		orderItem2.Quantity = 2;
		orderItem2.UnitPrice = 2400;
		orderItem2.Product2id = product2.id;
		insert orderItem2;

		//Insert a Payment record
		Payment2__c payment1 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		insert payment1;

		order1.Status = 'Paid';
		order1.Order_Paid__c = true;
		order1.Payment2__c = payment1.Id;
		update order1;

		Payment2__c payment2 = TestUtils.createPayment2(false, 'Credit_Card_or_ACH_Payment');
		payment2.Account_Type__c = 'Services';
		payment2.Payment_Processor__c = 'Paygov';
		payment2.Transaction_Status__c = 'Success';
		payment2.Transaction_Amount__c = 4800.00;
		payment2.Payment_Type__c = 'ACH';
		insert payment2;

		order2.Status = 'Paid';
		order2.Order_Paid__c = true;
		order2.Payment2__c = payment2.Id;
		update order2;
	}

	@isTest static void getPaymentDetails_ACH_Positive(){
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM Order WHERE Name = 'ACH Order X'];
		Id paymentId = orders[0].Payment2__c;
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryAchMockImpl());
		String returnValue = PaymentDetailsLightningController2.getPaymentDetails(paymentId);
		PaymentDetailsForPayGov.ReturnValue paymentDetails = (PaymentDetailsForPayGov.ReturnValue)JSON.deserialize(returnValue, PaymentDetailsForPayGov.ReturnValue.class);
		System.assertEquals(true, paymentDetails.isAch);
		System.assertEquals('transactionAmount', paymentDetails.transactionAmount);
		Test.stopTest();
	}

	@isTest static void getPaymentDetails_CreditCard_Positive(){
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId FROM Order WHERE Name = 'Credit Card Order X'];
		Id paymentId = orders[0].Payment2__c;
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryCCMockImpl());
		String returnValue = PaymentDetailsLightningController2.getPaymentDetails(paymentId);
		PaymentDetailsForPayGov.ReturnValue paymentDetails = (PaymentDetailsForPayGov.ReturnValue)JSON.deserialize(returnValue, PaymentDetailsForPayGov.ReturnValue.class);
		System.assertEquals(true, paymentDetails.isCreditCard);
		System.assertEquals('transactionAmount', paymentDetails.transactionAmount);
		Test.stopTest();
	}

}