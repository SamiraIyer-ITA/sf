/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: Assets.cls
	Purpose: Implementation of IAssets interface that will be used as an FFLIB domain object.
 */
public class Assets extends fflib_SObjectDomain implements IAssets {

	public static IAssets newInstance(List<Asset> records){
		return (IAssets) fflibext_Application.Domain.newInstance(records);
	}

	public static IAssets newInstance(Set<Id> recordIds){
		return (IAssets) fflibext_Application.Domain.newInstance(recordIds);
	}

	public Assets(List<Asset> sObjectList) {
		super(sObjectList);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<Asset> sObjectList) {
			return new Assets(sObjectList);
		}
	}

	public override void onBeforeInsert() {
		updateContactAndOfficer(Trigger.New);
	}

	public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
		updateContactAndOfficer(Trigger.New);
	}

	public void updateContactAndOfficer(List<Asset> assetsToUpdate) {
		try {
			AssetsService.updateContactAndOfficer(assetsToUpdate);
		} catch (AssetsService.AssetsServiceException e){
			Records.get(0).addError(e.getMessage());
		}
	}

}
