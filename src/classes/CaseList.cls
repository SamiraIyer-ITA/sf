public with sharing class CaseList{
    public id recordtype {get; set;}
    public string casediv {get; set;}
    public string RecordTypeName{get; set;}
    public String caseSelected { get; set; }
    public Case c {get; set;}
    public Case psC {get; set;}
    public String caseRT {get; set;}
    public Case[] openCases {get; set;}
    public Case[] actionReqCases {get; set;}
    public Case[] orgOpenCases {get; set;}
    public Site__c currentDomain {get; set;} 
    public boolean loggedIn {get; set;}

    public Case[] results {get;set;}
    public CaseComment comment {get; set;}
    public CaseComment[] cmnts{get; set;}
    public Attachment attachment {get; set;}
    public Attachment[] att {get; set;}
    public boolean caseHasComments {get; set;}
    public boolean caseHasAttachements {get; set;}
    public String showContent { get; set; }
    public String showAttachment { get; set; }
    
    private integer counter=0;  //keeps track of the offset
    private integer list_size; //sets the page size or number of rows
    public integer total_size; //used to show user the total size of the list
    
    //display sort and number
    public String filterId {get;set;}
    public SelectOption[] items {get; set;}
    public String RecPerPage {get; set;}
    public SelectOption[] RecPerPageOption {get; set;}
    
    //Start Constructor
    public CaseList(){
        if(UserInfo.getUserType() == 'Guest'){//check if the user is logged in
            loggedIn = false;
        }else{
            loggedIn = true;
        }
        RecordTypeName = '';
        caseSelected = '0';
        showContent = '0';
        showAttachment = '0';
        currentDomain = [select id, name, Domain__c, Title__c from Site__c where Domain__c = :URL.getSalesforceBaseUrl().getHost() or UseAsDefault__c = true 
                    order by UseAsDefault__c limit 1]; //should return the current site domain
        
        
        //records for page initialization
        items = new List<SelectOption>();
        items.add(new SelectOption('My Open Cases', 'My Open Cases'));
        items.add(new SelectOption('Action Required', 'Action Required'));
        items.add(new SelectOption('My Company Cases', 'My Company Cases'));
        items.add(new SelectOption('My Closed Cases', 'My Closed Cases'));
        
        RecPerPageOption = new list<SelectOption>();
        RecPerPageOption.add(new SelectOption('10','10'));
        RecPerPageOption.add(new SelectOption('20','20'));
        RecPerPageOption.add(new SelectOption('30','30'));
        RecPerPage = '10'; //default records per page
        
        list_size = Integer.valueof(RecPerPage);
        
        //dashboard query
        this.openCases = [SELECT CaseNumber, Status, Subject, CreatedDate, CreatedBy.Name,LastModifiedDate 
                          FROM Case 
                          WHERE contactid = :getcontactid() 
                          and status <> 'Successfully Closed' 
                          Limit 1000];
        this.actionReqCases = [select Id, CaseNumber, AccountId, Subject, Priority, Status,CreatedBy.Name, CreatedDate, ContactId, LastModifiedDate 
                               FROM Case 
                               WHERE contactid = :getcontactid() 
                               and Status = 'Action Required' 
                               Limit 1000];
        this.orgOpenCases = [SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate,CreatedBy.Name, ContactId, LastModifiedDate 
                             FROM Case 
                             WHERE AccountId = :getaccountId()  
                             Limit 1000];
        IF(UserInfo.getUserType() != 'Guest' || getContactId() != null){
            this.results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                            'FROM Case '+
                                            'WHERE contactid = \''+ getContactId() + '\' and status <> \'Successfully Closed\' ' +
                                            'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);                                
            total_size = this.openCases.size(); //set the total size
        }
        
        Id crt = Schema.SObjectType.case.getRecordTypeInfosByName().get('Participation').getRecordTypeId();
        this.psC = new case(recordtypeid = crt, type = 'Application Issue'); 

        this.c = new case(); 
      
        if(ApexPages.currentPage().getParameters().get('id') != null){
            Case[] tmpCases = [SELECT id, caseNumber, type, status, subject, description, contact.name, LastModifiedBy.name, createdBy.name,
                               LastModifieddate, contact.email, contact.MailingStreet, 
                                contact.MailingCity, contact.MailingState, contact.MailingPostalCode, contact.MailingCountry,
                                contact.account.name, contact.account.website, contact.account.BillingStreet, 
                                contact.account.BillingCity, contact.account.BillingState, contact.account.BillingPostalCode,
                                contact.account.BillingCountry, contact.account.ShippingStreet, 
                                contact.account.ShippingCity, contact.account.ShippingState, contact.account.ShippingPostalCode,
                                contact.account.ShippingCountry, recordtype.name, recordtype.developername, createdbyID 
                               FROM Case 
                               WHERE id = :ApexPages.currentPage().getParameters().get('id') limit 1]; //Added 11/12 6:59PM
            if(tmpCases.size() == 1){
                this.c = tmpCases[0];
                if(case__c.getAll().get(this.c.recordtype.developername) != null) {
                    caseRT = case__c.getAll().get(this.c.recordtype.developername).display_name__c;
                }
            }  
        }
        this.comment = new CaseComment();
        getComments();
        this.attachment = new attachment();
       
    }
   //End Constructor
    
    //Start Page Errors
    public integer numberOfErrors;
    public String typeError {get; set;}
    public String NameError {get; set;}
    public String emailError {get; set;}
    public String subjectError {get; set;}
    public String descriptionError {get; set;}
    
    public Boolean errorValidations(){//RETURNS TRUE IF PAGE HAS ERROR
        numberOfErrors = 0;//RUNNING COUNT OF PAGE ERRORS
        if(RecordTypeName.contains('Feedback') || RecordTypeName.contains('Outreach') || RecordTypeName.contains('Dispute')){
            if((c.SuppliedName == null || c.SuppliedName.trim() == '') && !loggedIn){
                NameError = 'Please provide your full name';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, NameError));
                numberOfErrors =+ 1;
            }
            if((c.SuppliedEmail == null || c.SuppliedEmail.trim() == '')  && !loggedIn) {
                emailError = 'Please provide a valid email address';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, emailError));
                numberOfErrors =+ 1;
            }
            if(c.type == null || c.type.trim() == ''){
                typeError = 'Please select an assistance / feedback type';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, typeError));
                numberOfErrors =+ 1;
            }
        }else{
            if(c.type == null || c.type.trim() == ''){
                typeError = 'Please select an assistance / feedback type';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, typeError));
                numberOfErrors =+ 1;
            }
        }
        if(c.subject == null || c.subject.trim() == ''){
            subjectError = 'Please provide a subject';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, subjectError));
            numberOfErrors =+ 1;
        }
        if(c.description == null || c.description.trim() == ''){
            descriptionError = 'Please provide a description';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, descriptionError));
            numberOfErrors =+ 1;
        }         
        if(numberOfErrors >= 1){
            return true;
        }else{
            return false;
        }
    }
    //End Page Errors
    
    public void changeFilter() {
        counter = 0;
        processRequests();
    }
    //Start page filter criteria
    public void processRequests()
    { 
        list_size = Integer.valueof(RecPerPage);
        if (filterId == 'My Company Cases') {
            results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                        'FROM Case '+
                                        'WHERE accountid = \''+ getAccountId() +'\'' +
                                        'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);  
            total_size = this.orgOpenCases.size(); //set the total size  
        } else if (filterId == 'Action Required') {
            results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                        'FROM Case '+
                                        'WHERE contactid = \''+ getContactId() + '\' and status = \'Action Required\' ' +
                                        'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);
            total_size = this.actionReqCases.size(); //set the total size   
        } else if (filterId == 'My Open Cases') {
            results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                        'FROM Case '+
                                        'WHERE contactid = \''+ getContactId() + '\' and status <> \'Successfully Closed\' ' +
                                        'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);                                
            total_size = this.openCases.size(); //set the total size  
        } 
        else if(filterId == 'My Closed Cases'){
            results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                        'FROM Case '+
                                        'WHERE contactid = \''+ getContactId() + '\' and status = \'Successfully Closed\' ' +
                                        'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);                                
            total_size = this.openCases.size(); //set the total size 
        }else{
            results = database.query('SELECT Id, CaseNumber, AccountId, Subject, Priority, Status, CreatedDate, ContactId, CreatedBy.Name, LastModifiedDate ' + 
                                        'FROM Case '+
                                        'WHERE contactid = \''+ getContactId() + '\' and status <> \'Successfully Closed\' ' +
                                        'order by ' + SortField +' '+ SortDirection + ' Limit ' + list_size + ' offset ' + counter);                                
            total_size = this.openCases.size(); //set the total size  
        }
        //return null;
    }
    
    //get the record types related to the case object, filter by Case__c custom setting
    public RecordType[] getRecordTypes(){
        String[] crt = new string[]{};
        
        //matches the case custom setting to the current site domain
        Case__c[] caseListMap = [select id, name, Display_Name__c from case__c where SiteDomain__c = :currentDomain.Domain__c order by sort_order__c asc nulls last limit 20]; 
        for(Case__c c : caseListMap){ 
                crt.add(c.name);
        } 
        
        RecordType[] output = new RecordType[]{};
        RecordType[] rts = [select id, developername, name, description from recordtype where sobjecttype = 'Case' and developername =:crt limit 20];
        
        for(case__c c : caseListMap){
            for(RecordType r : rts){
                if(r.developername == c.name){
                    if(c.Display_Name__c == null){
                        output.add(r);
                    }else{
                        r.name = c.Display_Name__c;
                        output.add(r);
                    }   
                }
            }
        }
        return output;
    }        
    
    public map<string, string> iconMap {get; set;}
    
    public map<integer, RecordType[]> getRecordTypes2(){
        this.iconMap = new map<string, string>();
        for(Case__c c : Case__c.getAll().values()){
                this.iconMap.put(c.name, c.icon__c);
        }      
        map<integer, RecordType[]> output = new map<integer, RecordType[]>();
        integer i = 0;
        for(RecordType rt : this.getRecordTypes()){
            if(output.get(i) == null)
                output.put(i, new RecordType[]{});
            if(output.get(i).size() < 3){
                output.get(i).add(rt);
            }else{
                i++;
                if(output.get(i) == null)
                    output.put(i, new RecordType[]{});
                output.get(i).add(rt);
            }
        }
        return output;
    }
    
    //Case Assistance Page Authentication
    //Case Assistance to set case recordtype 
    public pagereference SetRecordTypeId(){
        if(ApexPages.currentPage().getParameters().get('RecordTypeName').contains('Feedback') || ApexPages.currentPage().getParameters().get('RecordTypeName').contains('Outreach') || ApexPages.currentPage().getParameters().get('RecordTypeName').contains('Dispute')){
            this.recordtype = ApexPages.currentPage().getParameters().get('recordtypeid');
            this.casediv = ApexPages.currentPage().getParameters().get('casediv');
            this.RecordTypeName = ApexPages.currentPage().getParameters().get('RecordTypeName');
            caseSelected = '1';
            c = new case();
            c.status = 'New';          
            c.recordtypeID = recordtype;
            return null;
        }else if(UserInfo.getUserType() == 'Guest' || getContactId() == null){
            PageReference p = new PageReference('login?inst=t');   
            p.getParameters().put('UnAuth', '1');  
            p.getParameters().put('retURL', '/assistance');  
            p.setRedirect(true);
            return p;
        }else{
            this.recordtype = ApexPages.currentPage().getParameters().get('recordtypeid');
            this.casediv = ApexPages.currentPage().getParameters().get('casediv');
            this.RecordTypeName = ApexPages.currentPage().getParameters().get('RecordTypeName');
            caseSelected = '1';
            c = new case();
            c.status = 'New';
            c.recordtypeID = recordtype;
            this.c.contactid = this.getContactId();
            return null;
        }    
    }
    
    //External User submit a case
    public Pagereference save() {
        Group[] queue = [SELECT Id, developername, name FROM Group WHERE Type = 'Queue' and name = :currentDomain.Name LIMIT 1];
        //system.debug('!@@@'+errorValidations());
        if(!errorValidations()){
            try{
                /*if(RecordTypeName.contains('Feedback')){
                    if(queue.size() == 1)
                        this.c.ownerid = queue[0].id; //When creating a Queue for Website Feedback, the Queue name must match the Site Name e.g. StopFake
                }*/
                this.c.status = 'New';
                this.c.Origin = 'Web';
                this.c.recordtypeid = this.recordtype;
                this.c.site__c = currentDomain.id;
                insert this.c;
                PageReference caseRedirect;
                if(loggedIn){
                   caseRedirect = new PageReference('/apex/status?id='+ this.c.id);
                   caseRedirect.setRedirect(true);
                   return caseRedirect; 
                } else {
                    caseRedirect = new PageReference('/apex/assistance');
                   caseRedirect.setRedirect(true);
                   return caseRedirect;
                }    
            }catch(Exception e){
                Apexpages.AddMessages(e);
                return null;
            } 
        }
        return null;
    }
     public void psSave() {
        //Recordtype crt = [SELECT id, name, developername FROM recordtype WHERE sobjecttype ='Case' AND name = 'Privacy Shield' ];
        try{
            this.psC.status = 'New';
            this.psC.Origin = 'Web';
            this.psC.contactid = this.getContactId();
            this.psC.site__c = currentDomain.id;
            insert this.psC;
            Id crt = Schema.SObjectType.case.getRecordTypeInfosByName().get('Participation').getRecordTypeId();
            this.psC = new case(recordtypeid = crt, type = 'Application Issue'); 
        }catch(Exception e){
            system.debug(e);
            Apexpages.AddMessages(e);
        } 
    }
    
    //Directs to the /assistance page
    public PageReference NewCase() {
        PageReference pr = new PageReference('/apex/assistance');    
        pr.setRedirect(true);
        return pr;
    }
    
    //once an the assistance page and a recordtype is selected
    //the user can cancel their selection and start again
    public pageReference cancel() {
        PageReference cc= new PageReference('/apex/assistance');    
        cc.setRedirect(true);
        return cc;
    }

    //get the contact id of the current contact
    public id getContactId(){
        id conID = [SELECT contactid 
                FROM User
                WHERE id = :UserInfo.getUserId() limit 1].contactid;
        id userID = (id)ApexPages.currentPage().getParameters().get('runAs');//for development and testing
        if(conID != null){
            return conID;
        }else{
            return userId; 
        }
    }
    
    public id getAccountId(){
        return [SELECT accountid 
                FROM User 
                WHERE id = :UserInfo.getUserId() limit 1].accountid;   
    } 
    
    // Start Page Navigation
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      processRequests();
      return null;
    }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      processRequests();
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      processRequests();
      return null;
   }

   public PageReference End() { //user clicked end
      counter = total_size - math.mod(total_size, list_size);
      processRequests();
      return null;
   }

   public Boolean getDisablePrevious() { //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size < total_size) return false; else return true;
   }

    public Integer getTotal_size() {
      return total_size;
    }

    public Integer getPageNumber() {
       return counter/list_size + 1;
    }

    public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
    }
    //END Page Navigation
   public void getComments(){
        cmnts=[select Id,CreatedDate,IsPublished,CommentBody, CreatedByid, createdBy.name
               from CaseComment 
               where ParentId = :this.c.Id 
               AND isDeleted=false 
               And isPublished = true order by createdDate desc];  
       if(cmnts.size() < 1)
           caseHasComments = false;
       else
           caseHasComments = true;
       
        att = [SELECT id, createdDate, name, body, description, CreatedById 
               FROM Attachment 
               WHERE parentId = :this.c.Id
               AND isDeleted=false order by createdDate desc];
       if(att.size() < 1)
           caseHasAttachements = false;
       else
           caseHasAttachements = true;
    }
    
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; } return SortDirection;  }
        set;
    }
    
    //SortField - return sort by field. Default to Name
    public String SortField {
        get { if (SortField == null) {SortField = 'CaseNumber'; } return SortField;  }
        set; 
    }
    
    //SortToggle - toggles the sorting of query from asc<-->desc
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // run the query again
        processRequests();
    }
    //upload the cases and the attachments to a case 
    public PageReference upload() {
       if(attachment.body!=null && !(comment.commentbody.equals(null)||comment.commentbody.equals(''))){
           try{
               sobject[] commentAttachment = new sobject[]{};
               this.comment.parentid = this.c.id;
               this.comment.IsPublished = true; 
               
               this.attachment.OwnerId = UserInfo.getUserId();
               this.attachment.ParentId = this.c.id;
               PageReference ac = new PageReference('/apex/status?id='+c.Id);
               ac.setRedirect(true);
               
               commentAttachment.add(comment);
               commentAttachment.add(attachment);
               insert commentAttachment;
               return ac;
           }catch(Exception e){
                Apexpages.AddMessages(e);
           }
        }else if(attachment.body==null && !(comment.commentbody.equals(null)||comment.commentbody.equals(''))){
            try{
                this.comment.parentid = this.c.id;
                this.comment.IsPublished = true; 
                insert comment;
                PageReference ac = new PageReference('/apex/status?id='+c.Id);
                ac.setRedirect(true);
                return ac;
            }catch(Exception e){
                Apexpages.AddMessages(e);
            }
        }else if(attachment.body==null && (comment.commentbody.equals(null)||comment.commentbody.equals(''))){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'No comment or attachment has been added.'));
        }else{
            try{
                this.attachment.OwnerId = UserInfo.getUserId();
                this.attachment.ParentId = this.c.id;
                insert attachment;
                PageReference ac = new PageReference('/apex/status?id='+c.Id);
                ac.setRedirect(true);
                return ac;
            }catch(Exception e){
                Apexpages.AddMessages(e);
            }
        } return null;
    }
    
    public void toggleContent() {
        //If the showContent variable is 0, set it to 1, else, set it to 0
        showContent = showContent.equals('0') ? '1' : '0';
    }
    public void toggleAttachment() {
        //If the showAttachment variable is 0, set it to 1, else, set it to 0
        showAttachment = showAttachment.equals('0') ? '1' : '0';
    }
}