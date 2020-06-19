/**
 * Opportunities Service class that can be called by implementations when they share the same exact methodology.
 */
public with sharing class OpportunitiesSvcLibrary {

	public static Id orderServicesRecordTypeId
		= Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();

	public static Id contractParticipationAgreementRecordTypeId
		= Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName()
			.get('Participation_Agreement').getRecordTypeId();

	private static Contract getNeedsAnalysisContract(Opportunity opp) {
		return new Contract(
			AccountId = opp.AccountId,
			RecordTypeId = contractParticipationAgreementRecordTypeId,
			StartDate = opp.CloseDate,
			ContractTerm = 12
		);
	}

	private static Order getNeedsAnalysisOrder(Opportunity opp) {
		return new Order(
			OpportunityId = opp.Id,
			AccountId = opp.AccountId,
			Status = 'Draft',
			EffectiveDate = opp.CloseDate,
			RecordTypeId = orderServicesRecordTypeId
		);
	}

	public static void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		for (Opportunity opp : (List<Opportunity>) records.deepClone()) {
			if (opp.StageName == 'Needs Analysis') {
				Contract oppContract = getNeedsAnalysisContract(opp);
				Order oppOrder = getNeedsAnalysisOrder(opp);
				// Using a list so we verify in our mock test
				uow.registerNew(new List<SObject>{oppContract, oppOrder });
				uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
				uow.registerDirty(opp, Opportunity.ContractId, oppContract);
			}
		}
		uow.commitWork();
	}

	public static void createContractsAndOrdersWhensNeedsAnalysis(
		List<SObject> records,
		Map<Id, SObject> existingRecords
	) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		List<Order> ordersByOpportunities
			= OrdersSelector.newInstance().selectOrdersByOpportunities(new Map<Id, SObject>(records).keySet());
		Set<Id> opportunityIdsWithOrders
			= Utils.getParentIdsByRelatedObjectRecords((List<SObject>) ordersByOpportunities, Order.OpportunityId);
		for (Opportunity opp: (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.StageName != existingOpp.StageName && opp.StageName == 'Needs Analysis') {
				// Create a order/contract if one does not already exist for this opportunity
				if (!opportunityIdsWithOrders.contains(opp.Id) && opp.ContractId == null) {
					Contract oppContract = getNeedsAnalysisContract(opp);
					Order oppOrder = getNeedsAnalysisOrder(opp);
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