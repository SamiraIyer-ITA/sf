/**
 * Services service interface.
 *
 * @author Andrew La Russa
 */
public interface IOpportunitiesSvcServices extends IOpportunitiesSvcBase {

	void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records);
	void createContractsAndOrdersWhensNeedsAnalysis(List<SObject> records, Map<Id, SObject> existingRecords);
}