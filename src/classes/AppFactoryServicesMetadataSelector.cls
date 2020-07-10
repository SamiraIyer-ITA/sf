/**
 * ApplicationFactory_Service__mdt fflib Selector
 *
 * @author Andrew La Russa
 */
public class AppFactoryServicesMetadataSelector
	extends fflibext_SObjectSelector implements IAppFactoryServicesMetadataSelector {

	public static IAppFactoryServicesMetadataSelector newInstance() {
		return (IAppFactoryServicesMetadataSelector)
					fflibext_Application.Selector.newInstance(ApplicationFactory_Service__mdt.SObjectType);
	}

	private Schema.sObjectType getSObjectType() {
		return ApplicationFactory_Service__mdt.SObjectType;
	}

	private List<Schema.SObjectField> getAdditionalSObjectFieldList() {
		return new List<Schema.SObjectField>{
			ApplicationFactory_Service__mdt.SObjectType__c,
			ApplicationFactory_Service__mdt.Service_Implementation_Key__c
		};
	}

	public List<ApplicationFactory_Service__mdt> selectById(Set<Id> idSet) {
		return (List<ApplicationFactory_Service__mdt>) selectSObjectsById(idSet);
	}

	/**
	 * Application Factory Service implementation wrapper selector
	 *
	 * @param developerName Service_Implementation_SObject__r.DeveloperName
	 *
	 * @return ImplementationWrapper for the Service SObject selected
	 */
	public ImplementationWrapper selectByServiceImplementationSObjectDeveloperName(String sObjectApiName) {
		List<ImplementationWrapper> wrapper = new List<ImplementationWrapper>();
		List<ApplicationFactory_Service__mdt> appServices = Database.query(
			newQueryFactory()
				.selectField('Service_Implementation_SObject__r.Implementation_Field__c')
				.selectField('Service_Implementation_SObject__r.SObject_Type__c')
				.setCondition('Service_Implementation_SObject__r.SObject_Type__c = :sObjectApiName')
				.toSOQL()
		);
		return new ImplementationWrapper(
			appServices.isEmpty() ? null : appServices[0].Service_Implementation_SObject__r.Implementation_Field__c,
			appServices
		);
	}

	/**
	 * Wrapper class used for ApplicationFactory Services when selecting a Service Implementation SObject.
	 * Used to build a map for a service implementation
	 */
	public class ImplementationWrapper {

		public String implementationField {get; private set;}
		public List<ApplicationFactory_Service__mdt> appServices {get; private set;}

		public ImplementationWrapper(String implementationField, List<ApplicationFactory_Service__mdt> appServices) {
			this.implementationField = implementationField;
			this.appServices = appServices;
		}
	}
}