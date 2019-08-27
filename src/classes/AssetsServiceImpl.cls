/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: AssetsServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Asset object or as a result of the
		Asset object being updated. Which implementation is used is determined by custom metadata.
 */
public class AssetsServiceImpl implements IAssetsService{

	public static List<Asset> updateRelatedObjectList(List<Asset> assetsList){
		return new List<Asset>();
	}

	public static void updateContactAndOfficer(List<Asset> assetsList) {
		// process each batch of records
		Set<Id> applicationIdList = new Set<Id>();

		Map<Id, String> participantToContactEmail = new Map<Id, String>();
		Map<Id, String> participantToCorporateOfficer = new Map<Id,String>();

		for(Asset asset : assetsList) {
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

		for(Asset asset : assetsList) {
			if(asset.Organization_Corporate_Officer__c !=  participantToCorporateOfficer.get(asset.Participant__c) ||
					asset.Organization_Contact__c != participantToContactEmail.get(asset.Participant__c)) {
				asset.Organization_Corporate_Officer__c = participantToCorporateOfficer.get(asset.Participant__c);
				asset.Organization_Contact__c = participantToContactEmail.get(asset.Participant__c);
			}
		}
	}
}