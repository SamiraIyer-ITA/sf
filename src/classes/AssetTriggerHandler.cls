public without sharing class AssetTriggerHandler {

	public static void mainEntry(List<Asset> newList, List<Asset> oldList, Map<Id, Asset> newMap, Map<Id, Asset> oldMap,
		Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isBefore, Boolean isAfter) {
		if (isAfter && isUpdate) {

			// Create a Unit Of Work
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
				new Schema.SObjectType[] {
					Asset.SObjectType
				}
			);

			//application from participant contact, assets from application
			//Get list of assets, grab all fields needed (like application)
			List<Id> assetIds = new List<Id>();
			for(Asset asset : newList) {
				assetIds.add(asset.Id);
			}
			List<Asset> assetList = [SELECT Id, Name, Participant__c, Organization_Corporate_Officer__c, Organization_Contact__c FROM Asset WHERE Id IN: assetIds];

			//Call method to populate contact info on assets
			populateAssetContacts(assetList,uow);

			//Commit Work
			uow.commitWork();
		}
	}

	private static void populateAssetContacts(List<Asset> scope,fflib_SObjectUnitOfWork uow) {
		// process each batch of records
		Set<Id> applicationIdList = new Set<Id>();

		Map<Id, String> participantToContactEmail = new Map<Id, String>();
		Map<Id, String> participantToCorporateOfficer = new Map<Id,String>();

		for(Asset asset : scope) {
			applicationIdList.add(asset.Participant__c);
		}

		//order by: if there are duplicate role records in application contact, use the newest one.
		for(Participant_Contact__c applicationContact : [SELECT Name, Id, Role__c, Participant__c, Participant_Contact__c.Email__c FROM Participant_Contact__c WHERE Participant__c IN: applicationIdList ORDER BY LastModifiedDate ASC]) {
			if(applicationContact.Role__c == 'Organization Corporate Officer') {
				participantToCorporateOfficer.put(applicationContact.Participant__c, applicationContact.Email__c);
			} else if(applicationContact.Role__c == 'Organization Contact') {
				participantToContactEmail.put(applicationContact.Participant__c, applicationContact.Email__c);
			}
		}

		for(Asset asset : scope) {
			if(asset.Organization_Corporate_Officer__c !=  participantToCorporateOfficer.get(asset.Participant__c) ||
				asset.Organization_Contact__c != participantToContactEmail.get(asset.Participant__c)) {
				asset.Organization_Corporate_Officer__c = participantToCorporateOfficer.get(asset.Participant__c);
				asset.Organization_Contact__c = participantToContactEmail.get(asset.Participant__c);
				uow.registerDirty(asset);
			}
		}
	}
}