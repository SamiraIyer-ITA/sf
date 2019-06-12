public class ScheduleRecordsRefresh implements ScheduledRecordsRefreshDispatcher.IScheduleDispatched, Schedulable {
	@TestVisible private static ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');

// This class runs a scheduled job at 1AM every morning

	public Integer emailAllowed = 0;
	public String successText = '';
	public String failureText = '';
	public AppConfig__c AC = AppConfig__c.getValues('default');


	public void execute(SchedulableContext sc) {
		refreshDueDates();
	}

	public void refreshDueDates() {

		checkLimits();

		//set for cases associated with each object
		Set<Id> caseIdSet = new Set<Id>();

		//1 - Loop through all objects to get lists to update later
		//Petitions
		List<Petition__c> petitionsToRefresh = new List<Petition__c> ();
		for (Petition__c p : [SELECT Id, Schedule_Refresh__c, ADCVD_Case__c
							  FROM Petition__c
							  WHERE (Next_Announcement_Date__c = yesterday
								  OR Next_Due_to_DAS_Deadline__c = yesterday
								  OR Next_Office_Deadline__c = yesterday)
							  FOR UPDATE ]){

			if (p.Schedule_Refresh__c){
				p.Schedule_Refresh__c = false;
			} else {
				p.Schedule_Refresh__c = true;
			}

			//add case id to set
			caseIdSet.add(p.ADCVD_Case__c);
			//add petition to list
			petitionsToRefresh.add(p);
		}

		//Investigations
		List<Investigation__c> investigationsToRefresh = new List<Investigation__c> ();
		for (Investigation__c i : [SELECT Id, Schedule_Refresh__c, ADCVD_Case__c
								   FROM Investigation__c
								   WHERE (Next_Announcement_Date__c = yesterday
									   OR Next_Due_to_DAS_Deadline__c = yesterday
									   OR Next_Office_Deadline__c = yesterday)
								   FOR UPDATE]) {

			if (i.Schedule_Refresh__c){
				i.Schedule_Refresh__c = false;
			} else {
				i.Schedule_Refresh__c = true;
			}

			//add case id to set
			caseIdSet.add(i.ADCVD_Case__c);
			//add investigation to list
			investigationsToRefresh.add(i);
		}

		//Segments
		List<Segment__c> segmentsToRefresh = new List<Segment__c> ();
		for (Segment__c s : [SELECT Id, Schedule_Refresh__c, ADCVD_Case__c
							 FROM Segment__c
							 WHERE (Next_Announcement_Date__c = yesterday
								 OR Next_Due_to_DAS_Deadline__c = yesterday
								 OR Next_Office_Deadline__c = yesterday)
							 FOR UPDATE]){

			if (s.Schedule_Refresh__c){
				s.Schedule_Refresh__c = false;
			} else {
				s.Schedule_Refresh__c = true;
			}

			//add case id to set
			caseIdSet.add(s.ADCVD_Case__c);
			//add segment to list
			segmentsToRefresh.add(s);
		}

		//Litigations
		List<Litigation__c> litigationsToRefresh = new List<Litigation__c> ();
		for (Litigation__c l : [SELECT Id, Schedule_Refresh__c, ADCVD_Case__c
								FROM Litigation__c
								WHERE (Next_Announcement_Date__c =yesterday
									OR Next_Due_to_DAS_Deadline__c = yesterday
									OR Next_Office_Deadline__c = yesterday)
								FOR UPDATE]) {

			if (l.Schedule_Refresh__c){
				l.Schedule_Refresh__c = false;
			} else {
				l.Schedule_Refresh__c = true;
			}

			//add case id to set
			caseIdSet.add(l.ADCVD_Case__c);
			//add litigation to list
			litigationsToRefresh.add(l);
		}

		//2 - Instantiate caseMapper based on case ids from all objects
		caseMapper = caseMapper.getInstance(caseIdSet);

		//3 - DML operations for all objects

		//Petitions
		List<Database.SaveResult> petitionSRs = Database.update(petitionsToRefresh, false);
		for (Integer k = 0; k < petitionsToRefresh.size(); k++) {
			Database.SaveResult sr = petitionSRs[k];
			Id objectId = petitionsToRefresh[k].Id;
			String objectLabel = 'Petition';
			writeMessages(sr, objectId, objectLabel);
		}

		//Investigations
		List<Database.SaveResult> investigationSRs = Database.update(investigationsToRefresh, false);
		for (Integer k = 0; k < investigationsToRefresh.size(); k++) {
			Database.SaveResult sr = investigationSRs[k];
			Id objectId = investigationsToRefresh[k].Id;
			String objectLabel = 'Investigation';
			writeMessages(sr, objectId, objectLabel);
		}

		//Segments
		List<Database.SaveResult> segmentSRs = Database.update(segmentsToRefresh, false);
		for (Integer k = 0; k < segmentsToRefresh.size(); k++) {
			Database.SaveResult sr = segmentSRs[k];
			Id objectId = segmentsToRefresh[k].Id;
			String objectLabel = 'Segment';
			writeMessages(sr, objectId, objectLabel);
		}

		//Litigations
		List<Database.SaveResult> litigationSRs = Database.update(litigationsToRefresh, false);
		for (Integer k = 0; k < litigationsToRefresh.size(); k++) {
			Database.SaveResult sr = litigationSRs[k];
			Id objectId = litigationsToRefresh[k].Id;
			String objectLabel = 'Litigation';
			writeMessages(sr, objectId, objectLabel);
		}
		finish();
	}

	public void finish() {
		String emailtext = '';
		if (String.isEmpty(successText) && String.isEmpty(failureText)) emailtext = 'No records were processed for update during this execution.';
		if (String.isNotEmpty(successText) && String.isEmpty(failureText)) emailtext = 'Operation completely successful. No errors reported.';
		if (String.isEmpty(successText) && String.isNotEmpty(failureText)) emailtext = 'Operation failed. The following errors occurred: \n' + failureText;
		if (String.isNotEmpty(successText) && String.isNotEmpty(failureText)) emailtext = emailtext += successText + 'Partial Success! The following errors occurred: \n' + failureText;

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[]{AC.Primary_Admin__c};
		String[] ccAddresses = new String[]{AC.ADCVD_Admin__c};
		mail.setToAddresses(toAddresses);
		mail.setCcAddresses(ccAddresses);
		mail.setReplyTo('noreply@trade.gov');
		mail.setSenderDisplayName('ADCVD Scheduled Apex');
		mail.setBccSender(false);
		mail.setUseSignature(false);
		mail.PlainTextBody = emailtext;
		mail.Subject = 'ScheduleRecordsRefresh Job Results ' + System.now();
		mail.saveAsActivity = false;
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

	public void checkLimits(){
		Integer emailMax = limits.getLimitEmailInvocations();
		Integer emailActual = limits.getEmailInvocations();
		emailAllowed = emailMax - emailActual;
		if(emailAllowed > 2) Messaging.reserveSingleEmailCapacity(2);
	}

	public void writeMessages(Database.SaveResult sr, Id objectId, String objectLabel) {
		if (sr.isSuccess()) {
			// Operation was successful, so get the ID of the record that was processed
			successText = successText + 'Successfully updated ' + objectLabel + ': ' +
					URL.getSalesforceBaseUrl().toExternalForm() + '/' + sr.getId() + '\n';
		} else {
			// Operation failed, so get all errors
			for(Database.Error err : sr.getErrors()) {
				failureText = failureText + 'The following error has occurred for ' + objectLabel + ': ' +
						URL.getSalesforceBaseUrl().toExternalForm() + '/' + objectId + '\n';
				failureText = failureText + err.getStatusCode() + ': ' + err.getMessage() + '\n';
				failureText = failureText + 'Investigation fields that affected this error: ' + err.getFields() + '\n';
			}
		}
	}
}