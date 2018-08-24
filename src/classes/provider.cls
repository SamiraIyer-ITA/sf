public class provider {

    public String field { get; set; }

private Application app = new Application();

public Participation__c application {get; set;}
public string firstName {get; set;}
public string lastName {get; set;}
public string CurrentApplicationId {get; set;}

public map<string, string> FieldTranslations {get; set;}

public Participation__c applicationNew{get; set;}
public List<Contract__c> contractList{get; set;}

public void contractObjData(){
     
      
}


public provider(){
    contractList = new List<Contract__c>();
    if(String.isNotBlank(ApexPages.CurrentPage().getParameters().get('id'))) {
        applicationNew  = [SELECT Id, FAAContractor__c, (Select id, Name, Application__c, ContractNumber__c, ProductsServices__c from Contracts__r) FROM Participation__c WHERE Id=: ApexPages.CurrentPage().getParameters().get('id') LIMIT 1];
        System.debug('Debug Log for applicationNew'+applicationNew);
        if(applicationNew.FAAContractor__c && applicationNew.Contracts__r.size() >0) {
            for(Contract__c con : applicationNew.Contracts__r) {
                contractList.add(con);
            }
        }
        System.debug('Debug Log for contractList'+contractList);
    }
    
    //contractList = new List<Contract__c>();
    
    this.FieldTranslations = new map<string, string>();
    for(String str : new String[]{'First Name', 'Last Name', 'Email', 'Title', 'Solutions Offered', 'Company or Organization Name', 'Phone Number', 'Country in which you are located', 'Country where you are seeking to import the U.S. product or service', 'Write a message to this U.S. solution provider', 'Contact', 'Send'}){
        this.FieldTranslations.put(str, str);
    }
    Set<string> fields = app.getStandardFields();  
    fields.add('purpose__c');
    fields.add('Program__r.Name');
    fields.add('Program__r.Thank_You_Response__c');
    fields.add('Program__r.Thank_You_Response__r.Content__c');
    fields.add('Program__r.Thank_You_Response__r.Display_Title__c');
    fields.add('Program__r.Incorrect_or_Inactive_Provider_Message__r.Content__c');
    fields.add('Program__r.Disclaimer_Text__r.Content__c');
    fields.add('Program__r.Disclaimer_Text__c');
    fields.add('Program__r.isActive__c');
    fields.add('Company_Description__c');
    fields.add('Recordtype.DeveloperName');
    CurrentApplicationId = ApexPages.currentPage().getParameters().get('id');     
    this.application = this.app.getApplicationById(fields, CurrentApplicationId);
    //contractList = new List<Contract__c>();
     
}

public Case c {get{
    if(this.c == null){
        this.c = new Case();
    }
    return this.c;
} set;}

public boolean CaseSubmitted{get; set;}

public pageReference submitCase(){
  //Verify CAPTCHA
        if(! Test.isRunningTest()) {
            if (! verify()) {
                //CAPTCHA was not verified, so return null to stay on the same page and try again
                System.debug('CAPTCHA was not verified');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please click the "I\'m not a robot" checkbox.'));
                //errorValidations();
                return null;
            }
        }
    this.c.subject = 'Lead Generation Case Submitted';
    this.c.SuppliedName = firstName + ' ' + lastName;
    this.c.Participation_Profile__c = this.application.id; //CurrentApplicationId;
    this.c.recordtypeid = [select id from recordtype where developername='Lead_Generation' limit 1].id;
    List<Participant_Contact__c> participantContacts = [select ID,Name, language__c, Language__r.Name,Email__c,Role__c from Participant_Contact__c where Participant__c =: this.application.id and (Language__r.Name = :this.selectedLanguage or Role__c = 'Primary Contact') and Email__c != null order by Language__r.Name desc nulls last, Role__c desc nulls last];
    for(Participant_Contact__c pcontact : participantContacts) {
        if((!string.isBlank(this.selectedLanguage) && this.selectedLanguage != 'DEFAULT' && pcontact.language__c == this.selectedLanguage) || pcontact.role__c == 'Primary Contact'){
            this.c.Contact_Email__c = pcontact.Email__c;
            break;
        }
    }  

    Internal_Mailing_List__mdt[] IML = [select mailing_list__c from Internal_Mailing_List__mdt where label = :this.application.program__r.name limit 1];
    if(IML.size() == 1){
        this.c.InternalGroupMailingLists__c = IML[0].mailing_list__c;
    }
    try{
        upsert this.c;
    }catch(Exception e){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
    }
    system.debug(c);
    this.CaseSubmitted = true;
    return null;
}

public pageReference redirectForInactive() {
    PageReference pg;
    if(this.application == null || this.application.Program__c == null ||
    (!this.application.Program__r.isActive__c && (this.application.Program__r.Incorrect_or_Inactive_Provider_Message__c == null || 
    this.application.Program__r.Incorrect_or_Inactive_Provider_Message__r.Content__c == null))) {
        //if application is null, program is null, or application's program is inactive and has no provider message/content
        //redirect to 404 page
        pg = Page.pagenotfound;
        pg.setRedirect(true);
        return pg;   
    } else if(!this.application.Program__r.isActive__c) {
        //if application's program is inactive but has provider message/content
        //redirect to custom message
        this.NotFoundDisplayMessage = this.application.Program__r.Incorrect_or_Inactive_Provider_Message__r.Content__c;
        return null;
    }
    //program must be active, so now search for application's assets. if no assets exist display appropriate error page
    List<Asset> assetList = [select name,id,Participant__c,Status from Asset where Participant__c =: this.application.id and Status = 'Active'];
    if(assetList.isEmpty()){
        if(this.application.Program__r.Incorrect_or_Inactive_Provider_Message__c == null || 
        this.application.Program__r.Incorrect_or_Inactive_Provider_Message__r.Content__c == null) {
            //redirect to 404 if there are no assets and no custom error message
            pg = Page.pagenotfound;
            pg.setRedirect(true);
            return pg;
        } else {
            //redirect to custom message
            this.NotFoundDisplayMessage = this.application.Program__r.Incorrect_or_Inactive_Provider_Message__r.Content__c;
            return null;
        }
    }    
    return null;
}

public String NotFoundDisplayMessage {get; set;}

public Asset[] assets {get{
    if(this.assets == null){
        this.assets = this.app.getAssets(this.application.id, 'Active');
    } 
    return this.assets;
} set;}

public pagereference translate(){ return null;}

public Translation getTranslation(){
    Translation output = new Translation();
    output.Name = this.application.public_display_name__c != null ? this.application.public_display_name__c : this.application.name;
    output.Body = this.application.company_description__c.replaceAll('<pre>', '').replaceAll('</pre>', '').replaceAll('<pre />', '');

    output.Direction = 'ltr';
    output.Thanks = this.application.Program__r.Thank_You_Response__r.Content__c;
    output.ThanksHeader = this.application.Program__r.Thank_You_Response__r.Display_Title__c;
    output.DisclaimerText = this.application.Program__r.Disclaimer_Text__r.Content__c;
    set<string> assetSet = new set<string>();
    for(Asset asset : this.assets){
        assetSet.add(asset.product2.name);
    }
    output.assets = new List<String>(assetSet);

//now that the primary data has been set, check for translations
    set<string> TranslatedAssets = new set<String>();
    if(this.selectedLanguage != null && this.selectedLanguage != 'DEFAULT'){
        for(Translation__c t : getTranslations()){
            if(t.participation__c != null){
                output.Name = t.name;
                if(output.Body == null){
                    output.Body = '';
                }
                if(t.translation__c != null && output.Body != null)
                    output.Body = t.translation__c.replaceAll('<pre>', '').replaceAll('</pre>', '').replaceAll('<pre />', '');
                output.Direction = t.language__r.direction__c;
            }
            if(t.atom__c != null){
                if(t.atom__c == this.application.program__r.disclaimer_text__c){
                    output.DisclaimerText = t.translation__c;
                }else{
                    output.ThanksHeader = t.name;
                    output.Thanks = t.translation__c;
                }
            }
            for(string asset :output.assets){
                if(t.product__r.name == asset){
                    TranslatedAssets.add(t.name);
                    break;
                }
            }
            for(String field : this.FieldTranslations.keySet()){
                if(t.name == field){
                    this.FieldTranslations.put(field, t.Translation_Forms_Access__c);
                    break;
                }
            }
        }
        output.assets=new List<string>(TranslatedAssets);
    }else{
        for(String field : this.FieldTranslations.keySet()){
            this.FieldTranslations.put(field, field);
        }    
    }
    return output;
}

public List<Translation__c> getTranslations(){
        Id[] products = new Id[]{};
        for(Asset asset : this.assets){
            products.add(asset.product2id);
        }
        Set<id> ProductIds = new Set<id>(products);        
        return [select id, name, translation__c, language__c, language__r.name, participation__c, Translation_Forms_Access__c, product__r.name, atom__c, language__r.direction__c from translation__c where 
            language__c = :this.selectedLanguage 
            and (
                participation__c = :this.application.id or
                atom__c = :this.application.program__r.disclaimer_text__c or
                (
                    (
                    product__c in :ProductIds or 
                    atom__c = :this.application.Program__r.Thank_You_Response__c
                    ) 
                and participation__c = null
                ) or
                name in :this.FieldTranslations.keySet()
            )
        ];
} 

public string SelectedLanguage {get; set;}
public list<SelectOption> getAvailableLanguages(){
    List<SelectOption> output = new List<SelectOption>();
    output.add(new SelectOption('DEFAULT', 'English'));
    set<string> exists = new set<string>();
    for(Translation__c translation : [select id, language__c, language__r.ISO_639_1__c, language__r.name from translation__c where participation__c = :this.application.id ]){
        if(!exists.contains(translation.language__c)){
            exists.add(translation.language__c);
            output.add(new SelectOption(translation.language__c, translation.language__r.name));
        }
        if(ApexPages.currentPage().getParameters().get('uri') != null){
            if(translation.language__r.ISO_639_1__c == ApexPages.currentPage().getParameters().get('uri') && this.selectedLanguage == null){
                this.SelectedLanguage=translation.language__c;
            }
        }
    }


    return output;    
}

public class Translation {
    public string Body {get; set;}
    public string Name {get; set;}
    public string Thanks {get; set;}
    public string ThanksHeader {get; set;}
    public string Direction {get; set;}
    public string DisclaimerText {get; set;}
    public string[] Assets {get; set;}
}

//Captcha start

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

//End captcha

}