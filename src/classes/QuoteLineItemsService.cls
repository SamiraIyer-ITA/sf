/**
 * Used primarily as dispatcher for generic or implementation specific methods
 *
 * @author Andrew La Russa
 */
public with sharing class QuoteLineItemsService {

	/**
	 * Call this for standard fflib functionality
	 *
	 * @return fflib standard quotelineitem service
	 */
	public static IQuoteLineItemsService service() {
		return (IQuoteLineItemsService) fflibext_Application.Service.newInstance(IQuoteLineItemsService.class);
	}

	/**
	 * Call this when you require functionality on specific or all service implementations
	 *
	 * @param records SObjects list
	 *
	 * @return Implementation specific service(s).
	 */
	public static QuoteLineItemsImplManager service(List<SObject> records) {
		return new QuoteLineItemsImplManager(records);
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all quotelineitem service implementations.
	 *
	 * @param records SObjects list
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records) {
		return new QuoteLineItemsImplManager(records).triggerService();
	}

	/**
	 * Calls the trigger service for a list of SObjects. Performs logic on all quotelineitem service implementations.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 *
	 * @return ITriggerImpl service
	 */
	@TestVisible private static ITriggerImpl triggerService(List<SObject> records, Map<Id, SObject> existingRecords) {
		return new QuoteLineItemsImplManager(records, existingRecords).triggerService();
	}

	public static void handleBeforeInsert(List<SObject> records) {
		triggerService(records).handleBeforeInsert();
	}

	public static void handleBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {
		triggerService(records, existingRecords).handleBeforeUpdate();
	}

	public static void handleBeforeDelete(List<SObject> records) {
		triggerService(records).handleBeforeDelete();
	}

	public static void handleAfterDelete(List<SObject> records) {
		triggerService(records).handleAfterDelete();
	}
}