public class Lead_Past_Due_Controller {
	@AuraEnabled
    public static Boolean getStatus(Id leadRecordId) {
        if(null != leadRecordId) {
            Lead objLead = [Select Id, Name, Queue_Routing_Past_Due_Formula__c, Assigned_User__c, X1st_Contact_Attempt_Past_Due_Formula__c, X1st_Contact_Attempt_Date__c, X2nd_Contact_Attempt_Past_Due_Formula__c, X2nd_Contact_Attempt_Date__c From Lead Where Id =: leadRecordId LIMIT 1];
            if(null != objLead) {
				if((null != objLead.Queue_Routing_Past_Due_Formula__c && objLead.Queue_Routing_Past_Due_Formula__c == true && null == objLead.Assigned_User__c)
					|| (null != objLead.X1st_Contact_Attempt_Past_Due_Formula__c && objLead.X1st_Contact_Attempt_Past_Due_Formula__c == true && null == objLead.X1st_Contact_Attempt_Date__c)
					|| (null != objLead.X2nd_Contact_Attempt_Past_Due_Formula__c && objLead.X2nd_Contact_Attempt_Past_Due_Formula__c == true && null == objLead.X2nd_Contact_Attempt_Date__c)
				) 
				{
					return true;
				}
            }
        }
        return false;
    } 
}