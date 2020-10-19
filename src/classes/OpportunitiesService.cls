/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Andrew La Russa
 */
public with sharing class OpportunitiesService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard opportunity service
	 */
	public static IOpportunitiesService service() {
		return (IOpportunitiesService) fflibext_Application.Service.newInstance(IOpportunitiesService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static OpportunitiesImplManager service(List<SObject> records) {
		return new OpportunitiesImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all opportunity service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new OpportunitiesImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all opportunity service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new OpportunitiesImplManager(records, existingRecords).triggerService();
	}

	public static void handleBeforeInsert(List<SObject> records) {
		triggerService(records).handleBeforeInsert();
	}

	public static void handleBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		triggerService(records, existingRecords).handleBeforeUpdate();
	}
}