/**
 * Contracts service implementation manager class.
 *
 * Required for contract service implementations. Can be customized by calling the base class methods.
 *
 * @author Daniel Haro
 */
public class ContractsImplManager extends SObjectsImplManager {

	/**
	 * Create a static map that can be called when specific implementations are needed.
	 */
	@TestVisible private static fflib_Application.ServiceFactory service = fflibext_Application.Service;

	/**
	 * Constructs the Contracts Manager using the base class records constructor.
	 *
	 * @param records SObject list
	 */
	public ContractsImplManager(List<SObject> records) {
		super(records);
	}

	/**
	 * Constructs the Contracts Manager using the base class records and existing records constructor.
	 *
	 * @param records SObjects list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 */
	public ContractsImplManager(List<SObject> records, Map<Id, SObject> existingRecords) {
		super(records, existingRecords);
	}
}
