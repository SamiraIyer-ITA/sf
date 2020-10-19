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
    
    public List<QuoteLineItem> selectByIdAndRecordTypeOppNotClosedQuoteIsSyncingPrimaryWithOrderItems(Set<Id> idSet, String recordTypeDeveloperName) {
        String condition = 'Quote.PrimaryProductFamily__c != null '
            			 	+ 'AND Quote.IsSyncing = TRUE '
            			 	+ 'AND Quote.RecordType.DeveloperName = :recordTypeDeveloperName '
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
            QuoteLineItem.UnitPrice
		};
	}

	private Schema.SObjectType getSObjectType() {
		return QuoteLineItem.SObjectType;
	}
}