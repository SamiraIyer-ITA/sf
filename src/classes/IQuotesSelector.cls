/**
 * Quote fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IQuotesSelector extends fflib_ISObjectSelector {

	List<Quote> selectById(Set<Id> idSet);
	List<Quote> selectByQuoteLineItemsIsSyncingOppNotClosedIsPrimary(Set<Id> quoteLineItemIds);
	List<Quote> selectBySyncedQuotesAndOpportunitiesWithPrimaryLineItems(Set<Id> opportunityIds);
}