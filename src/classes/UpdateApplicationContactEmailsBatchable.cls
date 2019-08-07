global class UpdateApplicationContactEmailsBatchable implements 
	Database.Batchable<sObject>, Database.Stateful {

	global Database.QueryLocator start(Database.BatchableContext bc) {
		return Database.getQueryLocator('SELECT ID, Organization_Contact__c, Organization_Corporate_Officer__c, Participant__c FROM Asset');
	}
	global void execute(Database.BatchableContext bc, List<Asset> scope){
		Set<Id> applicationIdList = new Set<Id>();

		Map<Id,String> participantToContactEmail = new Map<Id,String>();
		Map<Id,String> participantToCorporateOfficer = new Map<Id,String>();
		
		for(Asset asset : scope) {
			applicationIdList.add(asset.Participant__c);
		}

		for(Participant_Contact__c applicationContact : [SELECT Name,Id,Role__c,Participant__c,Email__c from Participant_Contact__c where Participant__c IN: applicationIdList ORDER BY LastModifiedDate ASC]) {
			if(applicationContact.Role__c == 'Organization Corporate Officer') {
				participantToCorporateOfficer.put(applicationContact.Participant__c,applicationContact.Email__c);
			} else if(applicationContact.Role__c == 'Organization Contact') {
				participantToContactEmail.put(applicationContact.Participant__c,applicationContact.Email__c);
			}
		}

		List<Asset> assetsToUpdate = new List<Asset>();
		for(Asset asset : scope) {
			if(asset.Organization_Corporate_Officer__c !=  participantToCorporateOfficer.get(asset.Participant__c) ||
				asset.Organization_Contact__c != participantToContactEmail.get(asset.Participant__c)) {
				asset.Organization_Corporate_Officer__c = participantToCorporateOfficer.get(asset.Participant__c);
				asset.Organization_Contact__c = participantToContactEmail.get(asset.Participant__c);
				assetsToUpdate.add(asset);
			}
		}

		update assetsToUpdate;

	}	
	global void finish(Database.BatchableContext bc){
		System.debug('UpdateApplicationContactEmailsBatchable batch finished');
	}	
}