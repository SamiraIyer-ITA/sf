/**
* Created by cal smith on 8/16/2017.
*/

public with sharing class Describer {

    public String getChildkey() {
        return null;
    }
/*
    public String getAreCalculatedFields() {
        return null;
    }
*/    
    // perform global describe to get ALL Objects
    @testVisible private static map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    public list <Pair> pairFields {public get; public set;}
    public list <SelectOption> objectNames{get; private set;}
    public list <SelectOption> profileNames{public get; private set;}
    public string selectedObject {get; set;}
    public string selectedProfile {get; set;}
    public map<string,string>fieldName2FieldType {set; get;}
    // public Schema.DescribeSObjectResult descrSObject;
    @testvisible private map<String,map<string,string>>objectRecordTypeInfosByName {private get; private set;}
    @testVisible private SObject obj {private get; private set;}
    @testVisible private map<String, Schema.SObjectField> fieldMap {private get; private set;}
    public static Schema.DescribeFieldResult fieldDescribe {private get; private set;}
    //public boolean isNamePointing {get; set;} 
    //public boolean hasReferenceTo {get; set;}
    public map<string,map<string,string>>objectToCRUDPerms {get; set;}
    public map<string, string>objectToCRUD{get;set;} 
    public map<String,string>recordTypeMapByName {get; set;}
    public set<string> recordTypeMapkeyset {get; set;}
    public list<pair> areCreateableFields  {get; set;}    
    public list<pair> areUpdateableFields {get; set;} 
    public list<pair> areReadOnlyFields  {get; set;}
    public list<pair> areAccessibleFields  {get;set;}
    public map<string, string> areChildRelationships  {get; set;}
    public list<pair> areNamePointingFields  {get; set;}    
    public map<string, string> areReferenceToFields  {get; set;}
    public list<pair> areDefaultedOnCreateFields  {get; set;}
    public list<pair> areIdLookupFields  {get; set;}
    public list<pair> areExternalIDFields  {get; set;}
    public list<pair> areUniqueFields  {get; set;}
    public list<pair> areIncludedFields  {get; set;}
    private set<pair>includedFields = new set<pair>();        
    public list<pair> areNillableFields   {get; set;}
    public list<pair> areExcludedFields  {get; set;}
//    public list<pair> areCalculatedFields  {get; set;}

	public static map<string,schema.describefieldresult>pairFieldkey2FieldDescribe = new map<string,schema.describefieldresult>();
    @testvisible private map<string, string> areRefObjNameToRefObjField  {get; set;}
    @testvisible private map<string,string>FieldType2childRelFieldName = new map<string,string>();
    @testvisible private map<string,string>currentfield2targetfield = new map<string,string>();
    @testvisible private map<string,string>childRelField2RelName = new map<string,string>();
    @testvisible private map<string,string>childRelFieldName2FieldType = new map<string,string>();
    @testvisible private map<string,string>childRelationFieldNameToType = new map<string,string>();

    //public map<pair,schema.describefieldresult>pairfield2dfield = new map<pair,schema.describefieldresult>(); 

    // Intialize objectNames and pairFields
    public Describer() {
        objectNames = initObjNames();
        pairFields = new List<Pair>();
        profileNames = initProfileNames();
    }
    
    // Populate SelectOption list -
    // find all sObjects available in the organization
    @testvisible private List<SelectOption> initObjNames() {
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(globalDescribe.keySet());
        entities.sort();
        for(String name : entities) objNames.add(new SelectOption(name,name));
        return objNames;
    }
    
    // Find the pairFields for the selectedObject object
    public void showFields() {
        pairFields.clear();
        system.debug('Sel Object Value : ' + selectedObject);
        fieldMap = globalDescribe.get(selectedObject).getDescribe().fields.getMap();
        obj = getSelectedSObject(selectedObject);
        //Map <String,Schema.SObjectField> fieldMap = globalDescribe.get(selectedObject).getDescribe().fields.getMap();
        Schema.DescribeSObjectResult descrSObject=getdescribeSObject(selectedObject);
        createPairs(fieldMap);
        objectToCRUDPerms=getSObjectToCRUD(selectedObject);
        recordTypeMapByName=getRecordTypeInfosbyName(selectedObject);
        recordTypeMapkeyset = recordTypeMapByName.keyset();
        //objectRecordTypeInfosByName.put(selectedObject,recordTypeMapByName);
        hasChildRelationships(selectedObject);
        getCreateable(fieldMap);
        getUpdateable(fieldMap);
        getAccessible(fieldMap);
        getReadOnly(fieldMap);
        getIdLookups(fieldMap);
        getNamePointing(fieldMap);
        getDefaultedOnCreate(fieldMap);
        getUnique(fieldMap);
        getExternalID(fieldMap);
        getExcluded(fieldMap);
        getNillable(fieldMap);
        if(areCreateableFields != null) includedFields.addAll(areCreateableFields);
        if(areUpdateableFields != null) includedFields.addAll(areUpdateableFields);
        if(areAccessibleFields != null) includedFields.addAll(areAccessibleFields);
        areIncludedFields = new list<pair>();
        if(includedFields != null) areIncludedFields.addAll(includedFields); 
        if(createable != null) includedFlds.addAll(createable);
        if(updateable != null) includedFlds.addAll(updateable);
        if(accessible != null) includedFlds.addAll(accessible);
        //included = new list<pair>();
        if(includedFlds != null) included.addAll(included); 
        
        //if(areIncludedFields != null) system.debug('number of included fields : ' + areIncludedFields.size());
        

//        Map <String, Schema.SObjectField> fieldMap = fieldMapFor(selectedObject);
    }
    
    public class Pair {
        public String key {get; set;}
        public String val {get; set;}
    }
    
    public static SObject getSelectedSObject(string selObject){
        Schema.SObjectType tobjectType = globalDescribe.get(selObject);
        SObject obj = tobjectType.newSObject();
        return obj;
    }
    
    public Schema.DescribeSObjectResult getdescribeSObject(string selObject) {
       return globalDescribe.get(selObject).getDescribe();
    }
    
    public list<PermissionSet>allPerms = [SELECT Id, Label, Name, ProfileId, Profile.Name
                                          FROM PermissionSet];
    
    public list<PermissionSet>permsInProfiles = [SELECT Id, Label, Name, ProfileId, Profile.Name, IsOwnedByProfile
                                                 FROM PermissionSet
                                                 WHERE IsOwnedByProfile = TRUE];
    
    public list<PermissionSet>permsNotInProfiles = [SELECT Id, Label, Name, ProfileId, Profile.Name, IsOwnedByProfile
                                                    FROM PermissionSet
                                                    WHERE IsOwnedByProfile = FALSE];
    
    public list<ObjectPermissions>addedObjPerms = [SELECT Id, ParentId, PermissionsRead, SobjectType
                                                   FROM ObjectPermissions
                                                   WHERE Parent.IsOwnedByProfile = False];
    
    public list<ObjectPermissions>objPermsFromProfiles = [SELECT Id,ParentId, PermissionsRead, SobjectType, Parent.ProfileId
                                                          FROM ObjectPermissions
                                                          WHERE Parent.IsOwnedByProfile = TRUE];
    
    public list <Profile> allUserProfiles = [Select Id, Name, UserType from Profile ORDER BY Usertype, Name];
    
    //  We'll want to choose which profile to run this for  // ***this needs to be selectedProfile***
    public Profile userProfile = [Select Id, Name, UserType from Profile where Name = 'System Administrator'];
    
    // create select option list of user profiles
    @testvisible private List<SelectOption> initProfileNames() {
        List<SelectOption> profileNames = new List<SelectOption>();
        allUserProfiles.sort();
        For(Profile p:allUserProfiles){
            profileNames.add(new SelectOption(p.Id,p.Name));    
        }
        Return profileNames;        
    }
    
    // After Object Selected, will want to get FieldMapCache
    @testvisible private static Map<String, Map<String, Schema.SObjectField>> FieldMapCache = new Map<String, Map<String, Schema.SObjectField>>();
    
    // Key: sobject.field
    // Value: first picklist value
    @testvisible private Map<String, String> defaultPicklistValue = new Map<String, String>();
    
    @testvisible private map<string,map<string,string>> getSObjectToCRUD(string selObject){
        Schema.SObjectType tobjectType = globalDescribe.get(selObject);
        map<string,map<string,string>>sObjectToCRUD = new map<string,map<string,string>>();
        string objectName = String.valueOf(tobjectType).tolowercase();
        system.debug('objectName : ' + objectName);
        map<string,string>objToCRUD = new map<string,string>();
        objToCRUD=getObjectToCRUD(objectName);
        sObjectToCRUD.put(objectName,getObjectToCRUD(objectName));
        return sObjectToCRUD;
    }
    
    @testvisible private map<string, string> getObjectToCRUD(string selObject) {
        Schema.DescribeSObjectResult descrSObject = getdescribeSObject(selObject);
        map<string,string>objectToCRUD = new map<string,string>(); 
        objectToCRUD.put('isAccessible', string.ValueOf(descrSObject.isAccessible()));
        system.debug('isAccessible : ' + descrSObject.isAccessible());
        objectToCRUD.put('isCreateable', string.ValueOf(descrSObject.isCreateable()));
        system.debug('isCreateable : ' + descrSObject.isCreateable());
        objectToCRUD.put('isDeletable', string.ValueOf(descrSObject.isDeletable()));
        system.debug('isDeletable : ' + descrSObject.isDeletable());
        objectToCRUD.put('isUndeletable', string.ValueOf(descrSObject.isUndeletable()));
        system.debug('isUndeletable : ' + descrSObject.isUndeletable());
        objectToCRUD.put('isUpdateable', string.ValueOf(descrSObject.isUpdateable()));
        system.debug('isUpdateable : ' + descrSObject.isUpdateable());  
        return objectToCRUD;
        //filter pairFields thru this
    }
    
    @testvisible public map<String,string> getRecordTypeInfosbyName(string selObject){
        map<string,Schema.RecordTypeInfo>rT2FieldMapbyName = new map<string,Schema.RecordTypeInfo>();
        rT2FieldMapbyName=getdescribeSObject(selObject).getRecordTypeInfosByName();
        map<string,string>stringRT2FieldMapbyName = new map<string, string>();
        for(string key:rT2FieldMapbyName.keyset()){
            stringRT2FieldMapbyName.put(key,string.ValueOf(rT2FieldMapbyName.get(key)));    
        }
        
        return stringRT2FieldMapbyName;
        
        //for(Schema.RecordTypeInfo.  )
        //objectRecordTypeInfosByName = new map<string,map<string,string>>();
        //objectRecordTypeInfosByName.put(selObject,stringRT2FieldMapbyName);               
        
    }
    
    
    @testvisible public boolean hasChildRelationships(string selObject){
        boolean selfreference = false;
        Schema.DescribeSObjectResult descrSObject = globalDescribe.get(selObject).getDescribe();
        Schema.ChildRelationship[] relations = descrSObject.getChildRelationships();
        map<string,string>childRelationFieldNameToType = new map<string,string>();  
        if (!relations.isEmpty()) {
            for(Schema.ChildRelationship relation:relations){
                string referenceObjectType = relation.getRelationshipName();                                
                
                if (referenceObjectType == 'RecordType'){
                    //### could possibly get the results from the recordtypeinfos!!###
                    
                    recordTypeMapByName = getRecordTypeInfosbyName(selObject);
                    
                    for(string rtn:recordTypeMapByName.keyset()){
                        system.debug(rtn +' : ' + recordTypeMapByName.get(rtn));
                        childRelFieldName2FieldType.put(referenceObjectType, string.valueOf(relation.getField().getDescribe()));                            
                    }
                    
                    Schema.sObjectType childRelType = relation.getChildSObject();
                    Schema.SObjectField childRelField = relation.getField(); 
                    Schema.DescribeFieldResult childFieldResult = relation.getField().getDescribe();
                    FieldType2childRelFieldName.put(string.valueOf(childFieldResult.getSObjectField()),referenceObjectType );
                    string relName = relation.getRelationshipName();
                    childRelField2RelName.put(string.valueOf(childRelField),relName);                           
                    
                    
                } else if (referenceObjectType == 'Profile') {
                    
                    Schema.sObjectType childRelType = relation.getChildSObject();
                    Schema.SObjectField childRelField = relation.getField(); 
                    Schema.DescribeFieldResult childFieldResult = relation.getField().getDescribe();
                    FieldType2childRelFieldName.put(string.valueOf(childFieldResult.getSObjectField()), referenceObjectType);                           
                    string relName = relation.getRelationshipName();
                    childRelField2RelName.put(string.valueOf(childRelField),relName);
                    currentfield2targetfield.put(string.ValueOf(childRelField),childFieldResult.getReferenceTargetField());
                    
                } else if (referenceObjectType != descrSObject.getName()) {
                    // do something; create object reference   
                    system.debug(descrSObject.getName());
                    
                    Schema.sObjectType childRelType = relation.getChildSObject();
                    Schema.SObjectField childRelField = relation.getField(); 
                    Schema.DescribeFieldResult childFieldResult = relation.getField().getDescribe();
                    FieldType2childRelFieldName.put(string.valueOf(childFieldResult.getSObjectField()),referenceObjectType);                            
                    string relName = relation.getRelationshipName();
                    childRelField2RelName.put(string.valueOf(childRelField),relName);
                    currentfield2targetfield.put(string.ValueOf(childRelField),childFieldResult.getReferenceTargetField());
                    
                } else if(referenceObjectType == descrSObject.getName()){ //(selfreference = true)
                    // do something else;
                    system.debug(referenceObjectType + ' : ' + descrSObject.getName());
                    selfreference = true;
                    childRelFieldName2FieldType.put(referenceObjectType, 'self reference');                     
                }
                
                
            } // end for loop => Schema.ChildRelationship relation:relations
            
        } // end if (!relations.isEmpty())
        
        if(childRelFieldName2FieldType != null) childRelationFieldNameToType.putAll(childRelFieldName2FieldType);
        
        return !childRelationFieldNameToType.isEmpty() ? true : false;
        // FIX THIS names == null ? false : names.contains(names.getName());
    }
    

    /**
Returns a field map for a given sobject. 

Note : this method is kept public for Test cases to share the same field map info, without requiring a field desribe.

@param string selectedObject (objectType - sobject api name) for ex. Account
@returns FieldMap [Key:FieldName,Value:Schema.SObjectField]
*/
    @testvisible private static map<String, Schema.SObjectField> fieldMapFor(String selObject) {
        SObject obj = getSelectedSObject(selObject);
        Map<String, Schema.SObjectField> fieldMap = null;
        String normalizedObjectType = selObject.toLowerCase();
        
        if (FieldMapCache.containsKey(normalizedObjectType)) {
            fieldMap = FieldMapCache.get(normalizedObjectType);
        } else {
            fieldMap = globalDescribe.get(selObject).getDescribe().fields.getMap();
            // cache it for next use
            FieldMapCache.put(normalizedObjectType, fieldMap);
        }
        
        return fieldMap;
    }
    
    @testvisible private string getDefaultPicklistValue(string selObject, Schema.DescribeFieldResult fieldDescribe) {
        SObject obj=getSelectedSObject(selObject);
        String key = obj.getSObjectType() + '.' + fieldDescribe.getName();
        
        if (!defaultPicklistValue.containsKey(key)) {
            List<Schema.PicklistEntry> entries = fieldDescribe.getPicklistValues();
            String value = entries.size() > 0 ? entries[0].getValue() : null;
            defaultPicklistValue.put(key, value);
        }
        
        return defaultPicklistValue.get(key);
    }
    //filter pairFields thru this
    
    //  Of Interest:
    //  isCalculated()  isAutoNumber()  isNamePointing()  getReferenceTo()  isUpdateable()  isUnique()  isNillable()  isIdLookup()  isExternalID()
    //  getPicklistValues()  getReferenceTargetField()  getRelationshipName()  getRelationshipOrder()  getSOAPType()
    //  Reference  ID  Time



	public static list<schema.describefieldresult>createable = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>updateable = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>accessible = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>autoNumber = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>calculated = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>readOnly = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>idLookup = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>namePointing = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>defaultedOnCreate = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>unique = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>externalID = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>exclField = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>nillable = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>included = new list<schema.describefieldresult>();
	public static list<schema.describefieldresult>includedFlds = new list<schema.describefieldresult>();


    private void createPairs(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            pairFieldkey2FieldDescribe.put(pairField.key,fieldDescribe);
        
            pairFields.add (pairField);
                                    
            i++;
            system.debug('count = ' + i);

        }
    }   
        
    private void getNillable(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areNillableFields = new list<pair>();
        
            try{
                if(fieldDescribe.isNillable()){
                    nillable.add(fieldDescribe); 
                    areNillableFields.add(pairField);
                    system.debug('nillable : ' + i);// + fieldDescribe.getName() //areIncludedFields.add(pairField);
                }
            }catch(nullpointerexception e){
                system.debug('nillible is null : ' + i);
            }

            system.debug('count = ' + i);
            i++;
        }
    }               

    private void getCreateable(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areCreateableFields = new list<pair>();

            try{
                if(fieldDescribe.isCreateable()){
                    createable.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areCreateableFields.add(pairField);
                    //areIncludedFields.add(pairField);
                    system.debug('Createable : ' + i); // + fieldDescribe.getName()
                } 
            }catch(nullpointerexception e){
                system.debug('isCreateable is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;
        }
    }   

    private void getUpdateable(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areUpdateableFields = new list<pair>();

            try{            
                if(fieldDescribe.isUpdateable()){ 
                    updateable.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areUpdateableFields.add(pairField);
                    //areIncludedFields.add(pairField);
                    system.debug('Updateable : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isUpdateable is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;
            
        }
    }   

    private void getAccessible(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areAccessibleFields = new list<pair>();

            try{            
                if(fieldDescribe.isAccessible()){ 
                    accessible.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areAccessibleFields.add(pairField);                 
                    //areIncludedFields.add(pairField);
                    system.debug('Accessible : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isAccessible is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;

        }
    }
    
    private void getReadOnly(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areReadOnlyFields = new list<pair>();
            
            try{            
                if(fieldDescribe.isAutoNumber()){
                    readOnly.add(fieldDescribe);
                    areReadOnlyFields.add(pairField);
                    //system.debug('AutoNumber : ' + i);
                    system.debug('ReadOnly : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isAutoNumber is null : ' + i);
            }       

            try{            
                if(fieldDescribe.isCalculated()){
                    readOnly.add(fieldDescribe);
                    //areCalculatedFields.add(pairField);
                    areReadOnlyFields.add(pairField);
                    //system.debug('Calculated : ' + i);
                    system.debug('ReadOnly : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isCalculated is null : ' + i);
            }

            system.debug('count = ' + i);
            i++;

        }
    }           
            
    private void getIdLookups(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areIdLookupFields = new list<pair>();
            
            try{            
                if(fieldDescribe.isIdLookup()){    
                    idLookup.add(fieldDescribe);
                    areIdLookupFields.add(pairField);
                    system.debug('IdLookup : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isIdLookup is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;

        }
    }   
        
    private void getNamePointing(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areNamePointingFields = new list<pair>();
            
            try{            
                if(fieldDescribe.isnamePointing()){ 
                    namePointing.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areNamePointingFields.add(pairField);
                    //areIncludedFields.add(pairField);                    
                    //areReferenceToFields.put(fieldDescribe.getName(),string.ValueOf(fieldDescribe.getReferenceTo()));
                    system.debug('NamePointing : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isnamePointing is null : ' + i);
            }       

			try{
				if(fieldDescribe.isnamePointing()){
                    areReferenceToFields.put(fieldDescribe.getName(),string.ValueOf(fieldDescribe.getReferenceTo()));
					system.debug('areReferenceToFields : ' + i);
				}
			}catch(nullpointerexception e){
				system.debug('Name Pointing but areReferenceToFields is null : ' + i);
			}	
				
			try{
				if(fieldDescribe.isnamePointing()){
					areRefObjNameToRefObjField.put(selectedObject,fieldDescribe.getName());
					system.debug('areRefObjNameToRefObjField : ' + i);
				}		
			}catch(nullpointerexception e){
				system.debug('Name Pointing but areRefObjNameToRefObjField is null : ' + i);		
			}									
					
            system.debug('count = ' + i);
            i++;

        }
    }

    private void getDefaultedOnCreate(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areDefaultedOnCreateFields = new list<pair>();
            
            try{            
                if(fieldDescribe.isDefaultedOnCreate()){    
                    defaultedOnCreate.add(fieldDescribe);
                    areDefaultedOnCreateFields.add(pairField);
                    system.debug('DefaultedOnCreate : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isDefaultedOnCreate is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;

        }
    }   

    private void getUnique(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areUniqueFields = new list<pair>();

            try{            
                if(fieldDescribe.isUnique()){
                    unique.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areUniqueFields.add(pairField);
                    //areIncludedFields.add(pairField);
                    system.debug('Unique : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isUnique is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;

        }
    }       
    
    private void getExternalID(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areExternalIdFields = new list<pair>();
                
            try{            
                if(fieldDescribe.isExternalID()){
                    externalId.add(fieldDescribe);
                    //included.add(fieldDescribe);
                    areExternalIdFields.add(pairField);
                    //areIncludedFields.add(pairField);
                    system.debug('ExternalID : ' + i);
                }
            }catch(nullpointerexception e){
                system.debug('isExternalID is null : ' + i);
            }       

            system.debug('count = ' + i);
            i++;

        }
    }

    private void getExcluded(map <String, Schema.SObjectField> fieldMap){
        integer i=0;            
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult fieldDescribe =  sfield.getDescribe();
            Pair pairField = new Pair ();
            pairField.key = fieldDescribe.getname ();
            pairField.val = fieldDescribe.getType () + ' : ' + fieldDescribe.getLabel ();
            areExcludedFields = new list<pair>();
            
            // if account, check for person account fields
            try{
                if(ExcludedFields.get('All').contains(fieldDescribe.getName())) {
                    exclField.add(fieldDescribe);
                    areExcludedFields.add(pairField);
                    //system.debug('Is Excluded Field for ALL : ' + fieldDescribe.getName());
                    system.debug('Is Excluded Field for ALL : ' + i);
                }   
            }catch (nullpointerexception e){
                system.debug('not an All Objects excluded field : ' + i );
            }

            try{
                if(isExcludedField(selectedObject,fieldDescribe)){
                    exclField.add(fieldDescribe); 
                    areExcludedFields.add(pairField);
                    system.debug('Is Excluded field : ' + i  );
                    //system.debug('Is Excluded field : ' + isExcludedField(selectedObject,fieldDescribe) + ' object : ' + selectedObject + ' fieldDescribe : ' + fieldDescribe.getName() );
                }
            }catch(nullpointerexception e){
                system.debug('not a User or Account Object excluded field : ' + i );
            }
            
            try{
                if(selectedObject == 'account' && isPersonAccountField(fieldDescribe)){
                    exclField.add(fieldDescribe); 
                    areExcludedFields.add(pairField);
                    system.debug('Is Excluded person acct field : ' + i);
                }   
            }catch (nullpointerexception e){
                system.debug('not person account : ' + i );
            }

            i++;
            system.debug('count = ' + i);
        }
        
    }
    
    static boolean isExcludedField(Schema.DescribeFieldResult fieldDescribe) {
        return ExcludedFields.get('All').contains(fieldDescribe.getName()) ? true:false;
    }

    static boolean isExcludedField(string selObject, Schema.DescribeFieldResult fieldDescribe) {
        SObject obj = getSelectedSObject(selObject);
        set<String> fields = ExcludedFields.get(obj.getSObjectType().getDescribe().getName());
        return fields.contains(fieldDescribe.getName()) ? true : false ;
    }    

    static boolean isPersonAccountField(Schema.DescribeFieldResult fieldDescribe) {
        Boolean isPersonAccountEnabled = fieldMapFor('Account').get('IsPersonAccount') != null;
        set<string> skipPersonAccountFields = new set<string>{ 'Salutation' };
            
        Boolean CustomPerson = fieldDescribe.isCustom() && fieldDescribe.getName().endsWith('pc');
        Boolean StandardPerson = !fieldDescribe.isCustom() && fieldDescribe.getName().startsWith('Person');
        
        return (CustomPerson || StandardPerson || 
            (isPersonAccountEnabled && skipPersonAccountFields.contains(fieldDescribe.getName()))) ? true:false ;
    }
    
    public static map<String, set<String>> ExcludedFields = new map<String, set<String>>{
        'All' => new set<String>{'OwnerId', 'LastModifiedById', 'CreatedById', 'LastModifiedDate', 'CreatedDate'},
        'Account' => new set<String>{'FirstName', 'LastName'},
        'User' => new set<String>{'IsActive','DelegatedApproverId','CallCenterId','ContactId','DelegatedApproverId','ManagerId','UserRoleId','FederationIdentifier'}
    };
    
    public with sharing class UnsupportedObjectTypeException extends Exception {
        
    }
    
}