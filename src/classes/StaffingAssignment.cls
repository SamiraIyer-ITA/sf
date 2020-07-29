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
			Set<String> selectFieldsSet = new Set<String>{
					'Title__c', 'User__c', 'User__r.Name', sObjectName.substring(0, sObjectName.length() - 3) + '__r.ADCVD_Case__c'
			};
			String condition = '(' + sObjectName + ' = :parentIdString)';
			List<Staffing_Assignment__c> staffingAssignments = StaffingAssignmentSelector.newInstance().selectByParentId(parentId, selectFieldsSet, condition);
			staffingAssignments = sortStaffingAssignments(staffingAssignments);
			return staffingAssignments;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	private static List<Staffing_Assignment__c> sortStaffingAssignments(List<Staffing_Assignment__c> saList) {
		Map<String, List<Staffing_Assignment__c>> sortMap = new Map<String, List<Staffing_Assignment__c>>();
		sortMap.put('Analyst', new List<Staffing_Assignment__c>());
		sortMap.put('Program Manager', new List<Staffing_Assignment__c>());
		sortMap.put('Office Director', new List<Staffing_Assignment__c>());
		sortMap.put('Staff Policy', new List<Staffing_Assignment__c>());
		sortMap.put('Senior Policy', new List<Staffing_Assignment__c>());
		sortMap.put('Staff Legal', new List<Staffing_Assignment__c>());
		sortMap.put('Senior Legal', new List<Staffing_Assignment__c>());
		sortMap.put('Staff Accountant', new List<Staffing_Assignment__c>());
		sortMap.put('Accounting PM', new List<Staffing_Assignment__c>());
		sortMap.put('Accounting Director', new List<Staffing_Assignment__c>());
		sortMap.put('DAS Assistant', new List<Staffing_Assignment__c>());
		sortMap.put('Associate DAS', new List<Staffing_Assignment__c>());
		sortMap.put('DAS', new List<Staffing_Assignment__c>());
		sortMap.put('AS Assistant', new List<Staffing_Assignment__c>());
		sortMap.put('Assistant Secretary', new List<Staffing_Assignment__c>());
		for (Staffing_Assignment__c sa : saList) {
			sortMap.get(sa.Title__c).add(sa);
		}
		List<Staffing_Assignment__c> sortedList = new List<Staffing_Assignment__c> ();
		for (String s : sortMap.keySet()) {
			sortedList.addAll(sortMap.get(s));
		}
		return sortedList;
	}

	@AuraEnabled(cacheable=false)
	public static void deleteRecord(Id recordId) {
		try {
			Set<Id> recordIdSet = new Set<Id> ();
			recordIdSet.add(recordId);
			List<Staffing_Assignment__c> staffingAssignmentsForDelete = StaffingAssignmentSelector.newInstance().selectById(recordIdSet);

			delete staffingAssignmentsForDelete;

		} catch (Exception e) {
			throw new AuraHandledException('You do not have permission to perform this action.');
		}
	}

	public static String getParentIdString() {
		return pId;
	}

	@AuraEnabled(cacheable=true)
	public static String getSObjectNameFromRecordId(Id recordId) {
		return recordId.getSObjectType().getDescribe().getName();
	}

	@AuraEnabled(cacheable= true)
	public static recusalWrap getRecusalLinkMap(String caseId) {
		Map<Id, User> adcvdUserMap = new Map<Id, User>();
		for (User u : [SELECT Id, Name, Staffing_Role__c FROM User WHERE Staffing_Role__c != null ORDER BY Name Asc]) {
			adcvdUserMap.put(u.Id, u);
		}

		set<Id> userIdSet = adcvdUserMap.keySet();

		/*Id caseId = (Id) PetitionSelector.newInstance().selectById(new Set<Id>{parentId})[0].get('ADCVD_Case__c');*/
		ADCVD_CaseMapper caseMapper = (ADCVD_CaseMapper) ADCVD_CaseMapper.mapperMap.get('ADCVD_Case__c');
		caseMapper = caseMapper.getInstance(new Set<Id>{
				caseId
		});
		RecusalMapper recMapper = (RecusalMapper) caseMapper.getMapper('Recusal__c');
		Set<Id> usersWithActiveRecusals = recMapper.getInstance(adcvdUserMap.keySet()).getMapByUserIds().keySet();

		Map<Id, String> recusalStatusMap = new Map<Id, String>();
		Map<Id, String> recusalLinkMap = new Map<Id, String>();
		Map<Id, String> recusalLinkTextMap = new Map<Id, String>();

		for (Id userId : userIdSet) {
			recusalStatusMap.put(userId, 'This user does not have any active recusals.');
			//recusalLinkMap.put(userId, '');
			//recusalLinkTextMap.put(userId, '');
		}

		system.debug('caseId ' + caseId);

		for (Id userId : usersWithActiveRecusals) {
			system.debug(userId);
			system.debug('usersWithActiveRecusals' + usersWithActiveRecusals);

			recusalStatusMap.put(userId, 'This user has active recusals.' + '<br/>');
			String recusalLinkText = recusalStatusMap.containsKey(userId) ? 'Review Recusals' : '';
			String recusalLink = '/apex/ReviewRecusalPage?userId=' + userId + '&caseId=' + caseId;
			recusalLinkMap.put(userId, recusalLink);
			recusalLinkTextMap.put(userId, recusalLinkText);
		}

		recusalWrap objrescusalWrap = new recusalWrap(recusalStatusMap, recusalLinkMap, recusalLinkTextMap);

		return objrescusalWrap;
	}

	public class recusalWrap {
		@AuraEnabled
		public Map<Id, String> recusalStatusMap { get; set; }
		@AuraEnabled
		public Map<Id, String> recusalLinkMap { get; set; }
		@AuraEnabled
		public Map<Id, String> recusalLinkTextMap { get; set; }

		public recusalWrap(Map<Id, String> recusalStatusMap, Map<Id, String> recusalLinkMap, Map<Id, String> recusalLinkTextMap) {
			this.recusalStatusMap = recusalStatusMap;
			this.recusalLinkMap = recusalLinkMap;
			this.recusalLinkTextMap = recusalLinkTextMap;
		}
	}
}