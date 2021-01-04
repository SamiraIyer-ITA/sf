/**
 * QuoteLineItems Services service interface.
 *
 * @author Andrew La Russa
 */
public interface IQuoteLineItemsSvcServices extends IQuoteLineItemsSvcBase {

	void setFieldWhenProductIsPrimary(List<SObject> records);
	void updateRelatedOrderItems(List<SObject> records, Map<Id, SObject> existingRecords);
	void preventDeleteWhenPrimaryAndSynced(List<SObject> records);
	void deleteRelatedOrderItems(Set<Id> quoteLineItemIds);
	void setQuoteFieldsWhenPrimaryProductDeleted(List<SObject> records);
}