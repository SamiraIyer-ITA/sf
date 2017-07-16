public without sharing class IssueSelector {

	public static List<Issue__c> allIssues {
		get {
			if (allIssues == null) {
				String query = Utils.soqlBuilderAllFields('Issue__c', true);
				allIssues = database.query(query);
			}
			return allIssues;
		} set;
	}
}