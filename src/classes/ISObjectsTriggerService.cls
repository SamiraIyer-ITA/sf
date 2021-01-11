/**
 * Trigger service interface used for service implementations.
 * Used in service classes for trigger context calls. Uses fflib domain methodology.
 *
 * @author Andrew La Russa
 */
public interface ISObjectsTriggerService {

	void onApplyDefaults(List<SObject> records);
	void onBeforeInsert(List<SObject> records);
	void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords);
	void onBeforeDelete(List<SObject> records);
	void onValidate(List<SObject> records);
	void onAfterInsert(List<SObject> records);
	void onValidate(List<SObject> records, Map<Id, SObject> existingRecords);
	void onAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords);
	void onAfterDelete(List<SObject> records);
	void onAfterUndelete(List<SObject> records);

}