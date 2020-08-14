public class Lead_Past_Due_Controller {
	@AuraEnabled
    public static Boolean getStatus(Id leadRecordId) {
        if(null != leadRecordId) {
            Lead objLead = [Select Id, Name, First_Attempt_Past_Due__c, Second_Attempt_Past_Due__c, Queue_Routing_Past_Due__c From Lead Where Id =: leadRecordId LIMIT 1];
            if(null != objLead) {
               if((objLead.First_Attempt_Past_Due__c || objLead.Second_Attempt_Past_Due__c || objLead.Queue_Routing_Past_Due__c)) {
                    return true;
                }
            }
        }
        return false;
    } 
}