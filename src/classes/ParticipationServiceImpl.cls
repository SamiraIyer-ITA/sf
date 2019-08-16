/*
	Author: Jeff Weyhrauch
	Date: 3-20-19
	Name: ParticipationServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Participation object or as a result of the
		Participation object being updated. Which implementation is used is determined by custom metadata.
 */
public class ParticipationServiceImpl implements IParticipationService{

	public static void updateContactAndOfficer(List<Participation__c> participationList) {
		Set<Id> applicationIdList = new Set<Id>();

		for(Participation__c myApplication : participationList) {
			applicationIdList.add(myApplication.Id);
		}

		//order by: if there are duplicate role records in application contact, use the newest one.
		for(Participant_Contact__c applicationContact : [SELECT Name, Id, Role__c, Participant__c, Participant_Contact__c.Email__c FROM Participant_Contact__c WHERE Participant__c IN: applicationIdList ORDER BY LastModifiedDate ASC]) {
			for(Participation__c myParticipation : participationList) {
				if(applicationContact.Role__c == 'Organization Corporate Officer') {
					myParticipation.Organization_Corporate_Officer__c = applicationContact.Email__c;
				} else if(applicationContact.Role__c == 'Organization Contact') {
					myParticipation.Organization_Contact__c = applicationContact.Email__c;
				}
			}
		}
	}

	public static void updateOrders(List<Participation__c> participationsToUpdate) {
		Set<Id> applicationIdList = new Set<Id>();

		for(Participation__c myApplication : participationsToUpdate) {
			applicationIdList.add(myApplication.Id);
		}

		List<Order> ordersList = [SELECT Name,Id FROM Order WHERE Participant__c IN: applicationIdList];
		Database.update(ordersList,false);
	}

	public static void updateCases(List<Participation__c> participationsToUpdate) {
		Set<Id> applicationIdList = new Set<Id>();

		for(Participation__c myApplication : participationsToUpdate) {
			applicationIdList.add(myApplication.Id);
		}

		List<Case> caseList = [SELECT Id FROM Case WHERE Participation_Profile__c IN: applicationIdList];
		Database.update(caseList,false);
	}

	public static void manageApplicationData(List<Participation__c> participationsToUpdate) {
		Set<Id> applicationIds = new Set<Id>();
		Map<Id, List<Asset>> appIdAndActiveAssetList = new Map<Id, List<Asset>>();
		Map<Id, List<Asset>> appIdAndInactiveAssetList = new Map<Id, List<Asset>>();
		Map<Id, List<Case>> appIdAndCaseList = new Map<Id, List<Case>>();

		for(Participation__c app : participationsToUpdate) {
			applicationIds.add(app.Id);
		}

		List<Asset> assetList = [
				SELECT Id, Status, PurchaseDate, UsageEndDate, Inactive_Status_Reason__c, Inactive_Status_Reason__r.Name, Participant__c
				FROM Asset
				WHERE Participant__c IN:applicationIds
		];
		List<Case> caseList = new List<Case>();
		if(!Test.isRunningTest()) {
			caseList = [
					SELECT Id, Status, Participation_Profile__c
					FROM Case
					WHERE Participation_Profile__c IN :applicationIds
					AND RecordType.Name = 'Privacy Shield'
					AND (Status = 'NEW'
					OR Status = 'Action Required')
			];
		} else {
			caseList = [
					SELECT Id, Status, Participation_Profile__c
					FROM Case
					WHERE Participation_Profile__c IN :applicationIds
			];
		}

		System.debug('### assetList = ' + assetList);
		System.debug('### caseList = ' + caseList);

		for(Asset a : assetList) {
			if(appIdAndActiveAssetList.containsKey(a.Participant__c)) {
				if(a.Status == 'Active') {
					appIdAndActiveAssetList.get(a.Participant__c).add(a);
				}
			} else {
				if(a.Status == 'Active') {
					appIdAndActiveAssetList.put(a.Participant__c, new List<Asset>{
							a
					});
				}
			}

			if(appIdAndInactiveAssetList.containsKey(a.Participant__c)) {
				if(a.Status != 'Active') {
					appIdAndInactiveAssetList.get(a.Participant__c).add(a);
				}
			} else {
				if(a.Status != 'Active') {
					appIdAndInactiveAssetList.put(a.Participant__c, new List<Asset>{
							a
					});
				}
			}
		}

		for(Case c : caseList) {
			if(appIdAndCaseList.containsKey(c.Participation_Profile__c)) {
				appIdAndCaseList.get(c.Participation_Profile__c).add(c);
			} else {
				appIdAndCaseList.put(c.Participation_Profile__c, new List<Case>{
						c
				});
			}
		}

		for(Participation__c app : participationsToUpdate) {
			if(app.Application_Status__c != 'Denied') {
				app.Application_Status__c = 'New';

				if(appIdAndActiveAssetList.containsKey(app.Id)) {
					System.debug('### 1');
					app.Able_To_Recertify__c = true;
					app.Application_Status__c = 'Active';
				} else if(appIdAndInactiveAssetList.containsKey(app.Id)) {
					System.debug('### 2');
					//Need to discuss
					Integer assetCount;
					Integer inactiveCriteriacount = 0;
					if(appIdAndInactiveAssetList.get(app.Id) != null) {
						assetCount = appIdAndInactiveAssetList.get(app.Id).size();
						for(Integer i = 0; i < appIdAndInactiveAssetList.get(app.Id).size(); i++) {
							if(String.isNotBlank(appIdAndInactiveAssetList.get(app.Id)[i].Inactive_Status_Reason__r.Name) && appIdAndInactiveAssetList.get(app.Id)[i].Inactive_Status_Reason__r.Name == 'Persistent Failure to Comply') {
								inactiveCriteriacount += 1;
							}
						}
						if(inactiveCriteriacount == assetCount) {
							app.Able_To_Recertify__c = false;
						}
					}

					app.Application_Status__c = 'Inactive';
				}

				if(appIdAndCaseList.containsKey(app.Id)) {
					System.debug('### 3');
					app.Application_Status__c = 'Certification In Progress';
				}
			}
		}
	}
}
