/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Andrew La Russa
 */
public with sharing class ProductsService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard product service
	 */
	public static IProductsService service() {
		return (IProductsService) fflibext_Application.Service.newInstance(IProductsService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static ProductsImplManager service(List<SObject> records) {
		return new ProductsImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all product service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new ProductsImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all product service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new ProductsImplManager(records, existingRecords).triggerService();
	}

	public static void handleBeforeInsert(List<SObject> records) {
		triggerService(records).handleBeforeInsert();
	}
}