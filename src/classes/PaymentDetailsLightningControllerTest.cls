@isTest
public class PaymentDetailsLightningControllerTest {
	private static String PRIVACY_SHIELD_APP_ID;
	private static String PRIVACY_SHIELD_APP;
	private static String EVENTS_SERVICES_APP_ID;
	private static String EVENTS_SERVICES_APP;
	private static String AGENCY_ID;
	private static final String PAY_GOV_TRACKING_ID = 'testTrackingId';
	private static String EVENTS_SERVICES_APP_NAME;
	private static String PRIVACY_SHIELD_APP_NAME;

	@testSetup static void createTestData() {
		PaymentSettings__c[] psTypes = new PaymentSettings__c[]{};
		PaymentSettings__c ps1 = new PaymentSettings__c(Value__c='TCSITAUSMASSHQA', name ='PRIVACY_SHIELD_APP_ID');
		PaymentSettings__c ps2 = new PaymentSettings__c(Value__c='PS', name ='PRIVACY_SHIELD_APP');
		PaymentSettings__c ps3 = new PaymentSettings__c(Value__c='TCSITAUSFCSEMENUQA', name ='EVENTS_SERVICES_APP_ID');
		PaymentSettings__c ps4 = new PaymentSettings__c(Value__c='ES', name ='EVENTS_SERVICES_APP');
		PaymentSettings__c ps5 = new PaymentSettings__c(Value__c='967', name ='AGENCY_ID');
		PaymentSettings__c ps6 = new PaymentSettings__c(Value__c='Privacy Shield', name ='PRIVACY_SHIELD_APP_NAME');
		PaymentSettings__c ps7 = new PaymentSettings__c(Value__c='Event or Service', name ='EVENTS_SERVICES_APP_NAME');
		psTypes.add(ps1);
		psTypes.add(ps2);
		psTypes.add(ps3);
		psTypes.add(ps4);
		psTypes.add(ps5);
		psTypes.add(ps6);
		psTypes.add(ps7);
		insert psTypes;

		PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
		PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
		EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
		EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
		AGENCY_ID = PaymentSettings__c.getAll().get('AGENCY_ID').value__c;

		Account account = new Account(Name='Payment Details Lightning Controller Test Account');
		insert account;

		Order order = new Order();
		order.Name = '14TPE000001';
		order.AccountId = account.Id;
		order.EffectiveDate = Date.Today();
		order.Status = 'Draft';
		insert order;

		Payment__c payment = new Payment__c(Order__c = order.id, Pay_Gov_Tracking_Id__c = PAY_GOV_TRACKING_ID, Payment_Type__c = 'PLASTIC_CARD', Application__c = PRIVACY_SHIELD_APP_NAME, Transaction_Amount__c = 5.00);
		insert payment;
	}

	@isTest static void getCreditCardPaymentDetails(){
		System.debug('PaymentDetailsLightningController.getCreditCardPaymentDetails()');

		Payment__c payment = [SELECT Id FROM Payment__c WHERE Pay_Gov_Tracking_Id__c = :PAY_GOV_TRACKING_ID LIMIT 1];

		//Test retrieving the payment details
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryCCMockImpl());
		PaymentDetailsLightningController paymentDetailsLightningController = PaymentDetailsLightningControllerCallout.getPaymentDetails(payment.Id);
		System.assertEquals(paymentDetailsLightningController.isCreditCard, true);
		System.assertEquals(paymentDetailsLightningController.transactionAmount, 'transactionAmount');
		Test.stopTest();

	}

	@isTest static void getACHPaymentDetails(){
		System.debug('PaymentDetailsLightningController.getACHPaymentDetails()');

		Payment__c payment = [SELECT Id FROM Payment__c WHERE Pay_Gov_Tracking_Id__c = :PAY_GOV_TRACKING_ID LIMIT 1];

		//Test retrieving the payment details
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovSingleQueryAchMockImpl());
		PaymentDetailsLightningController paymentDetailsLightningController = PaymentDetailsLightningControllerCallout.getPaymentDetails(payment.Id);
		System.assertEquals(paymentDetailsLightningController.isAch, true);
		System.assertEquals(paymentDetailsLightningController.transactionAmount, 'transactionAmount');
		Test.stopTest();

	}
}