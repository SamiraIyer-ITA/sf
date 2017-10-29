/**
 * 
 *    Created by Cal Smith
 *    on 10/26/2017 
 *    MIL Corporation
 * 
 **/
 
public class SchedulePetitionRefresh implements ScheduledDispatcher.IScheduleDispatched, Schedulable {
    
// This class runs a scheduled job at 1AM every morning

	public integer emailAllowed = 0; 	
	public string emailtext1 = '';
	public string emailtext2 = '';
	public AppConfig__c AC = AppConfig__c.getValues('default');	

    
    public void execute(SchedulableContext sc)
    {
		refreshDueDates();
    }
    
    
	public void refreshDueDates(){

		checkLimits();
		
	    list<Petition__c>petitionsToRefresh = new list<Petition__c>();
        list<Investigation__c>investigationsToRefresh = new list<Investigation__c>();

        petitionsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Petition__c WHERE (Next_Announcement_Date__c = 
        	yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];

        investigationsToRefresh = [SELECT Id, Schedule_Refresh__c FROM Investigation__c WHERE (Next_Announcement_Date__c = 
        	yesterday OR Next_Due_to_DAS_Deadline__c = yesterday OR Next_Office_Deadline__c = yesterday) for update];
       
      	for(Petition__c p:petitionsToRefresh){

       		if(p.Schedule_Refresh__c){
       			p.Schedule_Refresh__c = false;
       		}else{
       			p.Schedule_Refresh__c = true;
       		}		
      	}
      
      	for(Investigation__c i:investigationsToRefresh){

       		if(i.Schedule_Refresh__c){
       			i.Schedule_Refresh__c = false;
       		}else{
       			i.Schedule_Refresh__c = true;
       		}	
      	}

		Database.SaveResult[] srList = Database.update(petitionsToRefresh, false); 
		for (Database.SaveResult sr : srList) {

    		if (sr.isSuccess()) {
        		// Operation was successful, so get the ID of the record that was processed
        		emailtext1 = emailtext1 + 'Successfully updated Petition ID: ' + sr.getId();
    	
    		}else {

        		// Operation failed, so get all errors               
        		for(Database.Error err : sr.getErrors()) {
        			emailtext2 = emailtext2 + 'The following error has occurred: \n';
        			emailtext2 = emailtext2 + err.getStatusCode() + ': ' + err.getMessage() + '\n';                   
        			emailtext2 = emailtext2 + 'Petition fields that affected this error: ' + err.getFields() + '\n';
        		}
    		}
		
   		}   

		Database.SaveResult[] srList1 = Database.update(investigationsToRefresh, false); 
		for (Database.SaveResult sr1 : srList1) {

    		if (sr1.isSuccess()) {
        		// Operation was successful, so get the ID of the record that was processed
        		emailtext2 = emailtext2 + 'Successfully updated Investiagation ID: ' + sr1.getId();
    	
    		}else {

        		// Operation failed, so get all errors               
        		for(Database.Error ierr : sr1.getErrors()) {
        			emailtext2 = emailtext2 + 'The following error has occurred: \n';
        			emailtext2 = emailtext2 + ierr.getStatusCode() + ': ' + ierr.getMessage() + '\n';                   
        			emailtext2 = emailtext2 + 'Investigation fields that affected this error: ' + ierr.getFields() + '\n';
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
        mail.setReplyTo('noreply@trade.gov');
        mail.setSenderDisplayName('ADCVD Scheduled Apex');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.PlainTextBody = emailtext;
        mail.Subject = 'ScheduledPetitionInvestigationRefresh Job Results ' + System.now();
        mail.saveAsActivity = false;    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	    	
   		// dispatch followup scheduled class
   		String chronExp = AC.ChronExp_LitigationSegement__c;
		DispatchScheduledFollower dsf = new DispatchScheduledFollower();	
   		String CronTriggerID1 = system.schedule('DispatchFollower', chronExp, dsf);
         
    }	
    
	public void checkLimits(){
		integer emailMax = limits.getLimitEmailInvocations();
		integer emailActual = limits.getEmailInvocations();
		emailAllowed = emailMax - emailActual;
		if(emailAllowed >3) Messaging.reserveSingleEmailCapacity(3);
	}
   

}