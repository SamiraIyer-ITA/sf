public without sharing class tradeRegistration_Controller {
    public integer page {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public Account a {get; set;}
    public Contact c {get; set;}
    public id logo {get; set;}
    Public Profile p = [SELECT id 
                         FROM profile 
                         WHERE name = 'Customer Trade Community User'];
    Public string webSite{get; set;} 
    
    //Start Constructor
    public tradeRegistration_Controller() {
        page = 0;  
        a = new account();
        c = new contact();
        a.Account_Type__c = 'Business'; //SET REGISTRATION TYPE TO "BUSINESS"
        //REGISTRATION PAGE LOGO
        logo = [SELECT ID 
               FROM Document
               Where DeveloperName = 'logo_jpg'].id;
        
        site__c CurrentSite = [SELECT NAME, title__c, Site_CSS__c, site_logo__c,slogan__c
               FROM site__c
               WHERE domain__c = :URL.getSalesforceBaseUrl().getHost() 
                or UseAsDefault__c = true 
                order by UseAsDefault__c asc limit 1];
        webSite = currentSite.Name;
    }
    //End Constructor
    //Start Page Errors
    public String emailError {get; set;}
    public String emailFormatError {get; set;}
    public String firstNameError {get; set;}
    public String lastNameError {get; set;}
    public String accountTypeError {get; set;}
    public String accountNameError {get; set;}
    public String streetError {get; set;}
    public String stateError {get; set;}
    public String cityError {get; set;}
    public String countryError {get; set;}
    public String zipcodeError {get; set;}
    public String zipcodeValidationError {get; set;}
    public String loginError {get; set;}
    public integer numberOfErrors;
    
    public Boolean errorValidations(){//RETURNS TRUE IF PAGE HAS ERROR
        numberOfErrors = 0;//RUNNING COUNT OF PAGE ERRORS
        if((c.firstName == null || c.firstName.trim() == '')&& page == 2){
            firstNameError = 'Please provide your first name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, firstNameError));
            numberOfErrors =+ 1;
        }
        if((c.lastName == null || c.lastName.trim() == '')&& page == 2){
            lastNameError = 'Please provide your last name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,lastNameError));
            numberOfErrors =+ 1;
        }
        if(a.Account_Type__c == null && page == 2){
            accountTypeError = 'Please indicate your customer type';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,accountTypeError));
            numberOfErrors =+ 1;
        }
        if(a.Account_Type__c == 'Business' && (a.Name == null || a.Name.trim() == '' )&& page == 2){
            accountNameError = 'Please provide your company name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,accountNameError));
            numberOfErrors =+ 1;
        }
        if((a.BillingStreet == null || a.BillingStreet.trim() == '')&& page == 2){
            streetError = 'Please provide your street address';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,streetError));
            numberOfErrors =+ 1;
        }
        if((a.BillingCity == null || a.BillingCity.trim() == '')&& page == 2){
            cityError = 'Please enter your city';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,cityError));
            numberOfErrors =+ 1;
        }          
        if((a.BillingCountrycode == null || a.BillingCountrycode == '')&& page == 2){
            countryError = 'Please select your country';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,countryError));
            numberOfErrors =+ 1;
        }   
        if((a.BillingStateCode== null || a.BillingStateCode == '')&& page == 2 && a.BillingCountryCode == 'US'){
            stateError = 'Please select your state';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,stateError));
            numberOfErrors =+ 1;
        }
        if((a.BillingPostalCode== null || a.BillingPostalCode == '')&& page == 2 && a.BillingCountryCode == 'US'){
            zipcodeError = 'Please provide your postal or zip code';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,zipcodeError));
            numberOfErrors =+ 1;
        }else if((!pattern.matches('^[0-9]{5}(-[0-9]{4})?$', a.BillingPostalCode.trim()))&& a.BillingCountryCode == 'US'){
                zipcodeValidationError = 'Please provide a valid postal code';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,zipcodeValidationError));
                numberOfErrors =+ 1;
        }
        if(numberOfErrors >= 1){
            return true;
        }else{
            return false;
        }
    }
    //END PAGE ERRORS
    //GETS EXISTING CONTACT
    public Contact[] existingContact(){
        //email = this.c.email;
        if(this.c.email == null || this.c.email.trim() == ''){//Check if email is null
            emailError = 'Please enter your email address';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,emailError));
        }else if(!pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', this.c.Email)){//Check that email matches email format
            emailFormatError = 'Please enter a valid email address';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,emailFormatError));
        }else if(this.c.email.indexOf('trade.gov')!= -1){
            emailError = 'Email cannot be an ITA Contact';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,emailError));
            numberOfErrors =+ 1;
        }else{//If email is not null and matches pattern query exisiting contact
            return [SELECT ID, firstname, lastname, email, accountid
                    FROM contact
                    WHERE email = :c.email AND Owner.UserRoleId != null AND Account.Owner.UserRoleId != null
                    LIMIT 1];   
        }
        return new Contact[]{};//return contacts if one exists or a blank list if no contact exists 
    }     


    public List<User> existingUser() {
        id tradeProfile = [SELECT ID
                          FROM profile
                          WHERE name = 'Customer Trade Community User'].id;
        system.debug(this.c.email);
        User[] activeUser = [SELECT ID, IsActive, email 
                                 FROM User
                                 WHERE (email = :this.c.Email or username =:this.c.Email) AND Profileid = :tradeProfile 
                                 LIMIT 1];
     return activeUser;
    }
    //CHECKS IF CONTACT HAS ACTIVE ACCOUNT
    boolean error = false;
    public PageReference checkUser() { 
        error = false;
        List<User> activeUser = existingUser();
        //user exists, but not contact
        if(activeUser.size() > 0) {
            if(activeUser.size() >= 1){ //a user already exists
                //user and contact exist
                if(activeUser[0].isActive == true){
                    loginError = c.email +' is already registered';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,loginError));
                    error = true;
                    return null;
                }else{
                    activeUser[0].IsActive = true;
                    activeUser[0].email = this.c.Email;
                    activeUser[0].username = this.c.Email;
                    update activeUser[0];
                    //page = 1;
                    PageReference confirmation = new PageReference('/apex/RegistrationConfirmation');
                    confirmation.setRedirect(false);
                    return confirmation;  
                }
            }else{ 
                //no user exists, so create a new user
                //contact exists, but not user
                PageReference confirmation = new PageReference('/apex/RegistrationConfirmation');
                confirmation.setRedirect(false);
                return confirmation;
            }
        }else if(pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', this.c.Email) && this.c.email.indexOf('trade.gov')== -1) {//if no contact exists, email is not ITA contact, and email matches email format
            page = 2;
            return null;
        } else if (this.c.email.indexOf('trade.gov') != -1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email cannot be an ITA Contact'));
            return null;
        }else{//if no contact, and email does not match email format, throw message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid email address'));
            return null;
        }
    }
    
    //CREATE NEW CONTACT 
    public PageReference newContact(){
        Savepoint sp = Database.setSavepoint();
        try {
            checkUser(); //validates the information is correct
            if(error) { return null; } 
            //TODO - clean this up - make it less fragile
                        Id holdingAcc = [SELECT id
                             FROM Account
                             WHERE name = 'Community Registration'
                             LIMIT 1].id; //get account holding organization
            Id parentAccountId = holdingAcc; 
            User u = new User();

            Id OwnerId = [SELECT id 
                         FROM user
                         WHERE name = 'ITA Community Account Owner'].id;
            if(errorValidations()== false){
                List<Contact> existingContacts = existingContact();
                if(existingContacts.size() != 0) {
                    parentAccountId = existingContacts[0].AccountId;
                } else if(a.Account_Type__c == 'Student' || a.Account_Type__c == 'Personal'){
                    errorValidations(); 
                    c.Accountid = parentAccountId;
                    c.LeadSource = 'Web';
                    c.MailingStreet = a.BillingStreet;
                    c.MailingCity = a.BillingCity;
                    c.MailingCountryCode = a.BillingCountryCode;
                    c.MailingPostalCode = a.BillingPostalCode;
                    c.MailingStateCode = a.BillingStateCode;
                    insert this.c;//create a contact
                }else{
                    a.Id = null; // set to null to fix a multi click defect
                    a.OwnerId = ownerid;
                    insert a;
                    parentAccountId = a.Id;
                    c.Accountid = a.id;
                    c.LeadSource = 'Web';
                    c.MailingStreet = a.BillingStreet;
                    c.MailingCity = a.BillingCity;
                    c.MailingCountryCode = a.BillingCountryCode;
                    c.MailingPostalCode = a.BillingPostalCode;
                    c.MailingStateCode = a.BillingStateCode;
                    insert this.c;//create a contact
                    Note notes = new Note();
                    notes.ParentId = c.id;
                    notes.Title = 'Company Information';
                    notes.Body = 'Compant Name: ' + a.Name;
                    insert notes;
                }


                u.Username = c.email;
                u.Email = c.email;
                u.FirstName = c.firstname;
                u.LastName = c.lastname;
                
                u.CommunityNickname =  getNickName(c);
                u.contactid = c.id;
                u.ProfileId = p.Id;
                String Alias = c.email;
                if(alias.length() > 8) {
                    alias = alias.substring(0, 8);
                }
                u.alias = alias;
                u.Keep_Active__c = true;
                String userId = Site.createExternalUser(u, parentAccountId, password);
                PageReference confirmation = new PageReference('/apex/RegistrationConfirmation');
                confirmation.setRedirect(false);
                return confirmation;
            }
            } catch (exception e) {
                Database.rollback(sp);
                system.debug(e);
                loginError = 'Something went wrong while attempting to register this user.';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, loginError));
            }
        return null;
    }
    public static String getNickName(Contact c) {
        String baseNickName = c.firstname.substring(0,1)+c.lastname;
        String newNickname = baseNickName;
        String queryNickname = baseNickName + '%';

        List<User> userList = [SELECT Id, CommunityNickname FROM User WHERE CommunityNickname LIKE : queryNickname ORDER BY CommunityNickname DESC LIMIT 50];
        Set<String> foundNickNameSet = new Set<String>();
        for(User u: userList) {
            system.debug(u);
            foundNickNameSet.add(u.CommunityNickname);
        }
        if(userList.size() > 0) {
            Integer i = 1;
            boolean unique = false; 
            while(!unique) {
                if(!foundNickNameSet.contains(newNickname)) {
                    unique = true;
                } else {
                    newNickname = baseNickname + i;
                    i++;
                }
            }
        }
        return newNickname;
    }
}