/**
 * Quotes Service Services implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class QuotesSvcServices extends SObjectsTriggerService implements IQuotesSvcServices {

	public override void onAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		updateOpportunitySOWAppproved(records, existingRecords);
	}

	public void updateOpportunitySOWAppproved(List<SObject> records, Map<Id, SObject> existingRecords) {
		Map<Id, Quote> quotesByOpportunityIds = new Map<Id, Quote>();
		for (Quote quote: (List<Quote>) records) {
			Quote existingQuote = (Quote) existingRecords.get(quote.Id);
			if (quote.Status == 'Approved' && quote.Status != existingQuote.Status) {
			   quotesByOpportunityIds.put(quote.OpportunityId, quote);
			}
		}
		if (!quotesByOpportunityIds.isEmpty()) {
			fflibext_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
			for (Opportunity opp: OpportunitiesSelector.newInstance().selectById(quotesByOpportunityIds.keySet())) {
				if (opp.Record_Type_Developer_Name__c == 'Services') {
					/*
					 * You cannot directly update this opportunity as you will receive a trigger read only error in
					 * regards to the SyncedQuoteId (which we queried for). In this case we create a new Opportunity
					 * with the Id and SOW_Approved__c field to update.
					 */
					uow.registerDirty(new Opportunity(Id = opp.Id, SOW_Approved__c = true));
				}
			}
			uow.commitWork();
		}
	}
}