@IsTest
	public class RecordLogViewerControllerTest {

	private static final String PAY_GOV_TRACKING_ID = 'testTrackingId';
	private static final String PRIVACY_SHIELD_APP_NAME = 'Privacy Shield';

	@testSetup static void createData(){
		Account account = new Account(Name='Record Log Viewer Controller Test Account');
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

	@IsTest
	public static void getRecordLogs_LogExists_True() {

		List<Payment__c> payments = [SELECT Id FROM Payment__c];

		Record_Log__c log = new Record_Log__c();
		log.Data__c = 'Some log data';
		log.Related_Record_Id__c = payments[0].Id;
		insert log;

		List<Record_Log__c> recordLogs = RecordLogViewerController.getRecordLogs(payments[0].Id);
		System.assertEquals(recordLogs.size(), 1);
		System.assertEquals(recordLogs[0].Data__c, 'Some log data');
	}

	@IsTest
	public static void getRecordLogs_LogExists_False() {

		List<Payment__c> payments = [SELECT Id FROM Payment__c];
		List<Record_Log__c> recordLogs = RecordLogViewerController.getRecordLogs(payments[0].Id);
		System.assertEquals(recordLogs.size(), 0);
	}
}