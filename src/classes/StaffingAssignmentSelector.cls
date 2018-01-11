/***************************************
* This class selects and maps staffing assignments
* to their parents.
* 
* Author: Joshua Moody
* Created Date: 1/11/2018
***************************************/

public class StaffingAssignmentSelector {

	public static Map<Id,List<Staffing_Assignment__c>> parentIdsToStaffLists = new Map<Id,List<Staffing_Assignment__c>>();
	private static Set<Id> staffingAssignmentIds = new Set<Id>();//all staffing assignments in all lists in parentIdsToStaffLists

	public static void setParentIdsToStaffLists(Id parentId, String sObjectName) {
		setParentIdsToStaffLists(new List<Id> {parentId}, sObjectName);
	}

	public static void setParentIdsToStaffLists(Set<Id> parentIds, String sObjectName) {
		setParentIdsToStaffLists(new List<Id> (parentIds), sObjectName);
	}

	public static void setParentIdsToStaffLists(List<Id> parentIds, String sObjectName) {
		if (parentIdsToStaffLists.isEmpty() || !parentIdsToStaffLists.keySet().containsAll(parentIds)) {
			String queryString = 'SELECT Id, User__c, Title__c, Related_Organization__r.' + sObjectName + ', ';
			queryString += sObjectName + ' ';
			queryString += 'FROM Staffing_Assignment__c ';
			queryString += 'WHERE ' + sObjectName + ' IN: parentIds ';
			queryString += 'OR Related_Organization__r.' + sObjectName + ' IN: parentIds';
			System.debug(loggingLevel.Error, '*** queryString: ' + queryString);
			List<Staffing_Assignment__c> saList = database.query(queryString);
			for (Staffing_Assignment__c sa : saList) {
				List<Staffing_Assignment__c> tempList = new List<Staffing_Assignment__c>();
				Id parentId = sa.Related_Organization__c != null ? (Id) sa.Related_Organization__r.get(sObjectName) : (Id) sa.get(sObjectName);
				if (!staffingAssignmentIds.contains(sa.Id)) {
					if (!parentIdsToStaffLists.isEmpty() && parentIdsToStaffLists.get(parentId) != null) {
						System.debug(loggingLevel.Error, '*** a parent sa: ' + sa);
						tempList.addAll(parentIdsToStaffLists.get(parentId));
					}
					staffingAssignmentIds.add(sa.Id);
					tempList.add(sa);
					parentIdsToStaffLists.put(parentId, tempList);
				}
			}
		}			
	}
	public List<Staffing_Assignment__c> getStaffingAssignments(Id parentId) {
		return (parentIdsToStaffLists.get(parentId));
	}
}