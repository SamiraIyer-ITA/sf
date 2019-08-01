/**
 * 
 *    Created by Joshua Moody & Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

public class InvestigationChatterPostWriter extends ChatterPostWriter {
    
    //empty constructor for base class map
    public InvestigationChatterPostWriter(){}
    
    //post templates from custom metadata
    private Map<String, Automated_Chatter_Post__mdt> postsMap = getPostsMap('Investigation__c');
    
    //override your order logic for multiple post conditions
    public override void checkConditions(SObject newRecord, SObject oldRecord) {
        prelimExtensionChanged(newRecord, oldRecord);
        finalExtensionChanged(newRecord, oldRecord);
        alignmentChanged(newRecord, oldRecord);
        litigationChanged(newRecord, oldRecord);
    }
    
    //conditionally build post for Prelim Extension changes
    @TestVisible private void prelimExtensionChanged(SObject newRecord, SObject oldRecord) {
        //Variables specific to this condition
        String extensionFieldName = 'Prelim_Extension_of_days__c';
        Map<String, String> calculationFieldNameToLabelMap = new Map<String, String> {'Calculated_Preliminary_Signature__c' => 'Calculated Preliminary Signature'};
        //check if condition is met
        Map<String,String> newToOldValueMap = fieldChanged(extensionFieldName, newRecord, oldRecord);
        //if condition is not met, return
        if(newToOldValueMap.isEmpty() || newRecord.get('Calculated_Preliminary_Signature__c') == null) {
            return;
        }
        //get details from record
        String detailsFromRecord = addExtensionChangeToPost('Preliminary', newToOldValueMap);
        detailsFromRecord += addExtensionResultToPost(calculationFieldNameToLabelMap, newRecord);
        //insert case info into post template
        String templateWithCaseInfo = addTemplateWithCaseInfo(newRecord, postsMap.get('Extension'));
        finishPost(templateWithCaseInfo, detailsFromRecord, newRecord, false);
    }
    
    //conditionally build post for Final Extension changes
    @TestVisible private void finalExtensionChanged(SObject newRecord, SObject oldRecord) {
                //Variables specific to this condition
        String extensionFieldName = 'Final_Extension_of_days__c';
        Map<String, String> calculationFieldNameToLabelMap = new Map<String, String> {'Calculated_Final_Signature__c' => 'Calculated Final Signature'};
        //check if condition is met
        Map<String,String> newToOldValueMap = fieldChanged(extensionFieldName, newRecord, oldRecord);
        //if condition is not met, return
        if(newToOldValueMap.isEmpty() || newRecord.get('Calculated_Final_Signature__c') == null) {
            return;
        }
        //get details from record
        String detailsFromRecord = addExtensionChangeToPost('Final', newToOldValueMap);
        detailsFromRecord += addExtensionResultToPost(calculationFieldNameToLabelMap, newRecord);
        //insert case info into post template
        String templateWithCaseInfo = addTemplateWithCaseInfo(newRecord, postsMap.get('Extension'));
        finishPost(templateWithCaseInfo, detailsFromRecord, newRecord, false);
    }
    
    //conditionally build post for litigation field(s) changes
    @TestVisible private void litigationChanged(SObject newRecord, SObject oldRecord) {
        //get details from record
        String detailsFromRecord = getLitigationStateChange(newRecord, oldRecord);
        //check if condition is met
        if ((fieldChanged('Litigation_YesNo__c', newRecord, oldRecord).isEmpty()
            && fieldChanged('Litigation_Resolved__c', newRecord, oldRecord).isEmpty())
            || (detailsFromRecord == 'No Change')) {
            return;
        }
        //insert case info into post template
        String templateWithCaseInfo = addTemplateWithCaseInfo(newRecord, postsMap.get('Litigation Change'));
        //add the standard details to post and add to post map
        finishPost(templateWithCaseInfo, detailsFromRecord, newRecord, false);
    }
    @TestVisible private void alignmentChanged(SObject newRecord, SObject oldRecord) {
        //Variables specific to this condition
        String alignmentLookupFieldName = 'AD_Investigation_Aligned_To__c';
        //check if condition is met
        Map<String, String> newToOldValueMap = fieldChanged(alignmentLookupFieldName, newRecord, oldRecord);
        if(newToOldValueMap.isEmpty()) {
            return;
        }
        //insert case info into post template
        String templateWithCaseInfo = addTemplateWithCaseInfo(newRecord, postsMap.get('Alignment'));
        String detailsFromRecord = addAlignmentChangeToPost(newToOldValueMap);
        //add the standard details to post and add to post map
        finishPost(templateWithCaseInfo, detailsFromRecord, newRecord, false);
    }
}