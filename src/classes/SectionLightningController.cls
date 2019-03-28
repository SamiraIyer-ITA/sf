public with sharing class SectionLightningController {

    public static List<String> supportedObjects {get; set;}
    @AuraEnabled public static String actionType {get;set;}
    @AuraEnabled public static Form_Section__c myFormSection {get;set;}
    @AuraEnabled public static lightningWrapper myLightningWrapper {get;set;}

    public class lightningWrapper {
        @AuraEnabled public List<String> supportedObjects {get;set;}
        @AuraEnabled public Form_Section__c myFormSection {get;set;}
    }
        
    @AuraEnabled public static lightningWrapper getSectionInfo(String sectionId, String formId) {
        System.debug('sectionId: '+sectionId);
        System.debug('formid: '+formId);
        myLightningWrapper = new lightningWrapper();

        //Need parent Id
        if(sectionId == null) {
            actionType = 'New';
            if(formId != null) {
                Form__c objectAPI = [SELECT Object_API__c FROM Form__c WHERE Id =: formId];
                supportedObjects = MetadataHelper.getChildObjects(objectAPI.Object_API__c);
                myLightningWrapper.supportedObjects = supportedObjects;
                myLightningWrapper.myFormSection = new Form_Section__c();
            } else {
                supportedObjects = new List<String>();
                myLightningWrapper.supportedObjects = supportedObjects;
                myLightningWrapper.myFormSection = new Form_Section__c();

            }
            return myLightningWrapper;
        } else {
           actionType = 'Edit';
        }
        myFormSection = [SELECT Id,Name,Object_API_Name__c,Form__r.Object_API__c from Form_Section__c where Id =: sectionId];
        System.debug('Object API: '+myFormSection.Form__r.Object_API__c);
        supportedObjects = MetadataHelper.getChildObjects(myFormSection.Form__r.Object_API__c);
        myLightningWrapper.supportedObjects = supportedObjects;
        myLightningWrapper.myFormSection = myFormSection;
        System.debug('SupportedObjects:');
        for(String s : supportedObjects) {
            System.debug(s);
        }
        return myLightningWrapper;
    }
    
    @AuraEnabled public static String saveSection(Form_Section__c section) {
        if(section == null) { return 'Error'; }
        myFormSection = section;
        try {
            update section;
            return 'Success';
        } catch(Exception e) {
            //throw new AuraHandledException('e.getMessage');
            return e.getMessage();
        }
    }

    @AuraEnabled public static String newSection(Form_Section__c section) {
        if(section == null) { return 'Error'; }
        myFormSection = section;
        try {
            insert section;
            return 'Success';
        } catch(Exception e) {
            //throw new AuraHandledException('e.getMessage');
            return e.getMessage();
        }
    }

    public SectionLightningController() {

    }
}