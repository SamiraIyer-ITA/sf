/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IAssets.cls
	Purpose: Asset interface that will be used as an FFLIB domain object.
 */
public interface IAssets extends fflib_ISObjectDomain {

	void updateContactAndOfficer(List<Asset> existingAssets);

}