/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: CasesServiceImpl.cls
	Purpose:
		The implementation for the operations and work we plan to do on the Case object or as a result of the
		Case object being updated. Which implementation is used is determined by custom metadata.
 */
public class CasesServiceImpl implements ICasesService{

	public static void updateCaseContactAndOfficer(List<Case> casesList){
		// process each batch of records
		Set<Id> applicationIdList = new Set<Id>();

		Map<Id, String> participantToContactEmail = new Map<Id, String>();
		Map<Id, String> participantToCorporateOfficer = new Map<Id,String>();

		for(Case myCase : casesList) {
			applicationIdList.add(myCase.Participation_Profile__c);
		}

		//order by: if there are duplicate role records in application contact, use the newest one.
		for(Participant_Contact__c applicationContact : [SELECT Name, Id, Role__c, Participant__c, Email__c FROM Participant_Contact__c WHERE Participant__c IN: applicationIdList ORDER BY LastModifiedDate ASC]) {
			for(Case myCase : casesList) {
				if (myCase.Participation_Profile__c == applicationContact.Participant__c) {
					if (applicationContact.Role__c == 'Organization Corporate Officer') {
						myCase.Organization_Corporate_Officer__c = applicationContact.Email__c;
					} else if (applicationContact.Role__c == 'Organization Contact') {
						myCase.Organization_Contact__c = applicationContact.Email__c;
					}
				}
			}
		}
	}

	public static void updateAssets(Map<Id,Case> oldCaseMap,List<Case> caseList){
		//List<Case> caseList = trigger.new;
		set<id> OrderIds = new set<id>();
		set<id> AccountIds = new set<id>();
		set<id> MakeAssets = new set<id>();
		set<id> DeniedOrders = new set<id>();
		Map<Id,Case> successfulOrders = new Map<Id,Case>();
		Set<Id> setDeniedCaseApplicationId = new Set<Id>();
		Set<Id> adminClosedOrders = new Set<Id>();
		Map<Id,Case> ordersToCases = new Map<Id,Case>();
		Set<Id> possibleRecertifiedAssets = new Set<Id>();
		Set<Id> recertifiedAssets = new Set<Id>();

		for(case c : caseList) { //only invoke these updates when the status is changed
			if(c.order__c != null && (c.status == 'Successfully Closed' || c.status == 'Administratively Closed' || c.status == 'Denied' || c.status == 'In Progress') && (oldCaseMap.get(c.Id).status != c.status) ){
				//gather list of applications that might count as recertifications
				//possibleRecertifiedAssets.add(c.AssetID);

				if(c.status == 'Denied'){
					DeniedOrders.add(c.order__c);
					setDeniedCaseApplicationId.add(c.Participation_Profile__c);
				}
				if(c.status == 'Administratively Closed') {
					adminClosedOrders.add(c.order__c);
				}
				if(c.status == 'Successfully Closed') {
					successfulOrders.put(c.order__c,c);
				}
				OrderIds.add(c.order__c);
				ordersToCases.put(c.order__c,c);
			}
			if(c.accountId != null){
				AccountIds.add(c.accountid);
			}
		}

		//Get ID(s) of 'Persistent Failure to Comply' Inactive Reason(s)
		Set<Id> persistentFailureToComply = new Set<Id>();
		for(Inactive_Reason__c reason : [SELECT Name,Id FROM Inactive_Reason__c WHERE Name =: 'Persistent Failure to Comply']) {
			persistentFailureToComply.add(reason.Id);
		}

		//Get List of Re-Certified Asset Ids
		list<Asset> assets = [
            select 	id, status, product2id, accountid, installdate, usageenddate, price,
            		(select id, name, Third_Party_Master_List__c from third_parties__r),
            		(SELECT Id,Inactive_Status_Reason__c FROM Inactive_Periods__r),
           			 Participant__c,Participant__r.Able_To_Recertify__c 
            from 	Asset where AccountId = :AccountIds
        ];
		for(Asset asset : assets) {
			Boolean hasInactivePeriodWithPersistentFailureToComply = false;
			for(Inactive_Period__c inactivePeriod : asset.Inactive_Periods__r) {
				if(persistentFailureToComply.contains(inactivePeriod.Inactive_Status_Reason__c)) {
					hasInactivePeriodWithPersistentFailureToComply = true;
				}
			}
			if(asset.Status == 'Active' && hasInactivePeriodWithPersistentFailureToComply == false && asset.Participant__r.Able_To_Recertify__c == true) {
				recertifiedAssets.add(asset.Id);
			}
		}

		list<asset> toUpsert = new list<asset>();
		list<third_party__c> ThirdParties = new list<third_party__c>();
		set<Third_Party__c> ThirdPartiesToUpdate = new set<third_party__c>();

		list<OrderItem> lineItems = [
            select 	id, PricebookEntry.Product2Id, order.accountid, unitprice,
            		(select id, name, Third_Party_Master_List__c from third_parties__r) 
            from 	orderitem where orderid in :OrderIds
        ];
		set<id> AlreadyExistsTP = new set<id>();
		set<id> AlreadyExistsUpsert = new set<id>();

		for(OrderItem oli : lineItems){
			//loop throug the list of assets
			for(Asset asset : assets){
				//if the asset matches the current account for the order, and the product matches

				if(asset.accountId == oli.order.accountid && asset.product2id == oli.pricebookentry.product2id){
					if(DeniedOrders.contains(oli.orderid) || adminClosedOrders.contains(oli.orderid) 
                       		|| ((asset.UsageEndDate == null || asset.UsageEndDate < Date.today()) && !successfulOrders.containsKey(oli.orderId)) ){
						//Conditional expression changed for TRAC-220 to fix an issue with administratively closed orders staying active. I tried to wrap the expression with parentheses to make the order of logical operations more apparent
						//This section has been disabled for TRAC-150, previously asset.Status = 'Inactive';
					} else {
						//otherwise the asset status will reimain active
						asset.Status = 'Active';
						//if the order was successful, update the usageEndDate
						if(successfulOrders.containsKey(oli.orderid)) {
							//SUCCESSFUL ORDER
							//update the install date
							if(asset.installDate == null){
								asset.installDate = Date.today();
							}
							//update the price
							for(OrderItem item : lineItems){
								if(item.pricebookentry.product2Id == asset.product2Id){
									asset.price = item.unitPrice;
									break;
								}
							}
							//DIFFERENT USAGE END DATE DEPENDING ON CERTIFICATION/RE-CERTIFICATION
							if(recertifiedAssets.contains(asset.Id)) {
								//Re-Certification
								asset.usageEndDate = ordersToCases.get(oli.orderid).CreatedDate.Date() + 365;
								System.debug('ASSET '+asset.Id+' is re certified');
							} else {
								//First-Time Certification
								asset.usageEndDate = ordersToCases.get(oli.orderid).ClosedDate.Date() + 365;
								System.debug('ASSET '+asset.Id+' is NOT re certified');
							}
						}
					}
				}

				//make sure there are no dupes, in case the asset has already been processed
				if(!AlreadyExistsUpsert.contains(asset.id)){
					toUpsert.add(asset);
					AlreadyExistsUpsert.add(asset.id);

				}

				//make list of all third parties related to asset
				for(third_party__c atp: asset.third_parties__r){
					AlreadyExistsTP.add(atp.third_party_master_list__c);
				}

				//no idea
				for(third_party__c otp : oli.third_parties__r){
					if(!AlreadyExistsTP.contains(otp.third_party_master_List__c)){
						AlreadyExistsTP.add(otp.third_party_master_list__c);
						otp.asset__c = asset.id;
						ThirdPartiesToUpdate.add(otp);
					}
				}
			}
		}

		for(third_party__c tp : ThirdPartiesToUpdate){
			ThirdParties.add(tp);
		}

		List<Participation__c> lstApplicationwithAssets = new List<Participation__c>();
		//handle application denials
		if(!setDeniedCaseApplicationId.isEmpty()) {
			lstApplicationwithAssets = [SELECT Id, Able_To_Recertify__c, (SELECT Id,Status FROM Assets__r) FROM Participation__c WHERE Id IN: setDeniedCaseApplicationId];
			if(!lstApplicationwithAssets.isEmpty()) {
				for(Participation__c objParticipation : lstApplicationwithAssets) {
					System.debug('APPLICATION WAS DENIED');
					//All logic around Denied Case is removed for TRAC-150
				}
			}
		}

		database.update(toUpsert);
		database.update(ThirdParties);

		//gather application ids related to all cases
		Set<Id> applicationIdsNew = New Set<Id>();
		for(Case c : caseList) {
			applicationIdsNew.add(c.Participation_Profile__c);
		}

		//this looks like it is supposed to call the update trigger on all related applications to any case that is updated
		Map<Id, Participation__c> applicationMapNew = new Map<Id, Participation__c>([Select id, Name, Able_To_Recertify__c from Participation__c where id IN: applicationIdsNew AND ID NOT IN: setDeniedCaseApplicationId ]);
		//combine applications and denied applications for one update
		lstApplicationwithAssets.addAll(applicationMapNew.values());
		update lstApplicationwithAssets;
	}

	public static void sendToEximBank(List<Case> caseList) {
		Id networkId = PartnerConnectionHelper.getInstance().getConnectionId('Export-Import Bank of the United States');
		System.debug('Networkid = ' + networkId);
		List<PartnerNetworkRecordConnection> prncList = new List<PartnerNetworkRecordConnection>();

		if (networkId != null) {
			for (Case c: caseList) {
				if (c.ConnectionReceivedId == null
						&& c.Status == 'Successfully Closed'
						&& c.Record_Type__c == 'Export Promotion'
						&& c.Fee__c != ''
						&& c.Fee__c != 'Administration'
						&& c.Fee__c != 'No Fee-Based Services Used'
						&& c.Fee__c != 'HQ Use Only - Administration'
						&& c.Contact_Email_Opt_Out__c == false) {

					//This case should be sent to Exim Bank
					PartnerNetworkRecordConnection newConnection = new PartnerNetworkRecordConnection(
							ConnectionId = networkId,
							LocalRecordId = c.Id,
							SendClosedTasks = false,
							SendOpenTasks = false,
							SendEmails = false);
					prncList.add(newConnection);
				}
			}

			if (prncList.size() > 0) {
				database.insert(prncList);
			}
		}
	}

	// can do small unit tests here at the bottom
}