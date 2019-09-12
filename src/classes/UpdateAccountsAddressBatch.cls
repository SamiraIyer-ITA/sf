/*
* This batch will only be used one time. It will be launched after the Participation trigger logic has been
* deployed - which will likely be at the same this is deployed. This batch job will update all Accounts' address
* information using the last Participation record created with respect to that Account.
*
* To run the batch, open the dev console and execute:
*
* Database.executeBatch(new UpdateAccountsAddressBatch(), 200);
*/
global class UpdateAccountsAddressBatch implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			'SELECT Id, Name'
			+ ' FROM Account'
		);
	}

	global void execute(Database.BatchableContext BC, List<SObject> scope){
		Set<Id> accountIdSet = new Set<Id>();
		for(Account a : (List<Account>) scope){
			accountIdSet.add(a.Id);
		}

		List<Participation__c> participationListUnfiltered = [
			SELECT Id, Organization__c, CreatedDate
			FROM Participation__c
			WHERE Organization__c IN :accountIdSet
			ORDER BY CreatedDate DESC
		];

		List<Participation__c> participationListFiltered = new List<Participation__c>();
		Id previousOrgLookup = null;
		for(Participation__c p : participationListUnfiltered){
			if(previousOrgLookup != null){
				if(previousOrgLookup == p.Organization__c){
					continue;
				} else {
					previousOrgLookup = p.Organization__c;
				}
			} else {
				previousOrgLookup = p.Organization__c;
			}
			participationListFiltered.add(p);
		}

		update participationListFiltered;
	}

	global void finish(Database.BatchableContext BC){
	}

}