public with sharing class FormController {
    //expose public property, this property will be listing each layout section
    public List<LayoutDescriberHelper.LayoutSection> layoutSections { get; set; }
    public List<String> supportedObjects {get; set;}
    public List<SelectOption> supportedObjectsList { get {
        List<SelectOption> supportedObjectsList = new List<SelectOption>();
        for(String s: supportedObjects) {
            supportedObjectsList.add(new SelectOption(s, s));
        }
        system.debug(supportedObjectsList);
        return supportedObjectsList;
    } set; }
    public FormController(ApexPages.StandardController controller) {
        supportedObjects = new List<String>();
        supportedObjects.add('Participation__c');

        String sObjectType = 'Form__c';
        // Create list of fields to add to controller for object 
        List<String> fields = MetadataHelper.getFieldsForSobject(sObjectType);
        // Add fields to controller. This is to avoid the SOQL error in visualforce page
        if(!Test.isRunningTest()){
            controller.addFields(fields);
        }
        sObject obj = controller.getRecord();

        /************************************************************************/
         //getting the default record type
        //if we want an specific layout we must provide the appropriate record type id
        id theRecordTypeIdToDescribe = LayoutDescriberHelper.getDefaultRecordType(obj);
        //get the layout section items
        layoutSections = LayoutDescriberHelper.describeSectionWithFields(theRecordTypeIdToDescribe, sObjectType);
        /***************************************************************************/
    }
}