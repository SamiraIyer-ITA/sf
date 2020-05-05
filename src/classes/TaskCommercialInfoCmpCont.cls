public class TaskCommercialInfoCmpCont {
        
    @AuraEnabled
    public static Commercial_Diplomacy_Triage__c getCommDiplTrig(Id taskIds) {
        
         Task objTask = [SELECT Id, Commercial_Diplomacy_Triage__c FROM Task WHERE Id =:taskIds LIMIT 1];
                // Returning the contact list
         
         Commercial_Diplomacy_Triage__c objComm = new Commercial_Diplomacy_Triage__c();
                     
         if(objTask.Commercial_Diplomacy_Triage__c != null){
             objComm = [SELECT Id FROM Commercial_Diplomacy_Triage__c  WHERE Id=:objTask.Commercial_Diplomacy_Triage__c LIMIT 1];
         }      
         
         
        return objComm ;
    }
}