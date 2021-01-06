/**
 * Opportunities service implementation manager class.
 *
 * Required for opportunity service implementations. Can be customized by calling the base class methods.
 *
 * @author Andrew La Russa
 */
public class OpportunitiesImplManager extends SObjectsImplManager {

	/**
	 * Create a static map that can be called when specific implementations are needed.
	 */
	@TestVisible private static fflib_Application.ServiceFactory service = fflibext_Application.Service;

	/**
	 * Constructs an the Opportunities Manager using the base class records constructor.
	 *
	 * @param records SObject list
	 */
	public OpportunitiesImplManager(List<SObject> records) {
		super(records);
	}

	/**
	 * Constructs an the Opportunities Manager using the base class records and existing records constructor.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 */
	public OpportunitiesImplManager(List<SObject> records, Map<Id, SObject> existingRecords) {
		super(records, existingRecords);
	}

	/**
	 * Call this when you need to call methods for IOpportunitiesSvcServices
	 *
	 * @return IOpportunitiesSvcServices
	 */
	public static IOpportunitiesSvcServices servicesService() {
		return (IOpportunitiesSvcServices) service.newInstance(IOpportunitiesSvcServices.class);
	}
}