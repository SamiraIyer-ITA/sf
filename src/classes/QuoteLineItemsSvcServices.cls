/**
 * QuoteLineItems Service Services implementation class
 *
 * @author Andrew La Russa
 */
public with sharing class QuoteLineItemsSvcServices extends SObjectsTriggerService implements IQuoteLineItemsSvcServices {

	public override void onBeforeInsert(List<SObject> records) {
		setFieldWhenProductIsPrimary(records);
	}

	public override void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		updateRelatedOrderItems(records, existingRecords);
	}

	public override void onBeforeDelete(List<SObject> records) {
		preventDeleteWhenPrimaryAndSynced(records);
		deleteRelatedOrderItems(new Map<Id, SObject>(records).keySet());
	}

	public override void onAfterDelete(List<SObject> records) {
		removeQuotePrimaryProductFamilyWhenDeleted(records);
	}

	public void setFieldWhenProductIsPrimary(List<SObject> records) {
		Map<Id, QuoteLineItem> quoteLineItemsByProductIds = new Map<Id, QuoteLineItem>();
		Set<Id> quoteIds = new Set<Id>();
		List<QuoteLineItem> quoteLineItemsToUpdate = new List<QuoteLineItem>();
		for (QuoteLineItem qli: (List<QuoteLineItem>) Records) {
			if (qli.IsPrimary__c) {
				quoteLineItemsByProductIds.put(qli.Product2Id, qli);
				quoteIds.add(qli.QuoteId);
			}
		}
		if (!quoteLineItemsByProductIds.isEmpty()) {
			fflibext_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
			Map<Id, Quote> quotesByIds = new Map<Id, Quote>(QuotesSelector.newInstance().selectById(quoteIds));
			for (Product2 product: ProductsSelector.newInstance().selectById(quoteLineItemsByProductIds.keySet())) {
				QuoteLineItem qli = quoteLineItemsByProductIds.get(product.Id);
				Quote quote = quotesByIds.get(qli.QuoteId);
				if (qli != null && quote != null) {
					qli.Client_Form_Type__c = product.Client_Form_Type__c;
					qli.Statement_of_Work__c = product.Statement_of_Work__c;
					if (quote.PrimaryProductFamily__c != null) {
						qli.addError(Label.Line_Item_One_Primary_Per_Quote);
					}
					quote.PrimaryProductFamily__c = product.Family;
					quote.Client_Form_Type__c = product.Client_Form_Type__c;
					uow.registerDirty(quote);
				}
			}
			uow.commitWork();
		}
	}

	public void updateRelatedOrderItems(List<SObject> records, Map<Id, SObject> existingRecords) {
		Set<Id> recordsByIds = new Map<Id, SObject>(Records).keySet();
		Map<Id, QuoteLineItem> quoteLineItemsByIds = new Map<Id, QuoteLineItem>(
			QuoteLineItemsSelector.newInstance()
				.selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(recordsByIds));
		if (!quoteLineItemsByIds.isEmpty()) {
			fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
			QuoteLineItemSObjectMapper.UpdateServicesOrderItem updateOrderItem =
				new QuoteLineItemSObjectMapper.UpdateServicesOrderItem();
			Set<String> fieldsToCheckThatChanged = new Set<String>{ 'Description', 'Quantity', 'ServiceDate', 'UnitPrice' };
			for (QuoteLineItem qli: (List<QuoteLineItem>) records) {
				if (Utils.getHasRecordChanged(fieldsToCheckThatChanged, qli, existingRecords.get(qli.Id))
						&& quoteLineItemsByIds.containsKey(qli.Id))
				{
					for (OrderItem orderItem: quoteLineItemsByIds.get(qli.Id).OrderItems) {
						uow.registerDirty(updateOrderItem.getTargetRecord(qli, orderItem.Id));
					}
				}
			}
			uow.commitWork();
		}
	}

	public void preventDeleteWhenPrimaryAndSynced(List<SObject> records) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		Set<Id> quoteIds = new Set<Id>();
		Map<Id, List<QuoteLineItem>> primaryQuoteLineItemsByQuoteIds = new Map<Id, List<QuoteLineItem>>();
		for (QuoteLineItem qli: (List<QuoteLineItem>) records) {
			if (qli.IsPrimary__c) {
				if (!primaryQuoteLineItemsByQuoteIds.containsKey(qli.QuoteId)) {
					primaryQuoteLineItemsByQuoteIds.put(qli.QuoteId, new List<QuoteLineItem>());
				}
				primaryQuoteLineItemsByQuoteIds.get(qli.QuoteId).add(qli);
			}
		}
		if (!primaryQuoteLineItemsByQuoteIds.isEmpty()) {
			Map<Id, Quote> quotesByIds = new Map<Id, Quote>(
				QuotesSelector.newInstance().selectById(primaryQuoteLineItemsByQuoteIds.keySet()));
			for (Id quoteId: primaryQuoteLineItemsByQuoteIds.keySet()) {
				Quote quote = quotesByIds.get(quoteId);
				if (quote.IsSyncing) {
					for (QuoteLineItem qli: primaryQuoteLineItemsByQuoteIds.get(quoteId)) {
						 qli.addError(Label.Line_Item_Cannot_Be_Deleted);
					}
				}
			}
		}
	}

	public void deleteRelatedOrderItems(Set<Id> quoteLineItemIds) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		List<OrderItem> orderItemsToDelete = new List<OrderItem>();
		for (QuoteLineItem qli:
			 QuoteLineItemsSelector.newInstance()
				.selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(quoteLineItemIds)
		) {
			for (OrderItem orderItem: qli.OrderItems) {
				orderItemsToDelete.add(orderItem);
			}
		}
		if (!orderItemsToDelete.isEmpty()) {
			uow.registerDeleted(orderItemsToDelete);
			uow.commitWork();
		}
	}

	public void removeQuotePrimaryProductFamilyWhenDeleted(List<SObject> records) {
		fflib_ISObjectUnitOfWork uow = fflibext_Application.UnitOfWork.newInstance();
		Set<Id> quoteIds = new Set<Id>();
		for (QuoteLineItem qli: (List<QuoteLineItem>) records) {
			if (qli.IsPrimary__c) {
				quoteIds.add(qli.QuoteId);
			}
		}
		for (Quote quote: QuotesSelector.newInstance().selectById(quoteIds)) {
			quote.PrimaryProductFamily__c = null;
			uow.registerDirty(quote);
		}
		uow.commitWork();
	}
}