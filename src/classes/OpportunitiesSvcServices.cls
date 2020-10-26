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
		Map<Id, Opportunity> oppsByIds = new Map<Id, Opportunity>(
			OpportunitiesSelector.newInstance().selectByIdNoContractNoOrdersServicesQuoteApproved(opportunityIds));
		if (oppsByIds.isEmpty()) {
			throw new OpportunitiesSvcServicesException(oppDoesNotMeetCriteriaError);
		}
		buildOpportunityContractOrderOrderItemsUOW(oppsByIds, false);
	}

	public void createContractOrderAndOrderItemsWhenSowApproved(
		List<SObject> records,
		Map<Id, SObject> existingRecords
	) {
		// Get only opportunities that changed to Proposal/Price Quote, are syncing, and do not have a contract/order
		Map<Id, Opportunity> oppsByIds = new Map<Id, Opportunity>();
		Set<Id> opportunityIdsWithOrders =
			Utils.getRecordsIdsByRelatedObjectRecords(
				(List<SObject>) OrdersSelector.newInstance()
					.selectOrdersByOpportunities(new Map<Id, SObject>(records).keySet()), Order.OpportunityId);
		for (Opportunity opp : (List<Opportunity>) records) {
			Opportunity existingOpp = (Opportunity) existingRecords.get(opp.Id);
			if (opp.SOW_Approved__c && opp.SOW_Approved__c != existingOpp.SOW_Approved__c
					&& opp.SyncedQuoteId != null && opp.ContractId == null && !opportunityIdsWithOrders.contains(opp.Id)
			) {
				oppsByIds.put(opp.Id, opp);
			}
		}
		if (!oppsByIds.isEmpty()) {
			buildOpportunityContractOrderOrderItemsUOW(oppsByIds, true);
		}
	}

	public void setStages(List<SObject> records) {
		OpportunitiesStageLibrary.setServicesStages((List<SObject>) records);
	}

	public void setStages(List<SObject> records, Map<Id, SObject> existingRecords) {
		OpportunitiesStageLibrary.setServicesStages(records, existingRecords);
	}

	/**
	 * Inserts contracts, orders, and order items. Updates opportunities and quotes.
	 *
	 * @param oppsByIds Map of Opportunities that qualify for contract, order, and order items creation
	 * @param isTrigger Specifies is this was called via a trigger. If yes, true; otherwise, false
	 */
	private static void buildOpportunityContractOrderOrderItemsUOW(Map<Id, Opportunity> oppsByIds, Boolean isTrigger) {
		fflibext_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		List<SObject> recordsToInsert = new List<SObject>{};
		for (Quote syncedQuote :
			QuotesSelector.newInstance().selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(oppsByIds.keySet())
		) {
			if (!syncedQuote.QuoteLineItems.isEmpty()) {
				// Add contract and order
				Opportunity opp = oppsByIds.get(syncedQuote.OpportunityId);
				Order oppOrder = (Order) servicesNewOrder.getTargetRecord(opp);
				Contract oppContract = (Contract) servicesNewContract.getTargetRecord(opp);
				// Add OrderItems
				for (QuoteLineItem qli : syncedQuote.QuoteLineItems) {
					if (qli.IsPrimary__c) {
						// Set contract SOW
						oppContract.Statement_of_Work__c = qli.Statement_of_Work__c;
						// Set order report status
						servicesNewOrder.setReportStatus(oppOrder, syncedQuote.PrimaryProductFamily__c, qli.Product2.Name);
					}
					OrderItem qliOrderItem = (OrderItem) servicesNewOrderItem.getTargetRecord(qli);
					recordsToInsert.add(qliOrderItem);
					uow.registerRelationship(qliOrderItem, OrderItem.OrderId, oppOrder);
				}
				recordsToInsert.add(oppOrder);
				recordsToInsert.add(oppContract);
				// Register contract relationships
				uow.registerRelationship(opp, Opportunity.ContractId, oppContract);
				// If this is a trigger we don't need to update, we can just set the value
				if (isTrigger) {
					uow.registerRelationship(oppOrder, Order.ContractId, oppContract);
				} else {
					uow.registerDirty(oppOrder, Order.ContractId, oppContract);
				}
				uow.registerDirty(syncedQuote, Quote.ContractId, oppContract);
			}
		}
		if (!recordsToInsert.isEmpty()) {
			uow.registerNew(recordsToInsert);
			uow.commitWork();
		}
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

	@TestVisible private static String oppDoesNotMeetCriteriaError =
		'The opportunity or opportunities do not meet the necessary criteria to create a Contract, Order, and Order '
		 + 'Items. Please check that the opportunity is synced to an approved services quote and does not have an '
		 + ' existing contract or order.';

	public class OpportunitiesSvcServicesException extends Exception {}
}