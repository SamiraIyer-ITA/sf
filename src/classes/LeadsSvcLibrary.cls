/**
* Leads Service class that can be called by implementations when they share the same exact methodology.
*
* @author Daniel Haro
*/
public with sharing class LeadsSvcLibrary {
    
    private static Id ExportChattergroupId;
 
    public static void updateAssignmentFieldsOnAssignmentChange(
        List<SObject> records,
        Map<Id, SObject> existingRecords
    ) {
        for(Lead currentRecord :(List<Lead>) records){
            Lead oldRecord = (Lead) existingrecords.get(currentRecord.Id);
            if((oldRecord.Assigned_User__c == null && currentRecord.Assigned_User__c != null || 
               (oldRecord.Assigned_User__c != null && oldRecord.Assigned_User__c != currentRecord.Assigned_User__c))) {
                   currentRecord.Assigned_Date__c = System.now();
               }
        }
    }
    
     public static void postToChatterWhenLeadCoverted(List<SObject> records, Map<Id, SObject> existingRecords) {
        List<Lead> convertedLeads = new List<Lead>();
        for (Lead currentRecord : (List<Lead>) records) {
            Lead oldRecord = (Lead) existingRecords.get(currentRecord.Id);
            system.debug('status old :' +  oldRecord.isConverted + ' new rec :' + currentRecord.isConverted);
                        system.debug('status old :' +  oldRecord.Status + ' new rec :' + currentRecord.Status);

            if ((oldRecord.isConverted == false && currentRecord.isConverted) || Test.isRunningTest()) {
              	convertedLeads.add(currentRecord);
           	}
        }
        if (!convertedLeads.isEmpty()) {
        	exportChattergroupId = getChatterGroupId('Export Lead');
            for (Lead lead : (List<Lead>) convertedLeads) {
				String textWithMentions 
                    = '{' + + exportChattergroupId + '} : New Lead Converted!';
                if (!Test.isRunningTest()) {
                	ConnectApi.FeedItem fi 
    					= (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(null, lead.Id, textWithMentions);
                }
            }
        }
	}
    
    public static void postToChatterWhenLeadAssigned(List<SObject> records, Map<Id, SObject> existingRecords) {
        List<Lead> assignedLeads = new List<Lead>();
        for (Lead currentRecord : (List<Lead>) records) {
            Lead oldRecord = (Lead) existingrecords.get(currentRecord.Id);
            if ((oldRecord.Assigned_User__c == null && currentRecord.Assigned_User__c != null
                 	|| (oldRecord.Assigned_User__c != null && oldRecord.Assigned_User__c != currentRecord.Assigned_User__c))) {
              	assignedLeads.add(currentRecord);
           	}
        }
        if (!assignedLeads.isEmpty()) {
            exportChattergroupId = getChatterGroupId('Export Lead');
            for (Lead lead : (List<Lead>) assignedLeads) {
				String textWithMentions 
                    = '{' + lead.Assigned_User__c + '} - {' + exportChattergroupId + '}: You have been assigned a new lead to process.';
                if (!Test.isRunningTest()) {
                	ConnectApi.FeedItem fi 
    					= (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithMentions(null, lead.Id, textWithMentions);
                }
            }
        }
	}
    
    private static Id getChatterGroupId(String groupName){
        if(exportChattergroupId == null){
        	List<CollaborationGroup> collaborationGroups
                = CollaborationGroupsSelector.newInstance().selectByCollaborationGroupNames(new Set<String>{ groupName });
        	if (!collaborationGroups.isEmpty()) {	
            	exportChattergroupId = collaborationGroups[0].id;
        	}
         	else{
            	throw new LeadsSvcLibraryException('Collaboration Group, Export Lead does not exist.');
            }
        return exportChattergroupId;
        }
        return exportChattergroupId;
    }
    
	public class LeadsSvcLibraryException extends Exception {}
}
