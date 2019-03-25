({
     doInit : function(component, event, helper) {
        var action = component.get("c.getFieldInfo");
        var fieldId = component.get("v.recordId");
        var sectionId = null;
        if(fieldId != null) { //Field already exists, it must have a section
        	component.set("v.actionType","Edit ");
        } else {
            sectionId = component.find("fieldSection").get("v.value");
        }
        action.setParams({ fieldId : fieldId, sectionId : sectionId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapperComponent = response.getReturnValue();
                component.set("v.wrapper",response.getReturnValue());
                component.set("v.field", response.getReturnValue().myField);
                component.set("v.supportedObjects", response.getReturnValue().supportedObjects);
            }
         });
         $A.enqueueAction(action); 
    },
    
    onSave : function(component, event, helper) {
        console.log('onSave5');
        var action = component.get("c.saveField");
        var fieldToSave = component.get("v.field");
        var fieldComponent = component.find("edit");
        var Display_Order__c = component.find("fieldDisplayOrder").get("v.value");
        var Read_Only__c = component.find("fieldReadOnly").get("v.value");
        var Section__c;
        var isNew = false;
        if(component.get("v.recordId") == null || typeof component.get("v.recordId") == 'undefined') {
            isNew = true;
			Section__c = component.find("fieldSection").get("v.value");
            action = component.get("c.newField");
        } else {
            Section__c = component.find("fieldSectionRO").get("v.value");
        }
        var Instructions__c = component.find("fieldInstructions").get("v.value");       
        var Help_Text__c = component.find("fieldHelpText").get("v.value");
        var Field_Header__c = component.find("fieldHeader").get("v.value");
        var Required__c = component.find("fieldRequired").get("v.value");
        var List_Card_Display__c = component.find("fieldDisplayLocation").get("v.value");
        var Style__c = component.find("fieldClass").get("v.value");
        var Validation_Type__c= component.find("fieldValidationType").get("v.value");
        var Reference__c= component.find("fieldReference").get("v.value");
        
        fieldToSave.Display_Order__c = Display_Order__c;
        fieldToSave.Section__c = Section__c;
        fieldToSave.Read_Only__c = Read_Only__c;
        fieldToSave.Instructions__c = Instructions__c;
        fieldToSave.Help_Text__c = Help_Text__c;
        fieldToSave.Field_Header__c = Field_Header__c;
        fieldToSave.Required__c = Required__c;
        fieldToSave.List_Card_Display__c = List_Card_Display__c;
        fieldToSave.Style__c = Style__c;
        fieldToSave.Validation_Type__c = Validation_Type__c;
        fieldToSave.Reference__c = Reference__c;
        delete fieldToSave.Section__r;
        
        action.setParams({ field: fieldToSave });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var info = response.getReturnValue();
                if(info.startsWith('Success')) {
                    //Can't navigate directly to new object because of Lightning refresh error
					//Go to object home instead
                    var homeEvt = $A.get("e.force:navigateToSObject");
                    if(isNew) {
                        homeEvt = $A.get("e.force:navigateToObjectHome");
					    homeEvt.setParams({
                            "scope": "Field__c"
                        });
                    } else {
                        homeEvt.setParams({
                            "recordId": component.get("v.recordId"),
                            "slideDevName": "detail"
                        });
                    }
                    homeEvt.fire();
                } else {
                    component.set("v.message",info);                   
                }
            }
         });
        $A.enqueueAction(action); 
    },
    
    onCancel : function(component, event, helper) { 
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Field__c"
        });
        homeEvt.fire();
    }
})