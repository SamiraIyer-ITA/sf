public without sharing class tradeRegistration_Controller {

    public PageReference doNothing() {
        return null;
    }

    public Id       logo        {get; set;}
    public String   webSite     {get; set;} 
    public Account  a           {get; set;} 
    public Contact  c           {get; set;}
    public Profile  tradeProfile{get; set;}
    public Boolean  errorOnLoad {get; set;}

    public String  returnUrl {get; set;}  //You will be redirected to this page.  Populated in the constructor.

    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }

    public string getEmployeeLoginLink(){
        if(Constants__c.getAll().get('ITA Employee Login URL') != null && Site.getSiteId() != null){
            return Constants__c.getAll().get('ITA Employee Login URL').value__c+
                '//servlet/networks/session/create?url='+EncodingUtil.urlEncode(Site.getBaseUrl()+'/', 'UTF-8')+
                '&site='+ String.valueOf(Site.getSiteId()).substring(0, 15)+
                '&refURL='+EncodingUtil.urlEncode(Site.getBaseUrl()+'/login', 'UTF-8') +
                '&inst=r';
        }
        return null;        
    }

    //Start Constructor
    public tradeRegistration_Controller() {
        system.debug('mgk controller is running');
        errorOnLoad = false;
        a = new account();
        c = new contact();
        a.Account_Type__c = null;
        
        /*
          Redirect the page after registering.
          If they came from an external (non-Salesforce page) or from the /registration page, the user will be redirected to the /welcome page
          If the user came from a Salesforce page other than the registration page, redirect the user to the page he was on
        */
        
        String startUri = apexpages.currentpage().getparameters().get('startURL');
 
                
        String referrerUrl = ApexPages.currentPage().getHeaders().get('Referer');  //Ends with a slash
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();  //Ends with no slash
        if (String.isNotBlank(baseUrl) && String.isNotBlank(startUri) && (referrerUrl != baseUrl + 'welcome')) {
            returnUrl = baseUrl + startUri;
            //returnUrl += '?redirectToPreviousPage=true';  //For debugging
        } else {
            //Redirect to the Welcome page
            returnUrl = baseUrl;
            //returnUrl += '?redirectToWelcomePage=true';  //For debugging
        }
        
        //returnUrl += '&referrerUrl=' + referrerUrl + '&baseUrl=' + baseUrl + '&startUri=' + startUri;  //For debugging
        
        //REGISTRATION PAGE LOGO
        List<Document> dList = [SELECT ID FROM Document WHERE DeveloperName = 'logo_jpg' LIMIT 1];
        if(!dList.isEmpty()) {
            logo = dList[0].id;
        }
        try {
            tradeProfile = [SELECT Id 
                    FROM Profile 
                     WHERE Name = 'Customer Trade Community User'];

            site__c CurrentSite = [SELECT NAME, Title__c, Site_CSS__c, Site_Logo__c, Slogan__c
                                        FROM Site__c
                                        WHERE Domain__c = :URL.getSalesforceBaseUrl().getHost() OR UseAsDefault__c = true 
                                        ORDER BY UseAsDefault__c ASC 
                                    LIMIT 1];
            webSite = currentSite.Name;
        } catch (exception e){
            //TODO - log exceptions
            system.debug(e);
            errorOnLoad = true;
        }
        
    }
    //End Constructor
    
    public PageReference validate() {
        //validate is the page load action - if the page failed in the constructor, then we should redirect to the construction page
        PageReference pageRef = null;
        if(errorOnLoad) {
            pageRef = new PageReference('/apex/UnderConstruction');
        } 
        return pageRef;
    }
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
    public Integer numberOfErrors;
    
    public Boolean errorValidations(){//RETURNS TRUE IF PAGE HAS ERROR
        numberOfErrors = 0;//RUNNING COUNT OF PAGE ERRORS
        //TODO - offload error messages to labels && consolidate error handling approach
        if(c.firstName == null || c.firstName.trim() == ''){
            firstNameError = 'Please provide your first name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, firstNameError));
            numberOfErrors =+ 1;
        }
        if(c.lastName == null || c.lastName.trim() == ''){
            lastNameError = 'Please provide your last name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,lastNameError));
            numberOfErrors =+ 1;
        }
        if(a.Account_Type__c == null){
            accountTypeError = 'Please indicate your organization type';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,accountTypeError));
            numberOfErrors =+ 1;
        }
        if(a.Account_Type__c != 'Researcher' && (a.Name == null || a.Name.trim() == '' )){
            accountNameError = 'Please provide your organization name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,accountNameError));
            numberOfErrors =+ 1;
        }
        //if(a.BillingStreet == null || a.BillingStreet.trim() == ''){
        //    streetError = 'Please provide your street address';
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,streetError));
        //    numberOfErrors =+ 1;
        //}
        //if(a.BillingCity == null || a.BillingCity.trim() == ''){
        //    cityError = 'Please enter your city';
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,cityError));
        //    numberOfErrors =+ 1;
        //}          
        if(a.BillingCountrycode == null || a.BillingCountrycode == ''){
            System.debug('Country is missing');
            countryError = 'Please select your country';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,countryError));
            numberOfErrors =+ 1;
        } else {
            System.debug('Country value is: ' + a.BillingCountrycode);
        }   
        //if((a.BillingStateCode== null || a.BillingStateCode == '') && a.BillingCountryCode == 'US'){
        //    stateError = 'Please select your state';
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,stateError));
        //    numberOfErrors =+ 1;
        //}
        System.debug('BillingPostalCode =' + a.BillingPostalCode);
        System.debug('BillingCountryCode =' + a.BillingCountryCode);
        if((a.BillingPostalCode== null || a.BillingPostalCode == '') && a.BillingCountryCode == 'US'){
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
        //TODO - offload error messages to labels && consolidate error handling approach
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
        }else{//If email is not null and matches pattern query existing contact
            return [SELECT ID, firstname, lastname, email, accountid
                    FROM contact
                    WHERE email = :c.email AND Owner.UserRoleId != null AND Account.Owner.UserRoleId != null
                    LIMIT 1];   
        }
        return new Contact[]{};//return contacts if one exists or a blank list if no contact exists 
    }     


    public List<User> existingUser() {
        system.debug(this.c.email);
        User[] activeUser = [SELECT ID, IsActive, email 
                             FROM User
                             WHERE (email = :this.c.Email or username =:this.c.Email) AND Profileid = :tradeProfile.Id 
                             LIMIT 1];
        return activeUser;
    }

    //CHECKS IF CONTACT HAS ACTIVE ACCOUNT
    boolean error = false;
    public PageReference checkUser() { 
        error = false;
        List<User> activeUser = existingUser();
        PageReference returnVal;

        //user exists, but not contact
        if(activeUser.size() > 0) {
            if(activeUser.size() >= 1){ //a user already exists
                System.debug('User already exists');
                //user and contact exist 
                if(activeUser[0].isActive == true){
                    loginError = 'You\'ve already registered with this account. Please reset your password.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,loginError));
                    error = true;
                }else{
                    activeUser[0].IsActive = true;
                    activeUser[0].email = this.c.Email;
                    activeUser[0].username = this.c.Email;
                    try{
                        update activeUser[0];
                    }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }
                    loginError = 'You\'ve already registered with this account. Please reset your password.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,loginError));
                    error = true;
                    PageReference confirmation = new PageReference('/apex/RegistrationConfirmation');
                    confirmation.setRedirect(false);
                    returnVal = confirmation;
                }
            }else{  //TO DO: remove?
                //no user exists, so create a new user
                //contact exists, but not user
                PageReference confirmation = new PageReference('/apex/RegistrationConfirmation');
                confirmation.setRedirect(false);
                returnVal = confirmation;
            }
        } else if(pattern.matches('^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$', this.c.Email) && this.c.email.indexOf('trade.gov')== -1) {//if no contact exists, email is not ITA contact, and email matches email format
            //good
        } else if (this.c.email.indexOf('trade.gov') != -1) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email cannot be an ITA Contact'));
        } else{//if no contact, and email does not match email format, throw message
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a valid email address'));
        }
        return returnVal;
    }

    //CREATE NEW CONTACT 
    public PageReference newContact(){
        
        //Verify CAPTCHA
        if(! Test.isRunningTest()) {
            if (! verify()) {
                //CAPTCHA was not verified, so return null to stay on the same page and try again
                System.debug('CAPTCHA was not verified');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please click the "I\'m not a robot" checkbox.'));
                errorValidations();
                return null;
            }
        }
        
        System.debug('CheckUser()');
        checkUser(); //validates the information is correct
        if(error) { return null; }

        String passwordCheck = passwordValidationResult();
        if(! Test.isRunningTest()) {
            if (passwordCheck != 'Valid'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, passwordCheck));
                errorValidations();
                return null;
            }
        }
        if (password != confirmPassword){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match));
            errorValidations();
            return null;
        }

        Savepoint sp = Database.setSavepoint();
        try {
            Account holdingAcc = new Account();

            //TODO - clean this up - make it less fragile
            System.debug('get account holding organization');
            List<Account> acctList = [SELECT ID FROM Account WHERE Name = 'Community Registration' LIMIT 1]; //get account holding organization
            if(!acctList.isEmpty()) {
                System.debug('!acctList.isEmpty()');
                holdingAcc.Id = acctList[0].Id;
            } else {
                System.debug('Create new account');
                holdingAcc = new Account(Name = 'Community Registration');
                //SafeDMLHandler.safeInsert(holdingAcc, false);
                System.debug('After inserting holdingAcc');
            }
            Id parentAccountId = holdingAcc.Id; 
            User u = new User();

            Id ownerId = [SELECT ID FROM User WHERE Name = 'ITA Community Account Owner'].ID;
            System.debug('OwnerId: ' + ownerId);
            if(errorValidations()== false){
                System.debug('No validation errors');
                List<Contact> existingContacts = existingContact();
                if(existingContacts.size() != 0) {
                    System.debug('existingContacts.size() != 0');
                    parentAccountId = existingContacts[0].AccountId;
                } else if(a.Account_Type__c == 'Researcher'){
                    System.debug('Account type is Researcher');
                    errorValidations();
                    RecordType[] individualRecType = [SELECT ID FROM RecordType WHERE DeveloperName = 'Individual' AND SobjectType = 'Account' AND IsActive = true LIMIT 1];
                    a.Name = c.FirstName + ' ' + c.LastName;
                    a.RecordTypeID = !individualRecType.isEmpty() ? individualRecType[0].ID : null;
                    a.OwnerId = ownerId;
                    a.Privacy_Shield_Disabled__c = true;

                    try{

                        insert a;
                    }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }


                    parentAccountId = a.ID;
                    c.Accountid = parentAccountId;
                    c.LeadSource = 'Web';
                    c.MailingStreet = a.BillingStreet;
                    c.MailingCity = a.BillingCity;
                    c.MailingCountryCode = a.BillingCountryCode;
                    c.MailingPostalCode = a.BillingPostalCode;
                    c.MailingStateCode = a.BillingStateCode;
                    System.debug('Insert contact');
                    try{
                        insert this.c;//create a contact
                    }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }
                }else{
                    System.debug('Account type is business');
                    a.Id = null; // set to null to fix a multi click defect
                    a.OwnerId = ownerId;
                    try{
                        system.debug('a is ==> ' + a);
                        system.debug('system.user ==> ' + System.userInfo.getProfileId());
                        insert a;
                    }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }
                        parentAccountId = a.Id;
                        c.Accountid = a.id;
                        c.LeadSource = 'Web';
                        c.MailingStreet = a.BillingStreet;
                        c.MailingCity = a.BillingCity;
                        c.MailingCountryCode = a.BillingCountryCode;
                        c.MailingPostalCode = a.BillingPostalCode;
                        c.MailingStateCode = a.BillingStateCode;
                    try{
                        insert this.c;//create a contact
                    }catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }
                        Note notes = new Note();
                        notes.ParentId = c.id;
                        notes.Title = 'Company Information';
                        notes.Body = 'Company Name: ' + a.Name;
                    try{
                        insert notes;
                    }Catch(Exception e){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                    }
                }

                u.Username = c.email;
                u.Email = c.email;
                u.FirstName = c.firstname;
                u.LastName = c.lastname;
                //START W-000887
                u.PostalCode = a.BillingPostalCode;
                u.CountryCode = a.BillingCountryCode;
                u.CompanyName = a.Name;
                u.TimeZoneSidKey = 'America/New_York';
                //END W-000887
                
                u.CommunityNickname = getNickName(c);
                u.contactid = c.id;
                u.ProfileId = tradeProfile.Id;
                String Alias = c.email;
                if(alias.length() > 8) {
                    alias = alias.substring(0, 8);
                }
                u.alias = alias;
                u.Keep_Active__c = true;
                u.Registered_Domain__c = webSite;

                if(! Test.isRunningTest()) {
                  Site.validatePassword(u, password, confirmPassword);
                }
                if (!ApexPages.hasMessages()){
                    String userId = Site.createPortalUser(u, parentAccountId, password);
                    return Site.login(u.Username, password, returnUrl);
                }
            }
        } catch (exception e) {
            Database.rollback(sp);
            system.debug(e.getMessage() + ': ' + e.getStackTraceString());
            loginError = 'Something went wrong while attempting to register this user.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, loginError));
        }
        
        return null;
    }
    public static String getNickName(Contact c) {
        String baseNickName = c.firstname.substring(0,1)+c.lastname;
        String newNickname = baseNickName;
        if(newNickName.length() >= 36){
            newNickName = newNickName.substring(0, 36);
        }
        String queryNickname = baseNickName + '%';

        List<User> userList = [SELECT Id, CommunityNickname FROM User WHERE CommunityNickname LIKE :queryNickname ORDER BY CommunityNickname DESC LIMIT 1000];
        if(userList.size() > 0) {
            integer increment = 1;
            for(User u : userList){
                increment++;
                newNickName = baseNickName+increment;
            }

        }
        return newNickname;
    }
    
    public Integer getMinimumPasswordCharacters(){
        Password_Policies__c pp = Password_Policies__c.getOrgDefaults();
        Integer min = 0;
        if (pp != null){
            min = (Integer)pp.Minimum_Characters__c;
        }
        return min;
    }
    private Boolean getBooleanPasswordPolicy(String fieldName){
        Password_Policies__c pp = Password_Policies__c.getOrgDefaults();
        Boolean req = false;
        if (pp != null){
            req = (Boolean)pp.get(fieldName);
        }
        return req;
    }
    public Boolean getPasswordRequireLowerCase(){
        return getBooleanPasswordPolicy('Require_Lower_Case__c');
    }
    public Boolean getPasswordRequireUpperCase(){
        return getBooleanPasswordPolicy('Require_Upper_Case__c');
    }
    public Boolean getPasswordRequireNumeric(){
        return getBooleanPasswordPolicy('Require_Numeric__c');
    }
    public Boolean getPasswordRequireSpecialChar(){
        return getBooleanPasswordPolicy('Require_Special_Character__c');
    }
        
    @TestVisible private String passwordValidationResult(){
        String result = 'Valid';
        if (String.isBlank(password)){
            result = 'Please set a password';
        } else {
            Boolean containsNumber = false;
            Boolean containsUpperCase = false;
            Boolean containsLowerCase = false;
            Boolean containsSpecialChar = false;
            for (String chr : password.split('')){
                if (!containsNumber)
                    containsNumber = chr.isNumeric();
                if (!containsUpperCase)
                    containsUpperCase = chr.isAllUpperCase();
                if (!containsLowerCase)
                    containsLowerCase = chr.isAllLowerCase();
                if (!containsSpecialChar)
                    containsSpecialChar = chr == '!' || chr == '#' || chr == '$' || chr == '%' || chr == '-' || chr == '_' || chr == '=' || chr ==  '+' || chr == '<' || chr == '>';
            }
            
            //Password must have a length of least [N] characters
            Integer minLength = getMinimumPasswordCharacters();
            if (password.length() < minLength){
                result = 'Password must be at least ' + minLength + ' characters long. ';
            }
            //Must contain numbers
            if (getPasswordRequireNumeric() && !containsNumber){
                result += 'Password must contain at least one number. ';
            }
            //Must contain upper case letters
            if (getPasswordRequireUpperCase() && !containsUpperCase){
                result += 'Password must contain at least one upper case letter. ';
            }
            //Must contain lower case letters
            if (getPasswordRequireLowerCase() && !containsLowerCase){
                result += 'Password must contain at least one lower case letter. ';
            }
            //Must contain special characters
            if (getPasswordRequireSpecialChar() && !containsSpecialChar){
                result += 'Password must contain at least special character (! # $ % - _ = + < >).';
            }
        }
        return result;
    }
    
    @TestVisible private static final String CAPTCHA_SECRET_KEY = CaptchaSettings__c.getAll().get('SECRET_KEY').value__c;  
    @TestVisible private static final String CAPTCHA_BASE_URL = CaptchaSettings__c.getAll().get('BASE_URL').value__c;
         
    //private static String CAPTCHA_BASE_URL = 'https://www.google.com/recaptcha/api/siteverify'; 
    //private static String CAPTCHA_SECRET_KEY = '6LcIcSkTAAAAAEoPmZtyjIZ9RwO7EVA_PdOFdeAp';   //BlackSOD
    //public String captcha_Site_Key= '6LcIcSkTAAAAAB1onbL367hba_oBft8SJO7eZLmT';   //BlackSOD

    public String captcha_Site_Key {get; set;}  {captcha_Site_Key = CaptchaSettings__c.getAll().get('SITE_KEY').value__c; }
    
    @TestVisible private String getRecaptchaResponse { 
        get {
            return ApexPages.currentPage().getParameters().get('g-recaptcha-response');
        }
    }
    
    @TestVisible private boolean verify() {
        System.debug('reCAPTCHA verification attempt');
        if ( getRecaptchaResponse == null ) { 
            System.debug('reCAPTCHA verification attempt with no response from Google');
            return false; 
        }
        
        HttpResponse response;
        /*if(Test.isRunningTest()) {
            response = new HttpResponse();
          response.setHeader('Content-Type', 'application/json');
          response.setBody('{"success":"true"}');
          response.setStatusCode(200);
        } else {*/
          response = makeRequest(CAPTCHA_BASE_URL,
            'secret=' + CAPTCHA_SECRET_KEY + 
            '&response='  + getRecaptchaResponse  + 
            '&remoteip=' + getUserIPAddress()
          );
        //}
        
        if ( response != null ) {
            return isCaptchaSuccess(response);
        }
        
        return false;
        
    }
    
    @TestVisible private boolean isCaptchaSuccess(HttpResponse response) { 
        JSONParser parser = JSON.createParser(response.getBody());
        System.debug('Checking response tokens');
        while (parser.nextToken() != null) {
            System.debug('A token is not null');
            //if current token is a field name
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String fieldName = parser.getText();
                System.debug('fieldName: ' + fieldName);
                //move to token after the field name
                parser.nextToken(); 
                if(fieldName == 'success'){
                    String successValue = parser.getText();
                    System.debug('CAPTCHA success response value: ' + successValue);
                    if (String.isNotEmpty(successValue) && successValue.equalsIgnoreCase('true')) {
                        return true;
                    }    
                }
            }
        }
        return false;
    }

    
    @TestVisible private static HttpResponse makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);
        try {
            Http http = new Http();
            if(Test.isRunningTest()) {
                response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"success":"true"}');
                response.setStatusCode(200);
            } else {
              response = http.send(req);
            }
            System.debug('reCAPTCHA response: ' + response);
            System.debug('reCAPTCHA body: ' + response.getBody());
        } catch(System.Exception e) {
            System.debug('ERROR: ' + e);
        }
        return response;
    } 
    
    @TestVisible private static String getUserIPAddress() {
        string ReturnValue = '';
    
        ReturnValue = ApexPages.currentPage().getHeaders().get('True-Client-IP');
                
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        } // get IP address when no caching (sandbox, dev, secure urls)
        if (ReturnValue == '' || ReturnValue == null) {
            ReturnValue = ApexPages.currentPage().getHeaders().get('X-Forwarded-For');
        }   
        system.debug('USER IP ADDRESS: ' + ReturnValue);
            
        return ReturnValue;
            
    } // GetUserIPAddress
    
    public SelectOption[] getAccountTypeOptions(){
        SelectOption[] options = new SelectOption[]{};
        Schema.DescribeFieldResult fieldResult = Account.Account_Type__c.getDescribe();   
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
}