/**
 * Created by Skip Kleckner on 5/11/2020.
 */

public with sharing class StaffingAssignment {
	private static String pId;

	@AuraEnabled(cacheable=false)
	public static List<Staffing_Assignment__c> getStaffingAssignmentByParentId(String parentId) {
		System.debug('parentId-------'+parentId);
		pId = parentId;
		try {
			Set<Id> parentIds = new Set<Id>{parentId};
			String wc = '(Petition__c = :parentIdString)';
			//List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByParentId('a3U350000002AmbEAE');
			List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByParentId(parentId);
			//List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByWhereClause(wc);
			//List<Staffing_Assignment__c> staffingAssignments = [SELECT Id, User__r.Name, User__c, Title__c FROM Staffing_Assignment__c WHERE Petition__c = :parentId];
			return staffingAssignments;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	public static String getParentIdString() {
		return pId;
	}

}