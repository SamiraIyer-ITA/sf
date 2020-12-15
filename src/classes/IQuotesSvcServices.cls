/**
 * Quotes Services service interface.
 *
 * @author Andrew La Russa
 */
public interface IQuotesSvcServices extends IQuotesSvcBase {

	void updateOpportunitySOWAppproved(List<SObject> records, Map<Id, SObject> existingRecords);
}