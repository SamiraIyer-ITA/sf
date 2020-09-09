public abstract class SObjectsFieldMapper {

	private Schema.SObjectType targetSObjectType;
	// Call this to get a target SObject's RecordTypeId from it's DeveloperName
	public Map<String, Id> recordTypeIdsByNames;

	// Map or the source object API field name to the target objects field API name
	public abstract Map<String, String> targetFieldsBySourceFields();
	// The target SObject type (used for the getting the record type Ids and dynamic SObject creation)
	public abstract Schema.SObjectType targetSObjectType();

	/**
	 * Constructor
	 *
	 * Sets the target SObject type and RecordTypeId map
	 */
	public SObjectsFieldMapper() {
		targetSObjectType = targetSObjectType();
		recordTypeIdsByNames = Utils.getRecordTypeMapBySObject(targetSObjectType);
	}

	/**
	 * Override this method when you need to set values for the target record
	 */
	public virtual void setAdditionalTargetRecordFields(SObject targetRecord) {}

	/**
	 * Override this method when you need to set values for the target record that are dependent on the source record
	 * criteria.
	 */
	public virtual void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {}

	/**
	 * Gets the value of a SObject field (Supports parent field names in dot notation)
	 *
	 * Credit: Adrian Larson
	 *
	 * @return Object value of a given SObject field
	 */
	private static Object get(SObject record, String field) {
		if (record == null) return null;
		if (!field.contains('.')) return record.get(field);
		return get(
			record.getSObject(field.substringBefore('.')),
			field.substringAfter('.')
		);
	}

	/**
	 * Gets the target SObject values using the abstract and virtual methods of this class
	 *
	 * @return SObject target record
	 */
	public SObject getTargetRecord(SObject sourceRecord) {
		SObject targetRecord = targetSObjectType.newSObject();
		Map<String, String> targetFieldsBySourceFields = targetFieldsBySourceFields();
		for (String field: targetFieldsBySourceFields.keySet()) {
			targetRecord.put(
				targetFieldsBySourceFields.get(field),
				get(sourceRecord, field)
			);
		}
		setAdditionalTargetRecordFields(targetRecord);
		setValuesBySourceRecordCriteria(sourceRecord, targetRecord);
		return targetRecord;
	}
}