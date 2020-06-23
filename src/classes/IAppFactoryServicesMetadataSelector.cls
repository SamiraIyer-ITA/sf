/**
 * ApplicationFactory_Service__mdt fflib Selector Interface
 *
 * @author Andrew La Russa
 */
public interface IAppFactoryServicesMetadataSelector extends fflibext_ISObjectSelector{

	List<ApplicationFactory_Service__mdt> selectById(Set<Id> idSet);
	AppFactoryServicesMetadataSelector.ImplementationWrapper
		selectByServiceImplementationSObjectDeveloperName(String developerName);
}