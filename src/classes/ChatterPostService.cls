/**
 * 
 *    Created by Joshua Moody
 *    on Jan 11 2018
 *    MIL Corporation
 * 
 **/

public class ChatterPostService {

	/***********************************************************************
	* This class accepts the parent records, performs logic to see if any posts 
	* are needed, gets those posts stored in the org using the CustomMetadataSelector,
	* gets the Staffing Personnel to mention using the StaffingAssignmentSelector,
	* and posts those to Chatter using the ConnectApiHelper.
	***********************************************************************/
	
	public void getChatterPosts(Map<Id,SObject> oldMap, Map<Id,SObject> newMap, String sObjectName) {
		List<Automated_Chatter_Post__mdt> postsList = CustomMetadataSelector.getPostsList(sObjectName);//get all posts for this SObjectType
		StaffingAssignmentsSelector.setParentIdsToStaffLists(newMap.keySet(), sObjectName);//initialized map of all staffing assignments in scope for all parent records
		for(Id i : newMap.keySet()) {
			//initialize strings to be used in post
			String caseNumber = (String)newMap.get(i).get('ADCVD_Case_Number__c') + '--' + (String)newMap.get(i).get('Name') + ' from ' + (String)newMap.get(i).get('Country__c');
			String message = '';
			Map<String,String> conditionToMessageMap = new Map<String,String>();
			//determine if conditions were met for posting
			if (sObjectName == 'Petition__c') {
				Petition__c oldPet = (Petition__c)oldMap.get(i);
				Petition__c newPet = (Petition__c)newMap.get(i);

				if (oldPet.Initiation_Extension_of_days__c != newPet.Initiation_Extension_of_days__c && newPet.Calculated_Initiation_Signature__c != null) {
					message = 'Initiation Extension Number of Days changed from ' + oldPet.Initiation_Extension_of_days__c + ' to ' + newPet.Initiation_Extension_of_days__c;
					message += '<p>The Calculated Initiation Signature date is: <b>' + newPet.Calculated_Initiation_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);
				}
			} else if (sObjectName == 'Investigation__c') {
				Investigation__c oldInv = (Investigation__c)oldMap.get(i);
				Investigation__c newInv = (Investigation__c)newMap.get(i);

				if (oldInv.AD_Investigation_Aligned_To__c != newInv.AD_Investigation_Aligned_To__c) {
					String changeType = newInv.AD_Investigation_Aligned_To__c == null ? 'removed' : 'added';
					message = 'Alignment has been ' + changeType;
					conditionToMessageMap.put('Alignment', message);
				}
				if (oldInv.Prelim_Extension_of_days__c != newInv.Prelim_Extension_of_days__c && newInv.Calculated_Preliminary_Signature__c != null) {
					message = '<p> Preliminary Extension Number of Days changed from ' + oldInv.Prelim_Extension_of_days__c + ' to ' + newInv.Prelim_Extension_of_days__c + '</p>';
					message += '<p> The Calculated Preliminary Signature date is: <b>' + newInv.Calculated_Preliminary_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);
				}
				if (oldInv.Final_Extension_of_days__c != newInv.Final_Extension_of_days__c && newInv.Calculated_Final_Signature__c != null) {
					message = conditionToMessageMap.get('Extension') != null ? conditionToMessageMap.get('Extension') : '';
					message += '<p> Final Extension Number of Days changed from ' + oldInv.Final_Extension_of_days__c + ' to ' + newInv.Final_Extension_of_days__c + '</p>';
					message += '<p> The Calculated Final Signature date is: <b>' + newInv.Calculated_Final_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);

				}
			} else if (sObjectName == 'Segment__c') {
				Segment__c oldSeg = (Segment__c)oldMap.get(i);
				Segment__c newSeg = (Segment__c)newMap.get(i);

				if (Utils.getRecordTypeDeveloperNameMap(newSeg).get(newSeg.RecordTypeId) == 'New_Shipper_Review'
					&& oldSeg.Administrative_Review_Aligned_To__c != newSeg.Administrative_Review_Aligned_To__c) {
					String changeType = newSeg.Administrative_Review_Aligned_To__c == null ? 'removed' : 'added';
					message = 'Alignment has been ' + changeType;
					conditionToMessageMap.put('Alignment', message);
				}
				if (oldSeg.Initiation_Extension_of_days__c != newSeg.Initiation_Extension_of_days__c && newSeg.Calculated_Initiation_Signature__c != null) {
					message = 'Initiation Extension Number of Days changed from ' + oldSeg.Initiation_Extension_of_days__c + ' to ' + newSeg.Initiation_Extension_of_days__c;
					message += '<p>The Calculated Initiation Signature date is: <b>' + newSeg.Calculated_Initiation_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);
				}
				if (oldSeg.Prelim_Extension__c != newSeg.Prelim_Extension__c && newSeg.Calculated_Preliminary_Signature__c != null) {
					message = conditionToMessageMap.get('Extension') != null ? conditionToMessageMap.get('Extension') : '';
					message += '<p>Preliminary Extension Number of Days changed from ' + oldSeg.Prelim_Extension__c + ' to ' + newSeg.Prelim_Extension__c + '</p>';
					message += '<p>The Calculated Preliminary Signature date is: <b>' + newSeg.Calculated_Preliminary_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);
				}
				if (oldSeg.Final_Extension_of_days__c != newSeg.Final_Extension_of_days__c && newSeg.Calculated_Final_Signature__c != null) {
					message = conditionToMessageMap.get('Extension') != null ? conditionToMessageMap.get('Extension'): '';
					message += '<p>Final Extension Number of Days changed from ' + oldSeg.Final_Extension_of_days__c + ' to ' + newSeg.Final_Extension_of_days__c + '</p>';
					message += '<p>The Calculated Final Signature date is: <b>' + newSeg.Calculated_Final_Signature__c.format() + '</b></p>';
					conditionToMessageMap.put('Extension', message);
				}
			}
			if (oldMap.get(i).get('Litigation_YesNo__c') != newMap.get(i).get('Litigation_YesNo__c')
				|| oldMap.get(i).get('Litigation_Resolved__c') != newMap.get(i).get('Litigation_Resolved__c')) {
				SObject oldRecord = oldMap.get(i);
				SObject newRecord = newMap.get(i);
				String changeType = '';
				if (newRecord.get('Litigation_YesNo__c') == 'Yes' && newRecord.get('Litigation_Resolved__c') != 'Yes') {
					changeType = 'being litigated.';
				} else if (newRecord.get('Litigation_YesNo__c') == 'No' || newRecord.get('Litigation_Resolved__c') == 'Yes') {
					changeType = 'not being litigated.';
				}
				message = newRecord.get('Litigation_YesNo__c') != null ? 'This record is ' + changeType : 'This record is not being litigated.';
				conditionToMessageMap.put('Litigation Change', message);
			}
			//post to chatter for all conditions met
			for (Automated_Chatter_Post__mdt acp : postsList) {
				if(conditionToMessageMap.containsKey(acp.Posting_Condition__c)) {
					postToChatter(i, caseNumber, conditionToMessageMap.get(acp.Posting_Condition__c), acp);
				}
			}
		}
	}

	private void postToChatter(Id parentId, String caseNumber, String message, Automated_Chatter_Post__mdt post) {
		//initialize variables for post
		String postToParse = post.Feed_Item_Message__c;
		Set<String> staffingRoles = new Set<String>();
		Map<String,List<Id>> roleToUserIdListMap = new Map<String,List<Id>>();
		List<Schema.PicklistEntry> pleList = Schema.Constant__mdt.Staffing_Role__c.getDescribe().getPicklistValues();
		for (Schema.PicklistEntry ple : pleList) {//add all roles from default list to title map
			staffingRoles.add(ple.getValue());
		}
		for (Staffing_Assignment__c sa : StaffingAssignmentsSelector.parentIdsToStaffLists.get(parentId)) {//iterate through the staff lists for each parent record
			List<Id> tempList = new List<Id>();
			if (roleToUserIdListMap.get(sa.Title__c) != null) {
				tempList = roleToUserIdListMap.get(sa.Title__c);
			}
			if (sa.User__c != null) {tempList.add(sa.User__c);}
			roleToUserIdListMap.put(sa.Title__c, tempList);
		}
		for (String role : roleToUserIdListMap.keySet()) {
			//Initialize variables to search for when replacing
			String mentionedRole = '@' + role;
			String mentionedRecord = '@record';
			String replacementUserIds = '';

			if (!postToParse.contains(mentionedRole)) {continue;}//if that role is not present in post from metadata, skip to next role

			for (Id userId : roleToUserIdListMap.get(role)) {
					replacementUserIds = '{' + userId + '}';
			}
			postToParse = postToParse.replace(mentionedRole, replacementUserIds);
			postToParse = postToParse.replace(mentionedRecord, caseNumber);
		}
		postToParse += '<p>' + message + '</p><p>' + 'Link to record: ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + parentId + '</p>';//add message about changes and link
		ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(Network.getNetworkId(), parentId, postToParse);
	}
}
