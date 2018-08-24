public without sharing class form_controller {
    /* Design Considerations 
    *   -At most, 1 section per sObject type. 
    *   -sObject type to section should be 1 to 1
    * test record in FORMS sandbox: https://trade--forms--c.cs32.visual.force.com/apex/form?id=a3Cr0000000043Z 
    */
    public Form__c form {get; set;}
    public list<Form_Section__c> sections {get; set;}
    public pricebook2 pricebook {get; set;}
    public List<sObject> sObjectList {get; set;} 
    public Map<String, Set<String>> sObjectToQueryFields {get; set;}
    public Map<String, List<sObject>> sObjectToRecords {get; set;}
    private Map<Id, Form_Section__c> sectionMap {get {
        return new Map<Id, Form_Section__c>(sections);
    }}


    public pageReference redirect(){
        if(this.participantRecord == null && ApexPages.CurrentPage().getParameters().get('Id') != null){
            return this.app.findFormPage(ApexPages.CurrentPage().getParameters().get('Id'), false);
        }
        return null;
    }

    private sObject generateNewSobject(String sObjectName) {
        //TODO parent bindings
        if(gd == null || gd.get(newRecordObjectType) == null) {return null;}
        sObject sObj = gd.get(newRecordObjectType).newSObject();
        if(sObjectToParentMap.get(sObjectName) != null) {
                Map<String, String> parentFieldMap = sObjectToParentMap.get(sObjectName);
                //set participant record as parent
                if(parentFieldMap.get('Participation__c') != null) {
                    String relationshipFieldName = parentFieldMap.get('Participation__c');
                    sObj.put(relationshipFieldName, participantRecord.Id);
                }
        }
        return sObj;
    }

    //map that contains an sObject -> returns a Map of Parent Object to Relationship Name
    private Map<String, Map<String, String>> sObjectToParentMap = new Map<String, Map<String, String>>();
    private void buildParentsObjectMap(Set<String> sObjectSet) {
        for(String sObjName: sObjectSet) {
            if(String.isBlank(sObjName)) { continue; }
            Map<String, String> objNameToRelationshipName = new Map<String, String>();
            Schema.SObjectType sObjType = gd.get(sObjName); //dynamic binding of sObject name to schema
            for(Schema.SobjectField strFld: sObjType.getDescribe().fields.getMap().Values()) {
                if(strFld.getDescribe().getType() == Schema.DisplayType.REFERENCE) {
                    String parentObj = '' + strFld.getDescribe().getReferenceTo()[0];            //object name of parent
                    //String relationshipName = (String)strFld.getDescribe().getRelationshipName(); //field relationship name of parent
                    String fieldName = String.ValueOf(strFld.getDescribe().getSobjectField());
                    objNameToRelationshipName.put(parentObj, fieldName);
                } 
            }
            sObjectToParentMap.put(sObjName, objNameToRelationshipName);
        }
    }
    /* global describe - this should be cached - as each call to populate this map costs ~21ms */
    public Map<String, Schema.SObjectType> gd { 
        get {
            if(gd == null) { 
                gd = Schema.getGlobalDescribe();
            } 
            return gd;
        } set;
    }
    /* method to insert a blank record into a list 
    *  used in the create new button
    */
    public String newRecordObjectType {get; set;} //expected value - sObjectType
    public PageReference addRecordToSection() {
        if(newRecordObjectType != null) {
            List<sObject> sobjList = sObjectToRecords.get(newRecordObjectType);
            //instantiate a blank sObject of the correct type
            sObject theNewRecord = generateNewSobject(newRecordObjectType);
            for(Form_Section__c section : this.sections){
                if(section.Object_API_Name__c == newRecordObjectType && section.Record_Type__c != null){
                    RecordType[] RecordTypeId = [select id from RecordType where developername = :section.Record_Type__c limit 1];
                    if(RecordTypeId.size() == 1){
                        theNewRecord.put('RecordTypeId', RecordTypeId[0].id);
                    }           
                    break;         
                }
            }
            //add sObject to list
            sobjList.add(theNewRecord);
            //TODO add page confirmation /error
        }
        return null;
    }

    /*method to save a single record*/
    public String SaveRecordId {get; set;}
    public PageReference saveRecord(){
        system.debug('@@'+SaveRecordId);
        //if(SaveRecordId != null){ //if the recordId is null, this means that you are inserting a record.
            //find the existing record in the map sObjectToRecords
            for(String key : sObjectToRecords.keySet()){
                List<sObject> sObjList = sObjectToRecords.get(key);
                if(sObjList != null && sObjList.size() != 0){
                system.debug(sObjList);                      
                    //loop through the list of sObjects
                    for(Integer i = 0; i < sObjList.size(); i++){
                        sObject sObj = sObjList[i];

                        //if the ID is null or empty, this is a save/new record, so it should be added.
                            system.debug(sobj);                        
                        if(sObj != null && sObj.get('Id') == null){
                            try{
                                insert sObj;
                                sObj.put('Id', sObj.id);
                            }catch(Exception e){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                            }
                            break;
                        }
                        //if it's not an insert, it's an update
                        if(sObj != null && SaveRecordId != null && SaveRecordId != '' && sObj.get('Id') == SaveRecordId){
                            system.debug('@@'+sObj);
                            try{
                                update sObj;
                                ApexPages.getMessages().clear();
                            }Catch(Exception e){
                                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
                            }
                            break;
                        }
                    }
                }
            }
        //}
        return null;
    }

    /* method to delete */
    public String deleteRecordId {get; set;}
    public PageReference deleteRecord() {
        if(!String.isBlank(deleteRecordId)) {
            //loop through map keyset to look for a match
            for(String s: sObjectToRecords.keyset()) {
                List<sObject> sObjList = sObjectToRecords.get(s);
                if(sObjList != null) {
                    //loop throough the sObject List
                    for(Integer i = 0; i < sObjList.size(); i++){
                        sObject sObj = sObjList[i];
                        if(sObj.get('Id') == deleteRecordId) {
                            //delete from database
                            delete sObj;
                            //remove from list
                            sObjList.remove(i);
                            //update map
                            sObjectToRecords.put(s, sObjList);
                            break;
                         //TODO add page confirmation /error
                        }
                    }
                }
            }
        }else{

            for(String s: sObjectToRecords.keyset()) {
                List<sObject> sObjList = sObjectToRecords.get(s);
                if(sObjList != null) {
                    //loop throough the sObject List
                    for(Integer i = 0; i < sObjList.size(); i++){
                        sObject sObj = sObjList[i];
                        system.debug('@@DAN'+sObj);
                        if(sObj != null){
                            Map<String, Object> fieldToValue = sObj.getPopulatedFieldsAsMap();
                            
                            if(fieldToValue.get('Id') == null) {
                                //remove from list
                                sObjList.remove(i);
                                //update map
                                sObjectToRecords.put(s, sObjList);
                                break;
                             //TODO add page confirmation /error
                            }
                        }
                    }
                }
            }
        
        }
        return null;
    }

    public map<string, integer> RecordsPerSection {get {if(this.RecordsPerSection == null){this.RecordsPerSection = new map<string, integer>();} return this.RecordsPerSection;} set;}

    public void saveSectionHelper(Form_Section__c section, List<sObject> toUpdate, List<sObject> toInsert) {
        for(sObject sObj: sObjectToRecords.get(section.Object_API_Name__c)) {
            if(sObj == null) { continue; }
            if(sObj.get('Id') == null) {
                if(section.Create__c) {
                    if(section.Record_Type__c != null){
                        RecordType[] RecordTypeId = [select id from RecordType where developername = :section.Record_Type__c limit 1];
                        if(RecordTypeId.size() == 1){
                            sObj.put('RecordTypeId', RecordTypeId[0].id);
                        }
                    }
                    toInsert.add(sObj);
                } 
                
            } else {
                if(section.Update__c) {
                    toUpdate.add(sObj);
                } 
            }
        }
    }

    public PageReference saveAllSections() {
        List<sObject> toInsert = new List<sObject>();
        List<sObject> toUpdate = new List<sObject>();
        for(String s: sectionMap.keySet()) {
           Form_Section__c section = sectionMap.get(s);
           saveSectionHelper(section, toUpdate, toInsert);
        } 
        try{
            insert toInsert;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
        }
        try{
            update toUpdate;            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
        }
        return null;
    }

    public String saveSectionId {get; set;} 
    public PageReference saveSection() {
        if(saveSectionId != null) {
            List<sObject> toInsert = new List<sObject>();
            List<sObject> toUpdate = new List<sObject>();
            Form_Section__c section = sectionMap.get(saveSectionId);
            
            saveSectionHelper(section, toUpdate, toInsert);
            try{            
                insert toInsert;
                ApexPages.getMessages().clear();
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
            }
            try{
                update toUpdate;
                ApexPages.getMessages().clear();
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
            }            
        }
        //TODO add page confirmation /error
        //TODO gracefully handling / save points / partial success?
        return null;
    }
    //?public sObject saveRecordSObj {get; set;}
    //public PageReference saveRecord()
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
            system.debug(this.form.program__c);
            participantRecord = this.app.getApplication(this.app.getStandardFields(), this.form.program__c);
            system.debug(participantRecord);
        }
        return participantRecord;
    } set;}

    public form_controller(){
        //initialize variables 
        sObjectToQueryFields = new Map<String, Set<String>>();
        sObjectToRecords = new Map<String, List<sObject>>();
        Id formId = ApexPages.currentPage().getParameters().get('id');


        if(!validCommunityUser()) {
            this.form = new Form__c(Name='Invalid User');  //to prevent a fatal VFP error.
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Invalid User Logged In.  Please login as community user.'));
        } else if(formId != null) {
            try {
                Set<String> objectsInScope = new Set<String>();
                String sectionsQuery = 'SELECT Id, Create__c, Delete__c, Display_Order__c, Form__c, Header__c, Instructions__c, Object_API_Name__c, Update__c  ';
                String fieldsQuery = 'SELECT API__c, Dependent_Field__c, Display_Order__c, Read_Only__c, Field_Header__c, List_Card_Display__c, Help_Text__c, Instructions__c, reference__c, validation_type__c, Required__c, Section__c, Style__c ';
                this.form = [SELECT Id, Name, Header__c, web_resource_type__c, Omb_Control_No__c, Omb_Expiration_Date__c, Program__c, Object_API__c, Instructions__c, Product_Catalog__c, case_subject__c, case_description__c, case_recordtype__c, Thank_You_Page__c, Thank_You_Page__r.Clean_URL__c, Order_Status__c, disable_submit__c FROM Form__c WHERE Id =: formId];
                system.debug(this.form);
                if(this.form.Product_Catalog__c != null){
                    this.pricebook = [SELECT Id, Public_Display_Instructions__c, Public_Display_Name__c, (SELECT Id, Product2Id, Product2.Name FROM PricebookEntries WHERE IsActive = true) FROM Pricebook2 WHERE Id = :this.form.Product_Catalog__c LIMIT 1];
                }

                sectionsQuery += ', (' + fieldsQuery + ' FROM Fields__r ORDER BY Display_Order__c ASC NULLS LAST), record_type__c, where_clause__c FROM Form_Section__c WHERE Form__c =: formId ORDER BY Display_Order__c ASC NULLS LAST';

                objectsInScope.add(this.form.Object_API__c); //add the base object in scope
                this.sections = database.query(sectionsQuery);

                List<sObject> sObjectList;

                //TODO query existing records

                map<string, string> WhereClauses = new map<string, string>();

                //build sObject query field set
                for(Form_Section__c section: sections) {
                    //instantiate set - pull from list if it exists already
                    
                    Set<String> sObjectFields;
                    String objectName;
                    //if section does not have a value specified - default from the parent form
                    if(String.isBlank(section.Object_API_Name__c)) { 
                         objectName = this.Form.Object_API__c;
                         section.Object_API_Name__c = this.Form.Object_API__c;//set fields to display for object
                    } else {
                        objectName = section.Object_API_Name__c;
                        WhereClauses.put(objectName, section.Where_Clause__c);
                    }
                    objectsInScope.add(objectName); //add each section's object
                    if(sObjectToQueryFields.get(objectName) == null) {
                        sObjectFields = new Set<String>();
                    } else {
                        sObjectFields = sObjectToQueryFields.get(objectName);
                    }
                    //populate a set of fields to query for each sobject (key)
                    for(Field__c field: section.Fields__r) {
                        sObjectFields.add(field.API__c);
                    }
                    sObjectToQueryFields.put(objectName, sObjectFields);
                }

                buildParentsObjectMap(objectsInScope);

                //query records in sObject map
                for(String sObjectType: sObjectToQueryFields.keySet()) {
                    if(SObjectType == null) {continue;}
                    String query = 'SELECT Id ';
                    for(String s: sObjectToQueryFields.get(sObjectType)) {
                        if(s == null) {continue;}
                        query += ', ' + s;
                    }
                    query += ' FROM ' + sObjectType;
                    if(SObjectType == 'Participation__c') {
                        query += ' WHERE Id = \'' + participantRecord.Id + '\'';

                    } else {
                        //dynamic filters of participation child records
                        Map<String, String> parentFieldMap = sObjectToParentMap.get(sObjectType);
                        if(parentFieldMap.get('Participation__c') != null) {
                            String relationshipFieldName = parentFieldMap.get('Participation__c');
                            query += ' WHERE ' + relationshipFieldName + '= \'' + participantRecord.Id + '\'';
                            
                            if(WhereClauses.get(sObjectType) != null && WhereClauses.get(sObjectType) != ''){
                                query += ' and ' + WhereClauses.get(sObjectType);
                            }
                            query += ' ORDER BY CreatedDate DESC';
                        }
                    }
                    system.debug('@@'+query);
                    //handle dynamic filters of participation child records
                    //This design requires at most, one sObject in total for all sections
                    sObjectToRecords.put(sObjectType, database.query(query));
                }

                //if no records exist for a section - instantiate a new one
                for(Form_Section__c section: sections) {
                    
                    if(section != null && (sObjectToRecords.get(section.Object_API_Name__c) == null || sObjectToRecords.get(section.Object_API_Name__c).isEmpty())){
                        List<sObject> sObjList = new List<sObject>();
                        //TODO - validate it is a valid sObject
                        sObjList.add(generateNewSobject(section.Object_API_Name__c));
                        //add new empty records to map
                        sObjectToRecords.put(section.Object_API_Name__c, sObjList);
                    }
                    
                }
                map<string, SelectOption[]> setOptions = this.Options; //method to set the options and lookupmap                

            }catch(Exception e){
                //system.debug(e);
                //Invalid Form Id provided.  Display a Message.
                this.form = new Form__c(Name='Invalid Form');  //to prevent a fatal VFP error.
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'Invalid Form Provided.  Please contact Support.'));
//                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, ErrorMessaging.clearMessage(e.getMessage())));
            }

        } else {
            this.form = new form__c(Name='Form Not Found');  //to prevent a fatal VFP error.
            //No Form was provided.  Display an error message.
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, 'No Form Provided.  Please contact Support.'));
        }
    }

    public string currentSection {get; set;}
    
    public Order getCurrentOrder(){
        system.debug('Get Current Order');
        system.debug(this.participantRecord.id);
        system.debug(participantRecord.id);
        Order[] orders = this.app.getOrders(this.participantRecord.id, this.form.Order_Status__c == null ? 'In Progress' : this.form.Order_Status__c);
        system.debug(orders);
        if(orders.size() != 0){
            return orders[0];
        }
        return null;
    }

    public pageReference submit(){
        if(this.app.getOrders(this.participantRecord.id, 'In Progress').size() != 0){
            return this.app.submit(this.app.getOrders(participantRecord.id, 'In Progress')[0], participantRecord.id, participantRecord.Organization__c, this.form.Case_Subject__c, this.form.Case_RecordType__c, this.form.Case_Description__c, this.form.Thank_You_Page__r.Clean_URL__c);
        }
        
        return null;
    }
    
    public map<String, String> lookupMap {get{if(this.lookupMap == null){this.lookupMap = new map<string, string>();} return this.lookupMap;} set;}
    
    public map<string, SelectOption[]> Options{
        get{
        if(this.options == null){
            map<string, SelectOption[]> output = new map<string, SelectOption[]>();
            for(Form_Section__c section : this.sections){
                for(Field__c field : section.fields__r){
                    if(field.Validation_Type__c == 'REFERENCE'){
                        if(output.get(field.reference__c) == null){
                            output.put(field.reference__c, new SelectOption[]{});
                            output.get(field.reference__c).add(new SelectOption('', '--N/A--'));
                        }
                    }
                }
            }
            for(String key :output.keySet()){
                //Generally, avoid doing queries in a for-loop, but this is required to get the values for lookup fields.
                for(SObject obj : Database.query('select id, name from '+key+' order by name asc')){
                    this.lookupMap.put((String)obj.get('id'), (String)obj.get('name'));
                    output.get(key).add( new SelectOption((String)obj.get('id'), (String)obj.get('name')));
                }
            }
            this.options = output;
        }
        return this.options;
        }
        set;
    }
    
    public PageReference doNothing() {
        //this method literally does nothing, and is used for rerender actions that don't require logic to be executed.
        if(this.currentSection == 'CANCELED'){
            if(String.isBlank(this.deleteRecordId)){
                this.deleteRecord();
            }
        }
        return null;
    }

}