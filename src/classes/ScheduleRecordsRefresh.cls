public class ScheduleRecordsRefresh implements ScheduledRecordsRefreshDispatcher.IScheduleDispatched, Schedulable {
	@TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');

// This class runs a scheduled job at 1AM every morning

	public static Integer emailAllowed = 0;
	public static String successText = '';
	public static String failureText = '';
	public static AppConfig__c AC = AppConfig__c.getValues('default');
	public static String wc = '(Next_Announcement_Date__c IN :dateSet7Days OR Next_Due_to_DAS_Deadline__c IN :dateSet7Days OR Next_Office_Deadline__c IN :dateSet7Days)';

	//object lists for update
	@TestVisible private static List<Petition__c> petitionsToRefresh = new List<Petition__c> ();
	@TestVisible private static List<Investigation__c> investigationsToRefresh = new List<Investigation__c> ();
	@TestVisible private static List<Segment__c> segmentsToRefresh = new List<Segment__c> ();
	@TestVisible private static List<Litigation__c> litigationsToRefresh = new List<Litigation__c> ();

	//set for cases associated with each object
	@TestVisible private static Set<Id> caseIdSet = new Set<Id>();

	public void execute(SchedulableContext sc) {
		checkLimits();
		refreshDueDates();
	}


	public static Set<Date> calculateDateSet7Days() {
		Set<Date> returnSet = new Set<Date>();
		for (Integer i=1; i<=7; i++) {
			returnSet.add(System.today().addDays(-i));
		}
		return returnSet;
	}

		@future
	@TestVisible public static void refreshDueDates() {

		//1 - Loop through all objects to get lists to update later

		//Petitions
		for (Petition__c p : PetitionSelector.newInstance().selectByWhereClause(wc)) {

			p.Schedule_Refresh__c = toggleScheduleRefresh(p.Schedule_Refresh__c);

			//add case id to set
			caseIdSet.add(p.ADCVD_Case__c);
			//add petition to list
			petitionsToRefresh.add(p);
		}

		//Investigations
		for (Investigation__c i : InvestigationSelector.newInstance().selectByWhereClause(wc)) {

			i.Schedule_Refresh__c = toggleScheduleRefresh(i.Schedule_Refresh__c);

			//add case id to set
			caseIdSet.add(i.ADCVD_Case__c);
			//add investigation to list
			investigationsToRefresh.add(i);
		}

		//Segments
		for (Segment__c s : SegmentSelector.newInstance().selectByWhereClause(wc)) {

			s.Schedule_Refresh__c = toggleScheduleRefresh(s.Schedule_Refresh__c);

			//add case id to set
			caseIdSet.add(s.ADCVD_Case__c);
			//add segment to list
			segmentsToRefresh.add(s);
		}

		//Litigations
		for (Litigation__c l : LitigationSelector.newInstance().selectByWhereClause(wc)) {

			l.Schedule_Refresh__c = toggleScheduleRefresh(l.Schedule_Refresh__c);

			//add case id to set
			caseIdSet.add(l.ADCVD_Case__c);
			//add litigation to list
			litigationsToRefresh.add(l);
		}

		//2 - Instantiate caseMapper based on case ids from all objects
		caseMapper = caseMapper.getInstance(caseIdSet);

		//3 - DML operations for all objects
		//Petitions
		updateSObjectLists('Petition', petitionsToRefresh);

		//Investigations
		updateSObjectLists('Investigation', investigationsToRefresh);

		//Segments
		updateSObjectLists('Segment', segmentsToRefresh);

		//Litigations
		updateSObjectLists('Litigation', litigationsToRefresh);

		finish();
	}

	private static void updateSObjectLists(String sObjectName, List<SObject> l) {
		List<Database.SaveResult> srList = Database.update(l, false);
		for (Integer k = 0; k < l.size(); k++) {
			Database.SaveResult sr = srList[k];
			Id objectId = l[k].Id;
			String objectLabel = sObjectName;
			writeMessages(sr, objectId, objectLabel);
		}

	}
	public static void finish() {
		String emailtext = '';
		if (String.isEmpty(successText) && String.isEmpty(failureText)) emailtext = 'No records were processed for update during this execution.';
		if (String.isNotEmpty(successText) && String.isEmpty(failureText)) emailtext = 'Operation completely successful. No errors reported.';
		if (String.isEmpty(successText) && String.isNotEmpty(failureText)) emailtext = 'Operation failed. The following errors occurred: \n' + failureText;
		if (String.isNotEmpty(successText) && String.isNotEmpty(failureText)) emailtext = emailtext += successText + 'Partial Success! The following errors occurred: \n' + failureText;

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[]{
				AC.Primary_Admin__c
		};
		String[] ccAddresses = new String[]{
				AC.ADCVD_Admin__c
		};
		mail.setToAddresses(toAddresses);
		mail.setCcAddresses(ccAddresses);
		mail.setReplyTo('noreply@trade.gov');
		mail.setSenderDisplayName('ADCVD Scheduled Apex');
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.PlainTextBody = emailtext;
		mail.Subject = 'ScheduleRecordsRefresh Job Results ' + System.now();
		mail.saveAsActivity = false;
		Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
	}

	public void checkLimits() {
		Integer emailMax = limits.getLimitEmailInvocations();
		Integer emailActual = limits.getEmailInvocations();
		emailAllowed = emailMax - emailActual;
		if (emailAllowed > 2) Messaging.reserveSingleEmailCapacity(2);
	}

	public static void writeMessages(Database.SaveResult sr, Id objectId, String objectLabel) {
		if (sr.isSuccess()) {
			// Operation was successful, so get the ID of the record that was processed
			successText = successText + 'Successfully updated ' + objectLabel + ': ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + sr.getId() + '\n';
		} else {
			// Operation failed, so get all errors
			for (Database.Error err : sr.getErrors()) {
				failureText = failureText + 'The following error has occurred for ' + objectLabel + ': ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + objectId + '\n';
				failureText = failureText + err.getStatusCode() + ': ' + err.getMessage() + '\n';
				failureText = failureText + 'Investigation fields that affected this error: ' + err.getFields() + '\n';
			}
		}
	}

	private static Boolean toggleScheduleRefresh(Boolean b) {
		if (b) {
			return false;
		} else {
			return true;
		}

	}
}