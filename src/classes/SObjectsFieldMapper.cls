/**
 * This is class is used to map values from SObject to another by using dynamic SObjects.
 *
 * Extend this class and provide the map of source fields to target fields and SObject type (which allows dynamic SObject
 * creation and to get a record type id)
 *
 * @author Andrew La Russa
 */
public abstract class SObjectsFieldMapper {

	private SObject targetRecord;
	private Schema.SObjectType targetSObjectType;
	private Map<String, String> targetFieldsBySourceFields;
	/**
	 * Since this uses the Utils method to cache the SObject type it will only get the map once for each
	 * SObject type. Called only when needed.
	 */
	private Map<String, Id> recordTypeIdsByNames {
		get {
			if (recordTypeIdsByNames == null) {
				recordTypeIdsByNames = Utils.getRecordTypeMapBySObject(targetSObjectType);
			}
			return recordTypeIdsByNames;
		}
		set;
	}
	// Map or the source object API field name to the target objects field API name
	public abstract Map<String, String> targetFieldsBySourceFields();
	// The target SObject type (used for the getting the record type Ids and dynamic SObject creation)
	public abstract Schema.SObjectType targetSObjectType();

	/**
	 * Constructor
	 *
	 * Sets the target SObject
	 */
	public SObjectsFieldMapper() {
		this(null);
	}

	/**
	 * Constructor
	 *
	 * Sets the target SObject and RecordTypeId by RecordType DeveloperName
	 *
	 * @param recordTypeDeveloperName Targe records record type's developer name
	 */
	public SObjectsFieldMapper(String recordTypeDeveloperName) {
		this.targetSObjectType = targetSObjectType();
		this.targetFieldsBySourceFields = targetFieldsBySourceFields();
		this.targetRecord = this.targetSObjectType.newSObject();
		if (recordTypeDeveloperName != null) {
			setRecordTypeIdByDeveloperName(recordTypeDeveloperName);
		}
	}

	/**
	 * Call this when you don't want to set the record type Id through the constructor.
	 *
	 * Scenario: There is logic that determines which record type to use.
	 *
	 * @param recordTypeDeveloperName RecordType.DeveloperName
	 */
	public void setRecordTypeIdByDeveloperName(String recordTypeDeveloperName) {
		this.targetRecord.put(
			'RecordTypeId',
			recordTypeIdsByNames.get(recordTypeDeveloperName)
		);
	}

	/**
	 * Override this method when you need to set values for the target record not dependent on the source record
	 *
	 * @param targetRecord Target record to be set
	 */
	public virtual void setAdditionalTargetRecordFields(SObject targetRecord) {}

	/**
	 * Override this method when you need to set values for the target record that are dependent on the source record
	 * criteria.
	 *
	 * @param sourceRecord Record that you are mapping to targetRecord
	 * @param targetRecord Target record to be set
	 */
	public virtual void setValuesBySourceRecordCriteria(SObject sourceRecord, SObject targetRecord) {}

	/**
	 * Gets the value of a SObject field (Supports parent field names in dot notation)
	 *
	 * Credit: Adrian Larson
	 *
	 * @param record Record that we are gettign the field value for
	 * @param field Field we are retrieving
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
	 * Gets the target SObject values using the abstract and virtual methods of this class. Use for inserts.
	 *
	 * @param sourceRecord Record that you are mapping to targetRecord
	 *
	 * @return SObject target record
	 */
	public SObject getTargetRecord(SObject sourceRecord) {
		setTargetRecord(sourceRecord, null);
		return this.targetRecord;
	}

	/**
	 * Gets the target SObject values using the abstract and virtual methods of this class. Use for updates.
	 *
	 * @param sourceRecord Record that you are mapping to targetRecord
	 * @param targetRecordId Target record Id
	 *
	 * @return SObject target record
	 */
	public SObject getTargetRecord(SObject sourceRecord, Id targetRecordId) {
		setTargetRecord(sourceRecord, targetRecordId);
		return this.targetRecord;
	}

	private void setTargetRecord(SObject sourceRecord, Id targetRecordId) {
		this.targetRecord.Id = targetRecordId == null ? null : targetRecordId;
		for (String field: this.targetFieldsBySourceFields.keySet()) {
			this.targetRecord.put(
				targetFieldsBySourceFields.get(field),
				get(sourceRecord, field)
			);
		}
		setAdditionalTargetRecordFields(this.targetRecord);
		setValuesBySourceRecordCriteria(sourceRecord, this.targetRecord);
	}
}