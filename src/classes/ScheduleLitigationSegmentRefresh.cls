/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 **/
 
public class ScheduleLitigationSegmentRefresh implements DispatchScheduledFollower.IScheduleDispatched, Schedulable {

	public integer emailAllowed = 0; 	
	public string emailtext1 = '';
	public string emailtext2 = '';
	public AppConfig__c AC = AppConfig__c.getValues('default');
    
    public void execute(SchedulableContext sc)
    {
		refreshDueDates();
    }
    

	public void refreshDueDates(){

	    list<Litigation__c>litigationsToRefresh = new list<Litigation__c>();
        list<Segment__c>segmentsToRefresh = new list<Segment__c>();

        litigationsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Litigation__c WHERE (Next_Announcement_Date__c = 
        	yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];

        segmentsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Segment__c WHERE (Next_Announcement_Date__c = 
        	yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
       
      	for(Litigation__c p:litigationsToRefresh){

       		if(p.Schedule_Refresh__c){
       			p.Schedule_Refresh__c = false;
       		}else{
       			p.Schedule_Refresh__c = true;
       		}		
      	}
      
      	for(Segment__c i:segmentsToRefresh){

       		if(i.Schedule_Refresh__c){
       			i.Schedule_Refresh__c = false;
       		}else{
       			i.Schedule_Refresh__c = true;
       		}	
      	}

		Database.SaveResult[] srList = Database.update(litigationsToRefresh, false); 
		for (Integer k = 0; k < litigationsToRefresh.size(); k++) {
        Database.SaveResult sr = srList[k];
        Litigation__c so = litigationsToRefresh[k];

    		if (sr.isSuccess()) {
        		// Operation was successful, so get the ID of the record that was processed
        		emailtext1 = emailtext1 + 'Successfully updated Litigation: ' + 
            URL.getSalesforceBaseUrl().toExternalForm() + '/' + sr.getId() + '\n';
    	
    		}else {

        		// Operation failed, so get all errors               
        		for(Database.Error err : sr.getErrors()) {
        			emailtext2 = emailtext2 + 'The following error has occurred for Litigation: ' + 
              URL.getSalesforceBaseUrl().toExternalForm()+'/'+ so.Id + '\n';
        			emailtext2 = emailtext2 + err.getStatusCode() + ': ' + err.getMessage() + '\n';                   
        			emailtext2 = emailtext2 + 'Litigation fields that affected this error: ' + err.getFields() + '\n';
        		}
    		}
		
   		}   

		Database.SaveResult[] srList1 = Database.update(segmentsToRefresh, false); 
		for (Integer k = 0; k < segmentsToRefresh.size(); k++) {
        Database.SaveResult sr1 = srList1[k];
        Segment__c so = segmentsToRefresh[k];

    		if (sr1.isSuccess()) {
        		// Operation was successful, so get the ID of the record that was processed
        		emailtext2 = emailtext2 + 'Successfully updated Segment: ' + 
            URL.getSalesforceBaseUrl().toExternalForm() + '/' + sr1.getId() + '\n';
    	
    		}else {

        		// Operation failed, so get all errors               
        		for(Database.Error ierr : sr1.getErrors()) {
        			emailtext2 = emailtext2 + 'The following error has occurred for Segment: ' + 
              URL.getSalesforceBaseUrl().toExternalForm()+'/'+ so.Id + '\n';
        			emailtext2 = emailtext2 + ierr.getStatusCode() + ': ' + ierr.getMessage() + '\n';                   
        			emailtext2 = emailtext2 + 'Segment fields that affected this error: ' + ierr.getFields() + '\n';
        		}
    		}    		
		
   		}   


		finish();
	}
	
    public void finish() {
    	
    	string emailtext = '';
    	if(string.isEmpty(emailtext1) && string.isEmpty(emailtext2)) emailtext = 'No records were processed for update during this execution.';
    	if(string.isNotEmpty(emailtext1) && string.isEmpty(emailtext2)) emailtext = 'Operation completely successful. No errors reported.';
    	if(string.isNotEmpty(emailtext1) && string.isNotEmpty(emailtext2)) emailtext = emailtext += emailtext1 + 'Partial Success! The following errors occurred: ' + emailtext2;
    	
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{AC.Primary_Admin__c};
        string[] ccAddresses = new string[]{AC.ADCVD_Admin__c}; 
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setReplyTo(AC.ADCVD_Admin__c);
        mail.setSenderDisplayName('ADCVD Admin');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.PlainTextBody = emailtext;
        mail.Subject = 'ScheduledLitigationSegmentInvestigationRefresh Job Results ' + System.now();
        mail.saveAsActivity = false;    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        // schedule tomorrow's PetitionInvestigation run 
		String chronExpr = AC.ChronExpr_PetitionInvestigation__c;    	    	
   		ScheduledDispatcher sd = new ScheduledDispatcher();

   		// actually schedules the job for tommorrow
   		String CronTriggerID = system.schedule('Next Dispatch Scheduled', chronExpr, sd); 

    }	

}