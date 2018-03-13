public without sharing class InvestigationSelector {

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