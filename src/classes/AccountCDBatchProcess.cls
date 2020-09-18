/**
 * Created by mark on 9/16/2020.
 */

global class AccountCDBatchProcess implements Database.Batchable<sObject>, Database.Stateful {

	global Database.QueryLocator start(Database.BatchableContext BC){
		String query = 'SELECT ID, BillingCountry, State_Code__c, Congressional_District__c, BillingPostalCode, RecordTypeId FROM Account WHERE BillingCountry = \'United States\'';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC,List<Account> scope) {

		List<Account> updatedScope = UpdateCDHandler.updateCDHandlerMain(scope);

		update updatedScope;

	}

	global void finish(Database.BatchableContext BC) {

	}
}