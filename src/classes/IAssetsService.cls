/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IAssetsService.cls
	Purpose: Interface that describes the type of operations and work we plan to do on the Asset object or as a result of the Asset object being updated.
 */
public interface IAssetsService {

	void updateContactAndOfficer(List<Asset> assetsList);

}