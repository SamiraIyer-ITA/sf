/**
 * Leads Service Export implementation class
 *
 * @author Daniel Haro
 */
public with sharing class LeadsSvcExport extends SObjectsTriggerService implements ILeadsSvcExport {

    public override void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		updateAssignmentFieldsOnAssignmentChange(records, existingRecords);
	}

    public override void onAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		postToChatterWhenLeadAssigned(records, existingRecords);
        postToChatterWhenLeadCoverted(records, existingRecords);
	}

    public void updateAssignmentFieldsOnAssignmentChange(List<SObject> records, Map<Id, SObject> existingRecords) {
		LeadsSvcLibrary.updateAssignmentFieldsOnAssignmentChange(records, existingRecords);
	}

    public void postToChatterWhenLeadAssigned(List<SObject> records, Map<Id, SObject> existingRecords) {
		LeadsSvcLibrary.postToChatterWhenLeadAssigned(records, existingRecords);
	}

     public void postToChatterWhenLeadCoverted(List<SObject> records, Map<Id, SObject> existingRecords) {
		LeadsSvcLibrary.postToChatterWhenLeadCoverted(records, existingRecords);
	}
}
