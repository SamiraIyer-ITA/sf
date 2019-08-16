/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: AssetsService.cls
	Purpose:
		Class that returns the implementation for the operations and work we plan to do on the Asset object or as
		a result of the Asset object being updated. Which implementation is used is determined by custom
		metadata. See AssetsServiceImpl.cls for the current and only implementation defined by custom metadata.
 */
public with sharing class AssetsService {

	private static IAssetsService service(){
		return (IAssetsService) fflibext_Application.Service.newInstance(IAssetsService.class);
	}

	public static void updateContactAndOfficer(List<Asset> assetsList) {
		service().updateContactAndOfficer(assetsList);
	}

	public class AssetsServiceException extends Exception {}

}