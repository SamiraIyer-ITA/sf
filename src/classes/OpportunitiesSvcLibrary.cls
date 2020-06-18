/**
 * Opportunities Service class that can be called by implementations when they share the same exact methodology.
 */
public with sharing class OpportunitiesSvcLibrary {

	public static Id orderServicesRecordTypeId
		= Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();

	/**
	 * Gets a list of opportunity Ids based on list of related records
	 *
	 * @param relatedRecords Records related to opportunity
	 * @param opportunityField The opportunity field on the related record
	 *
	 * @return Set of related opportunity Ids
	 */
	public static Set<Id> getOpportunityIdsByRelatedObjectRecords(
		List<SObject> relatedRecords,
		Schema.SObjectField opportunityField
	) {
		Set<Id> opportunityIds = new Set<Id>();
		for (SObject record: relatedRecords) {
			opportunityIds.add((Id)record.get(opportunityField));
		}
		return opportunityIds;
	}

	public static void createContractsAndOrdersWhensNeedsAnalysis(
		List<SObject> records,
		Map<Id, SObject> existingRecords
	) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		List<Order> ordersByOpportunities
				= OrdersSelector.newInstance().selectOrdersByOpportunities(new Map<Id, SObject>(records).keySet());
		Set<Id> opportunityIdsWithOrders
				= getOpportunityIdsByRelatedObjectRecords((List<SObject>) ordersByOpportunities, Order.OpportunityId);
		for (Opportunity opp: (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.StageName != existingOpp.StageName && opp.StageName == 'Needs Analysis') {
				// Create a order if one does not already exist for this opportunity
				if (!opportunityIdsWithOrders.contains(opp.Id) && opp.ContractId == null) {
					Contract oppContract = new Contract(
						AccountId = opp.AccountId
					);
					Order oppOrder = new Order(
						OpportunityId = opp.Id,
						AccountId = opp.AccountId,
						Status = 'Draft',
						EffectiveDate = opp.CloseDate,
						RecordTypeId = orderServicesRecordTypeId
					);
					// Using a list so we verify in our mock test
					uow.registerNew(new List<SObject>{ oppContract, oppOrder });
					uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
					uow.registerRelationship(opp, Opportunity.ContractId, oppContract);
				}
			}
		}
		uow.commitWork();
	}
}