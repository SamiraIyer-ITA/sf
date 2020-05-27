/**
 * Created by Skip Kleckner on 5/11/2020.
 */

public with sharing class StaffingAssignment {
	private static String pId;

	@AuraEnabled(cacheable=false)
	public static List<Staffing_Assignment__c> getStaffingAssignmentByParentId(String parentId) {
		pId = parentId;
		try {
			String wc = '(Petition__c = :parentIdString)';
			List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByParentId(parentId);
			return staffingAssignments;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	public static String getParentIdString() {
		return pId;
	}

	@AuraEnabled(cacheable=true)
	public static String getSObjectNameFromRecordId(Id recordId) {
		System.debug('----------1-------------'+recordId);
		return recordId.getSObjectType().getDescribe().getName();
	}

}