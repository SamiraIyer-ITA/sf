/**
 * 
 *    Created by Joshua Moody
 *    on Sep 19 2017
 *    MIL Corporation
 * 
 **/

public without sharing class ParentSortingService {

	/***********************************************************
    * This class assists with mapping the parent field names to 
    * records. In some cases, the record of import is actually a 
    * grandparent, which this also does.  On class instantiation,
    * the parent and grandparent field names are mapped and stored
    * in class.  The methods take an sObject in which the parent is
    * unknown and loops through the possible parents until one is found.
    * This class provides methods to:
    * 1. Return the name of a parent field name for a record
    * 2. Return the name of a grandparent field name for a record
    ***********************************************************/

	static FINAL Set<String> staffingAssignmentParents = new Set<String> {'Petition__c', 'Investigation__c', 'ADCVD_Order__c', 'Segment__c', 'Related_Organization__c'};
	static FINAL Set<String> relatedOrganizationParents = new Set<String> {'Petition__c', 'Investigation__c', 'ADCVD_Order__c', 'Segment__c', 'Litigation__c', 'Legal_Representation__c'};
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