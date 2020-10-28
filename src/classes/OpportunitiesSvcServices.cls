/**
 * Opportunities Service Services implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class OpportunitiesSvcServices extends SObjectsTriggerService implements IOpportunitiesSvcServices {

	public override void onBeforeInsert(List<SObject> records) {
		setStages(records);
	}

	public override void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		setStages(records, existingRecords);
		createContractOrderAndOrderItemsWhenSowApproved(records, existingRecords);
	}

	public void createContractOrderAndOrderItemsWhenSowApproved(Set<Id> opportunityIds) {
		Map<Id, Quote> syncedQuotesByIds = new Map<Id, Quote>(
			QuotesSelector.newInstance().selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(opportunityIds));
		List<Opportunity> opportunities = OpportunitiesSelector.newInstance()
			.selectByIdNoContractNoOrdersSowApproved(opportunityIds);
		List<ApprovedQuote> approvedQuotes = new List<ApprovedQuote>();
		for (Opportunity opp: opportunities) {
			if (syncedQuotesByIds.containsKey(opp.SyncedQuoteId)) {
				approvedQuotes.add(new ApprovedQuote(opp, syncedQuotesByIds.get(opp.SyncedQuoteId)));
			}
		}
		if (approvedQuotes.isEmpty()) {
			throw new OpportunitiesSvcServicesException(oppDoesNotMeetCriteriaError);
		}
		new SowApproval(approvedQuotes, false);
	}

	public void createContractOrderAndOrderItemsWhenSowApproved(
		List<SObject> records,
		Map<Id, SObject> existingRecords
	) {
		// Get only opportunities that changed to Proposal/Price Quote, are syncing, and do not have a contract/order
		Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>();
		Set<Id> opportunityIds = new Map<Id, SObject>(records).keySet();
		Set<Id> opportunityIdsWithOrders =
			Utils.getRecordsIdsByRelatedObjectRecords(
				(List<SObject>) OrdersSelector.newInstance()
					.selectOrdersByOpportunities(new Map<Id, SObject>(records).keySet()), Order.OpportunityId);
		Map<Id, Quote> syncedQuotesByIds = new Map<Id, Quote>(
			QuotesSelector.newInstance().selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(opportunityIds));
		List<ApprovedQuote> approvedQuotes = new List<ApprovedQuote>();
		for (Opportunity opp : (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.SOW_Approved__c && opp.SOW_Approved__c != existingOpp.SOW_Approved__c && opp.ContractId == null
					&& !opportunityIdsWithOrders.contains(opp.Id) && syncedQuotesByIds.containsKey(opp.SyncedQuoteId)
			) {
				approvedQuotes.add(new ApprovedQuote(opp, syncedQuotesByIds.get(opp.SyncedQuoteId)));
			}
		}
		if (!approvedQuotes.isEmpty()) {
			new SowApproval(approvedQuotes, true);
		}
	}

	public void setStages(List<SObject> records) {
		OpportunitiesStageLibrary.setServicesStages((List<SObject>) records);
	}

	public void setStages(List<SObject> records, Map<Id, SObject> existingRecords) {
		OpportunitiesStageLibrary.setServicesStages(records, existingRecords);
	}


	// Maps Opportunity fields to contracts to get the contract record to insert
	public static OpportunitySObjectMapper.ServicesNewContract servicesNewContract {
		get {
			if (servicesNewContract == null) {
				servicesNewContract = new OpportunitySObjectMapper.ServicesNewContract();
			}
			return servicesNewContract;
		}
		set;
	}

	// Maps Opportunity fields to orders to get the order record to insert
	public static OpportunitySObjectMapper.ServicesNewOrder servicesNewOrder {
		get {
			if (servicesNewOrder == null) {
				servicesNewOrder = new OpportunitySObjectMapper.ServicesNewOrder();
			}
			return servicesNewOrder;
		}
		set;
	}

	// Maps QuoteLineItems fields to order items to get the order item record to insert
	public static QuoteLineItemSObjectMapper.NewServicesOrderItem servicesNewOrderItem {
		get {
			if (servicesNewOrderItem == null) {
				servicesNewOrderItem = new QuoteLineItemSObjectMapper.NewServicesOrderItem();
			}
			return servicesNewOrderItem;
		}
		set;
	}

	/**
	 * Utility class to build a uow when the Sow is approved
	 */
	public class SoWApproval {

		public OpportunitySObjectMapper.ServicesNewContract newContract {get; private set;}
		public OpportunitySObjectMapper.ServicesNewOrder newOrder {get; private set;}
		public QuoteLineItemSObjectMapper.NewServicesOrderItem newOrderItem {get; private set;}

		public SowApproval(List<ApprovedQuote> approvedQuotes, Boolean isTrigger) {
			if (!approvedQuotes.isEmpty()) {
				this.newContract = servicesNewContract;
				this.newOrder = servicesNewOrder;
				this.newOrderItem = servicesNewOrderItem;
				buildUow(approvedQuotes, isTrigger);
			}
		}

		private void buildUow(List<ApprovedQuote> approvedQuotes, Boolean isTrigger) {
			fflibext_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
			List<SObject> recordsToInsert = new List<SObject>{};
			for (ApprovedQuote approvedQuote: approvedQuotes) {
				if (!approvedQuote.syncedQuote.QuoteLineItems.isEmpty()) {
					Opportunity opp = approvedQuote.opp;
					Order oppOrder = (Order) this.newOrder.getTargetRecord(approvedQuote.opp);
					Contract oppContract = (Contract) this.newContract.getTargetRecord(approvedQuote.opp);
					for (QuoteLineItem qli : approvedQuote.syncedQuote.QuoteLineItems) {
						if (qli.IsPrimary__c) {
							// Set contract SOW
							oppContract.Statement_of_Work__c = qli.Statement_of_Work__c;
							// Set order report status
							this.newOrder.setReportStatus(oppOrder, approvedQuote.syncedQuote.PrimaryProductFamily__c,
								qli.Product2.Name);
						}
						OrderItem qliOrderItem = (OrderItem) this.newOrderItem.getTargetRecord(qli);
						recordsToInsert.add(qliOrderItem);
						uow.registerRelationship(qliOrderItem, OrderItem.OrderId, oppOrder);
					}
					recordsToInsert.add(oppOrder);
					recordsToInsert.add(oppContract);
					// Register contract relationships
					uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
					// If this is a trigger we don't need to update, we can just set the value
					if (isTrigger) {
						uow.registerRelationship(opp, Opportunity.ContractId, oppContract);
					} else {
						uow.registerDirty(opp, Opportunity.ContractId, oppContract);
					}
					uow.registerDirty(approvedQuote.syncedQuote, Quote.ContractId, oppContract);
				}
			}
			if (!recordsToInsert.isEmpty()) {
				uow.registerNew(recordsToInsert);
				uow.commitWork();
			}
		}
	}

	/**
	 * Wrapper class that will hold a synced quote and the corresponding opportunity
	 */
	public class ApprovedQuote {

		public Opportunity opp {get; private set;}
		public Quote syncedQuote {get; private set;}

		public ApprovedQuote(Opportunity opp, Quote syncedQuote) {
			this.opp = opp;
			this.syncedQuote = syncedQuote;
		}
	}

	@TestVisible private static String oppDoesNotMeetCriteriaError =
		'The opportunity or opportunities do not meet the necessary criteria to create a Contract, Order, and Order '
		 + 'Items. Please check that the opportunity is synced to an approved services quote and does not have an '
		 + ' existing contract or order.';

	public class OpportunitiesSvcServicesException extends Exception {}
}