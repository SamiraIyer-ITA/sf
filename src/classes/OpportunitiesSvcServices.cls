/**
 * Opportunities Service Services implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class OpportunitiesSvcServices extends SObjectsTriggerService implements IOpportunitiesSvcEvents {

	public override void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		createContractsAndOrdersWhensNeedsAnalysis(records, existingRecords);
	}

	public void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records, Map<Id, SObject> existingRecords) {
		OpportunitiesSvcLibrary.createContractsAndOrdersWhensNeedsAnalysis(records, existingRecords);
	}
}