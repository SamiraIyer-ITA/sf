/**
 * Base implementation manager class.
 *
 * This class is used to build a map of service interface implementation to a list or map of SObjects as well as a
 * trigger service (which is called by the service class).
 *
 * Each class the extends must provide a Service Implementation SObject name which is used by the fflib Application
 * Factory Service custom metadata to build the implementation key to interface. This can be used to filter a list of
 * records to build the interface to list of records.
 *
 * @author Andrew La Russa
 */
public abstract with sharing class SObjectsImplManager {

	private ImplWrapper implWrapper;

	// Service Implementation SObject developer name
	public abstract String serviceImplementationSObjectName();

	/**
	 * Constructs SObjects Impl Manager with a custom implementation not based on custom metadata
	 *
	 * @param implWrapper ImplWrapper class
	 */
	public SObjectsImplManager(ImplWrapper implWrapper) {
		this.implWrapper = implWrapper;
	}

	/**
	 * Constructs SObjects Impl Manager to build a map of interfaces to lists of SObjects
	 *
	 * @param records SObject list
	 */
	public SObjectsImplManager(List<SObject> records) {
		this.implWrapper = new ImplWrapper(new ImplMapper(serviceImplementationSObjectName()), records, null);
	}

	/**
	 * Constructs SObjects Impl Manager to build a map of interfaces to lists of SObjects/Map of SObjects
	 *
	 * @param records SObject list
	 * @param existingRecords Map of existing records (Trigger.oldMap)
	 */
	public SObjectsImplManager(List<SObject> records, Map<Id, SObject> existingRecords) {
		this.implWrapper = new ImplWrapper(new ImplMapper(serviceImplementationSObjectName()), records, existingRecords);
	}

	/**
	 * Getter used to create an instance of the TriggerImpl class to run implementation trigger servcies
	 */
	public TriggerImpl triggerService {
		get {
			if (triggerService == null) {
				triggerService = new TriggerImpl(implWrapper.mapper.interfaceTypeByKey, implWrapper.recordsByInterfaceType,
					implWrapper.existingRecordsByInterfaceType);
			}
			return triggerService;
		}
		private set;
	}

	public Map<String, System.Type> getInterfaceTypeByKey() {
		return this.implWrapper.mapper.interfaceTypeByKey;
	}

	public Map<System.Type, List<SObject>> getRecordsByInterfaceType() {
		return this.implWrapper.recordsByInterfaceType;
	}

	/**
	 * Maps interfaces by the implementation key using the Application Factory Service metadata.
	 */
	public class ImplMapper {

		public Map<String, System.Type> interfaceTypeByKey {get; private set;}
		public String implementationField {get; private set;}

		/**
		 * Constructs ImplMapper to build a map of interfaces by keys and to set the implementation field
		 *
		 * @param serviceImplementationSObjectName Application Factory Service - Service Implementation SObject
		 * developerName.
		 */
		public ImplMapper(String serviceImplementationSObjectName) {
			AppFactoryServicesMetadataSelector.ImplementationWrapper metadataWrapper
				= AppFactoryServicesMetadataSelector.newInstance()
					.selectByServiceImplementationSObjectDeveloperName(serviceImplementationSObjectName);
			// Inform the caller that the metadata for this implementation has not be set
			if (metadataWrapper.appServices.isEmpty()) {
				throw new SObjectsImplManagerException(
					'No Application Factory Service custom metadata found with Service Implementation SObject, ' +
						serviceImplementationSObjectName + '.'
				);
			}
			implementationField = metadataWrapper.implementationField;
			interfaceTypeByKey = new Map<String, System.Type>();
			for (ApplicationFactory_Service__mdt metadataRecord: metadataWrapper.appServices) {
				interfaceTypeByKey.put(metadataRecord.Service_Implementation_Key__c,
					Type.forName(metadataRecord.SObjectType__c));
			}
		}
	}

	/**
	 * Implementation wrapper class which is used to store an implementation map along with the records by interface.
	 *
	 * This class can be extended when a custom implementation is needed that does not live in custom metadata. You can
	 * then pass this class into the constructor of an extended SObjectsImplManager class.
	 */
	public virtual class ImplWrapper {

		public Map<System.Type, List<SObject>> recordsByInterfaceType {get; private set;}
		public Map<System.Type, Map<Id, SObject>> existingRecordsByInterfaceType  {get; private set;}
		public ImplMapper mapper {get; private set;}

		/**
		 * Constructs ImplWrapper with necessary mappings and data to build an implementation map
		 *
		 * @param mapper ImplMapper
		 * @param records SObjects list
		 * @param existingRecords Map of existing SObjects (Trigger.oldMap)
		 */
		public ImplWrapper(ImplMapper mapper, List<SObject> records, Map<Id, SObject> existingRecords) {
			this.mapper = mapper;
			if (existingRecords == null) {
				setRecordsByInterfaceType(records);
			} else {
				setRecordsByInterfaceType(records, existingRecords);
			}
		}

		/**
		 * Override this method to build a specific records filtering
		 *
		 * @param records SObject list
		 */
		public virtual void setRecordsByInterfaceType(List<SObject> records) {
			this.recordsByInterfaceType = new Map<System.Type, List<SObject>>();
			for (SObject record: records) {
				System.Type interfaceType = this.mapper.interfaceTypeByKey.get(String.valueOf(record.get(mapper.implementationField)));
				if (interfaceType != null) {
					if (!this.recordsByInterfaceType.containsKey(interfaceType)) {
						this.recordsByInterfaceType.put(interfaceType, new List<SObject>());
					}
					this.recordsByInterfaceType.get(interfaceType).add(record);
				}
			}
		}

		/**
		 * Override this method to build a specific records/map filtering
		 *
		 * @param records SObject list
		 * @param existingRecords Map of existing SObjects (Trigger.oldMap)
		 */
		public virtual void setRecordsByInterfaceType(List<SObject> records, Map<Id, SObject> existingRecords) {
			this.recordsByInterfaceType = new Map<System.Type, List<SObject>>();
			this.existingRecordsByInterfaceType = new Map<System.Type, Map<Id, SObject>>();
			for (SObject record: records) {
				System.Type interfaceType = this.mapper.interfaceTypeByKey.get(String.valueOf(record.get(mapper.implementationField)));
				if (interfaceType != null) {
					SObject existingRecord = existingRecords.get(record.Id);
					if (!this.recordsByInterfaceType.containsKey(interfaceType)) {
						this.recordsByInterfaceType.put(interfaceType, new List<SObject>());
						this.existingRecordsByInterfaceType.put(interfaceType, new Map<Id, SObject>());
					}
					this.recordsByInterfaceType.get(interfaceType).add(record);
					this.existingRecordsByInterfaceType.get(interfaceType).put(record.Id, existingRecord);
				}
			}
		}
	}

	/**
	 * Interface for TriggerImpl
	 */
	public interface ITriggerImpl {

		void handleBeforeInsert();
		void handleBeforeUpdate();
		void handleBeforeDelete();
		void handleAfterInsert();
		void handleAfterUpdate();
		void handleAfterDelete();
		void handleAfterUndelete();

	}

	public class SObjectsImplManagerException extends Exception {}
}