/**
 * Opportunities Service Services implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class OpportunitiesSvcServices extends SObjectsTriggerService implements IOpportunitiesSvcEvents {

	public override void onBeforeInsert(List<SObject> records) {
		setStages(records);
	}

	public override void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		setStages(records, existingRecords);
		createContractsAndOrdersWhensNeedsAnalysis(records, existingRecords);
	}

	public override void onAfterInsert(List<SObject> records) {
		createContractsAndOrdersWhensNeedsAnalysis(records);
	}

	public void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records, Map<Id, SObject> existingRecords) {
		OpportunitiesSvcLibrary.createContractsAndOrdersWhensNeedsAnalysis(records, existingRecords);
	}

	public void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records) {
		OpportunitiesSvcLibrary.createContractsAndOrdersWhensNeedsAnalysis(records);
	}
    
    public void setStages(List<SObject> records) {
		OpportunitiesStageLibrary.setServicesStages((List<SObject>) records);
	}

	public void setStages(List<SObject> records, Map<Id, SObject> existingRecords) {
		OpportunitiesStageLibrary.setServicesStages(records, existingRecords);
	}

}