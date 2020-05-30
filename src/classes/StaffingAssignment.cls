/**
 * Created by Skip Kleckner on 5/11/2020.
 */

public with sharing class StaffingAssignment {
    private static String pId;

	@AuraEnabled(cacheable=false)
	public static List<Staffing_Assignment__c> getStaffingAssignmentByParentId(String parentId) {
		pId = parentId;
		try {
			String sObjectName = getSObjectNameFromRecordId(parentId);
			Set<String> selectFieldsSet = new Set<String>{'Title__c', 'User__c', 'User__r.Name', sObjectName.substring(0,sObjectName.length()-3)+'__r.ADCVD_Case__c'};
			String condition = '('+sObjectName+' = :parentIdString)';

			List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByParentId(parentId, selectFieldsSet, condition);

			return staffingAssignments;

		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	@AuraEnabled(cacheable=false)
	public static void deleteRecord(Id recordId) {
		try {
			Set<Id> recordIdSet = new Set<Id> ();
			recordIdSet.add(recordId);
			List<Staffing_Assignment__c> staffingAssignmentsForDelete = StaffingAssignmentSelector.newInstance().selectById(recordIdSet);

			delete staffingAssignmentsForDelete;

		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

  public static String getParentIdString() {
      return pId;
  }

	@AuraEnabled(cacheable=true)
	public static String getSObjectNameFromRecordId(Id recordId) {
		return recordId.getSObjectType().getDescribe().getName();
	}

}