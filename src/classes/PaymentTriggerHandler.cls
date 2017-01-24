Public without sharing Class PaymentTriggerHandler {
    public static void createCases(Payment__c[] newList, map<id, Payment__c> newMap, map<id, Payment__c> oldMap){
        Set<Id> newListIds = new Set<Id>();
        for(Payment__c payment : newList){
            if(payment != null && payment.order__c !=  null && oldMap.get(payment.id) != null && oldMap.get(payment.id).Transaction_Status__c != payment.Transaction_Status__c && (payment.Transaction_Status__c == 'Received' || payment.Transaction_Status__c == 'Success')){
                newListIds.add(payment.id);
            }
        }
        createCaseFuture(newListIds);
    }
    @Future
    public static void createCaseFuture(Set<Id> newListIds) {
        string subject = 'Application for Review';
        Id recordType = [select id from recordtype where sobjecttype = 'Case' and DeveloperName = 'U_S_Business' limit 1].id;
        List<Case> caseList = new List<Case>();
        Set<Id> participationIds = new Set<Id>();
//        List<User> uList = [SELECT ContactId FROM User WHERE Id =: UserInfo.getUserId()];
  //      Id cId = null;
    //    if(uList.size() > 0) {
      //      cId = uList[0].ContactId;
        //}
        Payment__c[] payments = [select id, order__r.participant__c, order__r.participation__c, order__c, order__r.participant__r.organization__c from payment__c
            where id = :newListIds];
            for(Payment__c payment: payments){ 
            if(payment != null && payment.Order__c != null && payment.order__r.participation__c != null && payment.order__r.participant__r.organization__c != null) {
                participationIds.add(payment.order__r.participation__c);    
                case c = new case();
          //      c.contactId = cId;
                c.subject = subject; 
                c.Order__c = payment.Order__c;
                c.recordtypeid = recordType;
                c.accountid = payment.order__r.participant__r.organization__c;
                c.participation__c = payment.order__r.participation__c;
                c.description = 'Thank you for contacting the Privacy Shield team at the U.S. Department of Commerce’s International Trade Administration (ITA).  We will work diligently to review and respond to your submission in a timely manner.  Please note that the processing time will depend on the nature and completeness of the submission, as well as the volume of submissions received.';
            Database.DMLOptions dmo = new Database.DMLOptions();        
                    dmo.assignmentRuleHeader.useDefaultRule = true;     
                c.setOptions(dmo);
                system.debug(c);
                caseList.add(c);
            }
            }
        if(caseList.size() > 0) {
            system.debug(caseList);
            INSERT CASELIST;
            //SafeDmlHandler.safeInsert(caseList, false);
        }
        
        Participant__c[] participations = [select id, application_stage__c from participant__c where id = :participationIds];
        for(Participant__c participation :participations){
            participation.application_stage__c = 'Pending Review';
        }
        UPDATE PARTICIPATIONS;
        //SafeDmlHandler.safeUpdate(participations, false);
    }
}