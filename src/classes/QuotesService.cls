/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Andrew La Russa
 */
public with sharing class QuotesService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard quote service
	 */
	public static IQuotesService service() {
		return (IQuotesService) fflibext_Application.Service.newInstance(IQuotesService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static QuotesImplManager service(List<SObject> records) {
		return new QuotesImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all quote service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new QuotesImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all quote service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new QuotesImplManager(records, existingRecords).triggerService();
	}

	public static void handleAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		triggerService(records, existingRecords).handleAfterUpdate();
	}
}