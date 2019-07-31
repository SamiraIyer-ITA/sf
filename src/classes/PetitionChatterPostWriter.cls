/**
 * 
 *    Created by Joshua Moody & Skip Kleckner
 *    on Feb 28 2019
 *    MIL Corporation
 *    
 **/

public class PetitionChatterPostWriter extends ChatterPostWriter {
    
    //empty constructor for base class map
	public PetitionChatterPostWriter(){}
    
    //post templates from custom metadata
	private Map<String, Automated_Chatter_Post__mdt> postsMap = getPostsMap('Petition__c');
    
	//override your order logic for multiple post conditions
	public override void checkConditions(SObject newRecord, SObject oldRecord) {
		initiationExtensionChanged(newRecord, oldRecord);
		litigationChanged(newRecord, oldRecord);
	}
    
    //conditionally build a post for Initiation Extension changes
	@TestVisible private void initiationExtensionChanged(SObject newRecord, SObject oldRecord) {
		//Variables specific to this condition
		String extensionFieldName = 'Initiation_Extension_of_days__c';
		Map<String, String> calculationFieldNameToLabelMap = new Map<String, String> {'Calculated_Initiation_Signature__c' => 'Calculated Initiation Signature'};
		//check if condition is met
		Map<String,String> newToOldValueMap = fieldChanged(extensionFieldName, newRecord, oldRecord);
		//if condition is not met, return
		if(newToOldValueMap.isEmpty() || newRecord.get('Calculated_Initiation_Signature__c') == null) {
			return;
		}
		//get details from record
		String detailsFromRecord = addExtensionChangeToPost('Initiation', newToOldValueMap);
		detailsFromRecord += addExtensionResultToPost(calculationFieldNameToLabelMap, newRecord);
		//insert case info into post template
		String templateWithCaseInfo = addTemplateWithCaseInfo(newRecord, postsMap.get('Extension'));
		//add the standard details to post and add to post map
		finishPost(templateWithCaseInfo, detailsFromRecord, newRecord, false);
	}
    
    //conditionally build a post for a change in litigation fields
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
}