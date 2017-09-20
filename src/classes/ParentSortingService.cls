public without sharing class ParentSortingService {


	static FINAL Set<String> staffingAssignmentParents = new Set<String> {'Petition__c', 'Investigation__c', 'ADCVD_Order__c', 'Segment__c', 'Related_Organization__c'};
	static FINAL Set<String> relatedOrganizationParents = new Set<String> {'Petition__c', 'Investigation__c', 'ADCVD_Order__c', 'Segment__c', 'Litigation__c'};
	static FINAL Set<String> litigationParents = new Set<String> {'Petition__c', 'Investigation__c', 'Segment__c'};
	static Map<String, Set<String>> soTypeToParentSet = new Map<String, Set<String>>();
	static {
		soTypeToParentSet.put('Staffing_Assignment__c', staffingAssignmentParents);
		soTypeToParentSet.put('Related_Organization__c', relatedOrganizationParents);
		soTypeToParentSet.put('Litigation__c', litigationParents);
	}

	public String getParentSObjectType (SObject so, String soType) {
		String returnString = '';
		for (String parentName : soTypeToParentSet.get(soType)) {
			if (so.get(parentName) != null) {
				returnString = parentName;
				return returnString;
			}
		}
		return returnString;
	}

	public String getGrandParentSObjectType (SObject so, String parentSObjectType) {
		String returnString = '';
		String parentSObjectRelationship = parentSObjectType.replace('__c','__r');
		for (String parentName : soTypeToParentSet.get(parentSObjectType)) {
			if (so.getSObject(parentSObjectRelationship).get(parentName) != null) {
				returnString = parentName;
				return returnString;
			}
		}
		return returnString;
	}
	
}