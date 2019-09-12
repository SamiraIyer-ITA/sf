public without sharing class ApplicationContactTriggerHandler {

	public static void mainEntry(List<Participant_Contact__c> newList, List<Participant_Contact__c> oldList, Map<Id, Participant_Contact__c> newMap, Map<Id, Participant_Contact__c> oldMap,
			Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isBefore, Boolean isAfter) {

		if (isAfter && isUpdate) {

			//get related applications
			List<Id> applicationIds = new List<Id>();
			for(Participant_Contact__c pContact : newList) {
				applicationIds.add(pContact.Participant__c);
			}

			//grab assets from related applications
			List<Asset> relatedAssets = [select Id from Asset where Participant__c IN: applicationIds];
			List<Case> relatedCases = [select Id from Case where Participation_Profile__c IN: applicationIds];

			//call update on assets to start asset trigger flow to update assets
			update relatedAssets;
			update relatedCases;
		}
	}
}