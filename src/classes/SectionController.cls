public with sharing class SectionController {
        public List<LayoutDescriberHelper.LayoutSection> layoutSections { get; set; }
        public List<String> supportedObjects {get; set;}
        public List<SelectOption> supportedObjectsList { get {
                List<SelectOption> supportedObjectsList = new List<SelectOption>();
                supportedObjectsList.add(new SelectOption('', '--Default From Parent--'));
                for(String s: supportedObjects) {
                        supportedObjectsList.add(new SelectOption(s, s));
                }
                return supportedObjectsList;
        } set; }
        public SectionController(ApexPages.StandardController controller) {
                String sObjectType = 'Form_Section__c';
                
                // Create list of fields to add to controller for object 
                List<String> fields = MetadataHelper.getFieldsForSobject(sObjectType);
                // Add fields to controller. This is to avoid the SOQL error in visualforce page
                if(!Test.isRunningTest()){
                    controller.addFields(fields);
                }
                sobject obj = controller.getRecord();
                system.debug(obj);
                Id formId = (Id)obj.get('Form__c');

                String parentObject = [SELECT Id, Object_API__c FROM Form__c WHERE Id =:formId].Object_API__c;
                supportedObjects = MetadataHelper.getChildObjects(parentObject);
                /************************************************************************/
                 //getting the default record type
                //if we want an specific layout we must provide the appropriate record type id
                id theRecordTypeIdToDescribe = LayoutDescriberHelper.getDefaultRecordType(obj);
                //get the layout section items
                layoutSections = LayoutDescriberHelper.describeSectionWithFields(theRecordTypeIdToDescribe, sObjectType);
                /***************************************************************************/
        
        }
}