global without sharing class CP_SaveContactRequestFlowAction {
 
    @InvocableMethod(label='Create Contact Request' description='Creates Contact Request Record.')
    global static void createRecord(List<RequestVariables> inputs) {
        RequestVariables userInputs = inputs[0];
        Boolean emailsTurnedOn = false;
        List<String> managerEmailList = getQueueManagerEmails(userInputs.queueDeveloperName);
        List<lead> leadList = new List<lead>();
        Map<String,EmailTemplate> emailTemplateMap = getEmailTempletes();
        Map<String,String> fromEmailMap = new Map<String,String>();
        User defaultUser = getDefaultUser();
        OrgWideEmailAddress noReplyEmail = getOrgWideEmail();
        ContactRequest newRecord = new ContactRequest();
		userInputs.leadId = getUserLeadId(userInputs.email);
        String userType = '';
       
        //Standard Fields  
        newRecord.First_Name__c = userInputs.firstName; 
        newRecord.Last_Name__c = userInputs.lastName;
        newRecord.Email__c = userInputs.email;
        newrecord.Company_Name__c = userInputs.companyName;
        newRecord.RequestDescription =  userInputs.message;
        if(userInputs.country != 'NONE'){
            newRecord.Country_1__c = userInputs.country;
        }
        newRecord.RequestReason =  userInputs.requestReason;
        //System and static fields 
        newRecord.OwnerId = userInputs.ownerId;
        newRecord.Status = 'New';
        if(userInputs.zipCode != 'NONE'){
            newRecord.US_ZIP_CODE__c = userInputs.zipCode;
        }
           //using text as boolean since value is passed from flow  
        if(userInputs.converted == 'true'){
            newRecord.WhoId = userInputs.contactId;
            userType = 'verified';
        }
        else
            if(userInputs.leadId != 'NONE' && userInputs.contactId != 'NONE'){
                newRecord.WhoId = userInputs.leadId;
                userType = 'unverified';
            }
        else{
            userType = 'unregistered';
        }
        database.insert(newRecord);
        try{
   				 Messaging.reserveSingleEmailCapacity(0);
   				 emailsTurnedOn = true;
		} 
        catch(System.NoAccessException e){
        }
        if (emailsTurnedOn ){ //&& ! TEST.isRunningTest()) {
        sendEmailToRequester(newRecord.Email__c,userType,userInputs.contactId,newRecord.Id,noReplyEmail,
                             emailTemplateMap.get('Contact_Us_Requested'));
   		SendEmailToManagers(noReplyEmail,userInputs.queueName,newRecord.Id,managerEmailList);
    	}
    }	
      
     private static void sendEmailToRequester(String toAddress,String userType,String userId,Id requestId,OrgWideEmailAddress orgEmail,EmailTemplate informTemplate){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(informTemplate.Id);
        mail.setSaveAsActivity(false);     
        if(userType == 'verified' || userType == 'unverified'){
            mail.setTargetObjectId(userId);
        }
        else{
            mail.setTargetObjectId(UserInfo.getUserId());  
        }
        if(orgEmail != null){
       	 mail.setOrgWideEmailAddressId(orgEmail.Id);
        }
        mail.setToAddresses(new list<string>{toAddress});
        if(! TEST.isRunningTest()){ 
        	Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
     }

    private static void SendEmailToManagers(OrgWideEmailAddress orgEmail,String queueName,Id recordId,List<String> managerEmailList){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);  
        mail.setSubject(getSubjectEmail(queueName));
        mail.setPlainTextBody(getEmailBody(recordId));
        if(orgEmail != null){
       	   mail.setOrgWideEmailAddressId(orgEmail.Id);
        }
        mail.setToAddresses(managerEmailList);
        if(! TEST.isRunningTest()){
       		 Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	}
    }
    
    private static String getSubjectEmail(String queueName){
        String subject;
        subject = '' + queueName + '- New Contact Request Notification';
        return subject;
    }
    private static String getEmailBody(Id RecordId){
        String body;
        String recordURL = URL.getSalesforceBaseUrl().toExternalForm() +
        '/' + RecordId;
        body = 'A new contact request has been received. Please review the request here:' +  '\n \n'
            + recordURL ;
        return body;
    }
        
     private static map<String,EmailTemplate> getEmailTempletes(){
       List<String> templateNameList = new list <String>();
       List<EmailTemplate> templeateList = new list <EmailTemplate>(); 
       map<String,emailTemplate> templateMap = new map<String,EmailTemplate>();
       templateNameList.add('Contact_Request_Manager_Notification');
       templateNameList.add('Contact_Us_Requested');
       templeateList = [SELECT Id, Body, Subject, DeveloperName FROM EmailTemplate WHERE DeveloperName IN: templateNameList];
        for(EmailTemplate ct : templeateList){
            templateMap.put(ct.developerName,ct);
        }
        return templateMap;
	}   
    
    private static OrgWideEmailAddress getOrgWideEmail(){
         List<OrgWideEmailAddress> orgEmails = new list<OrgWideEmailAddress>();
        //update to avoid double querry
        orgEmails = [SELECT Id FROM OrgWideEmailAddress WHERE Address =: 'noreply@trade.gov' LIMIT 1];
        if(!orgEmails.isEmpty()){
            return orgEmails[0];
        }
        else{
            return null;
        }
    }    
    
    private static User getDefaultUser(){
       List<User> defaultUserList = new List<User>();
           if(defaultUserList.isempty())  {
            defaultUserList = [SELECT Id FROM User WHERE Alias =: Label.CP_NoReply_Alias LIMIT 1];
        }
        If(!defaultUserList.isempty()){
            return defaultUserList[0];
        }
        else
        {
            return null;
        }
    }
 
    private static String getUserLeadId(String userMail){
        List<Lead> leadList = new List<Lead>();
         leadList= [SELECT Id FROM LEAD WHERE Email =: userMail AND RecordType.DeveloperName = 'New_Registrant' LIMIT 1];
        if(!leadList.isempty()){
            return leadList[0].id;
        }
        else{
            return 'NONE'; 
        }
    }
    
    private static String getNoReplyContactRecord(String userMail){
        List<Contact> contactList = new List<Contact>();
         contactList= [SELECT Id FROM CONTACT WHERE Email =: userMail LIMIT 1];
        if(!contactList.isempty()){
            return contactList[0].id;
        }
        else{
            return 'NONE'; 
        }
    }
    
    private static List<String> getQueueManagerEmails(String queueName){
       List<CP_Queue_grouping__c> publicGroups = CP_Queue_grouping__c.getAll().values();
       List<String> emailList = new list<String>();
       String publicGroup;
       map<string, string> queueGroupMappingValues = new Map<string, string>();
       if(Test.isRunningTest()){
            queueGroupMappingValues.put('CP_Contact_US_3', 'CP_Contact_Us_Group3');
        }
        for(CP_Queue_grouping__c cg :publicGroups){
            queueGroupMappingValues.put(cg.name, cg.value__c);
        }
        publicGroup = queueGroupMappingValues.get(queueName);
        for(User cu : [SELECT Id, Email, IsActive FROM USER WHERE Isactive =: TRUE AND
                       Id IN (SELECT UserOrGroupId FROM GROUPMEMBER WHERE Group.DeveloperName =: publicgroup)]){
            emailList.add(cu.Id);    
         }
        return emailList;
    }
    
    global class RequestVariables {
        @InvocableVariable(label='First Name' required=true)
        global String firstName;
        @InvocableVariable(label='Last Name' required=true)
        global String lastName;
        @InvocableVariable(label='Email' required=true)
        global String email;
        @InvocableVariable(label='Country Name' required=false)
        global String country;
        @InvocableVariable(label='Request Reason' required=false)
        global String requestReason;
        @InvocableVariable(label='Queue Id' required=false)
        global String ownerId;
        @InvocableVariable(label='Zip Code' required=false)
        global String zipCode;
        @InvocableVariable(label='Converted' required=false)
        global String converted;
        @InvocableVariable(label='Lead Id' required=false)
        global String leadId;
        @InvocableVariable(label='Contact Id' required=false)
        global String contactId;
        @InvocableVariable(label='Message' required=false)
        global String message;
        @InvocableVariable(label='Company Name' required=false)
        global String companyName;
        @InvocableVariable(label='Queue Name' required=false)
        global String queueName;
        @InvocableVariable(label='Queue Developer Name' required=false)
        global String queueDeveloperName;
        @InvocableVariable(label='Queue Id' required=false)
        global String queueId;
    }
}