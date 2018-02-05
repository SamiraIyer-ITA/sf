public without sharing class InvestigationSelector {

	/************************************************
	* InvestigatioSelector IS CURRENTLY A PLACEHOLDER CLASS AND IS NOT USED IN APP.
	*************************************************/

	public static List<Investigation__c> allInvestigations {
		get {
			if (allInvestigations == null) {
				String query = Utils.soqlBuilderAllFields('Investigation__c', true);
				allInvestigations = database.query(query);
			}
			return allInvestigations;
		} set;
	}

}