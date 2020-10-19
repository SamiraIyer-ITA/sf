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
		String condition = 'PrimaryProductFamily__c != NULL '
							+ 'AND IsSyncing = TRUE '
							+ 'AND OpportunityId IN :opportunityIds';
		fflib_QueryFactory query = newQueryFactory()
			.setCondition(condition);
		new QuoteLineItemsSelector()
			.addQueryFactorySubselect(query, 'QuoteLineItems');
		return (List<Quote>) Database.query(query.toSOQL());
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