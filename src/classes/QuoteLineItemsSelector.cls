/**
 * QuoteLineItem fflib Selector
 *
 * @author Andrew La Russa
 */
public class QuoteLineItemsSelector extends fflib_SObjectSelector implements IQuoteLineItemsSelector {

	public static IQuoteLineItemsSelector newInstance()  {
		return (IQuoteLineItemsSelector) fflibext_Application.Selector.newInstance(QuoteLineItem.SObjectType);
	}

	public List<QuoteLineItem> selectById(Set<Id> idSet) {
		return (List<QuoteLineItem>) selectSObjectsById(idSet);
	}

	public List<QuoteLineItem> selectByIdWithProductFields(Set<Id> idSet) {
		fflib_QueryFactory quoteLineItemsQueryFactory = newQueryFactory();

		new ProductsSelector().configureQueryFactoryFields(quoteLineItemsQueryFactory, 'Product2');

		return (List<QuoteLineItem>)
				Database.query(
					quoteLineItemsQueryFactory.setCondition('id in :idSet')
						.toSOQL());
	}

	public List<QuoteLineItem> selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(Set<Id> idSet) {
		String condition = 'Quote.PrimaryProductFamily__c != null '
							+ 'AND Quote.IsSyncing = TRUE '
							+ 'AND Quote.RecordType.DeveloperName =  \'Services\' '
							+ 'AND Quote.Opportunity.IsClosed = FALSE '
							+ 'AND Id IN :idSet';
		fflib_QueryFactory query = newQueryFactory()
			.setCondition(condition);
		new OrderItemsSelector()
			.addQueryFactorySubselect(query, 'OrderItems');
		return (List<QuoteLineItem>) Database.query(query.toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			QuoteLineItem.Id,
			QuoteLineItem.Accounting_Code__c,
			QuoteLineItem.Description,
			QuoteLineItem.ListPrice,
			QuoteLineItem.PricebookEntryId,
			QuoteLineItem.Product2Id,
			QuoteLineItem.Quantity,
			QuoteLineItem.QuoteId,
			QuoteLineItem.ServiceDate,
			QuoteLineItem.TotalPrice,
			QuoteLineItem.UnitPrice,
			QuoteLineItem.IsPrimary__c,
			QuoteLineItem.Statement_of_Work__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return QuoteLineItem.SObjectType;
	}
}