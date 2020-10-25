/**
 * QuoteLineItem fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IQuoteLineItemsSelector extends fflib_ISObjectSelector {

	List<QuoteLineItem> selectById(Set<Id> idSet);
	List<QuoteLineItem> selectByIdOppNotClosedServicesQuoteIsSyncingPrimaryWithOrderItems(Set<Id> idSet);
	List<QuoteLineItem> selectByIdWithProductFields(Set<Id> idSet);
}