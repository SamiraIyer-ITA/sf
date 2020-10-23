/**
 * Quote fflib Selector
 *
 * @author Andrew La Russa
 */
public class QuotesSelector extends fflib_SObjectSelector implements IQuotesSelector {

	public static IQuotesSelector newInstance()  {
		return (IQuotesSelector) fflibext_Application.Selector.newInstance(Quote.SObjectType);
	}

	public List<Quote> selectById(Set<Id> idSet) {
		return (List<Quote>) selectSObjectsById(idSet);
	}

	public List<Quote> selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(Set<Id> opportunityIds) {
		fflib_QueryFactory quotesQueryFactory = newQueryFactory();

		fflib_QueryFactory lineItemsQueryFactory =
			new QuoteLineItemsSelector().
				addQueryFactorySubselect(quotesQueryFactory);

		new ProductsSelector().
			configureQueryFactoryFields(lineItemsQueryFactory, 'Product2');

		String condition = 'PrimaryProductFamily__c != NULL '
							+ 'AND IsSyncing = TRUE '
							+ 'AND OpportunityId IN :opportunityIds';

		return (List<Quote>)
				Database.query(
					quotesQueryFactory
						.setCondition(condition)
						.toSOQL());
	}

	private List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Quote.Id,
			Quote.IsSyncing,
			Quote.OpportunityId,
			Quote.PrimaryProductFamily__c,
			Quote.Record_Type_Developer_Name__c
		};
	}

	private Schema.SObjectType getSObjectType() {
		return Quote.SObjectType;
	}
}