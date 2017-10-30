public class ScheduleRecordsRefresh implements ScheduledRecordsRefreshDispatcher.IScheduleDispatched, Schedulable {
		
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
		
    //Petitions
		List<Petition__c> petitionsToRefresh = new List<Petition__c> ();
    petitionsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Petition__c WHERE (Next_Announcement_Date__c = 
					yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
			 
		for (Petition__c p : petitionsToRefresh){

	 		if (p.Schedule_Refresh__c){
	 			p.Schedule_Refresh__c = false;
	 		} else {
	 			p.Schedule_Refresh__c = true;
	 		}		
		}

    List<Database.SaveResult> petitionSRs = Database.update(petitionsToRefresh, false); 
    for (Integer k = 0; k < petitionsToRefresh.size(); k++) {
      Database.SaveResult sr = petitionSRs[k];
      Id objectId = petitionsToRefresh[k].Id;
      String objectLabel = 'Petition';
      writeMessages(sr, objectId, objectLabel);
    }  

    //Investigations
    List<Investigation__c> investigationsToRefresh = new List<Investigation__c> ();
    investigationsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Investigation__c WHERE (Next_Announcement_Date__c = 
          yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
			
		for (Investigation__c i : investigationsToRefresh) {
	 		if (i.Schedule_Refresh__c){
	 			i.Schedule_Refresh__c = false;
	 		} else {
	 			i.Schedule_Refresh__c = true;
	 		}	
		}

		List<Database.SaveResult> investigationSRs = Database.update(investigationsToRefresh, false); 
		for (Integer k = 0; k < investigationsToRefresh.size(); k++) {
			Database.SaveResult sr = investigationSRs[k];
			Id objectId = investigationsToRefresh[k].Id;
      String objectLabel = 'Investigation';
      writeMessages(sr, objectId, objectLabel);
	 	}

    //Segments
    List<Segment__c> segmentsToRefresh = new List<Segment__c> ();
    segmentsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Segment__c WHERE (Next_Announcement_Date__c = 
          yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
       
    for (Segment__c s : segmentsToRefresh){

      if (s.Schedule_Refresh__c){
        s.Schedule_Refresh__c = false;
      } else {
        s.Schedule_Refresh__c = true;
      }   
    }

    List<Database.SaveResult> segmentSRs = Database.update(segmentsToRefresh, false); 
    for (Integer k = 0; k < segmentsToRefresh.size(); k++) {
      Database.SaveResult sr = segmentSRs[k];
      Id objectId = segmentsToRefresh[k].Id;
      String objectLabel = 'Segment';
      writeMessages(sr, objectId, objectLabel);
    }  

    //Litigations
    List<Litigation__c> litigationsToRefresh = new List<Litigation__c> ();
    litigationsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Litigation__c WHERE (Next_Announcement_Date__c = 
          yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
      
    for (Litigation__c l : litigationsToRefresh) {
      if (l.Schedule_Refresh__c){
        l.Schedule_Refresh__c = false;
      } else {
        l.Schedule_Refresh__c = true;
      } 
    }

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
