@isTest
public class RefundLightningControllerTest {
	private static String PRIVACY_SHIELD_APP_ID;
	private static String PRIVACY_SHIELD_APP;
	private static String EVENTS_SERVICES_APP_ID;
	private static String EVENTS_SERVICES_APP;
	private static String EVENTS_SERVICES_APP_NAME;
	private static String AGENCY_ID;
	private static String PRIVACY_SHIELD_APP_NAME;
	private static STring PAY_GOV_TCS_SINGLE_SERVICE_ENDPOINT;
	private static final String PAY_GOV_TRACKING_ID = 'testTrackingId';

	@testSetup static void createTestData() {
		PaymentSettings__c[] psTypes = new PaymentSettings__c[]{};
		PaymentSettings__c ps1 = new PaymentSettings__c(Value__c='TCSITAUSMASSHQA', name ='PRIVACY_SHIELD_APP_ID');
		PaymentSettings__c ps2 = new PaymentSettings__c(Value__c='PS', name ='PRIVACY_SHIELD_APP');
		PaymentSettings__c ps3 = new PaymentSettings__c(Value__c='TCSITAUSFCSEMENUQA', name ='EVENTS_SERVICES_APP_ID');
		PaymentSettings__c ps4 = new PaymentSettings__c(Value__c='ES', name ='EVENTS_SERVICES_APP');
		PaymentSettings__c ps5 = new PaymentSettings__c(Value__c='967', name ='AGENCY_ID');
		PaymentSettings__c ps6 = new PaymentSettings__c(Value__c='Privacy Shield', name ='PRIVACY_SHIELD_APP_NAME');
		PaymentSettings__c ps7 = new PaymentSettings__c(Value__c='Service Endpoint', name = 'PAY_GOV_TCS_SINGLE_SERVICE_ENDPOINT');
		PaymentSettings__c ps8 = new PaymentSettings__c(Value__c='Event or Service', name ='EVENTS_SERVICES_APP_NAME');
		psTypes.add(ps1);
		psTypes.add(ps2);
		psTypes.add(ps3);
		psTypes.add(ps4);
		psTypes.add(ps5);
		psTypes.add(ps6);
		psTypes.add(ps7);
		psTypes.add(ps8);
		insert psTypes;

		PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;
		PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;
		EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;
		EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;
		EVENTS_SERVICES_APP_NAME = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_NAME').value__c;
		PRIVACY_SHIELD_APP_NAME = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_NAME').value__c;
		PAY_GOV_TCS_SINGLE_SERVICE_ENDPOINT = PaymentSettings__c.getAll().get('PAY_GOV_TCS_SINGLE_SERVICE_ENDPOINT').value__c;
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

	@isTest static void refundCreditCardPayment(){
		System.debug('RefundLightningController.refundCreditCardPayment()');

		Payment__c payment = [SELECT Id FROM Payment__c WHERE Pay_Gov_Tracking_Id__c = :PAY_GOV_TRACKING_ID LIMIT 1];

		//Test retrieving the payment details
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
		RefundLightningController refundLightningController = RefundLightningController.issueRefund(payment.Id);
		System.assertEquals(refundLightningController.errorMessage, null);
		System.assertEquals(refundLightningController.refundObject.Status__c, 'Completed');
		Test.stopTest();

	}

	@isTest static void refundACHPayment(){
		System.debug('RefundLightningController.refundACHPayment()');

		Payment__c payment = [SELECT Id FROM Payment__c WHERE Pay_Gov_Tracking_Id__c = :PAY_GOV_TRACKING_ID LIMIT 1];
		payment.Payment_Type__c = 'ACH';
		update payment;

		//Test retrieving the payment details
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
		RefundLightningController refundLightningController = RefundLightningController.issueRefund(payment.Id);
		System.assertNotEquals(refundLightningController.errorMessage, null);
		Test.stopTest();

	}

	@isTest static void noTCSAppId(){
		System.debug('RefundLightningController.noTCSAppId()');

		Payment__c payment = [SELECT Id FROM Payment__c WHERE Pay_Gov_Tracking_Id__c = :PAY_GOV_TRACKING_ID LIMIT 1];

		PaymentSettings__c paymentSettings = [SELECT Id, Value__c FROM PaymentSettings__c WHERE Name = 'PRIVACY_SHIELD_APP_NAME' LIMIT 1];
		paymentSettings.Value__c = '';
		update paymentSettings;

		//Test retrieving the payment details
		Test.startTest();
		Test.setMock(WebServiceMock.class, new TEST_PayGovTCSSingleServiceMockImpl());
		RefundLightningController refundLightningController = RefundLightningController.issueRefund(payment.Id);
		System.assertNotEquals(refundLightningController.errorMessage, null);
		Test.stopTest();

	}

}