/**
 * Trigger service implementation service classed used in conjunction with SObjectsImplManager class to before trigger
 * operations on map of records/existing records by interface. Uses fflib domain trigger logic.
 *
 * @author Andrew La Russa
 */
public with sharing class TriggerImpl implements ITriggerImpl {

	private Map<String, System.Type> interfaceTypeByKey;
	private Map<System.Type, List<SObject>> recordsByInterfaceType;
	private Map<System.Type, Map<Id, SObject>> existingRecordsByInterfaceType;
	@TestVisible private static fflib_Application.ServiceFactory service = fflibext_Application.Service;

	/**
	 * Constructs the Trigger Service with the necessary mapping and data to before trigger context methods.
	 *
	 * @param interfaceTypeByKey Interfaces by the implementation key
	 * @param recordsByInterfaceType Records by interface
	 * @param existingRecordsByInterfaceType Existing records by interface
	 */
	public TriggerImpl(
		Map<String, System.Type> interfaceTypeByKey,
		Map<System.Type, List<SObject>> recordsByInterfaceType,
		Map<System.Type, Map<Id, SObject>> existingRecordsByInterfaceType
	) {
		this.interfaceTypeByKey = interfaceTypeByKey;
		this.recordsByInterfaceType = recordsByInterfaceType;
		this.existingRecordsByInterfaceType = existingRecordsByInterfaceType;
	}

	public void handleBeforeInsert() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List<SObject> records = this.recordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onApplyDefaults(records);
				triggerService.onBeforeInsert(records);
			}
		}
	}

	public void handleBeforeUpdate() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				Map <Id, SObject> existingRecords = this.existingRecordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onBeforeUpdate(records, existingRecords);
			}
		}
	}

	public void handleBeforeDelete() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onBeforeDelete(records);
			}
		}
	}

	public void handleAfterInsert() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onValidate(records);
				triggerService.onAfterInsert(records);
			}
		}
	}

	public void handleAfterUpdate() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				Map <Id, SObject> existingRecords = this.existingRecordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onValidate(records);
				triggerService.onValidate(records, existingRecords);
				triggerService.onAfterUpdate(records, existingRecords);
			}
		}
	}

	public void handleAfterDelete() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (this.recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onAfterDelete(records);
			}
		}
	}

	public void handleAfterUndelete() {
		for (System.Type interfaceType: this.recordsByInterfaceType.keySet()) {
			if (recordsByInterfaceType.get(interfaceType) != null) {
				List <SObject> records = this.recordsByInterfaceType.get(interfaceType);
				ISObjectsTriggerService triggerService = (ISObjectsTriggerService) service.newInstance(interfaceType);
				triggerService.onAfterUndelete(records);
			}
		}
	}
}