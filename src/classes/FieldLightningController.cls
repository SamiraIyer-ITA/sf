public with sharing class FieldLightningController {

    public static List<String> supportedObjects {get; set;}
    @AuraEnabled public static String actionType {get;set;}
    @AuraEnabled public static Field__c myField {get;set;}
    @AuraEnabled public static lightningWrapper myLightningWrapper {get;set;}

    public class lightningWrapper {
        @AuraEnabled public List<String> supportedObjects {get;set;}
        @AuraEnabled public Field__c myField {get;set;}
    }
        
    @AuraEnabled public static lightningWrapper getFieldInfo(String fieldId, String sectionId) {
        String objectAPIString = '';
        System.debug('fieldId: '+fieldId);
        System.debug('sectionid: '+sectionId);
        myLightningWrapper = new lightningWrapper();

        //Need parent Id, don't always have it
        if(fieldId == null) {
            actionType = 'New';
            if(sectionId != null) {
                Form_Section__c objectAPI = [SELECT Object_API_Name__c,Form__r.Object_API__c FROM Form_Section__c WHERE Id =: sectionId];
                objectAPIString = (objectAPI.Object_API_Name__c == null || objectAPI.Object_API_Name__c == '' ? objectAPI.Form__r.Object_API__c : objectAPI.Object_API_Name__c);
                supportedObjects = MetadataHelper.getChildObjects(objectAPIString);
                myLightningWrapper.supportedObjects = supportedObjects;
                myLightningWrapper.myField = new Field__c();
            } else {
                supportedObjects = new List<String>();
                myLightningWrapper.supportedObjects = supportedObjects;
                myLightningWrapper.myField = new Field__c();

            }
            return myLightningWrapper;
        } else {
           actionType = 'Edit';
        }
        myField = [SELECT Id,Name,Section__c,Section__r.Object_API_Name__c,API__c from Field__c where Id =: fieldId];
        if(myField.Section__r.Object_API_Name__c == null || myField.Section__r.Object_API_Name__c == '') {
            objectAPIString = [SELECT Id,Name,Form__r.Object_API__c from Form_Section__c where Id =: myField.Section__c].Form__r.Object_API__c;
        } else {
            objectAPIString = myField.Section__r.Object_API_Name__c;
        }
        supportedObjects = MetadataHelper.getChildObjects(objectAPIString);
        myLightningWrapper.supportedObjects = supportedObjects;
        myLightningWrapper.myField = myField;
        return myLightningWrapper;
    }
    
    @AuraEnabled public static String saveField(Field__c field) {
        if(field == null) { return 'Error'; }
        myField = field;
        try {
            update field;
            return 'Success';
        } catch(Exception e) {
            //throw new AuraHandledException('e.getMessage');
            return e.getMessage();
        }
    }

    @AuraEnabled public static String newField(Field__c field) {
        if(field == null) { return 'Error'; }
        myField = field;
        try {
            insert field;
            return 'Success';
        } catch(Exception e) {
            //throw new AuraHandledException('e.getMessage');
            return e.getMessage();
        }
    }

    public FieldLightningController() {

    }
}