/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Daniel Haro
 */
public with sharing class ContractsService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard contract service
	 */
	public static IContractsService service() {
		return (IContractsService) fflibext_Application.Service.newInstance(IContractsService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static ContractsImplManager service(List<SObject> records) {
		return new ContractsImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all contract service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new ContractsImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all contract service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new ContractsImplManager(records, existingRecords).triggerService();
	}
}