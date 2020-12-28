/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Daniel Haro
 */
public with sharing class LeadsService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard lead service
	 */
	public static ILeadsService service() {
		return (ILeadsService) fflibext_Application.Service.newInstance(ILeadsService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static LeadsImplManager service(List<SObject> records) {
		return new LeadsImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all lead service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new LeadsImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all lead service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new LeadsImplManager(records, existingRecords).triggerService();
	}

    public static void handleBeforeInsert(List<SObject> records) {
		triggerService(records).handleBeforeInsert();
	}

	public static void handleBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		triggerService(records, existingRecords).handleBeforeUpdate();
	}

    public static void handleAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		triggerService(records, existingRecords).handleAfterUpdate();
	}
}
