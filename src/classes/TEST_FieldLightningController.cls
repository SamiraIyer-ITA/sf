@isTest(seeAllData=false)
public class TEST_FieldLightningController{

    static testmethod void TEST_NoSectionNoForm(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        FieldLightningController controller = new FieldLightningController();
        FieldLightningController.lightningWrapper myLightningWrapper = FieldLightningController.getFieldInfo(null,null);
        System.assertEquals(new Field__c(),myLightningWrapper.myField);
    } 
    
    static testmethod void TEST_NoField(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        FieldLightningController controller = new FieldLightningController();
        FieldLightningController.lightningWrapper myLightningWrapper = FieldLightningController.getFieldInfo(null,mySection.Id);
        System.assertEquals(new Field__c(),myLightningWrapper.myField);
    }
    
    static testmethod void TEST_HasFieldAndSection(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        FieldLightningController controller = new FieldLightningController();
        FieldLightningController.lightningWrapper myLightningWrapper = FieldLightningController.getFieldInfo(myField.Id,mySection.Id);
        System.assertEquals(myField.Id,myLightningWrapper.myField.Id);
    }
    
    static testmethod void TEST_HasFieldAndSectionAPI(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id,Object_API_Name__c='Artifact__c');
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        FieldLightningController controller = new FieldLightningController();
        FieldLightningController.lightningWrapper myLightningWrapper = FieldLightningController.getFieldInfo(myField.Id,mySection.Id);
        System.assertEquals(myField.Id,myLightningWrapper.myField.Id);
    }
    
    static testmethod void TEST_CreateField(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Field_Header__c='header',Section__c=mySection.Id);
        FieldLightningController.newField(myField);
        Field__c myField2 = [select Id,Field_Header__c from Field__c where Field_Header__c =: 'header'];
        System.assertEquals('header',myField2.Field_Header__c);
    }
    
    static testmethod void TEST_SaveField(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        myField.Field_Header__c = 'header2';
        FieldLightningController.saveField(myField);
        Field__c myField2 = [select Field_Header__c from Field__c where Id =: myField.Id];
        system.assertEquals('header2',myField2.Field_Header__c);
    }
    
    static testmethod void TEST_CreateFieldException(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Field_Header__c='header',Section__c=mySection.Id,Display_Order__c=250);
        FieldLightningController.newField(myField);
        List<Field__c> myField2 = [select Id from Field__c where Field_Header__c =: 'header'];
        System.assertEquals(0,myField2.size());
    }
    
    static testmethod void TEST_SaveFieldException(){
        Form__c myForm = new Form__c();
        insert myForm;
        Form_Section__c mySection = new Form_Section__c(Header__c='header',Form__c = myForm.Id);
        insert mySection;
        Field__c myField = new Field__c(Section__c=mySection.Id, Field_Header__c='header');
        insert myField;
        myField.Field_Header__c = 'header2';
        myField.Display_Order__c = 250;
        FieldLightningController.saveField(myField);
        Field__c myField2 = [select Field_Header__c from Field__c where Id =: myField.Id];
        system.assertNotEquals('header2',myField2.Field_Header__c);
        system.assertEquals('header',myField2.Field_Header__c);
    } 
}