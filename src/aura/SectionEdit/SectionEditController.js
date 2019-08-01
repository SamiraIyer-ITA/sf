({
     doInit : function(component, event, helper) {
        var action = component.get("c.getSectionInfo");
        var sectionId = component.get("v.recordId");
        var formId = null;
        if(sectionId != null) {
        	component.set("v.actionType","Edit ");
        } else {
            formId = component.find("sectionForm").get("v.value");
        }
        action.setParams({ sectionId : sectionId, formId : formId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var wrapperComponent = response.getReturnValue();
                component.set("v.wrapper",response.getReturnValue());
                component.set("v.section", response.getReturnValue().myFormSection);
                component.set("v.supportedObjects", response.getReturnValue().supportedObjects);
            }
         });
         $A.enqueueAction(action); 
    },
    
    onSave : function(component, event, helper) {
        var action = component.get("c.saveSection");
        var sectionToSave = component.get("v.section");
        var sectionComponent = component.find("edit");
        
        var Display_Order__c = component.find("sectionDisplayOrder").get("v.value");
        var Record_Type__c = component.find("sectionRecordType").get("v.value"); 
        var Form__c;
        var isNew = false;
        if(component.get("v.recordId") == null || typeof component.get("v.recordId") == 'undefined') {
            isNew = true;
			Form__c = component.find("sectionForm").get("v.value");
            action = component.get("c.newSection");
        } else {
            Form__c = component.find("sectionFormRO").get("v.value")
        }
        var Header__c = component.find("sectionHeader").get("v.value");
        var Instructions__c = component.find("sectionInstructions").get("v.value");       
        var Create__c = component.find("sectionCreate").get("v.value");
        var Update__c = component.find("sectionUpdate").get("v.value");
        var Delete__c = component.find("sectionDelete").get("v.value");
        var Where_Clause__c = component.find("sectionWhereClause").get("v.value");
        
        sectionToSave.Display_Order__c = Display_Order__c;
        sectionToSave.Record_Type__c = Record_Type__c;
        sectionToSave.Form__c = Form__c;
        sectionToSave.Header__c = Header__c;
        sectionToSave.Instructions__c = Instructions__c;
        sectionToSave.Create__c = Create__c;
        sectionToSave.Update__c = Update__c;
        sectionToSave.Delete__c = Delete__c;
        sectionToSave.Where_Clause__c = Where_Clause__c;
        delete sectionToSave.Form__r;
        
        action.setParams({ section: sectionToSave });
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
                            "scope": "Form_Section__c"
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
            "scope": "Form_Section__c"
        });
        homeEvt.fire();
    }
})