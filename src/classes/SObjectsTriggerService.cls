/**
 * Service implementations classes should extend this class to inherit base trigger service methods, which can be
 * overwritten. Follows fflib domain trigger pattern.
 *
 * @author Andrew La Russa
 */
public virtual with sharing class SObjectsTriggerService implements ISObjectsTriggerService {

	public virtual void onApplyDefaults(List<SObject> records) {}
	public virtual void onBeforeInsert(List<SObject> records) {}
	public virtual void onBeforeUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {}
	public virtual void onBeforeDelete(List<SObject> records) {}
	public virtual void onValidate(List<SObject> records) {}
	public virtual void onAfterInsert(List<SObject> records) {}
	public virtual void onValidate(List<SObject> records, Map<Id, SObject> existingRecords) {}
	public virtual void onAfterUpdate(List<SObject> records, Map<Id, SObject> existingRecords) {}
	public virtual void onAfterDelete(List<SObject> records) {}
	public virtual void onAfterUndelete(List<SObject> records) {}

}