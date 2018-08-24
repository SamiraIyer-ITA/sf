public without sharing class form_start_controller {

    public PageReference doNothing() {
        return null;
    }

    public PageReference start(){
        if(participantRecord != null && participantRecord.Id != null){
            if(app.getOrders(participantRecord.id, 'In Progress').size() == 0){
                Order o = app.createOrder(participantRecord.id, this.form.program__c, this.form.Product_Catalog__c);
            }
        }else{
            participantRecord = app.createApplication(this.form.program__c);
            RecordType[] RecordTypeId = [select id from RecordType where DeveloperName = :this.form.Record_Type__c limit 1];
            if(RecordTypeId.size() == 1){
                participantRecord.RecordTypeId = RecordTypeId[0].id;
                insert participantRecord;
                Participant_Contact__c contact = new Participant_Contact__c(participant__c = participantRecord.id, contact__c = [select contactid from user where id = :UserInfo.getUserId() limit 1][0].contactId, role__c='Portal Administrator', first_name__c = UserInfo.getFirstName(), last_name__c = UserInfo.getLastName(), email__c = UserInfo.getUserEmail(), recordtypeid=[select id from recordtype where sObjectType = 'Participant_Contact__c' and developername = 'Toolkit_Application_Contact' limit 1][0].id);
                insert contact;
            }
            
            Order o = app.createOrder(participantRecord.id, this.form.program__c, this.form.product_catalog__c);
        }
        if(participantRecord != null){
            return this.app.findFormPage(this.form.id, true);
        }
        return null;
    }

    public Form__c form {get; set;}

    public User u {get {
        if(u == null) {
          u = [SELECT ContactId, Contact.AccountId, postalcode FROM User WHERE Id =: UserInfo.getUserId()];  
        }
        return u;
    } set; }

    public boolean validCommunityUser() {
        if(u.ContactId == null) {
            return false;
        }
        return true;
    }

    private Application app = new Application();

    public Participation__c participantRecord {get {
        if(participantRecord == null) {
            participantRecord = this.app.getApplication(this.app.getStandardFields(), this.form.program__c);
            if(participantRecord == null) {
                participantRecord = app.createApplication(this.form.program__c);                
            }
        }
        return participantRecord;
    } set;}

    public pageReference redirect(){
        if(this.participantRecord != null && this.participantRecord.id != null && ApexPages.CurrentPage().getParameters().get('Id') != null){
            return this.app.findFormPage(this.form.id, true);
        }
        return null;
    }

    public form_start_controller(){
        //initialize variables 
        Id formId = ApexPages.currentPage().getParameters().get('id');

        if(!validCommunityUser()) {
            this.form = new Form__c(Name='Invalid User');  //to prevent a fatal VFP error.
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Invalid User Logged In.  Please login as community user.'));
        } else if(formId != null) {
            try {
                this.form = [SELECT Id, Name, Header__c, Omb_Control_No__c, Record_Type__c, Omb_Expiration_Date__c, Program__c, Object_API__c, Instructions__c, Product_Catalog__c FROM Form__c WHERE Id =: formId];
            }catch(Exception e){
                //system.debug(e);
                //Invalid Form Id provided.  Display a Message.
                this.form = new Form__c(Name='Invalid Form');  //to prevent a fatal VFP error.
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Invalid Form Provided.  Please contact Support.'));
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, e.getMessage()));
            }

        } else {
            this.form = new form__c(Name='Form Not Found');  //to prevent a fatal VFP error.
            //No Form was provided.  Display an error message.
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'No Form Provided.  Please contact Support.'));
        }
    }

}