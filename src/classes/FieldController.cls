public with sharing class FieldController {
    public List<LayoutDescriberHelper.LayoutSection> layoutSections { get; set; }
    public List<SelectOption> supportedFieldList {get; set;}

    Form_Section__c form {get; set;}

    public FieldController(ApexPages.StandardController controller) {
        String sObjectType = 'Field__c';
        
        // Create list of fields to add to controller for object 
        List<String> fields = MetadataHelper.getFieldsForSobject(sObjectType);
        // Add fields to controller. This is to avoid the SOQL error in visualforce page
        if(!Test.isRunningTest()){
            controller.addFields(fields);
        }
        sObject obj = controller.getRecord();
        this.control = controller;
        Id sectionId = (Id)obj.get('Section__c');
        String parentObject = '';
        form = [SELECT Id, Object_API_Name__c, Form__r.Object_API__c FROM Form_Section__c WHERE Id =:sectionId];
        if(!String.IsBlank(form.Object_API_Name__c)) {
            parentObject = form.Object_API_Name__c;
        } else {
            parentObject = form.Form__r.Object_API__c;
        }
        supportedFieldList = MetadataHelper.getFieldListForObject(parentObject);
        /************************************************************************/
         //getting the default record type
        //if we want an specific layout we must provide the appropriate record type id
        id theRecordTypeIdToDescribe = LayoutDescriberHelper.getDefaultRecordType(obj);
        //get the layout section items
        layoutSections = LayoutDescriberHelper.describeSectionWithFields(theRecordTypeIdToDescribe, sObjectType);
        /***************************************************************************/
    }

    private final ApexPages.standardController control;
    
    public PageReference SetSystemOptions(){
        sObject obj = control.getRecord();
            Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
            Schema.sObjectType describedObject = globalDescribe.get(form.object_api_name__c != null ? form.object_api_name__c : form.form__r.Object_API__c);

            Schema.DescribeFieldResult field = describedObject.getDescribe().fields.getMap().get((string)obj.get('api__c')).getDescribe();
            if(field.getType() != Schema.DisplayType.BOOLEAN && !field.isNillable() && obj.get('required__c') != true){
                obj.put('required__c', true);
            }
            system.debug(field);
            obj.put('Validation_Type__c', field.getType().name());
            if(field.getType().name() == 'REFERENCE'){
                obj.put('Reference__c', field.getReferenceTo()[0].getDescribe().getName());
            }else{
                obj.put('Reference__c', '');
            }
            system.debug(obj);
        return null;
    }
}