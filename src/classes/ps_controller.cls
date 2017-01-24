public without sharing class ps_controller {

    public boolean isNewParticipant {get; set;}

    public PageReference NewDRP() {
        this.DRP = new Third_Party__c();
        return null;
    }

    public PageReference useSelectedDRP() {
        //this method is currently only used to populate NonHR_Data records.
        //fixed to only allow a record to be selected once.
        system.debug('Participation:  '+this.participation);
        Boolean DRPAlreadyExists = false;
        for(Third_Party__c ExistingThirdParty : this.getResolutionProviders()){
            if(ApexPages.currentPage().getParameters().get('SelectedDRP') == ExistingThirdParty.Third_Party_Master_List__c){
                DRPAlreadyExists = true;
                this.DRP.Id = ExistingThirdParty.Id;
                break;
            }
        }
        this.DRP.name = ApexPages.currentPage().getParameters().get('SelectedDRPName');
        this.DRP.NonHR_Data__c = true;
        if(!DRPAlreadyExists){
            this.DRP.recordtypeId = this.DRPType;
            this.DRP.Participation_Status__c = this.participation.id;
            this.DRP.third_party_master_list__c = ApexPages.currentPage().getParameters().get('SelectedDRP');
        }
        showErrors = !SafeDMLHandler.safeUpsert(this.DRP, true);
        this.DRP = new Third_Party__c();
        return null;
    }

    public PageReference useSelectedVerifier() {
        this.Verifier.recordtypeId = this.VerifierType;
        this.Verifier.Participation_Status__c = this.participation.id;
        this.Verifier.third_party_master_list__c = ApexPages.currentPage().getParameters().get('SelectedVerifier');
        this.Verifier.name = ApexPages.currentPage().getParameters().get('SelectedVerifierName');
        showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
        this.Verifier = new Third_Party__c();
        return null;
    }

    public pageReference deleteDRP(){
        if(ApexPages.currentPage().getParameters().get('entityId') != null){
            for(Third_Party__c drp : this.getResolutionProviders()){
                if(drp.id == ApexPages.currentPage().getParameters().get('entityId')) {
                    showErrors = !SafeDMLHandler.safeDelete(drp, true); 
                }
            }

        }
        return null;
    }

    public pageReference deleteVerifier(){
        if(ApexPages.currentPage().getParameters().get('entityId') != null){
            for(Third_Party__c v : this.getVerifiers()){
                if(v.id == ApexPages.currentPage().getParameters().get('entityId')) {
                    showErrors = !SafeDMLHandler.safeDelete(v, true);
                }
            }
        }
        return null;
    }

    public pageReference deleteIndustry(){
        if(ApexPages.currentPage().getParameters().get('entityId') != null){
            for(Industry__c v : this.getIndustries()){
                if(v.id == ApexPages.currentPage().getParameters().get('entityId')) {
                    showErrors = !SafeDMLHandler.safeDelete(v, true);
                }
            }
        }
        return null;
    }

    public PageReference newArtifact() {
        this.artifact = new Artifact__c();

        //TODO remove PolicyEffectiveDate
        if(this.PolicyEffectiveDate == null){
            this.PolicyEffectiveDate = date.today();
        }
        //TODO remove PolicyEffectiveDateString
        this.PolicyEffectiveDateString = String.valueOf(this.PolicyEffectiveDate.Month()).leftPad(2).replaceAll(' ', '0')+'/'+string.ValueOf(this.PolicyEffectiveDate.Day()).leftPad(2).replaceAll(' ', '0')+'/'+this.PolicyEffectiveDate.Year();
        
        return null;
    }
    //for psTest page
    public pageReference addArtifact() {
        artifactList.add(new Artifact__c());
        return null;
    }

    public void getPolicyFromList() {
        system.debug(selectedPolicy);
        //if(this.artifact == null)
            //this.artifact = new Artifact__c();
            system.debug(ApexPages.currentPage().getParameters().get('selectedPolicy'));
        if(ApexPages.currentPage().getParameters().get('selectedPolicy') != null){
            for(Artifact__c ar : this.artifactList){
                if(ApexPages.currentPage().getParameters().get('selectedPolicy') == ar.id){

                    this.artifact = ar;                    
                    break;
                }
            }
        }
        system.debug(this.artifact);
    }

    public Boolean getDoesPrivacyPolicyExist(){    //Check if the user has uploaded a privacy document. DK 8/22/16.
        artifactList = getArtifacts();  //requery
        Boolean boolResult = false;
        boolean hasHRArtifact = false;
        boolean hasNonHRArtifact = false;
        //if (artifactList != null && !artifactList.isEmpty()){
        for(artifact__c art : artifactList){
            if(this.participation.hr_data__c){
                if(art.type__c == 'HR' || art.type__c == 'HR and Non-HR'){
                    hasHRArtifact = true;
                }
            }
            if(this.participation.non_hr_data__c){
                if(art.type__c == 'Non-HR' || art.type__c == 'HR and Non-HR'){
                    hasNonHRArtifact = true;
                }            
            }
//  removed check to ensure at least 1 was uploaded.            boolResult = true;
        }
        //HR, but Not NonHR
        if(this.participation.HR_Data__c && !this.participation.Non_HR_Data__c && hasHRArtifact){ 
            boolResult = true;
        }
        //Not HR, but NonHR
        if(!this.participation.HR_Data__c && this.participation.Non_HR_Data__c && hasNonHRArtifact){ 
            boolResult = true;
        }
        //HR AND NonHR
        if(this.participation.HR_Data__c && this.participation.Non_HR_Data__c && hasHRArtifact && hasNonHRArtifact){ 
            boolResult = true;
        }
        //FINAL SCENARIO OF NOT NONHR AND NOT HR SHOULD NEVER HAPPEN PRIOR TO THIS STEP
        return boolResult;
    }

    public Participant_Contact__c[] contacts {get; set;}
    public Participant_Contact__c contact {get; set;}

    public pageReference deleteContact(){
        this.getContactFromList();
        if(this.contact.id != null){
            //there is a contact to delete
            try{
                delete this.contact;
                this.contact = new Participant_Contact__c();
                this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
                    FROM Participant_Contact__c WHERE Participant__c = :this.participant.id
                ];
            }catch(Exception e){
                system.debug(e);
            }
        }
        return null;
    }

    public pageReference saveContact(){
        system.debug('SaveContact');
        system.debug(this.contact);
        if(this.contact.role__c == 'Organization Corporate Officer'){
            system.debug('Corporate Officer Logic');
            Participant_Contact__c[] cs = [SELECT id, role__c FROM participant_contact__c WHERE Participant__c = :this.participant.id AND role__c = 'Organization Corporate Officer' AND id != :this.contact.id];
            system.debug('Exissting Corporate Officers:  '+cs.size());
            for(participant_contact__c c : cs){
                c.role__c = 'Organization Contact';
            }
            if(contacts.size() != 0) {
                showErrors = !SafeDMLHandler.safeUpdate(cs, true);
            }
        }
        system.debug(this.contact);
        this.isNewParticipant = false;
        system.debug(this.isNewParticipant);
        showErrors = !SafeDMLHandler.safeUpsert(this.contact, true);
        this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
            FROM Participant_Contact__c WHERE Participant__c = :this.participant.id
        ];
        return null;
    }

    public void getContactFromList(){
        if(ApexPages.currentPage().getParameters().get('contactId') != null){
            system.debug(ApexPages.currentPage().getParameters().get('contactId'));
            for(Participant_Contact__c c : this.contacts){
                if(c.id == ApexPages.currentPage().getParameters().get('contactid')){
                    this.contact = c;
                    break;
                }
            }
        }
    }

    public PageReference createContact() {
        this.contact = new Participant_Contact__c();
        this.contact.Participant__c = this.participant.id;
        //@@TODO:  remove the default value.  this.contact.role__c = 'Organization Contact';
        return null;
    }

    public static string getHRDRPRecordTypeId(){
        return [select id from recordType where sObjectType = 'Third_Party__c' and developername ='Resolution_Provider' limit 1].id;
    }

    public pageReference processHRCompliance(){
        system.debug('Entering ProcessHRCompliance');
        system.debug('Participation Confirming HR Compliance: '+this.participation.Confirm_HR_Compliance__c);
        Third_Party_Master_List__c[] HRThirdPartyMasterList = [select id, name from third_party_master_list__c where HR_Data__c = true and type__c = 'Dispute Resolution Provider' limit 1];
        Third_Party__c HRComplianceThirdParty = new Third_Party__c();
        Boolean AlreadyExists = false;
        if(this.participation.Confirm_HR_Compliance__c){
            try{            
                for(Third_Party__c ExistingThirdParty : this.getResolutionProviders()){
                    if(ExistingThirdParty.HR_Data__c == true){
                        //this record already exists so we should just exit out.
                        return null;             
                    }
                    if(ExistingThirdParty.third_party_master_list__c == HRThirdPartyMasterList[0].id){
                        AlreadyExists = true;
                        HRComplianceThirdParty = ExistingThirdParty;
                        HRComplianceThirdParty.HR_Data__c = true;
                        break;
                    }
                }
                if(!AlreadyExists){
                    HRComplianceThirdParty.HR_Data__c = true;
                    HRComplianceThirdParty.recordtypeid = getHRDRPRecordTypeId();
                    HRComplianceThirdParty.name = HRThirdPartyMasterList[0].name; 
                    HRComplianceThirdParty.third_party_master_list__c = HRThirdPartyMasterList[0].id; 
                    HRComplianceThirdParty.Participation_Status__c = this.participation.id; 
                }
                try{
                    system.debug('attempting to insert');
                    system.debug(HRComplianceThirdParty);
                    this.showErrors = !SafeDMLHandler.safeUpsert(HRComplianceThirdParty, true);
                }catch(Exception e){
                    system.debug(e);
                }
            }catch(exception e){
                system.debug(e);
            }
        }else{
            Third_Party__c DeletableThirdParty = new Third_Party__c();
            for(Third_Party__c ExistingThirdParty : this.getResolutionProviders()){
                if(ExistingThirdParty.HR_Data__c == true){
                    HRComplianceThirdParty = ExistingThirdParty;
                    HRComplianceThirdParty.HR_Data__c = false;
                    if(HRComplianceThirdParty.NonHR_Data__c != true){
                        DeletableThirdParty = HRComplianceThirdParty;
                    }
                    AlreadyExists = true;
                    break;
                }
            }
            if(DeletableThirdParty.id != null){
                try{
                    delete DeletableThirdParty;
                }catch(Exception e){
                    system.debug(e);
                }
            }
            try{
                this.showErrors = !SafeDMLHandler.safeUpdate(HRComplianceThirdParty, true);
            }catch(exception e){
                system.debug(e);
            }
        }
        return null;
    }


    public pageReference saveParticipation(){
        system.debug('Before: '+this.participation.claiming_self_verified__c);
        if(!this.participation.HR_Data__c){
            this.participation.Confirm_HR_Compliance__c = false;
        }
        processHRCompliance();
        showErrors = !SafeDMLHandler.safeUpdate(this.participation, true);
        return null;   
    }
    
    public third_party_master_list__c[] getAvailableStatutoryBodies() {
        return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'U.S. Statutory Body'];
    }

    public Third_Party_Master_List__c[] getAvailable_Verifiers(){
        return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'Verification Provider'];
    }

    public Third_Party_Master_List__c[] getAvailable_DRPs(){
        return [SELECT id, name FROM third_party_master_list__c WHERE type__c = 'Dispute Resolution Provider' and NonHR_Data__c = true]; //only display the NonHR DRPs
    }

    public third_party__c Verifier {get; set;}

    public Boolean DRPIsDisplayed {get; set;}
    
    public PageReference displayDRP(){
        this.DRPIsDisplayed = true;
        return null;
    }
    
    public PageReference hideDRP(){
        this.DRPIsDisplayed = false;
        return null;
    }

    public third_party__c DRP {get; set;}

    public pageReference saveDRP(){
        system.debug('DRP ' + this.participation);
        this.DRP.recordtypeId = this.DRPType;
        this.DRP.NonHR_Data__c = true;
        this.DRP.Participation_Status__c = this.participation.id;
        showErrors = !SafeDMLHandler.safeUpsert(this.DRP, true);
        this.DRP = new Third_Party__c();
        return null;
    }
    
    public pageReference saveVerifier(){
        this.Verifier.recordtypeId = this.VerifierType;
        this.Verifier.Participation_Status__c = this.participation.id;
        showErrors = !SafeDMLHandler.safeUpsert(this.Verifier, true);
        this.Verifier = new Third_Party__c();
        return null;
    }
    
    public Third_Party__c[] getResolutionProviders(){
        if(this.participation == null || this.participation.id == null)
            return new third_party__c[]{};
        return [SELECT id, name, website__c, NonHR_Data__c, HR_Data__c, Third_Party_Master_List__c FROM third_party__c WHERE RecordType.DeveloperName = 'Resolution_Provider' /*AND NonHR_Data__c = true */ AND Participation_Status__c = :this.participation.id];
    }

    public Third_Party__c[] getVerifiers(){
        if(this.participation == null || this.participation.id == null)
            return new third_party__c[]{};
        return [SELECT id, name, website__c FROM third_party__c WHERE RecordType.DeveloperName = 'Verification' AND Participation_Status__c = :this.participation.id];
    }

    public pageReference setStatutoryBody(){
        showErrors = !SafeDMLHandler.safeDelete([SELECT id FROM third_party__c WHERE participation_status__c = :this.participation.id AND RecordType.DeveloperName = 'Statutory_Body'], true);
        Third_Party__c stat = new Third_Party__c();
            stat.recordTypeId = [SELECT id FROM RecordType WHERE sObjectType = 'Third_Party__c' AND DeveloperName = 'Statutory_Body' LIMIT 1].id;
            stat.name = ApexPages.currentPage().getParameters().get('statBodyName');
            stat.participation_status__c = this.participation.id;
            stat.third_party_master_list__c = ApexPages.currentPage().getParameters().get('statBodyId');
        showErrors = !SafeDMLHandler.safeInsert(stat, true);
        return null;
    }
    
    public Id getStatutoryBodyId(){
        if(this.participation != null && this.participation.id != null){
            third_party__c[] sb = [SELECT third_party_master_list__c FROM third_party__c WHERE participation_status__c = :this.participation.id AND recordtype.DeveloperName = 'Statutory_Body' LIMIT 1];
            if(sb.size() == 1){
                return sb[0].third_party_master_list__c;
            }
        }
        return null;
    }
    

    public pageReference save(){
        showErrors = !SafeDMLHandler.safeUpdate(this.participant, true);
        this.participation = [SELECT id, name, opportunity__c, order__c, framework__r.program__c, status__c, application_stage__c, hr_data__c, non_hr_data__c, purpose__c, Confirm_HR_Compliance__c, Privacy_Programs__c, Claiming_Self_Verified__c FROM Participant__c WHERE Participant__c = :this.participant.id AND framework__c = :ApexPages.CurrentPage().getParameters().get('framework') LIMIT 1];
        system.debug(this.participation);
        this.artifactList = getArtifacts();
        return null;
    }

    public PageReference start() {
        showErrors = !SafeDMLHandler.safeUpsert(this.participant, true);

        if(this.contacts == null){
            this.contacts = new List<Participant_Contact__c>();
        }

        if(this.contacts.size() != 0){
            for(Participant_Contact__c c : this.contacts){
                if(c.Contact__c == this.u.contactid){
                    this.contact = c;
                    break;
                }
            }
        }else{
            //TODO -- build a constructor method to build a contact from a user (reduce to 1 DML)
            this.contact = new Participant_Contact__c();
            this.contact.First_Name__c = this.u.firstname;
            this.contact.Last_Name__c = this.u.lastname;
            this.contact.Email__c = this.u.email;
            this.contact.Phone__c = this.u.phone;
            this.contact.Fax__c = this.u.fax;
            this.contact.Participant__c = this.participant.id;
            this.contact.Role__c = 'Portal Administrator';
            this.contact.Contact__c = this.u.ContactId;
            showErrors = !SafeDMLHandler.safeInsert(this.contact, true);
            
            this.contact = new Participant_Contact__c();
            this.contact.First_Name__c = this.u.firstname;
            this.contact.Last_Name__c = this.u.lastname;
            this.contact.Email__c = this.u.email;
            this.contact.Phone__c = this.u.phone;
            this.contact.Fax__c = this.u.fax;
            this.contact.Participant__c = this.participant.id;
            this.contact.Role__c = 'Organization Contact';
            this.contact.Contact__c = this.u.ContactId;
            showErrors = !SafeDMLHandler.safeInsert(this.contact, true);
        }
        
        this.participation = new Participant__c();
        Participant__c[] participations = [SELECT id, name, status__c, opportunity__c, order__c, framework__r.program__c, application_stage__c, hr_data__c, non_hr_data__c, purpose__c, Confirm_HR_Compliance__c, Privacy_Programs__c, Claiming_Self_Verified__c FROM Participant__c WHERE Participant__c = :this.participant.id AND framework__c = :ApexPages.CurrentPage().getParameters().get('framework') LIMIT 1];
        system.debug(participations.size());
        if(participations.size() == 1){
            this.participation = participations[0];
            system.debug(this.participation);
            if(this.participation.application_stage__c == 'Finalized')
                this.participation.application_stage__c = 'Updated';        
        }else{
            this.participation.Participant__c = this.participant.id;
            this.participation.framework__c = ApexPages.CurrentPage().getParameters().get('framework');
            this.participation.status__c = 'Pending';
            this.participation.application_stage__c = 'New';
        }
        showErrors = !SafeDMLHandler.safeUpsert(this.participation, true); 
        //TODO clean up SOQLs below to prevent ""System.QueryException: List has no rows for assignment to SObject"
        List<Participant__c> partList = [SELECT id, name, status__c, opportunity__c, order__c, application_stage__c, hr_data__c, non_hr_data__c, purpose__c, 
            Confirm_HR_Compliance__c, Privacy_Programs__c, framework__c, framework__r.program__c, Claiming_Self_Verified__c 
            FROM Participant__c WHERE Participant__c = :this.participant.id AND framework__c 
            = :ApexPages.CurrentPage().getParameters().get('framework') LIMIT 1];
        if(partList.size() > 0) {
            this.participation = partList[0];    
            this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
            FROM Participant_Contact__c WHERE Participant__c = :this.participant.id];
        } else {
            ExceptionHandler.addErrorMessageToPage('Unable to find the requested framework.');
            showErrors = true;
        }
        system.debug('CONTACT:  '+this.contact);
        return null;
    }

public covered_entity__c entity {get; set;}
public covered_entity__c[] entities {get; set;}

public pageReference deleteEntity(){
    system.debug('deleting');
    if(ApexPages.currentPage().getParameters().get('entityId') != null){
        system.debug(ApexPages.currentPage().getParameters().get('entityId'));
        for(Covered_Entity__c ent : this.entities){
            if(ent.id == ApexPages.currentPage().getParameters().get('entityId'))
                showErrors = !SafeDMLHandler.safeDelete(ent, true);
        }
    }
    this.entities = [SELECT id, name FROM covered_entity__c WHERE Participant__c = :this.participant.id];
    return null;
}

public pageReference addEntity(){
    if(this.entity.name != null && this.entity.name.trim() != ''){
        if(this.entity.Participant__c == null)
            this.entity.Participant__c = this.participant.id;
        showErrors = !SafeDMLHandler.safeInsert(this.entity, true); 
        this.entities.add(this.entity);
    }
    this.entity = new Covered_Entity__c();
        this.entity.Participant__c = this.participant.id;
    return null;
}

public pageReference saveIndustry(){
    system.debug('Save Industry');
    this.industry.Participant__c = this.participant.id;
    showErrors = !SafeDMLHandler.safeUpsert(this.industry, true);
    system.debug('Industry: '+this.industry.id);
    this.industry = new industry__c();
    this.industry.Participant__c = this.participant.id;
    return null;
}

public Industry__c industry {get; set;}

public Industry__c[] getIndustries(){
    if(this.participant.id != null)
        return [SELECT id, industry__c, sector__c, sub_sector__c FROM industry__c WHERE Participant__c = :this.participant.id ORDER BY Industry__c ASC];
    return new Industry__c[]{};
}

public pageReference selectIndustry(){
    if(ApexPages.currentPage().getParameters().get('industryId') != null){
        for(Industry__c ind : this.getIndustries()){
            if(ind.id == ApexPages.currentPage().getParameters().get('industryId')){
                this.industry = ind;
                break;
            }
        }
    }
    return null;
}

public pageReference doNothing(){ return null;}

public Participation__c participant {get; set;}
public Participant__c participation {get; set;}
public Account account {get; set;}
public User u {get; set;}
public boolean showErrors {get; set;}

public artifact__c[] artifactList {get; set;}

public Artifact__c[] getArtifacts(){
    Artifact__c[] output = new Artifact__c[]{};
    if(this.participation != null && this.participation.id != null)
        output = [SELECT id, name, Participation_Number__c, isCurrent__c, Effective_Date__c, Description__c, External_Artifact_URL__c, Type__c,
                  (SELECT id, createdDate, name, description, CreatedById, ParentId 
                    FROM Attachments
                  WHERE isDeleted=false ORDER BY createdDate desc LIMIT 1)
                  FROM Artifact__c 
                  WHERE participation_number__c = :this.participation.id];
    this.artifactList = output;
    return output;
}
public String selectedPolicy {get; set;}

public Artifact__c artifact {
    get {
        if(this.artifact.effective_date__c != null){
            this.PolicyEffectiveDate = this.artifact.effective_date__c;
        }else{
            this.PolicyEffectiveDate = date.today();
        }
        this.PolicyEffectiveDateString = String.valueOf(this.PolicyEffectiveDate.Month()).leftPad(2).replaceAll(' ', '0')+'/'+string.ValueOf(this.PolicyEffectiveDate.Day()).leftPad(2).replaceAll(' ', '0')+'/'+this.PolicyEffectiveDate.Year();
        return this.artifact;
    } 
    set { 
        system.debug(artifact); artifact = value; 
    }
}

public pageReference saveArtifact(){
    if(this.artifact.id == null)
        this.artifact.participation_number__c = this.participation.id;
//    system.debug('Date String: '+PolicyEffectiveDateString);
//    this.artifact.effective_date__c = PolicyEffectiveDateString != null ? Date.parse(PolicyEffectiveDateString) : date.today();
    system.debug('Artifact:  '+this.artifact);
    showErrors = !SafeDMLHandler.safeUpsert(this.artifact, true);
    system.debug(showErrors);
    return null;
}

public Document attachment {get; set;}

public PageReference RedirectToErrorPage(){
    system.debug('Check Redirect');
    if(this.account.Privacy_Shield_Disabled__c == true){
        system.debug('Privacy_Shield_Disabled');
        PageReference oops = new PageReference('/apex/pageforbidden');
        oops.setRedirect(true);
        return oops;
    }
    return null;
}

public order[] orders {get; set;}

public ps_controller(){
    this.orders = new order[]{};
    this.showErrors = false;  
    if(ApexPages.CurrentPage().getParameters().get('framework') == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please contact the Site Administrator'));
        this.showErrors = true;
    }else{
        Id userId = UserInfo.getUserId();
        this.u = [SELECT id, contactid, contact.accountid, firstname, lastname, email, phone, fax FROM User WHERE id = :userId LIMIT 1];
        //TODO - update to handle "System.QueryException: List has no rows for assignment to SObject"
        this.account = [SELECT 
            id, name, billingcity, billingstatecode, billingstate, 
            billingstreet, billingpostalcode, Privacy_Shield_Disabled__c,
            (SELECT id, name, city__c, street__c, state__c, postal_code__c, public_display_name__c, level_of_sales__c, number_of_employees__c FROM Participations__r ORDER BY createddate desc LIMIT 1) 
            FROM account WHERE id = :this.u.contact.accountid LIMIT 1];
        this.RedirectToErrorPage();
        if(this.account.Participations__r.size() != 0){
            this.participant = this.account.participations__r[0];
            this.orders = [select 
                            id, ordernumber, TotalAmount, order.status, effectivedate, participation__c, accountid, createddate,
                            (select id, Pricebookentry.Product2.Name from orderitems),
                            (select Transaction_Date__c, Pay_Gov_Tracking_Id__c, Transaction_Amount__c, Transaction_Status__c, Total_Refunds__c 
                             FROM Payments__r)
                             from order where order_paid__c = true and participant__c = :this.participant.id];
        }else{ 
            this.participant = new Participation__c();
            this.participant.organization__c = this.account.id;
            this.participant.name = this.account.name;
            this.participant.public_display_name__c = this.account.name;
            this.participant.city__c = this.account.billingcity;
            this.participant.street__c = this.account.billingstreet;            
            this.participant.state__c = this.account.billingstate; 
            this.participant.postal_code__c = this.account.billingpostalcode;            
        }
        
    }
    this.contacts = [SELECT id, first_name__c, last_name__c, email__c, Contact_Office__c, phone__c, role__c, Contact__c, fax__c, title__c
        FROM Participant_Contact__c WHERE Participant__c = :this.participant.id
    ];

    this.industry = new Industry__c(); 
        this.industry.Participant__c = this.participant.id;
    this.entity = new Covered_Entity__c();
        this.entity.Participant__c = this.participant.id;
    this.entities = [SELECT id, name FROM covered_entity__c WHERE Participant__c = :this.participant.id];
    this.artifact = new Artifact__c();
    this.attachment = new Document();
    this.DRP = new third_party__c();
    this.Verifier = new third_party__c();
    for(RecordType rt : [SELECT id, DeveloperName, name FROM RecordType WHERE DeveloperName in ('Verification', 'Resolution_Provider')]){ //TODO refactor to use schema AND use the API names
        if(rt.DeveloperName == 'Resolution_Provider')
            this.DRPType = rt.id;
        if(rt.DeveloperName == 'Verification')
            this.VerifierType = rt.id;    
    }
        if(this.participant.id == null){
            this.isNewParticipant = true;
        }
        system.debug(this.isNewParticipant);
    }
    
    public Id VerifierType {get; set;}
    public Id DRPType {get; set;}

    public boolean getHasContacts(){
        boolean output = false;
            boolean hasCO = false;
            boolean hasPC = false;
        for(Participant_Contact__c pc : this.contacts){
            if(pc.role__c == 'Organization Contact')
                hasPC = true;
            if(pc.role__c == 'Organization Corporate Officer')
                hasCO = true;
        }
        if(hasPC && hasCO)
            output = true;
        return output;
    }

//START PAYMENT METHODS AND VARIABLES
    public Opportunity opportunity {get; set;}
    public Order order {get; set;}
    public String amount {get;set;}
    public String agencyTrackingId {get;set;}
    public boolean paymentCancelled {get;set;}
    private static final String PRIVACY_SHIELD_APP_ID = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP_ID').value__c;  
    private static final String EVENTS_SERVICES_APP_ID = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP_ID').value__c;  
    private static final String PRIVACY_SHIELD_APP = PaymentSettings__c.getAll().get('PRIVACY_SHIELD_APP').value__c;  
    private static final String EVENTS_SERVICES_APP = PaymentSettings__c.getAll().get('EVENTS_SERVICES_APP').value__c;

    public PageReference privacyShieldPayment() {
        if (agencyTrackingId != null && ! agencyTrackingId.trim().equals('')) {
                return payment(PRIVACY_SHIELD_APP_ID, PRIVACY_SHIELD_APP);
        } else {
                //ERROR -- Agency Tracking Id must be populated first
                return null;
        }
    }
    
    public void CheckOpportunity(){
        if(this.participation.order__c == null){
            this.order = new Order();
                this.order.accountid = this.account.id;
                this.order.pricebook2id = [SELECT id FROM pricebook2 WHERE program__c = :this.participation.framework__r.program__c LIMIT 1].id;
                this.order.EffectiveDate = Date.today().addDays(1);
                this.order.participant__c = this.participant.id;
                this.order.participation__c = this.participation.id;
                this.order.Status = 'Draft';
            showErrors = !SafeDMLHandler.safeInsert(this.order, true);
            this.participation.order__c = this.order.id;
            showErrors = !SafeDMLHandler.safeUpdate(this.participation, true); 
        }
        OrderItem[] items = new OrderItem[]{};
        this.order = [SELECT Id, Name, EffectiveDate, TotalAmount, Pricebook2Id, (SELECT id, pricebookentryid, unitprice FROM orderitems), (SELECT id, name, Order__c FROM payments__r WHERE Transaction_Status__c = '' ORDER BY createddate desc) FROM order WHERE id = :this.participation.order__c LIMIT 1];        

        system.debug(this.participant.level_of_sales__c);
        system.debug(this.order.pricebook2Id);
        for(PricebookEntry pbe : [SELECT id, product2Id, unitprice FROM PricebookEntry WHERE Pricebook2Id = :this.order.pricebook2Id AND isActive = true AND product2.Family = 'Certification' ]){
            system.debug(pbe.unitprice);
            if(this.order.OrderItems != null  && this.order.OrderItems.size() != 0){
                for(OrderItem oi : this.order.orderitems){
                    if(oi.pricebookentryid == pbe.id){
                        //Update the price to reflect the Level of Sales)
                        if(CertificationPricePoints__c.getAll().get(this.participant.level_of_sales__c) != null){
                            oi.unitprice = CertificationPricePoints__c.getAll().get(this.participant.level_of_sales__c).price__c;
                            items.add(oi);
                        } 
                    }
                }
            }else{
                if(CertificationPricePoints__c.getAll().get(this.participant.level_of_sales__c) != null){
                    items.add(new OrderItem(orderId = this.order.id, pricebookentryid = pbe.id, quantity = 1, serviceDate = this.Order.EffectiveDate, unitprice = CertificationPricePoints__c.getAll().get(this.participant.level_of_sales__c).price__c));
                } else {
                    items.add(new OrderItem(orderId = this.order.id, pricebookentryid = pbe.id, quantity = 1, serviceDate = this.Order.EffectiveDate, unitprice = pbe.unitprice));
                }
            }
        }
        showErrors = !SafeDMLHandler.safeUpsert(items, true);
        
        this.order = [SELECT id, name, totalamount, pricebook2Id, (SELECT id, pricebookentryid, unitprice FROM orderitems), (SELECT id, name FROM payments__r WHERE Transaction_Status__c = '' ORDER BY createddate desc) FROM order WHERE id = :this.participation.order__c LIMIT 1];        

        if(this.order.payments__r.size() != 0){
            this.agencyTrackingId = this.order.payments__r[0].name;
        }
        this.amount = string.valueOf(this.order.totalamount);
    }
    
    @TestVisible private String getBaseUrl() {
        return 'https://' + ApexPages.currentPage().getHeaders().get('Host');
    }

    public PageReference getAgencyTrackingId() {
        checkOpportunity(); //check the opportunity for most current amount
        if (String.isNotEmpty(this.agencyTrackingId)) {
            Payment payment = new Payment();
            agencyTrackingId = payment.getAgencyTrackingId(this.agencyTrackingId, this.order.id);
            return null;
        } else {
            //Get a tracking id
            Payment payment = new Payment();
            agencyTrackingId = payment.getAgencyTrackingId(this.order.id);
            return null;
        }
    }
    
    public Date PolicyEffectiveDate {get; set;}
    public String PolicyEffectiveDateString {get; set;}
    
    private PageReference payment(String tcs_app_id, String application) {
        Payment payment = new Payment();
        String transaction_type = 'Sale';
        String url_success = getBaseUrl() + '/apex/PaymentConfirmation?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.id;
        System.debug('url_success = ' + url_success);
        String url_cancel = getBaseUrl() + '/apex/Payment?id=' + agencyTrackingId + '&app=' + application+'&opp='+this.order.id;
        System.debug('Amount = ' + amount);
        System.debug('Agency Tracking Id = ' + agencyTrackingId);
        String token = payment.getToken(agencyTrackingId, tcs_app_id, transaction_type, amount, url_success, url_cancel );
        System.debug('Pay.gov token = ' + token);
        
        //Redirect to Pay.gov
        PageReference pageRef = payment.redirectToPayGov(token, tcs_app_id);
        pageRef.setRedirect(true);
        return pageRef;
    }
//END PAYMENT METHODS AND VARIABLES
}